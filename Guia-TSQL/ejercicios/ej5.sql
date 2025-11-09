/*5. Realizar un procedimiento que complete con los datos existentes en el modelo provisto la tabla de hechos denominada 
Fact_table tiene las siguiente definición: 
Create table Fact_table ( anio char(4), mes char(2), familia char(3), rubro char(4), zona char(3), cliente char(6), producto char(8), 
cantidad decimal(12,2), monto decimal(12,2) ) Alter table Fact_table Add constraint primary key(anio,mes,familia,rubro,zona,cliente,producto
*/

Create table Fact_table ( anio char(4), mes char(2), familia char(3), rubro char(4), zona char(3), cliente char(6), producto char(8), 
cantidad decimal(12,2), monto decimal(12,2) ) 
Alter table Fact_table Add constraint primary key(anio,mes,familia,rubro,zona,cliente,producto

CREATE PROCEDURE Cargar_Fact_Table
AS
BEGIN
    -- Establece SET NOCOUNT ON para evitar que se muestren los mensajes
    -- con el número de filas afectadas por una instrucción Transact-SQL.
    SET NOCOUNT ON;

    -- 1. Se vacía la tabla de hechos para asegurar que no haya datos duplicados
    --    en caso de que el procedimiento se ejecute más de una vez.
    TRUNCATE TABLE Fact_table;

    -- 2. Se insertan los nuevos datos consolidados en la tabla de hechos.
    INSERT INTO Fact_table (
        anio,
        mes,
        familia,
        rubro,
        zona,
        cliente,
        producto,
        cantidad,
        monto
    )
    SELECT
        -- Dimensiones extraídas y agrupadas
        CONVERT(char(4), YEAR(f.fact_fecha)),    -- Año de la factura
        FORMAT(f.fact_fecha, 'MM'),              -- Mes de la factura (formato de 2 dígitos)
        p.prod_familia,                          -- Familia del producto
        p.prod_rubro,                            -- Rubro del producto
        c.clie_zona,                             -- Zona del cliente
        f.fact_cliente,                          -- Código del cliente
        i.item_producto,                         -- Código del producto

        -- Métricas (hechos) agregadas
        SUM(i.item_cantidad),                    -- Suma de la cantidad vendida
        SUM(i.item_cantidad * i.item_precio)     -- Suma del monto total (cantidad * precio)
    FROM
        Factura f
    -- Se asume una tabla de detalle de factura para unir los productos
    JOIN Item_Factura i ON f.fact_numero = i.item_numero
    -- Se une con la tabla de productos para obtener familia y rubro
    JOIN Producto p ON i.item_producto = p.prod_codigo
    -- Se asume una tabla de clientes para obtener la zona
    JOIN Cliente c ON f.fact_cliente = c.clie_codigo
    GROUP BY
        -- La cláusula GROUP BY debe coincidir con todas las columnas de dimensión
        YEAR(f.fact_fecha),
        FORMAT(f.fact_fecha, 'MM'),
        p.prod_familia,
        p.prod_rubro,
        d.,
        f.fact_cliente,
        i.item_producto;

    SET NOCOUNT OFF;
END
GO