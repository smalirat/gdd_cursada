/*16. Desarrolle el/los elementos de base de datos necesarios para que ante una venta automaticamante se descuenten del stock los articulos vendidos. 
Se descontaran del deposito que mas producto poseea y se supone que el stock se almacena tanto de productos simples como compuestos 
(si se acaba el stock de los compuestos no se arman combos) En caso que no alcance el stock de un deposito se descontara del siguiente y asi hasta agotar 
los depositos posibles. En ultima instancia se dejara stock negativo en el ultimo deposito que se desconto. */


CREATE TRIGGER ej_t16
ON item_factura
AFTER INSERT
AS
BEGIN
    DECLARE @producto CHAR(8), @cantidad DECIMAL(12,2);

    DECLARE c CURSOR FOR
        SELECT item_producto, item_cantidad
        FROM inserted;

    OPEN c;
    FETCH NEXT FROM c INTO @producto, @cantidad;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC dbo.ej_f16 @producto, @cantidad;

        DECLARE @comp CHAR(8), @cant_comp DECIMAL(12,2);

        DECLARE c2 CURSOR FOR
            SELECT comp_componente, comp_cantidad * @cantidad
            FROM Composicion
            WHERE comp_producto = @producto;

        OPEN c2;
        FETCH NEXT FROM c2 INTO @comp, @cant_comp;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC dbo.ej_f16 @comp, @cant_comp;
            FETCH NEXT FROM c2 INTO @comp, @cant_comp;
        END

        CLOSE c2;
        DEALLOCATE c2;

        FETCH NEXT FROM c INTO @producto, @cantidad;
    END

    CLOSE c;
    DEALLOCATE c;
END;
GO



CREATE FUNCTION ej_f16 (
    @producto CHAR(8),
    @cantidad DECIMAL(12,2)
)
RETURNS INT
AS
BEGIN
    DECLARE 
        @restante DECIMAL(12,2) = @cantidad,
        @deposito CHAR(8),
        @stock_actual DECIMAL(12,2);

    DECLARE c CURSOR FOR
        SELECT stoc_deposito, stoc_cantidad
        FROM STOCK
        WHERE stoc_producto = @producto
        ORDER BY stoc_cantidad DESC;  

    OPEN c;
    FETCH NEXT FROM c INTO @deposito, @stock_actual;

    WHILE @@FETCH_STATUS = 0 AND @restante > 0
    BEGIN
        IF @restante <= @stock_actual
        BEGIN
            -- alcanza el stock del depósito
            UPDATE STOCK
            SET stoc_cantidad = stoc_cantidad - @restante
            WHERE stoc_producto = @producto AND stoc_deposito = @deposito;

            SET @restante = 0;
        END
        ELSE
        BEGIN
            -- no alcanza, consumir todo y seguir
            UPDATE STOCK
            SET stoc_cantidad = 0
            WHERE stoc_producto = @producto AND stoc_deposito = @deposito;

            SET @restante = @restante - @stock_actual;
        END

        FETCH NEXT FROM c INTO @deposito, @stock_actual;
    END

    CLOSE c;
    DEALLOCATE c;

    -- Si aún queda remanente → permitir negativo en último depósito
    IF @restante > 0
    BEGIN
        DECLARE @ultimo CHAR(8);
        SELECT TOP 1 @ultimo = stoc_deposito
        FROM STOCK
        WHERE stoc_producto = @producto
        ORDER BY stoc_cantidad ASC; -- el más bajo (último)

        UPDATE STOCK
        SET stoc_cantidad = stoc_cantidad - @restante
        WHERE stoc_producto = @producto AND stoc_deposito = @ultimo;
    END

    RETURN 1;
END;
GO



