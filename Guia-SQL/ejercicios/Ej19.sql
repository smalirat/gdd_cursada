/*19. En virtud de una recategorizacion de productos referida a la familia de los mismos  
se solicita que desarrolle una consulta sql que retorne para todos los productos: 
 Codigo de producto  Detalle del producto  Codigo de la familia del producto
 Detalle de la familia actual del producto  Codigo de la familia sugerido para el producto
 Detalla de la familia sugerido para el producto La familia sugerida para un producto es la que poseen la mayoria de los productos
cuyo detalle coinciden en los primeros 5 caracteres. En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar 
la de menor codigo.  Solo se deben mostrar los productos para los cuales la familia actual sea diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente */

SELECT p.prod_codigo CODIGO, p.prod_detalle DETALLE, f.fami_id ID_FAMILIA, f.fami_detalle DETALLE_FAMILIA,

(SELECT TOP 1 f2.fami_id
FROM Producto p2
JOIN Familia f2 ON f2.fami_id = p2.prod_familia
WHERE SUBSTRING(p2.prod_detalle, 1,5) = SUBSTRING(p.prod_detalle, 1,5)
GROUP BY f2.fami_id
ORDER BY COUNT(p2.prod_codigo) DESC, f2.fami_id ASC
) ID_FAMILIA_SUGERIDA,

(SELECT TOP 1 f3.fami_detalle
FROM Producto p3
JOIN Familia f3 ON f3.fami_id = p3.prod_familia
WHERE SUBSTRING(p3.prod_detalle, 1,5) = SUBSTRING(p.prod_detalle, 1,5)
GROUP BY f3.fami_id, f3.fami_detalle
ORDER BY COUNT(p3.prod_codigo) DESC, f3.fami_id ASC
)DETALLE_FAMILIA_SUGERIDA

FROM Producto p
JOIN Familia f ON p.prod_familia = f.fami_id
WHERE f.fami_id != 
(SELECT TOP 1 f2.fami_id
FROM Producto p2
JOIN Familia f2 ON f2.fami_id = p2.prod_familia
WHERE SUBSTRING(p2.prod_detalle, 1,5) = SUBSTRING(p.prod_detalle, 1,5)
GROUP BY f2.fami_id
ORDER BY COUNT(p2.prod_codigo) DESC, f2.fami_id ASC
)

