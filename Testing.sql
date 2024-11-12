USE Com5600G09;

--==========================================================
-- Inicio tests tabla Sucursal
--==========================================================

-- Insertar sucursales

EXEC ddbba.InsertarSucursales @Ruta = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';

-- ABM sucursales

EXEC ddbba.InsertarSucursal
							@Nombre = 'Coraje', 
							@Ciudad = 'San Isidro', 
							@Direccion = 'Av Chascomus 1829', 
							@Horario = 'Lunes a jueves 17hs a 21hs',
							@Telefono = '44123578'

EXEC ddbba.ModificarSucursal
							 @PuntoDeVenta = 4,
							 @Nombre = 'Sucursal Modificada',
							 @Ciudad = 'Ciudad Modificada',
							 @Direccion = 'Direccion Modificada',
							 @Horario = 'Lunes a Viernes 9:00-19:00',
							 @Telefono = '98765432'

EXEC ddbba.EliminarSucursal @PuntoDeVenta = 4

--==========================================================
-- Fin tests tabla Sucursal
--==========================================================
--==========================================================
-- Inicio tests tabla Cargo
--==========================================================

-- ABM cargo

EXEC ddbba.InsertarCargo @Cargo = 'Cajero'
EXEC ddbba.InsertarCargo @Cargo = 'Supervisor'
EXEC ddbba.InsertarCargo @Cargo = 'Gerente de sucursal'
EXEC ddbba.InsertarCargo @Cargo = 'Camionero'


EXEC ddbba.ModificarCargo @Id = 4, @Cargo = 'Gerente'

EXEC ddbba.EliminarCargo @Id = 4

--==========================================================
-- Fin tests tabla Cargo
--==========================================================
--==========================================================
-- Inicio tests tabla Empleado
--==========================================================

-- Insertar empleados

EXEC ddbba.InsertarEmpleados @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';

-- ABM empleados

EXEC ddbba.InsertarEmpleado 
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

EXEC ddbba.ModificarEmpleado 
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

EXEC ddbba.EliminarEmpleado @Legajo = 12345;

--==========================================================
-- Fin tests tabla Empleado
--==========================================================
--==========================================================
-- Inicio tests tabla MedioDePago
--==========================================================

-- Insertar Medios de pago

EXEC ddbba.InsertarMediosDePago @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';

-- ABM Medio de pago

EXEC ddbba.InsertarMedioDePago @Nombre = 'Casheable', @Descripcion = 'Efectivo copado'

EXEC ddbba.ModificarMedioDePago @Nombre = 'Casheable', @Descripcion = 'Efectivo'

EXEC ddbba.EliminarMedioDePago @Nombre = 'Casheable'

--==========================================================
-- Fin tests tabla MedioDePago
--==========================================================
--==========================================================
-- Inicio tests tabla Producto
--==========================================================

-- Insertar Productos

EXEC ddbba.InsertarCatalogoEnProducto @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\catalogo.csv';

EXEC ddbba.InsertarElectronicosEnProducto @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\Electronic accessories.xlsx';

EXEC ddbba.InsertarImportadosEnProducto @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\Productos_importados.xlsx';

-- ABM Producto

EXEC ddbba.InsertarProducto 
							@Descripcion = 'Paralelas', 
							@Categoria = 'Medicina',
							@Linea = '',
							@Proveedor = '',
							@CantPorUnidad = '',
							@Precio = 12,
							@PrecioRef = '',
							@Moneda = '',
							@UnidadRef = ''

EXEC ddbba.ModificarProducto
							@CodProducto = '660AF3C432D59FE132B705849667D11820DC4F87',
							@Linea = 'HOGAR',
							@Proveedor = '',
							@CantPorUnidad = '',
							@Precio = 15,
							@PrecioRef = '',
							@Moneda = '',
							@UnidadRef = ''

EXEC ddbba.EliminarProducto @CodProducto = '660AF3C432D59FE132B705849667D11820DC4F87'

--==========================================================
-- Fin tests tabla Producto
--==========================================================
--==========================================================
-- Inicio tests tabla Cliente
--==========================================================

EXEC ddbba.InsertarCliente
    @Dni = '12345678',
    @Nombre = 'Juan',
    @Apellido = 'Perez',
    @Genero = 'Masculino',
    @TipoCliente = 'Particular',
    @CondicionIVA = 'Consumidor Final',
    @Cuit = '20-123456789-0',
    @DomicilioFiscal = 'Av. Libertador 1234';

EXEC ddbba.ModificarCliente
    @Dni = '12345678',
    @Nombre = 'Pedro',
    @Apellido = 'Gomez',
    @Genero = 'Masculino',
    @TipoCliente = 'Empresa',
    @CondicionIVA = 'Responsable Inscripto',
    @Cuit = '20-987654321-0',
    @DomicilioFiscal = 'Calle Ficticia 4567';

EXEC ddbba.EliminarCliente @Dni = '12345678';

--==========================================================
-- Fin tests tabla Cliente
--==========================================================
--==========================================================
-- Inicio tests Ventas
--==========================================================

DECLARE @VentaID INT;
EXEC ddbba.IniciarVenta 
    @EmpleadoID = 257020, 
    @SucursalID = 1,
    @ClienteID = 1,
    @MedioPagoID = 1,
    @TipoFactura = 'A',
    @VentaID = @VentaID OUTPUT;

EXEC ddbba.AgregarDetalleVenta @VentaID = @VentaID, @CodProducto = '732D2678CD17CA12AECCD2F0768A692DD36AA975', @Cantidad = 2
EXEC ddbba.AgregarDetalleVenta @VentaID = @VentaID, @CodProducto = 'EA7A618817ECF3DA0591417CE19D096A8EA429A8', @Cantidad = 3


DECLARE @FacturaId VARCHAR(40);

EXEC ddbba.ConfirmarVenta @VentaID = 7, @FacturaId = @FacturaId OUTPUT;

EXEC ddbba.ConfirmarPago @VentaID = 4

EXEC ddbba.CambiarMetodoPago @VentaID = 2, @NuevoMedioPagoID = 3

EXEC ddbba.CancelarVenta @VentaID = 2
