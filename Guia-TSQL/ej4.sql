/* 4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año. */

select * from empleado

alter procedure ej4 @codigo numeric(6) OUTPUT
AS
BEGIN
		update Empleado
		set empl_comision = (select sum(fact_total) from Factura where fact_vendedor = empl_codigo and year(fact_fecha) =
                                        (select max(year(fact_fecha)) from factura))
		set @codigo = (SELECT TOP 1 FACT_VENDEDOR 
						   FROM FACTURA
						   GROUP BY FACT_VENDEDOR
						   ORDER BY SUM(FACT_TOTAL) DESC)

END
go 


BEGIN 
declare @empleado numeric(6)  
exec dbo.ej4 @empleado output 
PRINT @empleado
END 
GO

