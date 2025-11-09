/*23. Realizar una consulta SQL que para cada año muestre : 
 Año
 El producto con composición más vendido para ese año.
 Cantidad de productos que componen directamente al producto más vendido
 La cantidad de facturas en las cuales aparece
ese producto. 
 El código de cliente que más compro ese producto. 
 El porcentaje que representa la venta de ese producto respecto al total de venta del año. 
El resultado deberá ser ordenado por el total vendido por año en forma descendente. */


SELECT
    YEAR(F_externa.fact_fecha) AS Anio,
    
    /* Métrica 2: El producto con composición más vendido (PPMV) */
    (SELECT TOP 1 C.comp_producto
     FROM Composicion C
     JOIN Item_Factura IF_interna ON C.comp_producto = IF_interna.item_producto
     JOIN Factura F_interna ON IF_interna.item_numero = F_interna.fact_numero AND IF_interna.item_tipo = F_interna.fact_tipo
     WHERE YEAR(F_interna.fact_fecha) = YEAR(F_externa.fact_fecha) -- Correlación
     GROUP BY C.comp_producto
     ORDER BY SUM(IF_interna.item_cantidad) DESC -- Usamos cantidad como en el ej. anterior
    ) AS ProductoMasVendido,

    /* Métrica 3: Cantidad de productos que componen ese PPMV */
    (SELECT COUNT(*)
     FROM Composicion C_componentes
     WHERE C_componentes.comp_producto = (
        -- Lógica repetida para encontrar el PPMV
        SELECT TOP 1 C.comp_producto
        FROM Composicion C
        JOIN Item_Factura IF_interna ON C.comp_producto = IF_interna.item_producto
        JOIN Factura F_interna ON IF_interna.item_numero = F_interna.fact_numero AND IF_interna.item_tipo = F_interna.fact_tipo
        WHERE YEAR(F_interna.fact_fecha) = YEAR(F_externa.fact_fecha)
        GROUP BY C.comp_producto
        ORDER BY SUM(IF_interna.item_cantidad) DESC
     )
    ) AS CantidadComponentes,

    /* Métrica 4: Cantidad de facturas en las que aparece ese PPMV */
    (SELECT COUNT(DISTINCT CONCAT(F_facturas.fact_numero, F_facturas.fact_tipo))
     FROM Factura F_facturas
     JOIN Item_Factura IF_facturas ON F_facturas.fact_numero = IF_facturas.item_numero AND F_facturas.fact_tipo = IF_facturas.item_tipo
     WHERE YEAR(F_facturas.fact_fecha) = YEAR(F_externa.fact_fecha) -- Correlación
       AND IF_facturas.item_producto = (
        -- Lógica repetida para encontrar el PPMV
        SELECT TOP 1 C.comp_producto
        FROM Composicion C
        JOIN Item_Factura IF_interna ON C.comp_producto = IF_interna.item_producto
        JOIN Factura F_interna ON IF_interna.item_numero = F_interna.fact_numero AND IF_interna.item_tipo = F_interna.fact_tipo
        WHERE YEAR(F_interna.fact_fecha) = YEAR(F_externa.fact_fecha)
        GROUP BY C.comp_producto
        ORDER BY SUM(IF_interna.item_cantidad) DESC
       )
    ) AS CantidadFacturas,

    /* Métrica 5: El código de cliente que más compró ese PPMV */
    (SELECT TOP 1 F_cliente.fact_cliente
     FROM Factura F_cliente
     JOIN Item_Factura IF_cliente ON F_cliente.fact_numero = IF_cliente.item_numero AND F_cliente.fact_tipo = IF_cliente.item_tipo
     WHERE YEAR(F_cliente.fact_fecha) = YEAR(F_externa.fact_fecha) -- Correlación
       AND IF_cliente.item_producto = (
        -- Lógica repetida para encontrar el PPMV
        SELECT TOP 1 C.comp_producto
        FROM Composicion C
        JOIN Item_Factura IF_interna ON C.comp_producto = IF_interna.item_producto
        JOIN Factura F_interna ON IF_interna.item_numero = F_interna.fact_numero AND IF_interna.item_tipo = F_interna.fact_tipo
        WHERE YEAR(F_interna.fact_fecha) = YEAR(F_externa.fact_fecha)
        GROUP BY C.comp_producto
        ORDER BY SUM(IF_interna.item_cantidad) DESC
       )
     GROUP BY F_cliente.fact_cliente
     ORDER BY SUM(IF_cliente.item_cantidad) DESC
    ) AS MejorCliente,

    /* Métrica 6: Porcentaje que representa la venta de ese PPMV */
    (
      (SELECT SUM(IF_venta.item_cantidad * IF_venta.item_precio)
       FROM Factura F_venta
       JOIN Item_Factura IF_venta ON F_venta.fact_numero = IF_venta.item_numero AND F_venta.fact_tipo = IF_venta.item_tipo
       WHERE YEAR(F_venta.fact_fecha) = YEAR(F_externa.fact_fecha) -- Correlación
         AND IF_venta.item_producto = (
          SELECT TOP 1 C.comp_producto
          FROM Composicion C
          JOIN Item_Factura IF_interna ON C.comp_producto = IF_interna.item_producto
          JOIN Factura F_interna ON IF_interna.item_numero = F_interna.fact_numero AND IF_interna.item_tipo = F_interna.fact_tipo
          WHERE YEAR(F_interna.fact_fecha) = YEAR(F_externa.fact_fecha)
          GROUP BY C.comp_producto
          ORDER BY SUM(IF_interna.item_cantidad) DESC
         )
      ) / SUM(IF_externo.item_cantidad * IF_externo.item_precio) -- Total del año (de la consulta principal)
    ) * 100 AS PorcentajeSobreTotalAnio,
    SUM(IF_externo.item_cantidad * IF_externo.item_precio) AS TotalVendidoAnio
FROM
    Factura F_externa
JOIN
    Item_Factura IF_externo ON F_externa.fact_numero = IF_externo.item_numero AND F_externa.fact_tipo = IF_externo.item_tipo
GROUP BY
    YEAR(F_externa.fact_fecha)
ORDER BY
    TotalVendidoAnio DESC;
