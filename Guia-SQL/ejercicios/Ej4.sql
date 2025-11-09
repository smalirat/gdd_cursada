/*. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de artículos que lo componen. 
Mostrar solo aquellos artículos para los cuales el stock promedio por depósito sea mayor a 100. */

SELECT prod_codigo,prod_detalle, count(comp_componente) cant_articulos 
FROM Producto LEFT JOIN Composicion ON prod_codigo = comp_producto
WHERE prod_codigo in (SELECT stoc_producto 
					FROM STOCK
					GROUP BY stoc_producto
					having AVG (stoc_cantidad) > 100)
GROUP BY prod_codigo, prod_detalle