USE Com5600G09;

BEGIN TRY
	BEGIN TRANSACTION

	 EXEC ddbba.InsertarSucursales @Ruta = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';
	
	 EXEC ddbba.InsertarEmpleados @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Informacion_complementaria.xlsx';

	 EXEC ddbba.InsertarCatalogoEnProductos @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\catalogo.csv';

	 EXEC ddbba.InsertarElectronicosEnProductos @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\Electronic accessories.xlsx';

	 EXEC ddbba.InsertarImportadosEnProductos @RutaArchivo = 'C:\Users\Lautaro\Desktop\UNLAM\BD_Aplicadas\TP\TP_integrador_Archivos\Productos\Productos_importados.xlsx';
	
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT '[ERROR] - NO SE HAN PODIDO REALIZAR LAS IMPORTACIONES'
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION

END CATCH