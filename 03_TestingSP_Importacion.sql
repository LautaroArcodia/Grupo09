USE Com5600G09;
GO

-- NOTA : En ruta copiar la ruta de los archivos a probar

--==========================================================
-- Inicio tests tabla Sucursal
--==========================================================

EXEC administracion.InsertarSucursales @Ruta = 'Informacion_complementaria.xlsx';

--==========================================================
-- Fin tests tabla Sucursal
--==========================================================
--==========================================================
-- Inicio tests tabla Empleado
--==========================================================

EXEC administracion.InsertarEmpleados @RutaArchivo = 'Informacion_complementaria.xlsx';

--==========================================================
-- Fin tests tabla Empleado
--==========================================================
--==========================================================
-- Inicio tests tabla MedioDePago
--==========================================================

EXEC administracion.InsertarMediosDePago @RutaArchivo = 'Informacion_complementaria.xlsx';

--==========================================================
-- Fin tests tabla MedioDePago
--==========================================================
--==========================================================
-- Inicio tests tabla Producto
--==========================================================

-- Actualizar Productos

EXEC administracion.InsertarCatalogoEnProducto @RutaArchivo = 'catalogo.csv';

EXEC administracion.InsertarElectronicosEnProducto @RutaArchivo = 'Electronic accessories.xlsx';

EXEC administracion.InsertarImportadosEnProducto @RutaArchivo = 'Productos_importados.xlsx';

-- Actualizar Lineas de productos

EXEC administracion.ActualizarLineasEnProducto @RutaArchivo = 'Informacion_complementaria.xlsx';

--==========================================================
-- Fin tests tabla Producto
--==========================================================