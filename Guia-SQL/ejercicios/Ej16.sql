/* Se pide una consulta SQL que retorne aquellos clientes cuyas compras son inferiores a 1/3 del monto de ventas del producto que más se vendió en el 2012. 
Además mostrar  
1. Nombre del Cliente 
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente. 
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1, mostrar solamente el de menor código) para ese cliente. */

WITH ProductoTop AS (
    SELECT TOP 1
        I.item_producto,
        SUM(I.item_cantidad * I.item_precio) AS MontoVendido
    FROM Factura F
    JOIN Item_Factura I 
        ON F.fact_tipo = I.item_tipo
       AND F.fact_sucursal = I.item_sucursal
       AND F.fact_numero = I.item_numero
    WHERE YEAR(F.fact_fecha) = 2012
    GROUP BY I.item_producto
    ORDER BY SUM(I.item_cantidad * I.item_precio) DESC, I.item_producto ASC
),
ClienteVentas AS (
    SELECT
        C.clie_codigo,
        C.clie_nombre,
        SUM(I.item_cantidad) AS UnidadesVendidas
    FROM Cliente C
    LEFT JOIN Factura F ON F.fact_cliente = C.clie_codigo
    LEFT JOIN Item_Factura I 
        ON F.fact_tipo = I.item_tipo
       AND F.fact_sucursal = I.item_sucursal
       AND F.fact_numero = I.item_numero
    WHERE YEAR(F.fact_fecha) = 2012
    GROUP BY C.clie_codigo, C.clie_nombre
)
SELECT
    CV.clie_codigo,
    CV.clie_nombre,
    CV.UnidadesVendidas,
    PT.item_producto AS ProductoTop
FROM ClienteVentas CV
CROSS JOIN ProductoTop PT
WHERE CV.UnidadesVendidas < PT.MontoVendido / 3;

