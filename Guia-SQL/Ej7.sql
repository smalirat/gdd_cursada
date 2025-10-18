/* Generar una consulta que muestre para cada artículo código, detalle, mayor precio menor precio y % de la diferencia de precios 
(respecto del menor Ej.: menor precio = 10, mayor precio =12 => mostrar 20 %). 
Mostrar solo aquellos artículos que posean stock. */

SELECT prod_codigo, prod_detalle, MIN(item_precio) precioMinimo, MAX(item_precio) precioMaximo, 
CASE 
        WHEN MIN(item_precio) IS NULL
            THEN NULL
        ELSE CAST(
            ( (MAX(item_precio) - MIN(item_precio)) / MIN(item_precio) * 100 ) 
            AS DECIMAL(10,2)
        ) END Diferencia 

FROM Producto LEFT JOIN Item_Factura on prod_codigo = item_producto
JOIN Stock ON prod_codigo = stoc_producto
GROUP BY prod_detalle, prod_codigo
ORDER BY prod_codigo

SELECT prod_codigo, prod_detalle FROM Producto