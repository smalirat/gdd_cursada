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

create procedure ej_t8 
AS
begin
    insert diferencias 
    select  distinct p1.prod_codigo, prod_Detalle,(select count(*) from composicion where comp_producto = p1.prod_codigo),
            (select sum(comp_cantidad*p2.prod_precio) from composicion join producto p2 on comp_componente = p2.prod_codigo
                where comp_producto = p1.prod_codigo) ,item_precio 
    from Item_Factura join producto p1 on p1.prod_codigo = item_producto
    where p1.prod_codigo in (select comp_producto from Composicion) 
    and item_precio <> (select sum(comp_cantidad*p2.prod_precio) from composicion join producto p2 on comp_componente = p2.prod_codigo
                where comp_producto = p1.prod_codigo)
    return
end    
go 


EXEC DBO.EJ8
select * from Diferencias
select * from Composicion
select * from Producto