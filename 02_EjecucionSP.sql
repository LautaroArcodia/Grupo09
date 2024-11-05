USE Com5600G09;

BEGIN TRY
	BEGIN TRANSACTION

	 EXEC ddbba.InsertarSucursales @Ruta = 'Informacion_complementaria.xlsx';
	
	 EXEC ddbba.InsertarEmpleados @RutaArchivo = 'Informacion_complementaria.xlsx';

	 EXEC ddbba.InsertarCatalogoEnProductos @RutaArchivo = 'catalogo.csv';

	 EXEC ddbba.InsertarElectronicosEnProductos @RutaArchivo = 'Electronic accessories.xlsx';

	 EXEC ddbba.InsertarImportadosEnProductos @RutaArchivo = 'Productos_importados.xlsx';
	
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT '[ERROR] - NO SE HAN PODIDO REALIZAR LAS IMPORTACIONES'
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION

END CATCH