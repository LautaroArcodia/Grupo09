USE Com5600G09;
GO
--=================================================================
-- Crear clave maestra y certificado para encriptar datos (una vez)
--=================================================================

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'contraEncrip';
CREATE CERTIFICATE CertificadoEmpleado WITH SUBJECT = 'Certificado para encriptar empleados';
CREATE SYMMETRIC KEY ClaveEmpleado WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE CertificadoEmpleado;

--=================================================================================
-- Cambia tamaño de columna Direccion porque no alcanzaba el tamaño para encriptar
--=================================================================================
ALTER TABLE administracion.Empleado
ALTER COLUMN Direccion VARCHAR(MAX);

--=================================================================================
-- Inicio encriptacion columnas 
--=================================================================================
OPEN SYMMETRIC KEY ClaveEmpleado DECRYPTION BY CERTIFICATE CertificadoEmpleado;

UPDATE administracion.Empleado
SET 
	Direccion = ENCRYPTBYKEY(KEY_GUID('ClaveEmpleado'), Direccion),
    EmailPersonal = ENCRYPTBYKEY(KEY_GUID('ClaveEmpleado'), EmailPersonal)

CLOSE SYMMETRIC KEY ClaveEmpleado;
GO
--=================================================================================
-- Fin encriptacion columnas 
--=================================================================================
--=================================================================================
-- Creacion SP obtener empleado segun rol
--=================================================================================

-- Rol Administrador

CREATE OR ALTER PROCEDURE administracion.ObtenerEmpleadosAdministrador
AS
BEGIN
    -- Abrir la clave para la sesión
    OPEN SYMMETRIC KEY ClaveEmpleado DECRYPTION BY CERTIFICATE CertificadoEmpleado;

    -- Consultar la tabla con los campos desencriptados
    SELECT 
        Legajo,
        Nombre,
        Apellido,
        Dni,
        CONVERT(varchar, DECRYPTBYKEY(Direccion)) AS Direccion,
        CONVERT(varchar, DECRYPTBYKEY(EmailPersonal)) AS EmailPersonal,
        EmailEmpresa,
        Cuil,
        CargoID,
        SucursalID,
        Turno,
        Activo,
        FechaIngreso,
        FechaBaja
    FROM administracion.Empleado;

    -- Cerrar la clave después de la consulta
    CLOSE SYMMETRIC KEY ClaveEmpleado;
END;
GO

-- Rol Supervisor

CREATE OR ALTER PROCEDURE administracion.ObtenerEmpleadosSupervisor
AS
BEGIN
    SELECT 
        Legajo,
        Nombre,
        Apellido,
        Dni,
        Direccion,
        EmailPersonal,
        EmailEmpresa,
        Cuil,
        CargoID,
        SucursalID,
        Turno,
        Activo,
        FechaIngreso,
        FechaBaja
    FROM administracion.Empleado;
END;
GO
--=================================================================================
-- Fin creacion SP obtener empleado segun rol
--=================================================================================
--=================================================================================
-- Dar permisos segun el rol
--=================================================================================

GRANT CONTROL ON CERTIFICATE::CertificadoEmpleado TO Administrador;
GRANT CONTROL ON SYMMETRIC KEY::ClaveEmpleado TO Administrador;
GRANT EXECUTE ON administracion.ObtenerEmpleadosAdministrador TO Administrador;

GRANT EXECUTE ON administracion.ObtenerEmpleadosSupervisor TO Supervisor;
--=================================================================================
-- Fin de dar permisos segun el rol
--=================================================================================
--=================================================================================
-- Ejecucion SP obtener empleado segun rol
--=================================================================================

EXEC administracion.ObtenerEmpleadosAdministrador
GO
EXEC administracion.ObtenerEmpleadosSupervisor

--=================================================================================
-- Fin ejecucion SP obtener empleado segun rol
--=================================================================================
