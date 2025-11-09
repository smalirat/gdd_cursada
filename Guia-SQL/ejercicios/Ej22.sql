/*22.Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por trimestre contabilizando 
todos los años. Se mostraran como maximo 4 filas por rubro (1 por cada trimestre). 
Se deben mostrar 4 columnas: ? Detalle del rubro ? Numero de trimestre del año (1 a 4) 
? Cantidad de facturas emitidas en el trimestre en las que se haya vendido al menos un producto del rubro
? Cantidad de productos diferentes del rubro vendidos en el trimestre 
El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada rubro primero el trimestre en el
que mas facturas se emitieron. No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas 
no superen las 100. En ningun momento se tendran en cuenta los productos compuestos para esta estadistica. */


SELECT
    R.rubr_detalle AS Detalle_Rubro,
    DATEPART(QUARTER, F.fact_fecha) Numero_Trimestre,
    COUNT(DISTINCT CONCAT(F.fact_numero, F.fact_tipo)) Cantidad_Facturas_Emitidas,
    COUNT(DISTINCT P.prod_codigo)  Cantidad_Productos_Diferentes
FROM Factura F
JOIN Item_Factura I ON F.fact_numero = I.item_numero AND F.fact_tipo = I.item_tipo
JOIN Producto P ON I.item_producto = P.prod_codigo
JOIN Rubro R ON P.prod_rubro = R.rubr_id
WHERE NOT EXISTS (SELECT 1 FROM Composicion C WHERE C.comp_producto = P.prod_codigo)
GROUP BY R.rubr_detalle, DATEPART(QUARTER, F.fact_fecha)    
HAVING COUNT(DISTINCT CONCAT(F.fact_numero, F.fact_tipo)) > 100
ORDER BY Detalle_Rubro ASC,Cantidad_Facturas_Emitidas DESC;


