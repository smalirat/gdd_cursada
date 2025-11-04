/*Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. 
Debe insertar una línea por cada artículo con los movimientos de stock generados por las ventas entre esas fechas. 
La tabla se encuentra creada y vacía. */

DROP TABLE Ventas;

CREATE TABLE Ventas (
    Renglon INT IDENTITY(1,1) PRIMARY KEY, 
    Codigo CHAR(8) NOT NULL,               
    Detalle CHAR(50),                      
    Cant_Mov DECIMAL(12, 2),               
    Precio_de_Venta DECIMAL(12, 2),          
    Ganancia DECIMAL(12, 2)                  
);

/*alter PROCEDURE ej7 (
    @fecha_desde SMALLDATETIME,
    @fecha_hasta SMALLDATETIME
)
AS
BEGIN
    --SET NOCOUNT ON;

    -- 1. Limpia la tabla Ventas. TRUNCATE TABLE es más rápido y resetea el IDENTITY.
    TRUNCATE TABLE Ventas;

    INSERT INTO Ventas (
        Codigo,
        Detalle,
        Cant_Mov,
        Precio_de_Venta,
        Ganancia
    )
    SELECT
        p.prod_codigo,                         
        p.prod_detalle,                        
        SUM(it.item_cantidad) AS Cant_Mov,      
        AVG(it.item_precio) AS Precio_de_Venta, 
        SUM(it.item_cantidad * it.item_precio) - SUM(it.item_cantidad * p.prod_precio) AS Ganancia
    FROM
        Factura AS f
    JOIN
        Item_Factura AS it ON f.fact_tipo = it.item_tipo
                           AND f.fact_sucursal = it.item_sucursal
                           AND f.fact_numero = it.item_numero
    JOIN
        Producto AS p ON it.item_producto = p.prod_codigo
    WHERE
        f.fact_fecha BETWEEN @fecha_desde AND @fecha_hasta 
    GROUP BY
        p.prod_codigo, p.prod_detalle
    ORDER BY
        p.prod_codigo; 

END

select * from Ventas */



create procedure ej_t7 @desde DATETIME, @hasta DATETIME
AS
begin 
    declare @renglon int, @producto char(8), @detalle char(50), @precio_prom numeric(12,4), @cantidad numeric(12,2), @ganancia numeric(12,2) 
    declare c1 cursor for 
    select prod_codigo, prod_Detalle, sum(item_cantidad), avg(item_precio), sum(item_precio*item_cantidad)-sum(item_cantidad)*prod_precio
    from Item_Factura join factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
    join producto on prod_codigo = item_producto
    where fact_fecha >= @desde and fact_fecha <= @hasta
    group by prod_codigo, prod_detalle, prod_precio
    open c1 
    fetch next into  @producto, @detalle,  @cantidad, @precio_prom, @ganancia
    select @renglon = 1
    while @@FETCH_STATUS = 0
    begin 
        insert ventas values (@producto, @detalle,  @cantidad, @precio_prom, @renglon, @ganancia)
        select @renglon = @renglon + 1
        fetch next into  @producto, @detalle,  @cantidad, @precio_prom, @ganancia
    END
    close c1
    deallocate c1
    RETURN
end
go 
