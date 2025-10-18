/*Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por cantidad vendida. */

SELECT PROD_CODIGO PRODUCTO, prod_detalle DETALLE, SUM(item_cantidad) CANTIDAD
FROM Producto JOIN Item_Factura ON PROD_CODIGO = ITEM_PRODUCTO 
JOIN Factura ON FACT_TIPO+FACT_SUCURSAL+fact_numero = ITEM_TIPO+ITEM_SUCURSAL+item_numero
WHERE YEAR(FACT_FECHA) = 2012
GROUP BY prod_codigo, prod_detalle
ORDER BY 3