USE Com5600G09
GO

--==========================================================
-- Inicio tests tabla Sucursal
--==========================================================

EXEC administracion.InsertarSucursal
							@Nombre = 'Coraje', 
							@Ciudad = 'San Isidro', 
							@Direccion = 'Av Chascomus 1829', 
							@Horario = 'Lunes a jueves 17hs a 21hs',
							@Telefono = '44123578'

EXEC administracion.ModificarSucursal
							 @PuntoDeVenta = 4,
							 @Nombre = 'Sucursal Modificada',
							 @Ciudad = 'Ciudad Modificada',
							 @Direccion = 'Direccion Modificada',
							 @Horario = 'Lunes a Viernes 9:00-19:00',
							 @Telefono = '98765432'

EXEC administracion.EliminarSucursal @PuntoDeVenta = 5

--==========================================================
-- Fin tests tabla Sucursal
--==========================================================
--==========================================================
-- Inicio tests tabla Cargo
--==========================================================

EXEC administracion.InsertarCargo @Cargo = 'Cajero'
EXEC administracion.InsertarCargo @Cargo = 'Supervisor'
EXEC administracion.InsertarCargo @Cargo = 'Gerente de sucursal'
EXEC administracion.InsertarCargo @Cargo = 'Camionero'

EXEC administracion.ModificarCargo @Id = 4, @Cargo = 'Gerente'

EXEC administracion.EliminarCargo @Id = 4

--==========================================================
-- Fin tests tabla Cargo
--==========================================================
--==========================================================
-- Inicio tests tabla Empleado
--==========================================================

EXEC administracion.InsertarEmpleado 
    @Legajo = 12345,
    @Nombre = 'Juan',
    @Apellido = 'Pérez',
    @Dni = 12345678,
    @Direccion = 'Calle Ficticia 123',
    @EmailPersonal = 'juan.perez@gmail.com',
    @EmailEmpresa = 'juan.perez@empresa.com',
    @Cuil = '20-12345678-9',
    @Cargo = 'Cajero', 
    @Sucursal = 'San Justo', 
    @Turno = 'Mañana';

EXEC administracion.ModificarEmpleado 
    @Legajo = 12345,
    @Nombre = 'Juan',
    @Apellido = 'Pérez',
    @Dni = 12345678,
    @Direccion = 'Calle Ficticia 123',
    @EmailPersonal = 'juan.perez@gmail.com',
    @EmailEmpresa = 'juan.perez@empresa.com',
    @Cuil = '20-12345678-9',
    @Cargo = 'Supervisor', 
    @Sucursal = 'Ramos Mejia', 
    @Turno = 'Tarde';

EXEC administracion.EliminarEmpleado @Legajo = 12345;

--==========================================================
-- Fin tests tabla Empleado
--==========================================================
--==========================================================
-- Inicio tests tabla MedioDePago
--==========================================================

EXEC administracion.InsertarMedioDePago @Nombre = 'Casheable', @Descripcion = 'Efectivo copado'

EXEC administracion.ModificarMedioDePago @Nombre = 'Casheable', @Descripcion = 'Efectivo'

EXEC administracion.EliminarMedioDePago @Nombre = 'Casheable'

--==========================================================
-- Fin tests tabla MedioDePago
--==========================================================
--==========================================================
-- Inicio tests tabla Producto
--==========================================================

EXEC administracion.InsertarProducto 
							@Descripcion = 'Paralelas', 
							@Categoria = 'Medicina',
							@Linea = '',
							@Proveedor = '',
							@CantPorUnidad = '',
							@Precio = 12,
							@PrecioRef = '',
							@Moneda = '',
							@UnidadRef = ''

EXEC administracion.ModificarProducto
							@CodProducto = '660AF3C432D59FE132B705849667D11820DC4F87',
							@Linea = 'HOGAR',
							@Proveedor = '',
							@CantPorUnidad = '',
							@Precio = 15,
							@PrecioRef = '',
							@Moneda = '',
							@UnidadRef = ''

EXEC administracion.EliminarProducto @CodProducto = '660AF3C432D59FE132B705849667D11820DC4F87'

--==========================================================
-- Fin tests tabla Producto
--==========================================================
--==========================================================
-- Inicio tests tabla Cliente
--==========================================================

EXEC ventas.InsertarCliente
    @Dni = '12345678',
    @Nombre = 'Juan',
    @Apellido = 'Perez',
    @Genero = 'M',
    @TipoCliente = 'Particular',
    @CondicionIVA = 'Consumidor Final',
    @Cuit = '20-123456789-0',
    @DomicilioFiscal = 'Av. Libertador 1234';

EXEC ventas.ModificarCliente
    @Dni = '12345678',
    @Nombre = 'Pedro',
    @Apellido = 'Gomez',
    @Genero = 'M',
    @TipoCliente = 'Empresa',
    @CondicionIVA = 'Responsable Inscripto',
    @Cuit = '20-987654321-0',
    @DomicilioFiscal = 'Calle Ficticia 4567';

EXEC ventas.EliminarCliente @Dni = '12345678';

--==========================================================
-- Fin tests tabla Cliente
--==========================================================
--==========================================================
-- Inicio tests Ventas
--==========================================================

DECLARE @VentaID INT;
EXEC ventas.IniciarVenta 
    @EmpleadoID = 257020, 
    @SucursalID = 1,
    @ClienteID = 1,
    @MedioPagoID = 1,
    @TipoFactura = 'A',
    @VentaID = @VentaID OUTPUT;

EXEC ventas.AgregarDetalleVenta @VentaID = 1, @CodProducto = '4A7F227C3B7866356A78E1DC8B1607A5309D0B01', @Cantidad = 2
EXEC ventas.AgregarDetalleVenta @VentaID = 1, @CodProducto = 'EA7A618817ECF3DA0591417CE19D096A8EA429A8', @Cantidad = 5
EXEC ventas.AgregarDetalleVenta @VentaID = 1, @CodProducto = '5E93CBD575233272EC6BF9A68C77A32D822CF1D9', @Cantidad = 5

DECLARE @FacturaId VARCHAR(40);
EXEC ventas.ConfirmarVenta @VentaID = 1, @FacturaId = @FacturaId OUTPUT;

EXEC ventas.ConfirmarPago @VentaID = 1

EXEC ventas.CambiarMetodoPago @VentaID = 1, @NuevoMedioPagoID = 3

EXEC ventas.CancelarVenta @VentaID = 1

--==========================================================
-- Fin tests Ventas
--==========================================================
--==========================================================
-- Inicio tests Devoluciones (NotaDeCredito)
--==========================================================

-- Insertar nota de credito con determinados productos

DECLARE @Detalles administracion.DetalleNotaDeCreditoVar;
INSERT INTO @Detalles (CodProducto, Cantidad)
VALUES ('4A7F227C3B7866356A78E1DC8B1607A5309D0B01', 2),
	   ('EA7A618817ECF3DA0591417CE19D096A8EA429A8', 1),
	   ('5E93CBD575233272EC6BF9A68C77A32D822CF1D9', 3);

EXEC administracion.InsertarNotaDeCreditoConDetalles '0001-B0000001', @Detalles, NULL;

-- Insertar nota de credito del total de la factura (Todos los productos)

DECLARE @Detalles administracion.DetalleNotaDeCreditoVar;

EXEC administracion.InsertarNotaDeCreditoConDetalles '0001-B0000001', @Detalles, 'Roto';

-- Cancelar nota de credito

EXEC administracion.CancelarNotaDeCredito 3;

--==========================================================
-- Fin tests Devoluciones (NotaDeCredito)
--==========================================================




