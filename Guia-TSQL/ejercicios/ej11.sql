

/*
11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.
*/

CREATE FUNCTION ej11 (@Jefe numeric(6,0))
RETURNS int
AS
BEGIN
	DECLARE @CantEmplACargo int = 0
	DECLARE @JefeAux numeric(6,0) = @Jefe
	DECLARE @CodEmplAux numeric(6,0)
	

	IF NOT EXISTS (SELECT * FROM EMPLEADO WHERE empl_jefe = @Jefe)
	BEGIN
		RETURN @CantEmplACargo
	END

	SET @CantEmplACargo = (
							SELECT COUNT(*)
							FROM Empleado
							WHERE empl_jefe = @Jefe AND empl_codigo > @Jefe)

	DECLARE cursor_empleado CURSOR FOR SELECT E.empl_codigo
										FROM Empleado E
										WHERE empl_jefe = @Jefe
	OPEN cursor_empleado
	FETCH NEXT from cursor_empleado
	INTO @JefeAux
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @CantEmplACargo = @CantEmplACargo + dbo.ej11(@JefeAux)	
	FETCH NEXT from cursor_empleado
	INTO @JefeAux
	END
	CLOSE cursor_empleado
	DEALLOCATE cursor_empleado

	RETURN @CantEmplACargo

	RETURN @CantEmplACargo
END
GO

Select * from Empleado

SELECT E.empl_codigo , dbo.ej11(E.empl_codigo) FROM Empleado E 

alter function ej_t11 (@jefe numeric(6))
returns int 
as 
begin
    declare @empleado numeric(6), @cantidad int 
    select @cantidad = 0
    declare c1 cursor for select empl_codigo from empleado where empl_jefe = @jefe
    open c1
    fetch c1 into @empleado 
    while @@FETCH_STATUS = 0
    begin  
        select @cantidad = @cantidad + 1 + dbo.ej_t11(@empleado)   
        fetch c1 into @empleado 
    end 
    close c1
    deallocate c1
    return @cantidad 
end
go