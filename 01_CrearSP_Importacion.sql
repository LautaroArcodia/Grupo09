/*
Enunciado:

Se proveen los archivos en el TP_integrador_Archivos.zip 
Ver archivo “Datasets para importar” en Miel. 
Se requiere que importe toda la información antes mencionada a la base de datos: 
• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los 
archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de 
novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.  
• Considere este comportamiento al generar el código. Debe admitir la importación de 
novedades periódicamente. 
• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que 
realicen tareas por fuera de un SP. 
• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba 
realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la 
estructura requerida.  
• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal 
cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones 
en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible 
interpretarlo como JSON o CSV). 

Fecha de entrega: 01/11/2024
Numero de grupo: 9
Nombre de la materia: Bases de Datos Aplicadas
Alumnos:
Arcodia Lautaro	     DNI: 41588362
Gorosito Candela     DNI: 43896171
Paez Maximiliano     DNI: 44004413
*/

USE Com5600G09;
GO

--==========================================================
-- Inicio creacion SP insercion masiva en tabla Sucursal
--==========================================================

CREATE OR ALTER PROCEDURE administracion.InsertarSucursales
    @Ruta NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #SucursalesSinDuplicados (
        Nombre VARCHAR(50),
        Ciudad VARCHAR(50),
        Direccion VARCHAR(100),
        Horario VARCHAR(50),
        Telefono CHAR(20)
    );

    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'INSERT INTO #SucursalesSinDuplicados (Nombre, Ciudad, Direccion, Horario, Telefono)
                SELECT * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
                ''Excel 12.0; Database=' + @Ruta + '; HDR=YES'',
                ''SELECT * FROM [sucursal$]'')';
    EXEC sp_executesql @SQL;

    DECLARE @TotalSucursales INT;
    SET @TotalSucursales = (SELECT COUNT(*) FROM #SucursalesSinDuplicados);

    INSERT INTO administracion.Sucursal (Nombre, Ciudad, Direccion, Horario, Telefono, PuntoDeVenta)
    SELECT 
        T.Nombre, 
        T.Ciudad, 
        T.Direccion, 
        T.Horario, 
        T.Telefono,
        NEXT VALUE FOR administracion.Seq_PuntoDeVenta
    FROM #SucursalesSinDuplicados AS T
    WHERE NOT EXISTS (
        SELECT 1 
        FROM administracion.Sucursal AS S 
        WHERE S.Nombre = T.Nombre AND S.Direccion = T.Direccion
    );

    DECLARE @NumInserciones INT;
    SET @NumInserciones = @@ROWCOUNT;

    DECLARE @NumDuplicados INT;
    SET @NumDuplicados = @TotalSucursales - @NumInserciones;

    DROP TABLE #SucursalesSinDuplicados;

    IF @NumInserciones > 0
    BEGIN
        PRINT CAST(@NumInserciones AS NVARCHAR(10)) + ' sucursales insertadas exitosamente.';
    END

    IF @NumDuplicados > 0
    BEGIN
        PRINT CAST(@NumDuplicados AS NVARCHAR(10)) + ' sucursales ya existían y no fueron insertadas.';
    END
END;
GO

--==========================================================
-- Fin creacion SP insercion masiva en tabla Sucursal
--==========================================================
--==========================================================
-- Inicio creacion SP insercion masiva en tabla Empleado
--==========================================================

CREATE OR ALTER PROCEDURE administracion.InsertarEmpleados
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DROP TABLE IF EXISTS #TempEmpleados;

        CREATE TABLE #TempEmpleados (
            Legajo INT,
            Nombre VARCHAR(50),
            Apellido VARCHAR(50),
            Dni INT,
            Direccion VARCHAR(100),
            EmailPersonal VARCHAR(100),
            EmailEmpresa VARCHAR(100),
            Cuil VARCHAR(30),
            Cargo VARCHAR(50),
            SucursalCiudad VARCHAR(50),
            Turno CHAR(20)
        );

        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        INSERT INTO #TempEmpleados (Legajo, Nombre, Apellido, Dni, Direccion, EmailPersonal, EmailEmpresa, Cuil, Cargo, SucursalCiudad, Turno)
        SELECT 
            CASE WHEN [Legajo/ID] IS NOT NULL AND TRY_CAST([Legajo/ID] AS INT) IS NOT NULL THEN [Legajo/ID] END AS Legajo, 
            Nombre, 
            Apellido, 
            DNI AS Dni, 
            Direccion, 
            [email personal] AS EmailPersonal, 
            [email empresa] AS EmailEmpresa, 
            CUIL AS Cuil, 
            Cargo, 
            Sucursal AS SucursalCiudad,
            Turno
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'', 
            ''Excel 12.0;Database=' + @RutaArchivo + N';HDR=YES'',
            ''SELECT [Legajo/ID], Nombre, Apellido, DNI, Direccion, [email personal], [email empresa], CUIL, Cargo, Sucursal, Turno FROM [Empleados$]''
		) AS ExcelData
		WHERE [Legajo/ID] IS NOT NULL AND TRY_CAST([Legajo/ID] AS INT) IS NOT NULL;';

        EXEC sp_executesql @sql;

        CREATE TABLE #TempAccionMerge (
            Action NVARCHAR(10)
        );

        -- Usar MERGE para insertar o actualizar empleados
        MERGE INTO administracion.Empleado AS E
        USING (
            SELECT 
                T.Legajo, 
                T.Nombre, 
                T.Apellido,
                T.Dni, 
                T.Direccion, 
                T.EmailPersonal,
                T.EmailEmpresa,
                T.Cuil,
                (SELECT C.ID
                 FROM administracion.Cargo AS C
                 WHERE C.Puesto = T.Cargo) AS CargoId,
                T.Turno,
                (SELECT S.ID
                 FROM administracion.Sucursal AS S
                 WHERE S.Ciudad = T.SucursalCiudad) AS SucursalId
            FROM #TempEmpleados AS T
            WHERE T.Legajo IS NOT NULL
        ) AS Temp
        ON E.Legajo = Temp.Legajo

        WHEN MATCHED AND (
                E.Nombre <> Temp.Nombre OR 
                E.Apellido <> Temp.Apellido OR 
                E.Dni <> Temp.Dni OR 
                E.Direccion <> Temp.Direccion OR 
                E.EmailPersonal <> Temp.EmailPersonal OR 
                E.EmailEmpresa <> Temp.EmailEmpresa OR 
                E.Cuil <> Temp.Cuil OR 
                E.CargoId <> Temp.CargoId OR 
                E.Turno <> Temp.Turno OR 
                E.SucursalId <> Temp.SucursalId
            )
            THEN UPDATE SET
                E.Nombre = Temp.Nombre,
                E.Apellido = Temp.Apellido,
                E.Dni = Temp.Dni,
                E.Direccion = Temp.Direccion,
                E.EmailPersonal = Temp.EmailPersonal,
                E.EmailEmpresa = Temp.EmailEmpresa,
                E.Cuil = Temp.Cuil,
                E.CargoId = Temp.CargoId,
                E.Turno = Temp.Turno,
                E.SucursalId = Temp.SucursalId

        WHEN NOT MATCHED THEN
            INSERT (Legajo, Nombre, Apellido, Dni, Direccion, EmailPersonal, EmailEmpresa, Cuil, CargoId, Turno, SucursalId)
            VALUES (Temp.Legajo, Temp.Nombre, Temp.Apellido, Temp.Dni, Temp.Direccion, Temp.EmailPersonal, Temp.EmailEmpresa, Temp.Cuil, Temp.CargoId, Temp.Turno, Temp.SucursalId)
        
        OUTPUT $action INTO #TempAccionMerge;

        -- Contar filas insertadas, actualizadas y omitidas
        DECLARE @FilasInsertadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'INSERT');
        DECLARE @FilasActualizadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'UPDATE');
		DECLARE @FilasOmitidas INT = (SELECT COUNT(*) FROM #TempEmpleados) - (@FilasInsertadas + @FilasActualizadas);

        PRINT 'Proceso completado para Empleados';
        PRINT 'Filas insertadas: ' + CAST(@FilasInsertadas AS NVARCHAR(10));
        PRINT 'Filas actualizadas: ' + CAST(@FilasActualizadas AS NVARCHAR(10));
        PRINT 'Filas omitidas: ' + CAST(@FilasOmitidas AS NVARCHAR(10));
        
		DROP TABLE #TempAccionMerge;
        DROP TABLE #TempEmpleados;

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar o actualizar empleados: ' + ERROR_MESSAGE();
        IF OBJECT_ID('tempdb..#TempEmpleados') IS NOT NULL
            DROP TABLE #TempEmpleados;
        IF OBJECT_ID('tempdb..#TempAccionMerge') IS NOT NULL
            DROP TABLE #TempAccionMerge;
    END CATCH;
END;
GO

--==========================================================
-- Fin creacion SP insercion masiva en tabla Empleado
--==========================================================
--==========================================================
-- Inicio creacion SP insercion masiva en tabla MedioDePago
--==========================================================

CREATE OR ALTER PROCEDURE administracion.InsertarMediosDePago
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DROP TABLE IF EXISTS #TempMediosPago;

        CREATE TABLE #TempMediosPago (
            Nombre VARCHAR(50),
            Descripcion VARCHAR(100)
        );

        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        INSERT INTO #TempMediosPago (Nombre, Descripcion)
        SELECT 
            F2 AS Nombre, 
            F3 AS Descripcion
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'', 
            ''Excel 12.0;Database=' + @RutaArchivo + N';HDR=NO'',
            ''SELECT * FROM [medios de pago$]''
        ) AS ExcelData
        WHERE F2 IS NOT NULL AND F3 IS NOT NULL;';

        EXEC sp_executesql @sql;

        CREATE TABLE #TempAccionMerge (
            Action NVARCHAR(10)
        );

        MERGE INTO administracion.MedioDePago AS MP
        USING (
            SELECT Nombre, Descripcion FROM #TempMediosPago
        ) AS Temp
        ON MP.Nombre = Temp.Nombre

        WHEN MATCHED AND MP.Descripcion <> Temp.Descripcion THEN
            UPDATE SET
                MP.Descripcion = Temp.Descripcion

        WHEN NOT MATCHED THEN
            INSERT (Nombre, Descripcion)
            VALUES (Temp.Nombre, Temp.Descripcion)
        
        OUTPUT $action INTO #TempAccionMerge;

        DECLARE @FilasInsertadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'INSERT');
        DECLARE @FilasActualizadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'UPDATE');
        DECLARE @FilasOmitidas INT = (SELECT COUNT(*) FROM #TempMediosPago) - (@FilasInsertadas + @FilasActualizadas);

        PRINT 'Proceso completado para Medios de Pago';
        PRINT 'Filas insertadas: ' + CAST(@FilasInsertadas AS NVARCHAR(10));
        PRINT 'Filas actualizadas: ' + CAST(@FilasActualizadas AS NVARCHAR(10));
        PRINT 'Filas omitidas: ' + CAST(@FilasOmitidas AS NVARCHAR(10));
        
        DROP TABLE #TempAccionMerge;
        DROP TABLE #TempMediosPago;

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar o actualizar medios de pago: ' + ERROR_MESSAGE();
        IF OBJECT_ID('tempdb..#TempMediosPago') IS NOT NULL
            DROP TABLE #TempMediosPago;
        IF OBJECT_ID('tempdb..#TempAccionMerge') IS NOT NULL
            DROP TABLE #TempAccionMerge;
    END CATCH;
END;
GO
--==========================================================
-- Fin creacion SP insercion masiva en tabla MedioDePago
--==========================================================
--==========================================================
-- Inicio creacion SP insercion masiva en tabla Producto
--==========================================================

-- Insercion Catalogo.csv

CREATE OR ALTER PROCEDURE administracion.InsertarCatalogoEnProducto
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        CREATE TABLE #TempCatalogo (
            id CHAR(10),
            category VARCHAR(50),
            name VARCHAR(100),
            price DECIMAL(10, 2),
            reference_price DECIMAL(10, 2),
            reference_unit CHAR(10),
            date DATETIME
        );

        DECLARE @SQL NVARCHAR(MAX);
        SET @SQL = N'
            BULK INSERT #TempCatalogo
            FROM ''' + @RutaArchivo + N'''
            WITH (
                FORMAT = ''CSV'',
                FIELDQUOTE = ''"'',
                FIELDTERMINATOR = '','',
                ROWTERMINATOR = ''0x0A'',
                FIRSTROW = 2,
                CODEPAGE = ''65001''
            );';

        EXEC sp_executesql @SQL;

        -- Verificar que se haya insertado al menos una fila
        IF (SELECT COUNT(*) FROM #TempCatalogo) = 0
        BEGIN
            PRINT 'No se encontraron registros en el archivo CSV.';
            RETURN;
        END

		-- Eliminar duplicados en #TempCatalogo basados en CodProducto (combinación de name y category)
        ;WITH CTE_Duplicados AS (
            SELECT *,
                ROW_NUMBER() OVER (PARTITION BY name, category ORDER BY id) AS RowNum
            FROM #TempCatalogo
        )
        DELETE FROM #TempCatalogo
        WHERE id IN (
            SELECT id FROM CTE_Duplicados WHERE RowNum > 1
        );

        -- Tabla temporal para registrar las operaciones del MERGE
        CREATE TABLE #TempAccionMerge (
            Action NVARCHAR(10)
        );

        MERGE INTO administracion.Producto AS P
        USING (
            SELECT
                name AS Descripcion, 
                category AS Categoria,
				NULL AS Linea,
                NULL AS Proveedor, 
                NULL AS CantPorUnidad, 
                price AS Precio, 
                reference_price AS PrecioRef,
                'USD' AS Moneda, 
                reference_unit AS UnidadRef,
				CONVERT(VARCHAR(40), HASHBYTES('SHA1', name + category), 2) AS CodProducto
            FROM #TempCatalogo
        ) AS Temp
        ON P.CodProducto = Temp.CodProducto

        WHEN MATCHED AND (
                P.Precio <> Temp.Precio OR 
                P.PrecioRef <> Temp.PrecioRef OR 
                P.UnidadRef <> Temp.UnidadRef
            )
            THEN UPDATE SET
                P.Precio = Temp.Precio,
                P.PrecioRef = Temp.PrecioRef,
                P.UnidadRef = Temp.UnidadRef
		
        WHEN NOT MATCHED THEN
            INSERT (Descripcion, Categoria, Linea, Proveedor, CantPorUnidad, Precio, PrecioRef, Moneda, UnidadRef)
            VALUES (Temp.Descripcion, Temp.Categoria, NULL, NULL, NULL, Temp.Precio, Temp.PrecioRef, Temp.Moneda, Temp.UnidadRef)
        
		OUTPUT $action INTO #TempAccionMerge;

        -- Contar filas insertadas, actualizadas y omitidas
        DECLARE @FilasInsertadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'INSERT');
        DECLARE @FilasActualizadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'UPDATE');
        DECLARE @FilasOmitidas INT = (SELECT COUNT(*) FROM #TempCatalogo) - (@FilasInsertadas + @FilasActualizadas);

        DROP TABLE #TempCatalogo;
        DROP TABLE #TempAccionMerge;

        PRINT 'Proceso completado para catalogo.csv';
        PRINT 'Filas insertadas: ' + CAST(@FilasInsertadas AS NVARCHAR(10));
        PRINT 'Filas actualizadas: ' + CAST(@FilasActualizadas AS NVARCHAR(10));
        PRINT 'Filas omitidas: ' + CAST(@FilasOmitidas AS NVARCHAR(10));

    END TRY
    BEGIN CATCH
        PRINT 'Se produjo un error: ' + ERROR_MESSAGE();
        IF OBJECT_ID('tempdb..#TempCatalogo') IS NOT NULL
            DROP TABLE #TempCatalogo;
        IF OBJECT_ID('tempdb..#TempAccionMerge') IS NOT NULL
            DROP TABLE #TempAccionMerge;
    END CATCH
END
GO

-- Insercion Electronic accesories.xlxs

CREATE OR ALTER PROCEDURE administracion.InsertarElectronicosEnProducto
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DROP TABLE IF EXISTS #TempElectro;

        CREATE TABLE #TempElectro (
            Producto VARCHAR(100),
            PrecioUnitario DECIMAL(10, 2)
        );

        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        INSERT INTO #TempElectro (Producto, PrecioUnitario)
        SELECT DISTINCT [Product] AS Producto, [Precio Unitario en dolares] AS PrecioUnitario
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'', 
            ''Excel 12.0;Database=' + @RutaArchivo + N';HDR=YES'',
            ''SELECT [Product], [Precio Unitario en dolares] FROM [Sheet1$]''
        );';

        EXEC sp_executesql @sql;

        -- Tabla temporal para registrar las operaciones del MERGE
        CREATE TABLE #TempAccionMerge (
            Action NVARCHAR(10)
        );

        MERGE INTO administracion.Producto AS P
        USING (
            SELECT
                Producto AS Descripcion, 
                'Electro' AS Categoria, 
				NULL AS Linea,
                NULL AS Proveedor, 
                NULL AS CantPorUnidad, 
                PrecioUnitario AS Precio, 
                NULL AS PrecioRef, 
                'USD' AS Moneda, 
                NULL AS UnidadRef,
                CONVERT(VARCHAR(40), HASHBYTES('SHA1', Producto + 'Electro'), 2) AS CodProducto
            FROM #TempElectro
        ) AS Temp
        ON P.CodProducto = Temp.CodProducto

        WHEN MATCHED AND (
                P.Precio <> Temp.Precio
            )
            THEN UPDATE SET
                P.Precio = Temp.Precio,
                P.PrecioRef = Temp.PrecioRef,
                P.UnidadRef = Temp.UnidadRef
		
        WHEN NOT MATCHED THEN
            INSERT (Descripcion, Categoria, Proveedor, CantPorUnidad, Precio, PrecioRef, Moneda, UnidadRef)
            VALUES (Temp.Descripcion, Temp.Categoria, NULL, NULL, Temp.Precio, Temp.PrecioRef, Temp.Moneda, Temp.UnidadRef)
        
		OUTPUT $action INTO #TempAccionMerge;

        -- Contar filas insertadas, actualizadas y omitidas
        DECLARE @FilasInsertadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'INSERT');
        DECLARE @FilasActualizadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'UPDATE');
        DECLARE @FilasOmitidas INT = (SELECT COUNT(*) FROM #TempElectro) - (@FilasInsertadas + @FilasActualizadas);

        DROP TABLE #TempElectro;
        DROP TABLE #TempAccionMerge;

        PRINT 'Proceso completado para Electronic accessories.xlxs';
        PRINT 'Filas insertadas: ' + CAST(@FilasInsertadas AS NVARCHAR(10));
        PRINT 'Filas actualizadas: ' + CAST(@FilasActualizadas AS NVARCHAR(10));
        PRINT 'Filas omitidas: ' + CAST(@FilasOmitidas AS NVARCHAR(10));

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar o actualizar productos electronicos: ' + ERROR_MESSAGE();
        IF OBJECT_ID('tempdb..#TempElectro') IS NOT NULL
            DROP TABLE #TempElectro;
        IF OBJECT_ID('tempdb..#TempAccionMerge') IS NOT NULL
            DROP TABLE #TempAccionMerge;
    END CATCH;
END;
GO

-- Insercion Productos_Importados.xlxs

CREATE OR ALTER PROCEDURE administracion.InsertarImportadosEnProducto
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DROP TABLE IF EXISTS #TempImportados;

        CREATE TABLE #TempImportados (
            IdProducto CHAR(10),
            NombreProducto VARCHAR(100),
            Proveedor VARCHAR(50),
            Categoria VARCHAR(50),
            CantidadPorUnidad VARCHAR(50),
            PrecioUnidad DECIMAL(10, 2)
        );

        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        INSERT INTO #TempImportados (IdProducto, NombreProducto, Proveedor, Categoria, CantidadPorUnidad, PrecioUnidad)
        SELECT IdProducto, NombreProducto, Proveedor, [Categoría] AS Categoria, CantidadPorUnidad, PrecioUnidad
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'', 
            ''Excel 12.0;Database=' + @RutaArchivo + N';HDR=YES'',
            ''SELECT IdProducto, NombreProducto, Proveedor, [Categoría], CantidadPorUnidad, PrecioUnidad FROM [Listado de Productos$]''
        );';

        EXEC sp_executesql @sql;

        -- Tabla temporal para registrar las operaciones del MERGE
        CREATE TABLE #TempAccionMerge (
            Action NVARCHAR(10)
        );

        MERGE INTO administracion.Producto AS P
        USING (
            SELECT
                NombreProducto AS Descripcion, 
                Categoria AS Categoria,
				NULL AS Linea,
                Proveedor AS Proveedor, 
                CantidadPorUnidad AS CantPorUnidad, 
                PrecioUnidad AS Precio,
                NULL AS PrecioRef, 
                'USD' AS Moneda, 
                NULL AS UnidadRef,
                CONVERT(VARCHAR(40), HASHBYTES('SHA1', NombreProducto + Categoria), 2) AS CodProducto
            FROM #TempImportados
        ) AS Temp
        ON P.CodProducto = Temp.CodProducto

        WHEN MATCHED AND (
                P.Precio <> Temp.Precio OR
				P.Proveedor <> Temp.Proveedor OR
				P.CantPorUnidad <> Temp.CantPorUnidad
            )
            THEN UPDATE SET
                P.Precio = Temp.Precio,
                P.PrecioRef = Temp.PrecioRef,
                P.UnidadRef = Temp.UnidadRef
		
        WHEN NOT MATCHED THEN
            INSERT (Descripcion, Categoria, Linea, Proveedor, CantPorUnidad, Precio, PrecioRef, Moneda, UnidadRef)
            VALUES (Temp.Descripcion, Temp.Categoria, NULL, Temp.Proveedor, Temp.CantPorUnidad, Temp.Precio, Temp.PrecioRef, Temp.Moneda, Temp.UnidadRef)
        
		OUTPUT $action INTO #TempAccionMerge;

        -- Contar filas insertadas, actualizadas y omitidas
        DECLARE @FilasInsertadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'INSERT');
        DECLARE @FilasActualizadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'UPDATE');
        DECLARE @FilasOmitidas INT = (SELECT COUNT(*) FROM #TempImportados) - (@FilasInsertadas + @FilasActualizadas);

        DROP TABLE #TempImportados;
        DROP TABLE #TempAccionMerge;

        PRINT 'Proceso completado para Productos_importados.xlxs';
        PRINT 'Filas insertadas: ' + CAST(@FilasInsertadas AS NVARCHAR(10));
        PRINT 'Filas actualizadas: ' + CAST(@FilasActualizadas AS NVARCHAR(10));
        PRINT 'Filas omitidas: ' + CAST(@FilasOmitidas AS NVARCHAR(10));

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar o actualizar productos importados: ' + ERROR_MESSAGE();
        IF OBJECT_ID('tempdb..#TempElectro') IS NOT NULL
            DROP TABLE #TempImportados;
        IF OBJECT_ID('tempdb..#TempAccionMerge') IS NOT NULL
            DROP TABLE #TempAccionMerge;
    END CATCH;
END;
GO

--==========================================================
-- Fin creacion SP insercion masiva en tabla Producto
--==========================================================
--==========================================================
-- Inicio creacion SP actualizar Linea en tabla Producto
--==========================================================
	
CREATE OR ALTER PROCEDURE administracion.ActualizarLineasEnProducto
    @RutaArchivo NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DROP TABLE IF EXISTS #TempLineas;

        CREATE TABLE #TempLineas (
            Linea VARCHAR(50),
            CategoriaProd VARCHAR(50)
        );

        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        INSERT INTO #TempLineas (Linea, CategoriaProd)
        SELECT [Línea de producto] AS Linea, [Producto] AS CategoriaProd
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.12.0'', 
            ''Excel 12.0;Database=' + @RutaArchivo + N';HDR=YES'',
            ''SELECT [Línea de producto], [Producto] FROM [Clasificacion productos$]''
        );';

        EXEC sp_executesql @sql;

        -- Tabla temporal para registrar las operaciones del MERGE
        CREATE TABLE #TempAccionMerge (
            Action NVARCHAR(10)
        );

        MERGE INTO administracion.Producto AS P
        USING (
            SELECT
                Linea AS Linea,
				CategoriaProd
            FROM #TempLineas
        ) AS Temp
        ON P.Categoria = Temp.CategoriaProd

        WHEN MATCHED
            THEN UPDATE SET
                P.Linea = Temp.Linea
        
		OUTPUT $action INTO #TempAccionMerge;

        -- Contar filas actualizadas
        DECLARE @FilasActualizadas INT = (SELECT COUNT(*) FROM #TempAccionMerge WHERE Action = 'UPDATE');

        DROP TABLE #TempLineas;
        DROP TABLE #TempAccionMerge;

        PRINT 'Proceso completado para Informacion_complementaria.xlxs actualizando lineas';
        PRINT 'Filas actualizadas: ' + CAST(@FilasActualizadas AS NVARCHAR(10));

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar lineas de productos: ' + ERROR_MESSAGE();
        IF OBJECT_ID('tempdb..#TempLineas') IS NOT NULL
            DROP TABLE #TempLineas;
        IF OBJECT_ID('tempdb..#TempAccionMerge') IS NOT NULL
            DROP TABLE #TempAccionMerge;
    END CATCH;
END;
GO

--==========================================================
-- Fin creacion SP actualizar Linea en tabla Producto
--==========================================================