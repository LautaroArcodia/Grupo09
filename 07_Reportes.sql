USE Com5600G09;
GO

-- NOTA: Ejecutar individualmente los reportes porque se declaran las mismas variables para las fechas en cada uno.

--====REPORTES EN XML====--

--1. Reporte Mensual: Total Facturado por Días de la Semana

DECLARE @anio INT=2024
DECLARE @mes INT=11

SELECT
    DATENAME(WEEKDAY, V.Fecha) AS DiaSemana,
    SUM(DV.Precio * DV.Cantidad) AS TotalFacturado
FROM ventas.Venta AS V 
INNER JOIN ventas.DetalleVenta AS DV 
	ON V.Id = DV.VentaId
WHERE YEAR(V.Fecha) = @anio AND MONTH(V.Fecha) = @mes
GROUP BY DATENAME(WEEKDAY, V.Fecha)
ORDER BY DiaSemana

FOR XML PATH('Dia'), ROOT('ReporteMensual');


--2. Reporte Trimestral: Total Facturado por Turnos de Trabajo por Mes

DECLARE @anio INT=2024
DECLARE @mes INT=11

SELECT
    MONTH(V.Fecha) AS Mes,
    CASE 
        WHEN DATEPART(HOUR, V.Hora) BETWEEN 00 AND 12 THEN 'Turno Mañana'
        ELSE 'Turno Tarde'
    END AS Turno,
    SUM(DV.Precio * DV.Cantidad) AS TotalFacturado
FROM ventas.Venta AS V 
INNER JOIN ventas.DetalleVenta AS DV 
	ON V.Id = DV.VentaId
WHERE YEAR(V.Fecha) = @anio AND MONTH(V.Fecha) = @mes
GROUP BY MONTH(V.Fecha),
         CASE 
             WHEN DATEPART(HOUR, V.Hora) BETWEEN 00 AND 12 THEN 'Turno Mañana'
             ELSE 'Turno Tarde'
         END
ORDER BY Mes, Turno

FOR XML PATH('Mes'), ROOT('ReporteTrimestral');

--3. Reporte por Rango de Fechas: Cantidad de Productos Vendidos Ordenado de Mayor a Menor

DECLARE @fecha_inicio DATE='2024-11-13'
DECLARE @fecha_fin DATE='2024-11-14'

SELECT
    P.Descripcion AS Producto,
    SUM(DV.Cantidad) AS TotalVendido
FROM ventas.Venta AS V 
INNER JOIN ventas.DetalleVenta AS DV 
	ON V.Id = DV.VentaId 
INNER JOIN administracion.Producto AS P 
	ON DV.CodProducto = P.Id
WHERE V.Fecha BETWEEN @fecha_inicio AND @fecha_fin
GROUP BY P.Descripcion
ORDER BY TotalVendido DESC

FOR XML PATH('Producto'), ROOT('ReportePorRangoFechas');

--4. Reporte por Rango de Fechas: Cantidad de Productos Vendidos por Sucursal

DECLARE @fecha_inicio DATE='20241114'
DECLARE @fecha_fin DATE='20241114'

SELECT
    S.Nombre AS Sucursal,
    P.Descripcion AS Producto,
    SUM(DV.Cantidad) AS TotalVendido
FROM ventas.Venta AS V
INNER JOIN ventas.DetalleVenta AS DV 
	ON V.Id = DV.VentaId
INNER JOIN administracion.Producto AS P 
	ON DV.CodProducto = P.CodProducto
INNER JOIN administracion.Sucursal AS S 
	ON V.SucursalID = S.Id
WHERE V.Fecha BETWEEN @fecha_inicio AND @fecha_fin
GROUP BY S.Nombre, P.Descripcion
ORDER BY S.Nombre, TotalVendido DESC
FOR XML PATH('Producto'), ROOT('ReportePorSucursal');

--5. Los 5 Productos Más Vendidos en un Mes, por Semana

DECLARE @anio INT=2024
DECLARE @mes INT=11

SELECT TOP 5
    DATEPART(WEEK, V.Fecha) AS Semana,
    P.Descripcion AS Producto,
    SUM(DV.Cantidad) AS TotalVendido
FROM ventas.Venta AS V 
INNER JOIN ventas.DetalleVenta AS DV 
	ON V.Id = DV.VentaId 
INNER JOIN administracion.Producto AS P 
	ON DV.CodProducto = P.CodProducto
WHERE YEAR(V.Fecha) = @anio AND MONTH(V.Fecha) = @mes
GROUP BY DATEPART(WEEK, V.Fecha), P.Descripcion
ORDER BY TotalVendido DESC

FOR XML PATH('Producto'), ROOT('ReporteTop5ProductosSemanal');

---6. Los 5 Productos Menos Vendidos en el Mes

DECLARE @anio INT=2024
DECLARE @mes INT=11

SELECT TOP 5
    P.Descripcion AS Producto,
    SUM(DV.Cantidad) AS TotalVendido
FROM ventas.Venta AS V 
INNER JOIN ventas.DetalleVenta AS DV 
	ON V.Id = DV.VentaId
INNER JOIN administracion.Producto AS P 
	ON DV.CodProducto = P.CodProducto
WHERE YEAR(V.Fecha) = @anio AND MONTH(V.Fecha) = @mes
GROUP BY P.Descripcion
ORDER BY TotalVendido ASC

FOR XML PATH('Producto'), ROOT('ReporteProductosMenosVendidos');

---7. Total Acumulado de Ventas para una Fecha y Sucursal Específicas

DECLARE @fecha DATE='20241114'
DECLARE @sucursal_id INT=1

SELECT
    P.Descripcion AS Producto,
    SUM(DV.Cantidad) AS CantidadVendida,
    SUM(DV.Precio * DV.Cantidad) AS TotalFacturado
FROM ventas.Venta AS V 
INNER JOIN ventas.DetalleVenta AS DV 
	ON V.Id = DV.VentaId
INNER JOIN administracion.Producto AS P 
	ON DV.CodProducto = P.CodProducto
WHERE V.Fecha = @fecha AND V.SucursalID = @sucursal_id
GROUP BY P.Descripcion

FOR XML PATH('Producto'), ROOT('ReporteVentasPorFechaYSucursal');
