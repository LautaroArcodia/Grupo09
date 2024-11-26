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

EXEC administracion.InsertarSucursales @Ruta = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla Sucursal
--==========================================================
--==========================================================
-- Inicio tests tabla Empleado
--==========================================================

EXEC administracion.InsertarEmpleados @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla Empleado
--==========================================================
--==========================================================
-- Inicio tests tabla MedioDePago
--==========================================================

EXEC administracion.InsertarMediosDePago @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla MedioDePago
--==========================================================
--==========================================================
-- Inicio tests tabla Producto
--==========================================================

-- Actualizar Productos

EXEC administracion.InsertarCatalogoEnProducto @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\catalogo.csv';
GO
EXEC administracion.InsertarElectronicosEnProducto @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\Electronic accessories.xlsx';
GO
EXEC administracion.InsertarImportadosEnProducto @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\Productos_importados.xlsx';
GO
-- Actualizar Lineas de productos

EXEC administracion.ActualizarLineasEnProducto @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';
GO
--==========================================================
-- Fin tests tabla Producto
--==========================================================