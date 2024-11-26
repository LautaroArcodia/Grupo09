USE Com5600G09;
GO

-- NOTA 1: En ruta copiar la ruta de los archivos a probar

-- NOTA 2: 
--			Antes de insertar Empleados se deben insertar datos en la tabla Cargo.

--			EJEMPLO:

			EXEC administracion.InsertarCargo @Cargo = 'Cajero'
			GO
			EXEC administracion.InsertarCargo @Cargo = 'Supervisor'
			GO
			EXEC administracion.InsertarCargo @Cargo = 'Gerente de sucursal'
			GO

--==========================================================
-- Inicio tests tabla Sucursal
--==========================================================

EXEC administracion.InsertarSucursales @Ruta = 'Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla Sucursal
--==========================================================
--==========================================================
-- Inicio tests tabla Empleado
--==========================================================

EXEC administracion.InsertarEmpleados @RutaArchivo = 'Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla Empleado
--==========================================================
--==========================================================
-- Inicio tests tabla MedioDePago
--==========================================================

EXEC administracion.InsertarMediosDePago @RutaArchivo = 'Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla MedioDePago
--==========================================================
--==========================================================
-- Inicio tests tabla Producto
--==========================================================

-- Actualizar Productos

EXEC administracion.InsertarCatalogoEnProducto @RutaArchivo = 'catalogo.csv';
GO
EXEC administracion.InsertarElectronicosEnProducto @RutaArchivo = 'Electronic accessories.xlsx';
GO
EXEC administracion.InsertarImportadosEnProducto @RutaArchivo = 'Productos_importados.xlsx';
GO
-- Actualizar Lineas de productos

EXEC administracion.ActualizarLineasEnProducto @RutaArchivo = 'Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla Producto
--==========================================================