/* ============================================================
   RETAILPRO - MÓDULO 4
   CONSULTAS SQL DE NEGOCIO
   Base de datos: Ventas_Tech_DB
   Motor: SQL Server
   ============================================================ */

USE Ventas_Tech_DB;
GO


/* ============================================================
   CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
   ============================================================ */

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


/* ============================================================
   CONSULTA 2 - RANKING DE PRODUCTOS
   Top 5 productos por total facturado
   ============================================================ */

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
GO


/* ============================================================
   CONSULTA 3 - CLIENTES RECURRENTES
   Clientes que realizaron más de un pedido
   ============================================================ */

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO


/* ============================================================
   CONSULTA 4 - MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO
   ============================================================ */

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)

SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_mensual
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;
GO


/* ============================================================
   HALLAZGOS
   ============================================================ */

-- 1. El producto 1 generó la mayor facturación total.
-- 2. El producto 2 fue el producto con mayor cantidad de unidades vendidas.
-- 3. Los clientes recurrentes realizaron más de un pedido durante el período analizado.