/*Escriba una consulta que retorne una estadística de ventas por año y mes para cada producto.  
La consulta debe retornar:  
PERIODO: Año y mes de la estadística con el formato YYYYMM 
PROD: Código de producto DETALLE: Detalle del producto 
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo 
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo pero del año anterior 
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el periodo  
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada por periodo y código de producto.
*/

 
SELECT * FROM Item_Factura 
SELECT * FROM Factura

SELECT CONCAT(YEAR(f1.fact_fecha), MONTH(f1.fact_fecha)) año_mes, p.prod_codigo codigo, p.prod_detalle detalle, ISNULL(SUM(i1.item_cantidad),0) cantidad_vendida,
ISNULL((SELECT SUM(i2.item_cantidad)
		FROM Item_Factura i2
		JOIN Factura f2 ON f2.fact_tipo + f2.fact_sucursal + f2.fact_numero = i2.item_tipo + i2.item_sucursal + i2.item_numero
		WHERE i2.item_producto = p.prod_codigo 
		  AND YEAR(f2.fact_fecha) = YEAR(f1.fact_fecha) - 1 
		  AND MONTH(f2.fact_fecha) = MONTH(f1.fact_fecha)),0) anio_pasado, 
COUNT(DISTINCT(f1.fact_tipo + f1.fact_sucursal + f1.fact_numero)) cant_facturas
FROM Producto p
JOIN Item_Factura i1 ON i1.item_producto = p.prod_codigo
JOIN Factura f1 ON f1.fact_tipo + f1.fact_sucursal + f1.fact_numero = i1.item_tipo + i1.item_sucursal + i1.item_numero
GROUP BY p.prod_codigo, p.prod_detalle, YEAR(f1.fact_fecha), MONTH(f1.fact_fecha)
ORDER BY 1
