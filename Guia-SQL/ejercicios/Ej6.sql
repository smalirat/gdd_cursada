/*Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese rubro y stock total de ese rubro de artículos. 
Solo tener en cuenta aquellos artículos que tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’. */

/*SELECT stoc_cantidad, prod_rubro
    FROM Stock JOIN Producto ON stoc_producto = prod_codigo*/

SELECT rubr_id, rubr_detalle, COUNT(distinct stoc_producto) cant_articulos,
       SUM(ISNUll (stoc_cantidad, 0)) stock_total FROM Rubro 
LEFT JOIN Producto ON rubr_id = prod_rubro AND  
prod_codigo IN (SELECT stoc_producto FROM STOCK GROUP BY stoc_producto HAVING SUM(stoc_cantidad) >
(SELECT stoc_cantidad FROM STOCK WHERE stoc_producto = '00000000'
AND stoc_deposito = '00'))
LEFT JOIN Stock ON prod_codigo = stoc_producto
GROUP BY rubr_id, rubr_detalle
ORDER BY 1


