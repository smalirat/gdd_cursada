/*Mostrar para el o los artículos que tengan stock en todos los depósitos, 
nombre del artículo, stock del depósito que más stock tiene.*/

SELECT 
    prod_detalle, 
    MAX(stoc_cantidad)  max_stock
FROM Producto 
JOIN Stock 
    ON prod_codigo = stoc_producto
WHERE stoc_cantidad > 0
GROUP BY prod_detalle
HAVING COUNT(DISTINCT stoc_deposito) = (SELECT COUNT(*) FROM Deposito);

