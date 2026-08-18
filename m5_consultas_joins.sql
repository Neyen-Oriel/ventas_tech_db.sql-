

USE Ventas_Tech_DB;
GO



IF NOT EXISTS (
    SELECT *
    FROM sys.tables
    WHERE name = 'territorios'
)
BEGIN

    CREATE TABLE territorios (
        id_territorio INT PRIMARY KEY,
        region VARCHAR(50) NOT NULL
    );

END;
GO



IF NOT EXISTS (SELECT * FROM territorios)
BEGIN

    INSERT INTO territorios (id_territorio, region)
    VALUES
        (1, 'Buenos Aires'),
        (2, 'Córdoba'),
        (3, 'Santa Fe'),
        (4, 'Mendoza'),
        (5, 'Tucumán');

END;
GO


IF NOT EXISTS (
    SELECT *
    FROM sys.columns
    WHERE object_id = OBJECT_ID('clientes')
    AND name = 'id_territorio'
)
BEGIN

    ALTER TABLE clientes
    ADD id_territorio INT;

END;
GO


IF NOT EXISTS (
    SELECT *
    FROM sys.columns
    WHERE object_id = OBJECT_ID('clientes')
    AND name = 'segmento'
)
BEGIN

    ALTER TABLE clientes
    ADD segmento VARCHAR(50);

END;
GO



UPDATE clientes
SET id_territorio =
    CASE id_cliente
        WHEN 1 THEN 1
        WHEN 2 THEN 2
        WHEN 3 THEN 3
        WHEN 4 THEN 4
        WHEN 5 THEN 5
    END,
    segmento =
    CASE id_cliente
        WHEN 1 THEN 'Minorista'
        WHEN 2 THEN 'Mayorista'
        WHEN 3 THEN 'Minorista'
        WHEN 4 THEN 'Empresa'
        WHEN 5 THEN 'Minorista'
    END;
GO




IF NOT EXISTS (
    SELECT *
    FROM sys.foreign_keys
    WHERE name = 'FK_clientes_territorios'
)
BEGIN

    ALTER TABLE clientes
    ADD CONSTRAINT FK_clientes_territorios
    FOREIGN KEY (id_territorio)
    REFERENCES territorios(id_territorio);

END;
GO



IF NOT EXISTS (
    SELECT *
    FROM sys.columns
    WHERE object_id = OBJECT_ID('ventas')
    AND name = 'canal'
)
BEGIN

    ALTER TABLE ventas
    ADD canal VARCHAR(20);

END;
GO


/* Asignar canales a las ventas */

UPDATE ventas
SET canal =
    CASE
        WHEN id_venta IN (1, 3, 5, 7, 9)
            THEN 'Online'
        ELSE 'Presencial'
    END;
GO


/* ============================================================
   CONSULTA 1
   VISTA BASE DEL PROYECTO
   INNER JOIN
   ============================================================ */

SELECT
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta,
    v.canal
FROM ventas AS v

INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente

INNER JOIN productos AS p
    ON v.id_producto = p.id_producto

INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria

INNER JOIN territorios AS t
    ON c.id_territorio = t.id_territorio

ORDER BY v.fecha_venta;
GO


/* ============================================================
   CONSULTA 2
   CLIENTES SIN VENTAS
   LEFT JOIN
   ============================================================ */

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c

LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente

WHERE v.id_venta IS NULL;
GO


/* ============================================================
   CONSULTA 3
   PRODUCTOS SIN VENTAS
   LEFT JOIN
   ============================================================ */

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p

INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria

LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto

WHERE v.id_venta IS NULL;
GO


/* ============================================================
   CONSULTA 4
   CONSOLIDADO POR CANAL
   UNION ALL
   ============================================================ */

WITH ventas_consolidadas AS
(
    SELECT
        id_venta,
        'Online' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT
        id_venta,
        'Presencial' AS canal,
        cantidad * precio_unitario AS total_venta
    FROM ventas
    WHERE canal = 'Presencial'
)

SELECT
    canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total_venta) AS total_facturado
FROM ventas_consolidadas
GROUP BY canal
ORDER BY canal;
GO