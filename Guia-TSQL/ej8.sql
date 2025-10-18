/*Realizar un procedimiento que complete la tabla Diferencias de precios, para los productos facturados que tengan composición y 
en los cuales el precio de facturación sea diferente al precio del cálculo de los precios unitarios por cantidad de sus componentes, 
se aclara que un producto que compone a otro, también puede estar compuesto por otros y así sucesivamente, 
la tabla se debe crear y está formada por las siguientes columnas: */

CREATE TABLE Diferencias
(
	dif_codigo char(8) NULL,
	dif_detalle char(50) NULL,
	dif_cantidad int NULL,
	dif_precio_generado decimal(12,2) NULL,
	dif_precio_facturado decimal(12,2) NULL
)

CREATE PROCEDURE EJ8

AS	
	BEGIN
	
	DECLARE @codigo char(8) ,@detalle char(50),@cantidad int,@precio_generado decimal(12,2) ,@precio_facturado decimal(12,2) 


	DECLARE cursor_diferencia CURSOR
		FOR SELECT 

			OPEN cursor_diferencia
			FETCH NEXT FROM cursor_diferencia
				INTO @codigo,@detalle,@cantidad,@precio_generado,@precio_facturado

			WHILE(@@FETCH_STATUS = 0)
				BEGIN
					INSERT INTO Diferencias
						VALUES(@codigo,@detalle,@cantidad,@precio_generado,@precio_facturado)
					FETCH NEXT FROM cursor_diferencia
						INTO @codigo,@detalle,@cantidad,@precio_generado,@precio_facturado
				END
			CLOSE cursor_diferencia
			DEALLOCATE cursor_diferencia
				
	 END
GO



EXEC DBO.EJ8
select * from Diferencias
select * from Composicion
select * from Producto