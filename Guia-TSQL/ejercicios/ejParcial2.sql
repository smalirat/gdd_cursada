/* 2. Realizar un stored procedure que calcule e informe la comisión de un vendedor para un determinado mes.
Los parámetros de entrada es código de vendedor, mes y año.  
El criterio para calcular la comisión es: 5% del total vendido tomando como importe base el valor de la factura 
sin los impuestos del mes a comisionar, a esto se le debe sumar un plus de 3% más en el caso de que sea el vendedor 
que más vendió los productos nuevos en comparación al resto de los vendedores, es decir este plus se le aplica solo 
un vendedor y en caso de igualdad se le otorga al que posea el código de vendedor más alto. 
Se considera que un producto es nuevo cuando su primera venta en la empresa se produjo durante el mes en curso 
o en alguno de los 4 meses anteriores.
De no haber ventas de productos nuevos en ese periodo, ese plus nunca se aplica. */


create procedure parcial @vendedor numeric(6), @mes numeric(2), @año numeric(4), @comision numeric(12,2) output 
as 
begin 

    if @vendedor = (select top 1 fact_vendedor from factura join item_factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
        where item_producto in 
            (select distinct item_producto from item_factura join factura on 
            fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
            where fact_fecha >= GETDATE()-120 AND ITEM_PRODUCTO NOT IN 
                (select distinct item_producto from item_factura join factura on 
                fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
                where fact_fecha < GETDATE()-120))  
            group by fact_vendedor
            order by sum(item_cantidad*item_precio) desc, fact_vendedor desc)  

        /* select distinct item_producto from item_factura i join factura on 
        fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
        where fact_fecha >= GETDATE()-120 AND fact_fecha = (SELECT TOP 1 fact_fecha FROM Factura 
										JOIN Item_Factura ON fact_tipo+fact_numero+fact_sucursal = item_tipo+item_numero+item_sucursal 
										WHERE item_producto = i.item_producto 
										ORDER BY fact_fecha asc) */
        select @comision = sum(fact_total-fact_total_impuestos) from factura where fact_vendedor = @vendedor and year(fact_fecha) = @año AND
        month(fact_fecha) = @mes * 0.08
    else 
        select @comision = sum(fact_total-fact_total_impuestos) from factura where fact_vendedor = @vendedor and year(fact_fecha) = @año AND
        month(fact_fecha) = @mes * 0.05
    return
END
go