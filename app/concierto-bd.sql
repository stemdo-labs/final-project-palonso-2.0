-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS concierto;

-- Usar la base de datos creada
USE concierto;

-- Crear la tabla tipo_entradas
CREATE TABLE IF NOT EXISTS tipo_entradas (
    id VARCHAR(36) PRIMARY KEY,
    tipo VARCHAR(30),
    precio DECIMAL(10, 2)
);

-- Crear la tabla tipo_entradas
CREATE TABLE IF NOT EXISTS tipo_entradas (
    id VARCHAR(36) PRIMARY KEY,
    tipo VARCHAR(20),
    precio DECIMAL(10, 2)
);

-- Insertar registros en la tabla tipo_entradas
INSERT INTO tipo_entradas (id, tipo, precio) VALUES
(UUID(), 'Menor', 10),
(UUID(), 'Adulto', 5),
(UUID(), 'Jubilado', 7);

-- Crear la tabla entradas
CREATE TABLE IF NOT EXISTS entradas (
    id VARCHAR(36) PRIMARY KEY,
    fecha DATE,
    nombre VARCHAR(15),
    apellidos VARCHAR(30),
    telefono VARCHAR(15),
    tipo_entrada VARCHAR(36),
    cantidad INT,
    precio DECIMAL(10, 2),
    FOREIGN KEY (tipo_entrada) REFERENCES tipo_entradas(id)
);

-- Sembrar datos en la tabla entradas
INSERT INTO entradas (id, fecha, nombre, apellidos, telefono, tipo_entrada, cantidad, precio) VALUES
(UUID(), '2024-06-12', 'Juan', 'Pérez', '123456789', (SELECT id FROM tipo_entradas WHERE tipo = 'Menor'), 2, 20),
(UUID(), '2024-06-13', 'María', 'García', '987654321', (SELECT id FROM tipo_entradas WHERE tipo = 'Adulto'), 1, 5),
(UUID(), '2024-06-14', 'Pedro', 'López', '456789123', (SELECT id FROM tipo_entradas WHERE tipo = 'Jubilado'), 3, 21);



