/*
Enunciado:

Luego de decidirse por un motor de base de datos relacional, llegó el momento de generar la 
base de datos. 
Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle 
las configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos, 
etc.) en un documento como el que le entregaría al DBA. 
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar 
un archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es 
entregado). Incluya comentarios para indicar qué hace cada módulo de código.  
Genere store procedures para manejar la inserción, modificado, borrado (si corresponde, 
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla. 
Los nombres de los store procedures NO deben comenzar con “SP”.  
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto 
en la creación de objetos. NO use el esquema “dbo”.  
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha 
de entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.  
Entregar todo en un zip cuyo nombre sea Grupo_XX.zip mediante la sección de prácticas de 
MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

Fecha de entrega: 01/11/2024
Numero de grupo: 9
Nombre de la materia: Bases de Datos Aplicadas
Alumnos:
Arcodia Lautaro	     DNI: 41588362
Gorosito Candela     DNI: 43896171
Paez Maximiliano     DNI: 44004413
Delli Gatti Thomas   DNI: 42427810
*/

USE master
GO

--Crear base de datos
IF EXISTS (SELECT name 
			FROM master.dbo.sysdatabases 
			WHERE name = 'Com5600G09')
DROP DATABASE Com5600G09;
GO

CREATE DATABASE Com5600G09
GO
---------------------

USE Com5600G09
GO

--Crear esquemas para las tablas

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'ddbba')
	DROP SCHEMA ddbba;
GO

CREATE SCHEMA ddbba;
GO

--Crear tablas en schemas

-- Sucursal

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'ddbba'
			AND TABLE_NAME = 'Sucursales')
	DROP TABLE ddbba.Sucursales;
GO

BEGIN
	CREATE TABLE ddbba.Sucursales (
		ID INT PRIMARY KEY IDENTITY,
		Nombre VARCHAR(50) UNIQUE,
		Ciudad VARCHAR(50),
		Direccion VARCHAR(100),
		Horario VARCHAR(50),
		Telefono CHAR(20)
	)
END
GO

-- Empleados

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'ddbba'
			AND TABLE_NAME = 'Empleados')
	DROP TABLE ddbba.Empleados;
GO

BEGIN
	CREATE TABLE ddbba.Empleados (
		Legajo INT PRIMARY KEY,
		Nombre NVARCHAR(100),
		Apellido NVARCHAR(100),
		Dni INT UNIQUE NOT NULL,
		Direccion NVARCHAR(100),
		EmailPersonal NVARCHAR(100),
		EmailEmpresa NVARCHAR(100),
		Cuil NVARCHAR(50),
		Cargo NVARCHAR(50) NOT NULL,
		SucursalID INT,
		Turno NVARCHAR(30) NOT NULL,
		CONSTRAINT FK_Sucursal FOREIGN KEY (SucursalID) REFERENCES ddbba.Sucursales(ID)
	)
END
GO

-- Medios de pago

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'ddbba'
			AND TABLE_NAME = 'MediosDePago')
	DROP TABLE ddbba.MediosDePago;
GO

BEGIN
	CREATE TABLE ddbba.MediosDePago (
		ID INT PRIMARY KEY IDENTITY,
		Nombre VARCHAR(50) NOT NULL,
		Descripcion VARCHAR(100) NOT NULL
	)
END
GO

-- Productos

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'ddbba'
			AND TABLE_NAME = 'Productos')
	DROP TABLE ddbba.Productos;
GO

BEGIN
	CREATE TABLE ddbba.Productos (
		Id CHAR(10) NOT NULL,
		CodProducto AS CONVERT(VARCHAR(40), HASHBYTES('SHA1', ISNULL(Id, '') + ISNULL(Nombre, '') + ISNULL(Categoria, '') + ISNULL(Origen, '')), 2) PERSISTED PRIMARY KEY,
		Nombre VARCHAR(100) NOT NULL,
		Categoria VARCHAR(50) NOT NULL,
		Proveedor VARCHAR(50),
		CantPorUnidad VARCHAR(50),
		Precio DECIMAL(10,2) NOT NULL,
		PrecioRef DECIMAL(10,2),
		Moneda CHAR(10),
		UnidadRef CHAR(10),
		Fecha DATETIME DEFAULT GETDATE(),
		Origen VARCHAR(50) NOT NULL
	)
END
GO

-- Ventas

IF EXISTS (SELECT * 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'ddbba' 
		   AND TABLE_NAME = 'Ventas')
    DROP TABLE ddbba.Ventas;
GO

CREATE TABLE ddbba.Ventas (
    FacturaId VARCHAR(50) PRIMARY KEY NOT NULL,
    TipoFactura CHAR(1) NOT NULL,
    Ciudad VARCHAR(50),
    TipoCliente VARCHAR(20),
    Genero CHAR(6),
    Producto VARCHAR(100) NOT NULL,
    PrecioUnitario DECIMAL(10, 2) NOT NULL,
    Cantidad INT NOT NULL,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    MedioPagoID INT NOT NULL,
    EmpleadoID INT NOT NULL,
	ProductoID VARCHAR(40) NOT NULL,
    IdentificadorPago NVARCHAR(30),
    CONSTRAINT FK_Ventas_MedioPago FOREIGN KEY (MedioPagoID) REFERENCES ddbba.MediosDePago(ID),
    CONSTRAINT FK_Ventas_Empleado FOREIGN KEY (EmpleadoID) REFERENCES ddbba.Empleados(Legajo),
	CONSTRAINT FK_Ventas_Productos FOREIGN KEY (ProductoID) REFERENCES ddbba.Productos(CodProducto)
);
GO