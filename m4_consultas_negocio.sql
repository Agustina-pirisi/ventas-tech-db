-- =====================================================================
-- PRE-ENTREGA 4: Consultas SQL de negocio (Ventas_Tech_DB)
-- Archivo: m4_consultas_negocio.sql
-- =====================================================================

USE Ventas_Tech_DB;
GO


-- =====================================================================
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.
-- =====================================================================
SELECT 
    MONTH(fecha_venta) AS mes,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio) AS total_facturado,
    AVG(cantidad * precio) AS ticket_promedio
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY MONTH(fecha_venta);
GO


-- =====================================================================
-- Consulta 2 — Ranking de productos
-- Top 5 de id_producto por total facturado, unidades vendidas y total generado.
-- =====================================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(total_venta) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO


-- =====================================================================
-- Consulta 3 — Clientes recurrentes
-- id_cliente que hayan realizado más de un pedido, con cantidad y total gastado.
-- =====================================================================
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(total_venta) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;
GO


-- =====================================================================
-- Consulta 4 — Productos por encima/por debajo del promedio
-- Total facturado por id_producto etiquetado con CASE WHEN frente al promedio.
-- =====================================================================
WITH FacturacionProductos AS (
    SELECT 
        id_producto,
        SUM(total_venta) AS total_producto
    FROM ventas
    GROUP BY id_producto
),
PromedioGeneral AS (
    SELECT AVG(total_producto) AS promedio_productos
    FROM FacturacionProductos
)
SELECT 
    f.id_producto,
    f.total_producto,
    CASE 
        WHEN f.total_producto > p.promedio_productos THEN 'Por encima'
        ELSE 'Por debajo'
    END AS clasificacion_promedio
FROM FacturacionProductos f
CROSS JOIN PromedioGeneral p;
GO


-- =====================================================================
-- BLOQUE DE CIERRE: 3 Hallazgos concretos de negocio
-- =====================================================================
/*
HALLAZGOS DE NEGOCIO:
1. Concentración de facturación: El producto con id_producto 1 concentra la mayor proporción de los ingresos del período, traccionando el volumen principal de ventas de la tienda.
2. Oportunidad de fidelización: La totalidad de los clientes registrados registran transacciones individuales, evidenciando un espacio clave para implementar estrategias de retención y fomentar la recompra.
3. Estabilidad de ticket: Los montos por operación reflejan un comportamiento consistente, facilitando la previsión de ingresos por pedido dentro del canal online y presencial.
*/