/* Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de stock que se realizaron para ese artículo en el año 2012 
(egresan los productos que fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011. */

SELECT * FROM Item_Factura
SELECT * FROM Factura

SELECT prod_codigo, prod_detalle, sum(item_cantidad) '2012' FROM Producto 
JOIN Item_Factura ON prod_codigo = item_producto
JOIN factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
WHERE year(fact_fecha) = 2012
GROUP BY prod_codigo,prod_detalle
HAVING sum(item_cantidad) > (SELECT sum(item_cantidad) 
							FROM Item_Factura
							JOIN factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
							WHERE year(fact_fecha) = 2011 and item_producto = prod_codigo)