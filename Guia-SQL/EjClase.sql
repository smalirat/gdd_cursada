SELECT * FROM CLIENTE, FACTURA
WHERE CLIE_CODIGO = fact_cliente

SELECT * FROM CLIENTE LEFT JOIN FACTURA ON CLIE_CODIGO = fact_cliente
ORDER BY clie_codigo

SELECT CASE when year(fact_fecha) <= 2010 THEN 'VIEJA' WHEN fact_total < 100 then 'POCO MONTO' WHEN fact_cliente > 1000 then 'CLIENTE ALTO' 
	ELSE 'NADA' END, fact_total FROM FACTURA 
