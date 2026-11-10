-- =====================================================================
-- PROYECTO FINAL: BACK-END / CHECKPOINT - Ventas_Tech_DB
-- Base de datos normalizada para cadena de tiendas de tecnología (TechStore)
-- =====================================================================

-- Crear y usar la base de datos
CREATE DATABASE Ventas_Tech_DB;
GO

USE Ventas_Tech_DB;
GO


-- =====================================================================
-- SECCIÓN 1: DROP TABLES (Orden inverso a las dependencias por las FK)
-- =====================================================================

IF OBJECT_ID('ventas', 'U') IS NOT NULL DROP TABLE ventas;
IF OBJECT_ID('productos', 'U') IS NOT NULL DROP TABLE productos;
IF OBJECT_ID('clientes', 'U') IS NOT NULL DROP TABLE clientes;
IF OBJECT_ID('categorias', 'U') IS NOT NULL DROP TABLE categorias;
GO


-- =====================================================================
-- SECCIÓN 2: CREATE TABLES (Estructura, Tipos de datos, PK y FK)
-- =====================================================================

-- 1. Tabla de Dimensión: Categorías
CREATE TABLE categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(60) NOT NULL
);

-- 2. Tabla de Dimensión: Clientes
CREATE TABLE clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    email NVARCHAR(120) NOT NULL,
    segmento NVARCHAR(30) NOT NULL,
    fecha_registro DATE NOT NULL
);

-- 3. Tabla de Dimensión: Productos (Depende de Categorías)
CREATE TABLE productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto NVARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
    subcategoria NVARCHAR(60) NOT NULL,
    precio DECIMAL(12,2) NOT NULL,
    costo DECIMAL(12,2) NOT NULL,
    CONSTRAINT FK_productos_categorias FOREIGN KEY (id_categoria) 
        REFERENCES categorias(id_categoria)
);

-- 4. Tabla de Hechos: Ventas (Depende de Productos y Clientes)
CREATE TABLE ventas (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    total_venta DECIMAL(12,2) NOT NULL,
    canal NVARCHAR(30) NOT NULL,
    CONSTRAINT FK_ventas_clientes FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente),
    CONSTRAINT FK_ventas_productos FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto)
);
GO


-- =====================================================================
-- SECCIÓN 3: INSERT INTO (Carga de datos de prueba iniciales)
-- =====================================================================

-- Insertar Categorías
INSERT INTO categorias (nombre_categoria) VALUES 
('Computación'),
('Telefonía'),
('Audio y Video');

-- Insertar Clientes
INSERT INTO clientes (nombre, email, segmento, fecha_registro) VALUES 
('Ana Pérez', 'ana.perez@email.com', 'Minorista', '2025-01-15'),
('Carlos Gómez', 'carlos.gomez@email.com', 'Corporativo', '2025-02-10'),
('Lucía Fernández', 'lucia.f@email.com', 'Minorista', '2025-03-01');

-- Insertar Productos
INSERT INTO productos (nombre_producto, id_categoria, subcategoria, precio, costo) VALUES 
('Notebook Gamer X1', 1, 'Laptops', 1200000.00, 900000.00),
('Smartphone Z5', 2, 'Celulares', 800000.00, 600000.00),
('Auriculares Inalámbricos TWS', 3, 'Audio', 75000.00, 45000.00);

-- Insertar Ventas
INSERT INTO ventas (fecha_venta, id_cliente, id_producto, cantidad, total_venta, canal) VALUES 
('2026-03-10', 1, 1, 1, 1200000.00, 'Online'),
('2026-03-11', 2, 2, 2, 1600000.00, 'Tienda física'),
('2026-03-12', 3, 3, 3, 225000.00, 'Online');
GO


-- =====================================================================
-- SECCIÓN 4: VALIDACIÓN (Consultas SELECT de comprobación)
-- =====================================================================

SELECT '=== CATEGORIAS ===' AS Tabla;
SELECT * FROM categorias;

SELECT '=== CLIENTES ===' AS Tabla;
SELECT * FROM clientes;

SELECT '=== PRODUCTOS ===' AS Tabla;
SELECT * FROM productos;

SELECT '=== VENTAS (CON RELACIONES) ===' AS Tabla;
SELECT 
    v.id_venta,
    v.fecha_venta,
    c.nombre AS cliente,
    p.nombre_producto,
    v.cantidad,
    v.total_venta,
    v.canal
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto;
GO