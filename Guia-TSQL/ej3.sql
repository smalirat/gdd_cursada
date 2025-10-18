/* 3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución. */


alter procedure EJ_3 @cantidad int OUTPUT
AS
BEGIN
	SELECT @cantidad = COUNT(*) FROM EMPLEADO WHERE empl_jefe is null
	if @cantidad > 1 
	begin
		update Empleado
		set empl_jefe = (SELECT TOP 1 EMPL_CODIGO 
						 FROM EMPLEADO 
						 WHERE empl_jefe is null 
						 ORDER BY empl_salario DESC, empl_ingreso ASC)
		WHERE empl_jefe is null and 
			  empl_codigo not in (SELECT TOP 1 EMPL_CODIGO 
								  FROM EMPLEADO  
								  where empl_jefe is null 
								  ORDER BY empl_salario DESC, empl_ingreso ASC)
	end
END
go 


BEGIN 
declare @cantidad_emp int 
exec dbo.EJ_3 @cantidad_emp output 
PRINT @cantidad_emp
END 
GO