-- ==========================================================
-- 1. PREPARACIÓN DEL ENTORNO
-- ==========================================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SegundaJugada')
BEGIN
    CREATE DATABASE SegundaJugada;
END
GO

USE SegundaJugada;
GO

-- ==========================================================
-- 2. CREACIÓN DE TABLAS (Solo si no existen)
-- ==========================================================

-- Tabla de Inventario
IF OBJECT_ID('dbo.Inventario', 'U') IS NULL
BEGIN
    CREATE TABLE Inventario (
        sku INT PRIMARY KEY,
        descripcion VARCHAR(100),
        talla VARCHAR(10),
        precio DECIMAL(10,2),
        stock INT,
        categoria VARCHAR(50)
    );
    -- Insertamos el producto base solo la primera vez
    INSERT INTO Inventario (sku, descripcion, talla, precio, stock, categoria)
    VALUES (10101, 'Polo Nike Negro', 'M', 49.90, 10, 'Polos');
END

-- Tabla de Clientes
IF OBJECT_ID('dbo.Clientes', 'U') IS NULL
BEGIN
    CREATE TABLE Clientes (
        dni VARCHAR(20) PRIMARY KEY,
        nombre VARCHAR(100),
        apellido VARCHAR(100),
        celular VARCHAR(15),
        correo VARCHAR(100)
    );
END

-- Tabla de Ventas
IF OBJECT_ID('dbo.Ventas', 'U') IS NULL
BEGIN
    CREATE TABLE Ventas (
        id_venta INT IDENTITY(1,1) PRIMARY KEY,
        documento_cliente VARCHAR(20),
        tipo_comprobante CHAR(1),
        total_pagado DECIMAL(10,2),
        fecha_venta DATETIME DEFAULT GETDATE()
    );
END
GO

-- ==========================================================
-- 3. REPORTE Y DOCUMENTACIÓN (esto lo hice para mi compañeros)
-- ==========================================================

PRINT '--- ESTADO ACTUAL DE LA BASE DE DATOS ---';

-- Ver Productos
SELECT 'PRODUCTOS' AS Reporte, * FROM Inventario;

-- Ver Clientes Registrados desde Python
SELECT 'CLIENTES REGISTRADOS' AS Reporte, * FROM Clientes;

-- Ver Ventas Realizadas
SELECT 'HISTORIAL DE VENTAS' AS Reporte, * FROM Ventas;
-- ===============================================
-- REPORTE DIVIDIDO POR CATEGORÍAS (PRODUCTOS)
-- ===============================================
PRINT '---------- SECCIÓN: PANTALONES ----------';
SELECT sku, descripcion, talla, precio, stock 
FROM Inventario WHERE categoria = 'Pantalones';

PRINT '---------- SECCIÓN: POLOS ----------';
SELECT sku, descripcion, talla, precio, stock 
FROM Inventario WHERE categoria = 'Polos';

PRINT '---------- SECCIÓN: ACCESORIOS ----------';
SELECT sku, descripcion, talla, precio, stock 
FROM Inventario WHERE categoria NOT IN ('Pantalones', 'Polos');

-- ===============================================
-- REPORTE DE CLIENTES Y VENTAS
-- ===============================================
PRINT '---------- CLIENTES REGISTRADOS ----------';
SELECT dni, nombre, apellido, celular, correo FROM Clientes;

PRINT '---------- ÚLTIMAS VENTAS REALIZADAS ----------';
SELECT id_venta, documento_cliente, total_pagado, fecha_venta FROM Ventas;