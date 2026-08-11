

CREATE DATABASE Ventas_Tech_DB;
GO


USE Ventas_Tech_DB;
GO




DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
GO



CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO


-- Tabla clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
    fecha_registro DATE NOT NULL
);
GO


-- Tabla productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT DEFAULT 1,

    CONSTRAINT FK_productos_categorias
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);
GO


-- Tabla ventas
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,

    CONSTRAINT FK_ventas_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT FK_ventas_productos
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
);
GO


/*
   INSERT DATA
 */

-- Categorias
INSERT INTO categorias
VALUES
(1, 'Computación', 'Laptops, PCs y monitores'),
(2, 'Accesorios', 'Periféricos y complementos'),
(3, 'Audio', 'Auriculares y parlantes'),
(4, 'Almacenamiento', 'Discos y memorias');
GO


-- Clientes
INSERT INTO clientes
VALUES
(1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05'),
(2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10'),
(3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01'),
(4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15'),
(5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01');
GO


-- Productos
INSERT INTO productos
VALUES
(1, 'Laptop Pro 15',      1, 1200.00, 15, 1),
(2, 'Mouse Inalámbrico',  2,   28.00, 80, 1),
(3, 'Monitor 4K 27"',     1,  450.00, 12, 1),
(4, 'Auriculares BT Pro', 3,  120.00, 35, 1),
(5, 'SSD Externo 1TB',    4,  130.00, 18, 1),
(6, 'Teclado Mecánico',   2,   95.00, 40, 1);
GO


-- Ventas
INSERT INTO ventas
VALUES
(1,  1, 1, 2, 1200.00, '2024-03-05'),
(2,  2, 2, 5,   28.00, '2024-03-06'),
(3,  3, 3, 1,  450.00, '2024-03-07'),
(4,  1, 4, 2,  120.00, '2024-03-08'),
(5,  4, 5, 3,  130.00, '2024-03-10'),
(6,  2, 6, 4,   95.00, '2024-03-11'),
(7,  5, 1, 1, 1200.00, '2024-03-12'),
(8,  3, 2, 8,   28.00, '2024-03-13'),
(9,  4, 4, 1,  120.00, '2024-03-14'),
(10, 5, 3, 2,  450.00, '2024-03-15');
GO


/* VERIFICACIÓN */

SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
GO


/*CANTIDAD DE REGISTROS */

SELECT 'categorias' AS tabla, COUNT(*) AS cantidad FROM categorias
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'ventas', COUNT(*) FROM ventas;
GO