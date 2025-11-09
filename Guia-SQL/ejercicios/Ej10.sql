/*10. Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos vendidos en la historia. 
Además mostrar de esos productos, quien fue el cliente que mayor compra realizo. */

SELECT * FROM Producto

SELECT * FROM Item_Factura
ORDER BY item_producto

SELECT TOP 10 prod_codigo, prod_detalle, SUM (item_cantidad) cantidadVendida, 
(SELECT TOP 1 fact_cliente
 FROM Item_Factura 
 JOIN Factura ON item_numero = fact_numero
 WHERE item_producto = prod_codigo
 GROUP BY fact_cliente
 ORDER BY SUM(item_cantidad) DESC) clienteQueMasCompro
FROM Producto 
JOIN Item_Factura on prod_codigo = item_producto
JOIN Factura ON item_numero = fact_numero
JOIN Cliente ON fact_cliente = clie_codigo
GROUP BY prod_codigo, prod_detalle
ORDER BY cantidadVendida DESC