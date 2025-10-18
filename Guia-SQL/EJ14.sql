/* Escriba una consulta que retorne una estadística de ventas por cliente. 
Los campos que debe retornar son:  
Código del cliente 
Cantidad de veces que compro en el último año 
Promedio por compra en el último año 
Cantidad de productos diferentes que compro en el último año 
Monto de la mayor compra que realizo en el último año 
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en el último año.
No se deberán visualizar NULLs en ninguna columna */

select clie_codigo, count(distinct fact_numero) cantidadDeCompras, convert(numeric(10,2), 
	avg(fact_total)) promedioCompras, count(distinct item_producto) productosDistintosComprados, max(fact_total) maximaCompra
from Cliente
left join Factura on clie_codigo = fact_cliente and  year(fact_fecha) = (select year(max(fact_fecha)) from Factura)
left join Item_Factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
group by clie_codigo
order by 2 desc