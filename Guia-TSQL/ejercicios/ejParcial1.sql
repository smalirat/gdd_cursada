/* Se requiere armar una estadística que retorne para cada año y familia el cliente que menos
 productos diferentes compro y que más monto compro para ese año y familia

Año, Razón Social Cliente, Familia, Cantidad de unidades compradas de esa familia

Los resultados deben ser ordenados por año de menor a mayor y para cada año ordenados por la familia que menos productos 
tenga asignados
NOTA: No se permite el uso de sub-selects en el FROM.*/

SELECT year(f.fact_fecha), p.prod_familia, 
    (SELECT TOP 1 clie_CODIGO 
    FROM Factura 
    JOIN Item_Factura ON fact_tipo+fact_numero+fact_sucursal = item_tipo+item_numero+item_sucursal
    JOIN Producto p1 ON item_producto = p1.prod_codigo
    JOIN Cliente ON fact_cliente = clie_codigo
    WHERE year(fact_fecha) = year(f.fact_fecha) AND p1.prod_familia = p.prod_familia
    GROUP BY fact_cliente, clie_CODIGO 
    ORDER BY COUNT(DISTINCT P1.PROD_CODIGO), SUM(item_cantidad * item_precio) desc) 'Cliente',
SUM(item_cantidad) 'Cantidad de unidades vendidas'
FROM Factura f
JOIN Item_Factura ON f.fact_tipo+f.fact_numero+f.fact_sucursal = item_tipo+item_numero+item_sucursal
JOIN Producto p ON item_producto = p.prod_codigo
GROUP BY year(f.fact_fecha), p.prod_familia
ORDER BY year(f.fact_fecha) asc, (select COUNT(distinct prod_codigo) from producto where prod_familia = p.prod_familia) asc


SELECT year(f.fact_fecha), p.prod_familia, fact_cliente, SUM(item_cantidad) 'Cantidad de unidades vendidas'
FROM Factura f
JOIN Item_Factura ON f.fact_tipo+f.fact_numero+f.fact_sucursal = item_tipo+item_numero+item_sucursal
JOIN Producto p ON item_producto = p.prod_codigo
where fact_cliente = (SELECT TOP 1 FACT_CLIENTE 
    FROM Factura 
    JOIN Item_Factura ON fact_tipo+fact_numero+fact_sucursal = item_tipo+item_numero+item_sucursal
    JOIN Producto p1 ON item_producto = p1.prod_codigo
    JOIN Cliente ON fact_cliente = clie_codigo
    WHERE year(fact_fecha) = year(f.fact_fecha) AND p1.prod_familia = p.prod_familia
    GROUP BY fact_cliente, clie_razon_social
    ORDER BY COUNT(DISTINCT P1.PROD_CODIGO), SUM(item_cantidad * item_precio) desc)
GROUP BY year(f.fact_fecha), p.prod_familia, FACT_CLIENTE
ORDER BY year(f.fact_fecha) asc, (select COUNT(distinct prod_codigo) from producto where prod_familia = p.prod_familia) asc
go 