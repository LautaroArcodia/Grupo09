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

Fecha de entrega: 15/11/2024
Numero de grupo: 9
Nombre de la materia: Bases de Datos Aplicadas
Alumnos:
Arcodia Lautaro	     DNI: 41588362
Gorosito Candela     DNI: 43896171
Paez Maximiliano     DNI: 44004413
*/

USE master
GO

--=================================================================
-- Inicio creacion BD
--=================================================================

--Crear base de datos
IF EXISTS (SELECT name 
			FROM master.dbo.sysdatabases 
			WHERE name = 'Com5600G09')
DROP DATABASE Com5600G09;
GO

CREATE DATABASE Com5600G09
GO

--=================================================================
-- Fin creacion BD
--=================================================================

USE Com5600G09
GO

--=================================================================
-- Inicio creacion schemas
--=================================================================

--Crear esquemas para las tablas

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'administracion')
	DROP SCHEMA administracion;
GO

CREATE SCHEMA administracion;
GO

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'ventas')
	DROP SCHEMA ventas;
GO

CREATE SCHEMA ventas;
GO

--=================================================================
-- Fin creacion schemas
--=================================================================
--=================================================================
-- Inicio creacion tablas
--=================================================================

-- Crear tabla Sucursal

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'administracion'
			AND TABLE_NAME = 'Sucursal')
	DROP TABLE administracion.Sucursal;
GO

BEGIN
	CREATE TABLE administracion.Sucursal (
		Id INT PRIMARY KEY IDENTITY,
		Nombre VARCHAR(50) UNIQUE,
		Ciudad VARCHAR(50),
		Direccion VARCHAR(100),
		Horario VARCHAR(50),
		Telefono CHAR(20)
	)
END
GO
-- Fin creacion Sucursal

-- Crear tabla Cargo

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'administracion'
			AND TABLE_NAME = 'Cargo')
	DROP TABLE administracion.Cargo;
GO

BEGIN
	CREATE TABLE administracion.Cargo (
		Id INT PRIMARY KEY IDENTITY,
		Puesto VARCHAR(30) UNIQUE,
	)
END
GO
-- Fin creacion Cargo

-- Crear tabla Empleado

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'administracion'
			AND TABLE_NAME = 'Empleado')
	DROP TABLE administracion.Empleado;
GO

BEGIN
	CREATE TABLE administracion.Empleado (
		Id INT PRIMARY KEY IDENTITY,
		Legajo INT UNIQUE NOT NULL,
		Nombre VARCHAR(50),
		Apellido VARCHAR(50),
		Dni INT UNIQUE NOT NULL,
		Direccion VARCHAR(100),
		EmailPersonal VARCHAR(100),
		EmailEmpresa VARCHAR(100),
		Cuil VARCHAR(30),
		CargoID INT,
		SucursalID INT,
		Turno CHAR(20),
		Activo BIT DEFAULT 1,
		FechaIngreso DATETIME DEFAULT GETDATE(),
		FechaBaja DATETIME,
		CONSTRAINT FK_Sucursal FOREIGN KEY (SucursalID) REFERENCES administracion.Sucursal(Id),
		CONSTRAINT FK_Cargo FOREIGN KEY (CargoID) REFERENCES administracion.Cargo(Id)
	)
END
GO
-- Fin creacion Empleado

-- Crear tabla Medio de pago

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'administracion'
			AND TABLE_NAME = 'MedioDePago')
	DROP TABLE administracion.MedioDePago;
GO

BEGIN
	CREATE TABLE administracion.MedioDePago (
		Id INT PRIMARY KEY IDENTITY,
		Nombre VARCHAR(50) NOT NULL,
		Descripcion VARCHAR(100)
	)
END
GO
-- Fin creacion Medio de pago

-- Crear tabla Producto

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'administracion'
			AND TABLE_NAME = 'Producto')
	DROP TABLE administracion.Producto;
GO

BEGIN
	CREATE TABLE administracion.Producto (
		Id INT PRIMARY KEY IDENTITY,
		CodProducto AS CONVERT(VARCHAR(40), HASHBYTES('SHA1', ISNULL(Descripcion, '') + ISNULL(Categoria, '')), 2) PERSISTED UNIQUE NOT NULL,
		Descripcion VARCHAR(100) NOT NULL,
		Categoria VARCHAR(50) NOT NULL,
		Linea VARCHAR(50),
		Proveedor VARCHAR(50),
		CantPorUnidad VARCHAR(50),
		Precio DECIMAL(10,2) NOT NULL,
		PrecioRef DECIMAL(10,2),
		Moneda CHAR(10),
		UnidadRef CHAR(10),
		FechaModificacion DATETIME DEFAULT GETDATE()
	)
END
GO
-- Fin creacion Producto

-- Creacion tabla Cliente

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'ventas'
			AND TABLE_NAME = 'Cliente')
	DROP TABLE ventas.Cliente;
GO

BEGIN
	CREATE TABLE ventas.Cliente (
		Id INT PRIMARY KEY IDENTITY,
		Dni CHAR(8) UNIQUE NOT NULL,
		Nombre VARCHAR(30),
		Apellido VARCHAR(30),
		Genero CHAR(6),
		TipoCliente CHAR(20),
		CondicionIVA VARCHAR(30) CHECK (CondicionIVA IN ('Responsable Inscripto', 'Monotributista', 'Consumidor Final')),
		Cuit CHAR(11),
		DomicilioFiscal VARCHAR(100),
		Activo BIT NOT NULL DEFAULT 1,
		FechaAlta DATETIME DEFAULT GETDATE(),
		FechaBaja DATETIME DEFAULT NULL
	)
END
GO
-- Fin creacion Cliente

-- Creacion tabla FacturaControl

IF EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'administracion'
			AND TABLE_NAME = 'FacturaControl')
	DROP TABLE administracion.FacturaControl;
GO

CREATE TABLE administracion.FacturaControl (
    SucursalID INT,
    TipoFactura CHAR(1),
    Anio INT,
    NumeroFactura INT,
    PRIMARY KEY (SucursalID, TipoFactura, Anio)
);
GO

-- Fin creacion FacturaControl

-- Creacion tabla Venta

IF EXISTS (SELECT * 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'ventas' 
           AND TABLE_NAME = 'Venta')
    DROP TABLE ventas.Venta;
GO

CREATE TABLE ventas.Venta (
    Id INT PRIMARY KEY IDENTITY,
    FacturaId VARCHAR(40) NULL,  -- FacturaId puede ser NULL hasta confirmar la venta
    TipoFactura CHAR(1) NOT NULL CHECK (TipoFactura IN ('A', 'B', 'C')),
    ClienteID INT,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
	MontoTotal DECIMAL(10,2) DEFAULT 0,
    SucursalID INT,
    MedioPagoID INT NOT NULL,
    EmpleadoID INT NOT NULL,
    IdentificadorPago VARCHAR(30),
    EstadoVenta VARCHAR(20) DEFAULT 'Pendiente',
    EstadoPago VARCHAR(20) DEFAULT 'Pendiente',
    CONSTRAINT FK_Venta_MedioPago FOREIGN KEY (MedioPagoID) REFERENCES administracion.MedioDePago(Id),
    CONSTRAINT FK_Venta_Empleado FOREIGN KEY (EmpleadoID) REFERENCES administracion.Empleado(Legajo),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (ClienteID) REFERENCES ventas.Cliente(Id),
    CONSTRAINT FK_Venta_Sucursal FOREIGN KEY (SucursalID) REFERENCES administracion.Sucursal(Id)
);
GO

CREATE UNIQUE INDEX IDX_Venta_FacturaId_Unique
ON ventas.Venta (FacturaId)
WHERE FacturaId IS NOT NULL;

-- Fin creacion Venta

-- Creacion tabla Detalle Venta

IF EXISTS (SELECT * 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'ventas' 
           AND TABLE_NAME = 'DetalleVenta')
    DROP TABLE ventas.DetalleVenta;
GO

CREATE TABLE ventas.DetalleVenta (
    Id INT PRIMARY KEY IDENTITY,
    VentaId INT NOT NULL,
    CodProducto VARCHAR(40) NOT NULL,
    Cantidad INT NOT NULL,
    Precio DECIMAL(10,2),
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (VentaId) REFERENCES ventas.Venta(Id),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (CodProducto) REFERENCES administracion.Producto(CodProducto)
);
GO

-- Fin creacion DetalleVenta

-- Inicio creacion NotaDeCredito

IF EXISTS (SELECT * 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'administracion' 
           AND TABLE_NAME = 'NotaDeCredito')
    DROP TABLE administracion.NotaDeCredito;
GO

CREATE TABLE administracion.NotaDeCredito (
    Id INT PRIMARY KEY IDENTITY,
	VentaId INT NOT NULL,
    FacturaId VARCHAR(40) NOT NULL,                    
    TipoFactura CHAR(1) NOT NULL CHECK (TipoFactura IN ('A', 'B', 'C')),
    MontoTotal DECIMAL(10, 2) NOT NULL DEFAULT 0,                    
    Fecha DATE NOT NULL,                           
    EmpleadoID INT NOT NULL,                          
    Estado VARCHAR(20) DEFAULT 'Pendiente',         
    MotivoDevolucion VARCHAR(255) NULL,          
    CONSTRAINT FK_NotaDeCredito_VentaId FOREIGN KEY (VentaId) REFERENCES ventas.Venta(Id),
    CONSTRAINT FK_NotaDeCredito_Empleado FOREIGN KEY (EmpleadoID) REFERENCES administracion.Empleado(Legajo)
);
GO

-- Fin creacion NotaDeCredito

-- Inicio creacion DetalleNotaDeCredito

IF EXISTS (SELECT * 
           FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'administracion' 
           AND TABLE_NAME = 'DetalleNotaDeCredito')
    DROP TABLE administracion.DetalleNotaDeCredito;
GO

CREATE TABLE administracion.DetalleNotaDeCredito (
    Id INT PRIMARY KEY IDENTITY,
    NotaDeCreditoID INT NOT NULL,
	CodProducto VARCHAR(40) NOT NULL,
    Cantidad DECIMAL(10, 2) NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
	CONSTRAINT FK_DetalleNotaDeCredito_NotaDeCreditoId FOREIGN KEY (NotaDeCreditoID) REFERENCES administracion.NotaDeCredito(Id),
    CONSTRAINT FK_DetalleNotaDeCredito_Productos FOREIGN KEY (CodProducto) REFERENCES administracion.Producto(CodProducto)
);
GO

-- Fin creacion DetalleNotaDeCredito

--=================================================================
-- Fin creacion tablas
--=================================================================