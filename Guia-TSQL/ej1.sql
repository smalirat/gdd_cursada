/*1. Hacer una función que dado un artículo y un deposito devuelva un string que indique el estado del depósito según el artículo. 
Si la cantidad almacenada es menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el % de ocupación. 
Si la cantidad almacenada es mayor o igual al límite retornar “DEPOSITO COMPLETO*/



CREATE FUNCTION ej1 (@articulo char(8), @deposito char(2)) 
RETURNS char(50) 
BEGIN 
	DECLARE @maximo numeric(12,2), @stock numeric(12,2) 
	SELECT @stock= stoc_cantidad, @maximo = ISNULL (stoc_stock_maximo,0) FROM Stock WHERE stoc_producto = @articulo and stoc_deposito = @deposito 
	IF @stock < @maximo
		IF @maximo <> 0
			RETURN 'OCUPACION DEL DEPOSITO ' +@deposito + ' ' +STR(@stock/@maximo * 100,5,2)  
	RETURN 'DEPOSITO COMPLETO' 
END

drop function ej1

select *,dbo.ej1(stoc_producto, stoc_deposito) from Stock



--SELECT * FROM Stock