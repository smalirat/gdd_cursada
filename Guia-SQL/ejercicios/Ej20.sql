/*20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012 
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje 2012.  
El puntaje de cada empleado se calculara de la siguiente manera: 
para los que hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas que superen 
los 100 pesos que haya vendido en el año, para los que tengan menos de 50 facturas en el año el calculo del 
puntaje sera el 50% de cantidad de facturas realizadas por sus subordinados directos en dicho año. */

select * from factura

SELECT empl_codigo FROM empleado
JOIN factura on fact_vendedor = empl_codigo
WHERE YEAR(fact_fecha) = 2012


SELECT TOP 3 e.empl_codigo legajo, e.empl_nombre nombre, e.empl_apellido apellido, YEAR(e.empl_ingreso) anio_ingreso,
ISNULL((CASE WHEN fe2011.cant_facturas >= 50 THEN fe2011.mayores_100 ELSE fs2011.fact_subordinados END),0) puntaje2011,
ISNULL((CASE WHEN fe2012.cant_facturas >= 50 THEN fe2012.mayores_100 ELSE fs2012.fact_subordinados END),0) puntaje2012
FROM Empleado e

LEFT JOIN
(SELECT f.fact_vendedor, COUNT(*) cant_facturas, COUNT(CASE WHEN f.fact_total > 100 THEN 1 END) mayores_100
FROM Factura f
WHERE YEAR(f.fact_fecha) = 2011
GROUP BY f.fact_vendedor) fe2011 ON fe2011.fact_vendedor = e.empl_codigo

LEFT JOIN
(SELECT f.fact_vendedor, COUNT(*) cant_facturas, COUNT(CASE WHEN f.fact_total > 100 THEN 1 END) mayores_100
FROM Factura f
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY f.fact_vendedor) fe2012 ON fe2012.fact_vendedor = e.empl_codigo

LEFT JOIN
(SELECT j.empl_codigo legajo, COUNT(*) * 0.5  fact_subordinados
FROM Empleado j 
JOIN Empleado s ON s.empl_jefe = j.empl_codigo
JOIN Factura f ON f.fact_vendedor = s.empl_codigo AND YEAR(f.fact_fecha) = 2011 
GROUP BY j.empl_codigo) fs2011 ON fs2011.legajo = e.empl_codigo

LEFT JOIN
(SELECT j.empl_codigo legajo, COUNT(*) * 0.5  fact_subordinados
FROM Empleado j 
JOIN Empleado s ON s.empl_jefe = j.empl_codigo
JOIN Factura f ON f.fact_vendedor = s.empl_codigo AND YEAR(f.fact_fecha) = 2012 
GROUP BY j.empl_codigo) fs2012 ON fs2012.legajo = e.empl_codigo
ORDER BY puntaje2012 DESC


SELECT TOP 3
    e.empl_codigo legajo,
    e.empl_nombre nombre,
    e.empl_apellido apellido,
    YEAR(e.empl_ingreso) anio_ingreso,
    ISNULL((CASE WHEN (SELECT COUNT(*)
                  FROM Factura f
                  WHERE YEAR(f.fact_fecha) = 2011  AND f.fact_vendedor = e.empl_codigo) >= 50
            THEN (SELECT COUNT(CASE WHEN f.fact_total > 100 THEN 1 END)
                  FROM Factura f
                  WHERE YEAR(f.fact_fecha) = 2011
                    AND f.fact_vendedor = e.empl_codigo)

            ELSE (SELECT COUNT(*) * 0.5
                  FROM Empleado s
                  JOIN Factura f ON f.fact_vendedor = s.empl_codigo
                  WHERE YEAR(f.fact_fecha) = 2011
                    AND s.empl_jefe = e.empl_codigo
                 )
        END),
    0) AS puntaje2011,
    ISNULL(
        (CASE
            WHEN (SELECT COUNT(*)
                  FROM Factura f
                  WHERE YEAR(f.fact_fecha) = 2012
                    AND f.fact_vendedor = e.empl_codigo
                 ) >= 50

            THEN (SELECT COUNT(CASE WHEN f.fact_total > 100 THEN 1 END)
                  FROM Factura f
                  WHERE YEAR(f.fact_fecha) = 2012 AND f.fact_vendedor = e.empl_codigo)
            ELSE (SELECT COUNT(*) * 0.5
                  FROM Empleado s
                  JOIN Factura f ON f.fact_vendedor = s.empl_codigo
                  WHERE YEAR(f.fact_fecha) = 2012 AND s.empl_jefe = e.empl_codigo)END),0)  puntaje2012
FROM
    Empleado e
ORDER BY
    puntaje2012 DESC;