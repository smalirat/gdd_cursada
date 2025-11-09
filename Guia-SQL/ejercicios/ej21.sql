/*21. Escriba una consulta sql que retorne para todos los años, 
en los cuales se haya hecho al menos una factura, la cantidad de clientes a 
los que se les facturo de manera incorrecta al menos una factura y que cantidad de
facturas se realizaron de manera incorrecta. Se considera que una factura es incorrecta
cuando la diferencia entre el total de la factura menos el total de impuesto tiene una diferencia mayor a  1
respecto a la sumatoria de los costos de cada uno de los items de dicha factura. 
Las columnas que se deben mostrar son: 
 Año 
Clientes a los que se les facturo mal en ese año 
 Facturas mal realizadas en ese año*/

SELECT 
    YEAR(f1.fact_fecha) AS año,
    ISNULL(COUNT(DISTINCT(f1.fact_tipo + f1.fact_sucursal + f1.fact_numero)), 0) cant_facturas,
    ISNULL(COUNT(DISTINCT(c1.clie_codigo)), 0) AS cant_clientes
FROM Factura f1 JOIN  Cliente c1 ON f1.fact_cliente = c1.clie_codigo
WHERE 
    ABS((f1.fact_total - f1.fact_total_impuestos) - 
        (SELECT SUM(if2.item_cantidad * if2.item_precio) FROM Item_Factura if2
         WHERE if2.item_tipo = f1.fact_tipo AND if2.item_sucursal = f1.fact_sucursal AND if2.item_numero = f1.fact_numero)) > 1

GROUP BY  YEAR(f1.fact_fecha)
ORDER BY 1;