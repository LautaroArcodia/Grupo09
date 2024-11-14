USE Com5600G09;
GO

--==========================================================
-- Inicio ACLARACIONES
--==========================================================

-- Para realizar pruebas se pueden ejecutar de 2 maneras:

-- Se puede ejecutar este codigo para simular en esta pestaña el usuario (u omitir este paso y ejecutar todo como admin)
-- EXECUTE AS USER = 'Test1User';

--select current_user

-- O tambien se puede crear una nueva consulta a partir de loggearse con algun login creado (Ejemplo: Test1)
-- Y copiar los EXEC que quiera ejecutar en dicha sesion

--==========================================================
-- Fin ACLARACIONES
--==========================================================
--==========================================================
-- Inicio tests tabla Sucursal
--==========================================================

-- Insertar sucursales

EXEC administracion.InsertarSucursales @Ruta = 'Informacion_complementaria.xlsx';

-- ABM sucursales

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

EXEC administracion.EliminarSucursal @PuntoDeVenta = 4

--==========================================================
-- Fin tests tabla Sucursal
--==========================================================
--==========================================================
-- Inicio tests tabla Cargo
--==========================================================

-- ABM cargo

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

-- Insertar empleados

EXEC administracion.InsertarEmpleados @RutaArchivo = 'Informacion_complementaria.xlsx';

-- ABM empleados

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

-- Insertar Medios de pago

EXEC administracion.InsertarMediosDePago @RutaArchivo = 'Informacion_complementaria.xlsx';

-- ABM Medio de pago

EXEC administracion.InsertarMedioDePago @Nombre = 'Casheable', @Descripcion = 'Efectivo copado'

EXEC administracion.ModificarMedioDePago @Nombre = 'Casheable', @Descripcion = 'Efectivo'

EXEC administracion.EliminarMedioDePago @Nombre = 'Casheable'

--==========================================================
-- Fin tests tabla MedioDePago
--==========================================================
--==========================================================
-- Inicio tests tabla Producto
--==========================================================

-- Insertar Productos

EXEC administracion.InsertarCatalogoEnProducto @RutaArchivo = 'catalogo.csv';

EXEC administracion.InsertarElectronicosEnProducto @RutaArchivo = 'Electronic accessories.xlsx';

EXEC administracion.InsertarImportadosEnProducto @RutaArchivo = 'Productos_importados.xlsx';

-- Actualizar Lineas de productos

EXEC administracion.ActualizarLineasEnProducto @RutaArchivo = 'Informacion_complementaria.xlsx';

-- ABM Producto

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
    @Genero = 'Masculino',
    @TipoCliente = 'Particular',
    @CondicionIVA = 'Consumidor Final',
    @Cuit = '20-123456789-0',
    @DomicilioFiscal = 'Av. Libertador 1234';

EXEC ventas.ModificarCliente
    @Dni = '12345678',
    @Nombre = 'Pedro',
    @Apellido = 'Gomez',
    @Genero = 'Masculino',
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

EXEC ventas.AgregarDetalleVenta @VentaID = 1, @CodProducto = '732D2678CD17CA12AECCD2F0768A692DD36AA975', @Cantidad = 2
EXEC ventas.AgregarDetalleVenta @VentaID = 1, @CodProducto = 'EA7A618817ECF3DA0591417CE19D096A8EA429A8', @Cantidad = 3


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

EXEC administracion.InsertarNotaDeCredito '0001-A0000001',1000.00, 'Producto defectuoso';

EXEC administracion.ModificarNotaDeCredito 1, 1500.00, 'Cambio de opinión';

EXEC administracion.CancelarNotaDeCredito 1;

--==========================================================
-- Fin tests Devoluciones (NotaDeCredito)
--==========================================================