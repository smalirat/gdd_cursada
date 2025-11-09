/*18. Escriba una consulta que retorne una estadística de ventas para todos los rubros. 
La consulta debe retornar: 
DETALLE_RUBRO: Detalle del rubro 
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro 
PROD1: Código del producto más vendido de dicho rubro 
PROD2: Código del segundo producto más vendido de dicho rubro 
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días La consulta no puede mostrar
NULL en ninguna de sus columnas y debe estar ordenada por cantidad de productos diferentes vendidos del rubro. */


SELECT * FROM Rubro
SELECT * FROM Item_Factura
SELECT * FROM Factura


SELECT 
	R.rubr_detalle AS familia,
	
	(SELECT TOP 1 P_sub.prod_detalle
		 FROM Producto P_sub
		 JOIN Item_Factura I_sub ON P_sub.prod_codigo = I_sub.item_producto
		 WHERE P_sub.prod_rubro = R.rubr_id 
		 GROUP BY P_sub.prod_codigo, P_sub.prod_detalle
		 ORDER BY SUM(I_sub.item_cantidad) DESC
	) AS producto_mas_vendido,
	
	(SELECT P_sub.prod_detalle
		 FROM Producto P_sub
		 JOIN Item_Factura I_sub ON P_sub.prod_codigo = I_sub.item_producto
		 WHERE P_sub.prod_rubro = R.rubr_id 
		 GROUP BY P_sub.prod_codigo, P_sub.prod_detalle
		 ORDER BY SUM(I_sub.item_cantidad) DESC
		 OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY 
	) AS segundo_producto_mas_vendido,
	
	(SELECT TOP 1 fact_cliente
		 FROM Factura f2
		 JOIN Item_Factura i4 ON i4.item_tipo + i4.item_sucursal + i4.item_numero = f2.fact_tipo + f2.fact_sucursal + f2.fact_numero
		 JOIN Producto p4 ON p4.prod_codigo = i4.item_producto
		 WHERE p4.prod_rubro = r.rubr_id 
		   AND f2.fact_fecha >= DATEADD(DAY, -30, (SELECT TOP 1 fact_fecha FROM Factura ORDER BY fact_fecha DESC))
		 GROUP BY f2.fact_cliente
		 ORDER BY SUM(i4.item_cantidad) DESC 
	) AS mejor_cliente_ultimo_mes,
		SUM(I.item_cantidad * I.item_precio) AS total_vendido_rubro

FROM 
	Item_Factura I 
JOIN 
	Producto P ON P.prod_codigo = I.item_producto
JOIN 
	Rubro R ON R.rubr_id = P.prod_Rubro	
GROUP BY 
	R.rubr_detalle, R.rubr_id
ORDER BY 
	COUNT(DISTINCT(P.prod_codigo)) DESC;