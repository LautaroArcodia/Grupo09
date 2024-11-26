--======================================================
-- Inicio creacion de loggin
--======================================================
USE Com5600G09;
GO

IF NOT EXISTS(SELECT name, type_desc 
				FROM sys.server_principals 
				WHERE name = 'SoyGerente')
	CREATE LOGIN SoyGerente WITH PASSWORD = '1234', DEFAULT_DATABASE=Com5600G09, CHECK_POLICY = OFF;
GO

IF NOT EXISTS(SELECT name, type_desc 
				FROM sys.server_principals 
				WHERE name = 'SoySupervisor')
	CREATE LOGIN SoySupervisor WITH PASSWORD = '1234', DEFAULT_DATABASE=Com5600G09, CHECK_POLICY = OFF;
GO

IF NOT EXISTS(SELECT name, type_desc 
				FROM sys.server_principals 
				WHERE name = 'SoyCajero')
	CREATE LOGIN SoyCajero WITH PASSWORD = '1234', DEFAULT_DATABASE=Com5600G09, CHECK_POLICY = OFF;
GO

--======================================================
-- Fin creacion de loggin
--======================================================
--======================================================
-- Inicio creacion de Usuarios
--======================================================

-- Crear usuarios para los login

IF NOT EXISTS (SELECT * 
				FROM sys.database_principals 
				WHERE name = 'UsuarioGerente')
    CREATE USER UsuarioGerente FOR LOGIN SoyGerente;
GO

IF NOT EXISTS (SELECT * 
				FROM sys.database_principals 
				WHERE name = 'UsuarioSupervisor')
    CREATE USER UsuarioSupervisor FOR LOGIN SoySupervisor;
GO

IF NOT EXISTS (SELECT * 
				FROM sys.database_principals 
				WHERE name = 'UsuarioCajero')
    CREATE USER UsuarioCajero FOR LOGIN SoyCajero;
GO

-- Asignar roles a nivel BD a los usuarios

ALTER ROLE Vendedor ADD MEMBER UsuarioCajero;
GO
ALTER ROLE Supervisor ADD MEMBER UsuarioSupervisor;
GO
ALTER ROLE Administrador ADD MEMBER UsuarioGerente;
GO

--======================================================
-- Fin creacion de Usuarios
--======================================================

--==========================================================
-- Inicio ACLARACIONES
--==========================================================

-- Para realizar pruebas se pueden ejecutar de 2 maneras:

-- Se puede ejecutar este codigo para simular en esta pestaña el usuario (u omitir este paso y ejecutar todo como admin)
-- EXECUTE AS USER = 'UsuarioCajero';

-- select current_user (Para probar que se haya asignado correctamente)

-- O tambien se puede crear una nueva consulta a partir de loggearse con algun login creado (Ejemplo: SoyCajero)
-- Y copiar los EXEC que quiera ejecutar en dicha sesion

--==========================================================
-- Fin ACLARACIONES
--==========================================================