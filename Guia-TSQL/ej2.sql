/* Realizar una función que dado un artículo y una fecha, retorne el stock que existía a esa fecha  */

CREATE FUNCTION ej2 (@articulo char(8), @fecha smalldatetime) 
RETURNS numeric(12,2)
BEGIN 
	RETURN (SELECT ISNULL(SUM(stoc_Cantidad),0) FROM Stock WHERE stoc_producto = @articulo) +
	(SELECT ISNULL(SUM(item_cantidad),0) FROM Item_Factura JOIN Factura
	ON item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
	WHERE fact_fecha >= @fecha AND item_producto = @articulo
	)
END
GO

SELECT prod_codigo, dbo.ej2(prod_codigo, '10/01/2011') 
FROM  Producto
--WHERE item_producto = '00001121'

SELECT SUM(stoc_Cantidad) FROM Stock WHERE stoc_producto = '00001121'
SELECT SUM(item_cantidad) FROM Item_Factura JOIN Factura
	on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
	where fact_fecha >= '10/01/2011' AND item_producto = '00001121'

drop function ej2