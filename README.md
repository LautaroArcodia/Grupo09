CREATE SCHEMA ddbba;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'cargo' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.cargo (
      id int NOT NULL PRIMARY KEY,
      descripcion varchar
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'categoriaprodu' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.categoriaprodu (
      id int NOT NULL PRIMARY KEY,
      descripcion varchar
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'cliente' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.cliente (
      id int NOT NULL PRIMARY KEY,
      tipocliente varchar,
      genero varchar
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'direccionSucursal' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.direccionSucursal (
      id int NOT NULL PRIMARY KEY,
      sucursalid int,
      direccion varchar,
      horario datetime,
      telefono int
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Empleados' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.Empleados (
      TurnoID int,
      Nombre nvarchar,
      Apellido nvarchar,
      Dni int,
      Legajo int PRIMARY KEY,
      Direccion nvarchar,
      EmailPersonal nvarchar,
      EmailEmpresa nvarchar,
      Cuil int,
      CargoID int,
      SucursalID int,
      CONSTRAINT ddbba_PK__Empleado__0E01039BBE7F31E8 UNIQUE (Legajo),
      CONSTRAINT ddbba_UQ__Empleado__C0308575EFD07654 UNIQUE (Dni)
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'historialproducto' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.historialproducto (
      id int NOT NULL PRIMARY KEY,
      fecha datetime,
      precio int,
      precioref int,
      origen varchar,
      unidadref int
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'linea de venta' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.[linea de venta] (
      idventa int NOT NULL PRIMARY KEY,
      preciounitario int,
      idproducto int,
      cantidad int
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'MediosDePago' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.MediosDePago (
      ID int PRIMARY KEY,
      Nombre varchar,
      Descripcion varchar
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Productos' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.Productos (
      Id int PRIMARY KEY,
      CodProducto varchar PRIMARY KEY,
      Nombre varchar,
      CodCategoria varchar,
      Proveedor varchar,
      CantPorUnidad varchar,
      Moneda char,
      productohistoricoid int PRIMARY KEY,
      categoriaId int,
      CONSTRAINT ddbba_PK__Producto__0D06FDF3833DC33D UNIQUE (CodProducto)
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Sucursales' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.Sucursales (
      ID int PRIMARY KEY,
      Nombre varchar,
      Ciudad varchar,
      direccionsucursalID int PRIMARY KEY
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'turno' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.turno (
      id int NOT NULL PRIMARY KEY,
      descripcion varchar
    );
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Ventas' AND type = 'U')
BEGIN
    CREATE TABLE ddbba.Ventas (
      FacturaId varchar PRIMARY KEY,
      TipoFactura char,
      Ciudad varchar,
      Fecha date,
      Hora time,
      productoid int,
      MedioPagoID int,
      EmpleadoID int,
      lineadeventaID int,
      clienteID int,
      CONSTRAINT ddbba_PK__Ventas__5C0248651DD6F611 UNIQUE (FacturaId)
    );
END

ALTER TABLE ddbba.cliente ADD CONSTRAINT cliente_id_fk FOREIGN KEY (id) REFERENCES ddbba.Ventas (clienteID);
ALTER TABLE ddbba.direccionSucursal ADD CONSTRAINT direccionSucursal_id_fk FOREIGN KEY (id) REFERENCES ddbba.Sucursales (direccionsucursalID);
ALTER TABLE ddbba.Empleados ADD CONSTRAINT FK_Sucursal FOREIGN KEY (SucursalID) REFERENCES ddbba.Sucursales (ID);
ALTER TABLE ddbba.Ventas ADD CONSTRAINT FK_Ventas_Empleado FOREIGN KEY (EmpleadoID) REFERENCES ddbba.Empleados (Legajo);
ALTER TABLE ddbba.Ventas ADD CONSTRAINT FK_Ventas_MedioPago FOREIGN KEY (MedioPagoID) REFERENCES ddbba.MediosDePago (ID);
ALTER TABLE ddbba.[linea de venta] ADD CONSTRAINT [linea de venta_idventa_fk] FOREIGN KEY (idventa) REFERENCES ddbba.Ventas (lineadeventaID);
ALTER TABLE ddbba.Productos ADD CONSTRAINT Productos_productohistoricoid_fk FOREIGN KEY (productohistoricoid) REFERENCES ddbba.historialproducto (id);
ALTER TABLE ddbba.Productos ADD CONSTRAINT Productos_categoriaId_fk FOREIGN KEY (categoriaId) REFERENCES ddbba.categoriaprodu (id);
ALTER TABLE ddbba.Ventas ADD CONSTRAINT Ventas_productoid_fk FOREIGN KEY (productoid) REFERENCES ddbba.Productos (Id);
ALTER TABLE ddbba.Empleados ADD CONSTRAINT Empleados_CargoID_fk FOREIGN KEY (CargoID) REFERENCES ddbba.cargo (id);
ALTER TABLE ddbba.Empleados ADD CONSTRAINT Empleados_TurnoID_fk FOREIGN KEY (TurnoID) REFERENCES ddbba.turno (id);
