USE Com5600G09
GO

--================================================================
-- Inicio creacion ABM tabla Sucursal
--================================================================

-- Crear una secuencia para generar valores únicos de PuntoDeVenta
CREATE SEQUENCE administracion.Seq_PuntoDeVenta
    AS INT
    START WITH 0001
    INCREMENT BY 1;
GO

-- Creacion SP insertar sucursal

CREATE OR ALTER PROCEDURE administracion.InsertarSucursal
    @Nombre VARCHAR(50),
    @Ciudad VARCHAR(50),
    @Direccion VARCHAR(100),
    @Horario VARCHAR(50),
    @Telefono CHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM administracion.Sucursal WHERE Nombre = @Nombre)
    BEGIN
        PRINT 'Sucursal ya existente.';
        RETURN;
    END

    DECLARE @NuevoPuntoDeVenta INT;
    SET @NuevoPuntoDeVenta = NEXT VALUE FOR administracion.Seq_PuntoDeVenta;

    INSERT INTO administracion.Sucursal (Nombre, Ciudad, Direccion, Horario, Telefono, PuntoDeVenta)
    VALUES (@Nombre, @Ciudad, @Direccion, @Horario, @Telefono, @NuevoPuntoDeVenta);

    PRINT 'Sucursal insertada exitosamente con PuntoDeVenta ' + CAST(@NuevoPuntoDeVenta AS NVARCHAR(10));
END;
GO

-- Creacion SP modificar sucursal

CREATE OR ALTER PROCEDURE administracion.ModificarSucursal
    @PuntoDeVenta INT,
    @Nombre VARCHAR(50),
    @Ciudad VARCHAR(50),
    @Direccion VARCHAR(100),
    @Horario VARCHAR(50),
    @Telefono CHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE administracion.Sucursal
    SET Nombre = @Nombre,
        Ciudad = @Ciudad,
        Direccion = @Direccion,
        Horario = @Horario,
        Telefono = @Telefono
    WHERE PuntoDeVenta = @PuntoDeVenta;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No se encontró una sucursal con el PuntoDeVenta especificado.';
    END
    ELSE
    BEGIN
        PRINT 'Sucursal actualizada exitosamente.';
    END
END;
GO

-- Creacion SP eliminar sucursal

CREATE OR ALTER PROCEDURE administracion.EliminarSucursal
    @PuntoDeVenta INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM administracion.Sucursal
    WHERE PuntoDeVenta = @PuntoDeVenta;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No se encontró una sucursal con el PuntoDeVenta especificado.';
    END
    ELSE
    BEGIN
        PRINT 'Sucursal eliminada exitosamente.';
    END
END;
GO

--================================================================
-- Fin creacion ABM tabla Sucursal
--================================================================
--================================================================
-- Inicio creacion ABM tabla Cargo
--================================================================

-- Creacion SP insertar cargo

CREATE OR ALTER PROCEDURE administracion.InsertarCargo
    @Cargo VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM administracion.Cargo WHERE Puesto = @Cargo)
    BEGIN
        PRINT 'Cargo ya existente.';
        RETURN;
    END

    INSERT INTO administracion.Cargo(Puesto)
    VALUES (@Cargo);

    PRINT 'Cargo insertado exitosamente';
END;
GO

-- Creacion SP modificar cargo

CREATE OR ALTER PROCEDURE administracion.ModificarCargo
    @Id INT,
	@Cargo VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE administracion.Cargo
    SET Puesto = @Cargo
    WHERE Id = @Id;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No se encontró un cargo con el Id especificado.';
    END
    ELSE
    BEGIN
        PRINT 'Cargo actualizado exitosamente.';
    END
END;
GO

-- Creacion SP eliminar cargo

CREATE OR ALTER PROCEDURE administracion.EliminarCargo
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM administracion.Cargo
    WHERE Id = @Id;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No se encontró un cargo con el Id especificado.';
    END
    ELSE
    BEGIN
        PRINT 'Cargo eliminado exitosamente.';
    END
END;
GO

--================================================================
-- Fin creacion ABM tabla Cargo
--================================================================
--================================================================
-- Inicio creacion ABM tabla Empleado
--================================================================

-- Creacion insertar empleado

CREATE OR ALTER PROCEDURE administracion.InsertarEmpleado
    @Legajo INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Dni INT,
    @Direccion VARCHAR(100),
    @EmailPersonal VARCHAR(100),
    @EmailEmpresa VARCHAR(100),
    @Cuil VARCHAR(30),
    @Cargo VARCHAR(50),
    @Sucursal VARCHAR(50),
    @Turno CHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CargoID INT;
    DECLARE @SucursalID INT;

    SELECT @CargoID = Id
    FROM administracion.Cargo
    WHERE Puesto = @Cargo;

    SELECT @SucursalID = Id
    FROM administracion.Sucursal
    WHERE Ciudad = @Sucursal;

    IF @CargoID IS NULL
    BEGIN
        PRINT 'Cargo no encontrado.';
        RETURN;
    END

    IF @SucursalID IS NULL
    BEGIN
        PRINT 'Sucursal de la ciudad especificada no encontrada.';
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM administracion.Empleado WHERE Legajo = @Legajo OR Dni = @Dni)
    BEGIN
        PRINT 'Empleado ya existente.';
        RETURN;
    END

    INSERT INTO administracion.Empleado (
        Legajo, Nombre, Apellido, Dni, Direccion, 
        EmailPersonal, EmailEmpresa, Cuil, CargoID, 
        SucursalID, Turno
    )
    VALUES (
        @Legajo, @Nombre, @Apellido, @Dni, @Direccion, 
        @EmailPersonal, @EmailEmpresa, @Cuil, @CargoID, 
        @SucursalID, @Turno
    );

    PRINT 'Empleado insertado exitosamente.';
END;
GO

-- Creacion SP modificar empleado

CREATE PROCEDURE administracion.ModificarEmpleado
    @Legajo INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Dni INT,
    @Direccion VARCHAR(100),
    @EmailPersonal VARCHAR(100),
    @EmailEmpresa VARCHAR(100),
    @Cuil VARCHAR(30),
    @Cargo VARCHAR(50),
    @Sucursal VARCHAR(50),
    @Turno CHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CargoID INT;
    DECLARE @SucursalID INT;

    SELECT @CargoID = Id
    FROM administracion.Cargo
    WHERE Puesto = @Cargo;

    SELECT @SucursalID = Id
    FROM administracion.Sucursal
    WHERE Ciudad = @Sucursal;

    IF @CargoID IS NULL
    BEGIN
        PRINT 'Cargo no encontrado.';
        RETURN;
    END

    IF @SucursalID IS NULL
    BEGIN
        PRINT 'Sucursal de la ciudad especificada no encontrada.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM administracion.Empleado WHERE Legajo = @Legajo)
    BEGIN
        PRINT 'Empleado no encontrado con el Legajo proporcionado.';
        RETURN;
    END

    UPDATE administracion.Empleado
    SET
        Nombre = @Nombre,
        Apellido = @Apellido,
        Dni = @Dni,
        Direccion = @Direccion,
        EmailPersonal = @EmailPersonal,
        EmailEmpresa = @EmailEmpresa,
        Cuil = @Cuil,
        CargoID = @CargoID,
        SucursalID = @SucursalID,
        Turno = @Turno
    WHERE Legajo = @Legajo;

    PRINT 'Empleado actualizado exitosamente.';
END;
GO

-- Creacion SP eliminar empleado

CREATE PROCEDURE administracion.EliminarEmpleado
    @Legajo INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM administracion.Empleado WHERE Legajo = @Legajo)
    BEGIN
        PRINT 'Empleado no encontrado con el Legajo proporcionado.';
        RETURN;
    END

    DELETE FROM administracion.Empleado WHERE Legajo = @Legajo;

    PRINT 'Empleado eliminado exitosamente.';
END;
GO

--================================================================
-- Fin creacion ABM tabla Empleado
--================================================================
--================================================================
-- Inicio creacion ABM tabla MedioDePago
--================================================================

-- Creacion SP insertar MedioDePago

CREATE OR ALTER PROCEDURE administracion.InsertarMedioDePago
    @Nombre VARCHAR(30),
	@Descripcion VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM administracion.MedioDePago WHERE Nombre = @Nombre)
    BEGIN
        PRINT 'El medio de pago ya existe.';
        RETURN;
    END

    INSERT INTO administracion.MedioDePago(Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);

    PRINT 'Medio de pago insertado exitosamente';
END;
GO

-- Creacion SP modificar MedioDePago

CREATE OR ALTER PROCEDURE administracion.ModificarMedioDePago
    @Nombre VARCHAR(30),
	@Descripcion VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
	
	IF NOT EXISTS (SELECT 1 FROM administracion.MedioDePago WHERE Nombre = @Nombre)
    BEGIN
        PRINT 'No se encontró el medio de pago especificado.';
        RETURN;
    END

    UPDATE administracion.MedioDePago
    SET Descripcion = @Descripcion
    WHERE Nombre = @Nombre;

    PRINT 'Medio de pago actualizado exitosamente.';
END;
GO

-- Creacion SP eliminar MedioDePago

CREATE OR ALTER PROCEDURE administracion.EliminarMedioDePago
    @Nombre VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM administracion.MedioDePago WHERE Nombre = @Nombre)
    BEGIN
        PRINT 'No se encontró el medio de pago especificado.';
        RETURN;
    END

    DELETE FROM administracion.MedioDePago
    WHERE Nombre = @Nombre;
    
    PRINT 'Medio de pago eliminado exitosamente.';
END;
GO

--================================================================
-- Fin creacion ABM tabla MedioDePago
--================================================================
--================================================================
-- Inicio creacion ABM tabla Producto
--================================================================

-- Creacion SP insertar Producto

CREATE OR ALTER PROCEDURE administracion.InsertarProducto
    @Descripcion VARCHAR(100),
    @Categoria VARCHAR(50),
    @Linea VARCHAR(50) = NULL,
    @Proveedor VARCHAR(50) = NULL,
    @CantPorUnidad VARCHAR(50) = NULL,
    @Precio DECIMAL(10,2),
    @PrecioRef VARCHAR(20) = NULL,
    @Moneda CHAR(10) = NULL,
    @UnidadRef CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CodProducto VARCHAR(40);
    SET @CodProducto = CONVERT(VARCHAR(40), HASHBYTES('SHA1', ISNULL(@Descripcion, '') + ISNULL(@Categoria, '')), 2);

    IF EXISTS (SELECT 1 FROM administracion.Producto WHERE CodProducto = @CodProducto)
    BEGIN
        PRINT 'Producto ya existente en la base.';
        RETURN;
    END

	DECLARE @PrecioRefDecimal DECIMAL(10, 2) = NULL;
    IF (@PrecioRef IS NOT NULL AND TRY_CAST(@PrecioRef AS DECIMAL(10, 2)) IS NOT NULL)
    BEGIN
        SET @PrecioRefDecimal = CAST(@PrecioRef AS DECIMAL(10, 2));
    END

	IF (@Linea = '') SET @Linea = NULL;
    IF (@Proveedor = '') SET @Proveedor = NULL;
	IF (@CantPorUnidad = '') SET @CantPorUnidad = NULL;
	IF (@Moneda = '') SET @Moneda = NULL;
	IF (@UnidadRef = '') SET @UnidadRef = NULL;

    INSERT INTO administracion.Producto (
        Descripcion, Categoria, Linea, Proveedor, CantPorUnidad,
        Precio, PrecioRef, Moneda, UnidadRef
    )
    VALUES (
        @Descripcion, @Categoria, @Linea, @Proveedor, @CantPorUnidad,
        @Precio, @PrecioRefDecimal, @Moneda, @UnidadRef
    );

    PRINT 'Producto insertado exitosamente.';
END;
GO

-- Creacion SP modificar Producto

CREATE OR ALTER PROCEDURE administracion.ModificarProducto
    @CodProducto VARCHAR(40),
    @Linea VARCHAR(50) = NULL,
    @Proveedor VARCHAR(50) = NULL,
    @CantPorUnidad VARCHAR(50) = NULL,
    @Precio DECIMAL(10,2),
    @PrecioRef VARCHAR(20) = NULL,
    @Moneda CHAR(10) = NULL,
    @UnidadRef CHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM administracion.Producto WHERE CodProducto = @CodProducto)
    BEGIN
        PRINT 'El codigo de producto proporsionado no existe en la base.';
        RETURN;
    END

	DECLARE @PrecioRefDecimal DECIMAL(10, 2) = NULL;
    IF (@PrecioRef IS NOT NULL AND TRY_CAST(@PrecioRef AS DECIMAL(10, 2)) IS NOT NULL)
    BEGIN
        SET @PrecioRefDecimal = CAST(@PrecioRef AS DECIMAL(10, 2));
    END

	IF (@Linea = '') SET @Linea = NULL;
    IF (@Proveedor = '') SET @Proveedor = NULL;
	IF (@CantPorUnidad = '') SET @CantPorUnidad = NULL;
	IF (@Moneda = '') SET @Moneda = NULL;
	IF (@UnidadRef = '') SET @UnidadRef = NULL;

    UPDATE administracion.Producto
    SET 
        Linea = @Linea,
        Proveedor = @Proveedor,
        CantPorUnidad = @CantPorUnidad,
        Precio = @Precio,
        PrecioRef = @PrecioRefDecimal,
        Moneda = @Moneda,
        UnidadRef = @UnidadRef,
        FechaModificacion = GETDATE()
    WHERE CodProducto = @CodProducto;

    PRINT 'Producto modificado exitosamente.';
END;
GO

-- Creacion SP eliminar Producto

CREATE OR ALTER PROCEDURE administracion.EliminarProducto
    @CodProducto VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;

	IF NOT EXISTS (SELECT 1 FROM administracion.Producto WHERE CodProducto = @CodProducto)
    BEGIN
        PRINT 'Producto no existente en la base!';
        RETURN;
    END

    DELETE FROM administracion.Producto
    WHERE CodProducto = @CodProducto;

    IF @@ROWCOUNT = 0
        PRINT 'No se encontró el producto para eliminar.';
    ELSE
        PRINT 'Producto eliminado exitosamente.';
END;
GO

--================================================================
-- Fin creacion ABM tabla Producto
--================================================================
--================================================================
-- Inicio creacion ABM tabla Cliente
--================================================================

-- Creacion SP insertar Cliente

CREATE OR ALTER PROCEDURE ventas.InsertarCliente
    @Dni CHAR(8),
    @Nombre VARCHAR(30),
    @Apellido VARCHAR(30),
    @Genero CHAR(6),
    @TipoCliente CHAR(20),
    @CondicionIVA VARCHAR(30),
    @Cuit CHAR(11),
    @DomicilioFiscal VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ventas.Cliente WHERE Dni = @Dni)
    BEGIN
        PRINT 'El cliente ya está registrado.';
        RETURN;
    END

    INSERT INTO ventas.Cliente (Dni, Nombre, Apellido, Genero, TipoCliente, CondicionIVA, Cuit, DomicilioFiscal)
    VALUES (@Dni, @Nombre, @Apellido, @Genero, @TipoCliente, @CondicionIVA, @Cuit, @DomicilioFiscal);

    PRINT 'Cliente insertado con éxito.';
END;
GO

-- Creacion SP modificar Cliente

CREATE OR ALTER PROCEDURE ventas.ModificarCliente
    @Dni CHAR(8),
    @Nombre VARCHAR(30),
    @Apellido VARCHAR(30),
    @Genero CHAR(6),
    @TipoCliente CHAR(20),
    @CondicionIVA VARCHAR(30),
    @Cuit CHAR(11),
    @DomicilioFiscal VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el DNI existe en la base de datos
    IF NOT EXISTS (SELECT 1 FROM ventas.Cliente WHERE Dni = @Dni)
    BEGIN
        PRINT 'No se encontró un cliente con el DNI especificado.';
        RETURN;
    END

    UPDATE ventas.Cliente
    SET 
        Nombre = @Nombre,
        Apellido = @Apellido,
        Genero = @Genero,
        TipoCliente = @TipoCliente,
        CondicionIVA = @CondicionIVA,
        Cuit = @Cuit,
        DomicilioFiscal = @DomicilioFiscal
    WHERE Dni = @Dni;

    PRINT 'Cliente modificado con éxito.';
END;
GO

-- Creacion SP eliminar Cliente

CREATE OR ALTER PROCEDURE ventas.EliminarCliente
    @Dni CHAR(8)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ventas.Cliente WHERE Dni = @Dni)
    BEGIN
        PRINT 'No se encontró un cliente con el DNI especificado.';
        RETURN;
    END

    UPDATE ventas.Cliente
    SET 
		Activo = 0,
		FechaBaja = GETDATE()
    WHERE Dni = @Dni;

    PRINT 'Cliente marcado como inactivo con éxito.';
END;
GO

--================================================================
-- Fin creacion ABM tabla Cliente
--================================================================
--================================================================
-- Inicio creacion ABM tabla Venta
--================================================================

-- Procedimiento para generar número de factura

CREATE OR ALTER PROCEDURE administracion.GenerarNumeroFactura
    @SucursalID INT,
    @TipoFactura CHAR(1),
    @FacturaId VARCHAR(40) OUTPUT
AS
BEGIN
    DECLARE @Anio INT = YEAR(GETDATE());
    DECLARE @NumeroFactura INT;

    -- Intentar obtener el último número de factura para la combinación de sucursal, tipo de factura y año
    SELECT @NumeroFactura = NumeroFactura
    FROM administracion.FacturaControl
    WHERE SucursalID = @SucursalID AND TipoFactura = @TipoFactura AND Anio = @Anio;

    -- Si no existe un registro en la tabla de control, insertar el primer número de factura (1)
    IF @NumeroFactura IS NULL
    BEGIN
        -- Insertar el nuevo control de factura
        INSERT INTO administracion.FacturaControl (SucursalID, TipoFactura, Anio, NumeroFactura)
        VALUES (@SucursalID, @TipoFactura, @Anio, 1);

        -- Asignar el primer número de factura
        SET @NumeroFactura = 1;
    END
    ELSE
    BEGIN
        -- Si ya existe, incrementar el número de factura
        UPDATE administracion.FacturaControl
        SET NumeroFactura = NumeroFactura + 1
        WHERE SucursalID = @SucursalID AND TipoFactura = @TipoFactura AND Anio = @Anio;

        -- Asignar el número de factura actualizado
        SET @NumeroFactura = @NumeroFactura + 1;
    END

    -- Generar el ID de la factura con el formato adecuado
    SET @FacturaId = FORMAT(@SucursalID, '0000') + '-' + @TipoFactura + FORMAT(@NumeroFactura, '0000000');

END;
GO

-- Procedimiento para iniciar una venta
CREATE OR ALTER PROCEDURE ventas.IniciarVenta
    @EmpleadoID INT,
    @SucursalID INT,
    @ClienteID INT,
    @MedioPagoID INT,
    @TipoFactura CHAR(1),
    @VentaID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que el cliente esté registrado
    IF NOT EXISTS (SELECT 1 FROM ventas.Cliente WHERE Id = @ClienteID)
    BEGIN
        PRINT 'El cliente ingresado no está registrado.';
        RETURN;  -- Termina el procedimiento si el cliente no está registrado
    END

    -- Insertar nueva venta en estado pendiente (FacturaId será NULL al principio)
    INSERT INTO ventas.Venta (TipoFactura, ClienteID, Fecha, Hora, SucursalID, MedioPagoID, EmpleadoID, IdentificadorPago, FacturaId, EstadoVenta, EstadoPago)
    VALUES (@TipoFactura, @ClienteID, GETDATE(), CONVERT(TIME, GETDATE()), @SucursalID, @MedioPagoID, @EmpleadoID, NULL, NULL, 'Pendiente', 'Pendiente');

    -- Obtener el VentaID recién insertado
    SET @VentaID = SCOPE_IDENTITY();

    -- Verificar que la inserción fue exitosa
    IF @VentaID IS NULL
    BEGIN
        PRINT 'Error al iniciar la venta. No se pudo obtener el ID de la venta.';
        RETURN;
    END

    PRINT 'Venta iniciada correctamente. VentaID: ' + CAST(@VentaID AS VARCHAR);
END;
GO


-- Procedimiento para agregar un producto a la venta
CREATE OR ALTER PROCEDURE ventas.AgregarDetalleVenta
    @VentaID INT,
    @CodProducto VARCHAR(40),
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que el producto exista
    IF NOT EXISTS (SELECT 1 FROM administracion.Producto WHERE CodProducto = @CodProducto)
    BEGIN
        PRINT 'El producto ingresado no existe.';
        RETURN;
    END

    -- Verificar que la venta esté en estado "Pendiente"
    IF NOT EXISTS (SELECT 1 FROM ventas.Venta WHERE Id = @VentaID AND EstadoVenta = 'Pendiente')
    BEGIN
        PRINT 'La venta no puede ser modificada porque ya ha sido cerrada o cancelada.';
        RETURN;
    END

    DECLARE @Precio DECIMAL(10,2) = (SELECT Precio FROM administracion.Producto WHERE CodProducto = @CodProducto);

    INSERT INTO ventas.DetalleVenta (VentaId, CodProducto, Cantidad, Precio)
    VALUES (@VentaID, @CodProducto, @Cantidad, @Precio);

    PRINT 'Producto agregado al detalle de venta.';
END;
GO

-- Procedimiento para confirmar el pago de una venta
CREATE OR ALTER PROCEDURE ventas.ConfirmarVenta
    @VentaID INT,
    @FacturaId VARCHAR(40) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que la venta esté en estado "Pendiente"
    IF NOT EXISTS (SELECT 1 FROM ventas.Venta WHERE Id = @VentaID AND EstadoVenta = 'Pendiente')
    BEGIN
        PRINT 'La venta no puede ser confirmada porque ya ha sido cerrada o cancelada.';
        RETURN;
    END

    -- Generar el número de factura
    DECLARE @TipoFactura CHAR(1), @SucursalID INT;
    SELECT @TipoFactura = TipoFactura, @SucursalID = SucursalID FROM ventas.Venta WHERE Id = @VentaID;
    EXEC administracion.GenerarNumeroFactura @SucursalID, @TipoFactura, @FacturaId OUTPUT;

    -- Actualizar la venta a estado "Confirmado" y asignar el FacturaId
    UPDATE ventas.Venta
    SET FacturaId = @FacturaId, EstadoVenta = 'Confirmado'
    WHERE Id = @VentaID;

    PRINT 'Venta confirmada, se ha generado la factura.';
END;
GO

-- Procedimiento para confirmar el pago de la venta
CREATE OR ALTER PROCEDURE ventas.ConfirmarPago
    @VentaID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que la venta esté en estado "Pendiente"
    IF NOT EXISTS (SELECT 1 FROM ventas.Venta WHERE Id = @VentaID AND EstadoVenta = 'Confirmado')
    BEGIN
        PRINT 'El pago no puede realizarse porque la venta no esta confirmada.';
        RETURN;
    END

    -- Actualizar el estado de pago a "Pagado"
    UPDATE ventas.Venta
    SET EstadoPago = 'Pagado'
    WHERE Id = @VentaID;

    PRINT 'Pago confirmado.';
END;
GO

-- Procedimiento para cambiar el método de pago en caso de fallo
CREATE OR ALTER PROCEDURE ventas.CambiarMetodoPago
    @VentaID INT,
    @NuevoMedioPagoID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que la venta esté en estado "Pendiente"
    IF NOT EXISTS (SELECT 1 FROM ventas.Venta WHERE Id = @VentaID AND EstadoPago = 'Pendiente')
    BEGIN
        PRINT 'El método de pago no puede ser cambiado porque la venta ya ha sido cerrada o cancelada.';
        RETURN;
    END

    -- Actualizar el método de pago
    UPDATE ventas.Venta
    SET MedioPagoID = @NuevoMedioPagoID
    WHERE Id = @VentaID;

    PRINT 'Método de pago actualizado correctamente.';
END;
GO

-- Procedimiento para cancelar la venta
CREATE OR ALTER PROCEDURE ventas.CancelarVenta
    @VentaID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ventas.Venta WHERE Id = @VentaID AND EstadoPago = 'Pagado')
    BEGIN
        PRINT 'La venta no puede ser cancelada porque ya ha sido cerrada.';
        RETURN;
    END

    UPDATE ventas.Venta
    SET EstadoVenta = 'Cancelado', EstadoPago = NULL
    WHERE Id = @VentaID;

    PRINT 'Venta cancelada correctamente.';
END;
GO

--================================================================
-- Fin creacion ABM tabla Venta
--================================================================
--================================================================
-- Inicio creacion ABM tabla NotaDeCredito
--================================================================

-- Insertar NotaDeCredito

CREATE OR ALTER PROCEDURE administracion.InsertarNotaDeCredito
    @FacturaId VARCHAR(40),
    @Monto DECIMAL(10,2),                 
    @MotivoDevolucion VARCHAR(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @VentaId INT;
    DECLARE @EmpleadoID INT;

    -- Obtener el VentaId y verificar que el EstadoVenta sea 'Pagado'
    SELECT @VentaId = Id, @EmpleadoID = EmpleadoID
    FROM ventas.Venta
    WHERE FacturaId = @FacturaId AND EstadoPago = 'Pagado';

    IF @VentaId IS NOT NULL
    BEGIN
        -- Insertar la nota de crédito asociada a la venta
        INSERT INTO administracion.NotaDeCredito (VentaId, FacturaId, TipoFactura, Monto, Fecha, EmpleadoID, Estado, MotivoDevolucion)
        VALUES (@VentaId, @FacturaId, 'A', @Monto, GETDATE(), @EmpleadoID, 'Pendiente', @MotivoDevolucion);

        PRINT 'Nota de crédito creada exitosamente.';
    END
    ELSE
    BEGIN
        PRINT 'No se puede crear la nota de crédito. La factura no existe o no está en estado "Pagado".';
    END
END
GO

-- Modificacion NotaDeCredito

CREATE OR ALTER PROCEDURE administracion.ModificarNotaDeCredito
    @NotaDeCreditoId INT,
    @NuevoMonto DECIMAL(10,2),
    @NuevoMotivoDevolucion VARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;

    -- Verificar si la nota de crédito está en estado 'Pendiente'
    IF EXISTS (SELECT 1 FROM administracion.NotaDeCredito WHERE Id = @NotaDeCreditoId AND Estado = 'Pendiente')
    BEGIN
        UPDATE administracion.NotaDeCredito
        SET Monto = @NuevoMonto,
            MotivoDevolucion = @NuevoMotivoDevolucion
        WHERE Id = @NotaDeCreditoId;

        PRINT 'Nota de crédito modificada exitosamente.';
    END
    ELSE
    BEGIN
        PRINT 'La nota de crédito existe o no está en estado "Pendiente". No se puede modificar.';
    END
END
GO

-- Cancelar NotaDeCredito

CREATE OR ALTER PROCEDURE administracion.CancelarNotaDeCredito
    @NotaDeCreditoId INT
AS
BEGIN
	SET NOCOUNT ON;

    -- Verificar si existen ventas relacionadas con la nota de crédito y que tengan EstadoPago = 'Pagado'
    IF EXISTS (
        SELECT 1
        FROM ventas.Venta
        WHERE FacturaId IN (SELECT FacturaId FROM administracion.NotaDeCredito WHERE Id = @NotaDeCreditoId)
        AND EstadoPago = 'Pagado'
    )
    BEGIN
        UPDATE administracion.NotaDeCredito
        SET Estado = 'Cancelada'
        WHERE Id = @NotaDeCreditoId;
        
        PRINT 'La nota de crédito ha sido cancelada exitosamente.';
    END
    ELSE
    BEGIN
        PRINT 'No se puede cancelar la nota de crédito porque no existe o el pago no está efectuado.';
    END
END

--================================================================
-- Fin creacion ABM tabla NotaDeCredito
--================================================================