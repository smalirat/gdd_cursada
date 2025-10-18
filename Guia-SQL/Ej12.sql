/*Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe promedio pagado por el producto, 
cantidad de depósitos en los cuales hay stock del producto y stock actual del producto en todos los depósitos.
Se deberán mostrar aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán ordenarse de mayor a menor
por monto vendido del producto. */


SELECT 
    P.prod_detalle,
    COUNT(DISTINCT F.fact_cliente) AS [Clientes Totales],
    AVG(IT.item_precio * IT.item_cantidad) AS [Importe Total],
    (SELECT COUNT(S.stoc_deposito) 
     FROM Stock S 
     WHERE S.stoc_producto = P.prod_codigo) AS [Cantidad Depositos Stock Producto],
    (SELECT SUM(S2.stoc_cantidad) 
     FROM Stock S2 
     WHERE S2.stoc_producto = P.prod_codigo) AS [Stock Total Todos Depositos]
FROM Producto P
JOIN Item_Factura IT 
    ON IT.item_producto = P.prod_codigo
JOIN Factura F 
    ON F.fact_tipo+F.fact_sucursal+F.fact_numero=IT.item_tipo+IT.item_sucursal+IT.item_numero
GROUP BY 
    P.prod_detalle,
    P.prod_codigo
ORDER BY 
    P.prod_codigo ASC;
