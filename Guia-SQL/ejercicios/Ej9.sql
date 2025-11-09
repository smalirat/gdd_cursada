/* Mostrar el código del jefe, código del empleado que lo tiene como jefe,
nombre del mismo y la cantidad de depósitos que ambos tienen asignados. */

SELECT 
    j.empl_codigo AS jefe_codigo,
    e.empl_codigo AS empleado_codigo,
    e.empl_nombre,
    COUNT(DISTINCT dj.depo_codigo) AS cant_depos_jefe,
    COUNT(DISTINCT de.depo_codigo) AS cant_depos_empleado
FROM Empleado j
JOIN Empleado e ON j.empl_codigo = e.empl_jefe
LEFT JOIN Deposito dj ON dj.depo_encargado = j.empl_codigo
LEFT JOIN Deposito de ON de.depo_encargado = e.empl_codigo
GROUP BY j.empl_codigo, e.empl_codigo, e.empl_nombre;

SELECT * FROM Empleado
SELECT * FROM Deposito