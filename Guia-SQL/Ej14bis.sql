/* Escriba una consulta que retorne una estadística de ventas por cliente. 
Los campos que debe retornar son:  
Código del cliente 
Cantidad de veces que compro en el último año 
Promedio por compra en el último año 
Cantidad de productos diferentes que compro en el último año 
Monto de la mayor compra que realizo en el último año  
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en el último año. 
No se deberán visualizar NULLs en ninguna columna */




SELECT 
    C.clie_codigo, 
    COUNT(F.fact_cliente) AS VecesQueCompro, 
    ISNULL(AVG(F.fact_total),0) AS PromedioCompra, 
    ISNULL(COUNT(DISTINCT I.item_producto),0) AS CantProductos, 
    ISNULL(MAX(F.fact_total),0) AS MayorCompra
FROM Cliente C
LEFT JOIN Factura F 
    ON F.fact_cliente = C.clie_codigo
   AND YEAR(F.fact_fecha) = 2012
LEFT JOIN Item_Factura I 
    ON I.item_tipo = F.fact_tipo
   AND I.item_sucursal = F.fact_sucursal
   AND I.item_numero = F.fact_numero
GROUP BY C.clie_codigo
ORDER BY VecesQueCompro DESC;
