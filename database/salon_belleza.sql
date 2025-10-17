-- Script de creación de base de datos para Salon de Belleza
-- Autor: Sistema Salon Belleza
-- Fecha: 2024

-- Usar la base de datos existente (defaultdb en Aiven)
USE defaultdb;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    nombre_completo VARCHAR(100) NOT NULL,
    rol ENUM('ADMIN', 'RECEPCIONISTA', 'ESTILISTA', 'GERENTE') NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso DATETIME NULL,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_rol (rol),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla de empleados
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NULL,
    direccion VARCHAR(200) NULL,
    fecha_contratacion DATE NOT NULL,
    cargo ENUM('ESTILISTA', 'COLORISTA', 'MANICURISTA', 'ESTETICISTA', 
               'RECEPCIONISTA', 'SUPERVISOR', 'GERENTE', 'ASISTENTE') NOT NULL,
    salario DECIMAL(10,2) NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NULL,
    id_usuario BIGINT NULL,
    INDEX idx_email (email),
    INDEX idx_cargo (cargo),
    INDEX idx_activo (activo),
    INDEX idx_fecha_contratacion (fecha_contratacion),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar usuario administrador inicial
INSERT INTO usuarios (username, password, email, nombre_completo, rol, activo) 
VALUES (
    'admin', 
    'admin123', 
    'admin@salonbelleza.com', 
    'Administrador del Sistema', 
    'ADMIN', 
    TRUE
);

-- Insertar algunos empleados de ejemplo
INSERT INTO empleados (nombre, apellido, email, telefono, fecha_contratacion, cargo, salario, activo) VALUES
('Ana', 'López', 'ana.lopez@salonbelleza.com', '555-0101', '2023-01-15', 'ESTILISTA', 2500.00, TRUE),
('Carlos', 'Martínez', 'carlos.martinez@salonbelleza.com', '555-0102', '2023-02-20', 'COLORISTA', 2800.00, TRUE),
('María', 'González', 'maria.gonzalez@salonbelleza.com', '555-0103', '2023-03-10', 'MANICURISTA', 2200.00, TRUE),
('Pedro', 'Sánchez', 'pedro.sanchez@salonbelleza.com', '555-0104', '2023-04-05', 'ESTETICISTA', 2600.00, TRUE),
('Laura', 'Díaz', 'laura.diaz@salonbelleza.com', '555-0105', '2023-05-12', 'RECEPCIONISTA', 2000.00, TRUE),
('Roberto', 'Hernández', 'roberto.hernandez@salonbelleza.com', '555-0106', '2023-06-18', 'SUPERVISOR', 3200.00, TRUE);

-- Crear índices adicionales para optimización
CREATE INDEX idx_empleados_nombre_apellido ON empleados(nombre, apellido);
CREATE INDEX idx_usuarios_fecha_creacion ON usuarios(fecha_creacion);
CREATE INDEX idx_empleados_fecha_creacion ON empleados(fecha_creacion);

-- Crear vista para empleados activos con información de usuario
CREATE VIEW vista_empleados_activos AS
SELECT 
    e.id_empleado,
    e.nombre,
    e.apellido,
    e.email,
    e.telefono,
    e.fecha_nacimiento,
    e.direccion,
    e.fecha_contratacion,
    e.cargo,
    e.salario,
    e.activo,
    e.fecha_creacion,
    e.fecha_actualizacion,
    u.username,
    u.rol as rol_usuario,
    CONCAT(e.nombre, ' ', e.apellido) as nombre_completo,
    YEAR(CURDATE()) - YEAR(e.fecha_contratacion) as anios_experiencia
FROM empleados e
LEFT JOIN usuarios u ON e.id_usuario = u.id_usuario
WHERE e.activo = TRUE
ORDER BY e.nombre, e.apellido;

-- Crear procedimiento almacenado para obtener estadísticas
DELIMITER //
CREATE PROCEDURE ObtenerEstadisticasSalon()
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) as total_empleados,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'ESTILISTA' AND activo = TRUE) as total_estilistas,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'COLORISTA' AND activo = TRUE) as total_coloristas,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'MANICURISTA' AND activo = TRUE) as total_manicuristas,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'ESTETICISTA' AND activo = TRUE) as total_esteticistas,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'RECEPCIONISTA' AND activo = TRUE) as total_recepcionistas,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'SUPERVISOR' AND activo = TRUE) as total_supervisores,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'GERENTE' AND activo = TRUE) as total_gerentes,
        (SELECT COUNT(*) FROM empleados WHERE cargo = 'ASISTENTE' AND activo = TRUE) as total_asistentes,
        (SELECT AVG(salario) FROM empleados WHERE activo = TRUE AND salario IS NOT NULL) as salario_promedio,
        (SELECT MAX(salario) FROM empleados WHERE activo = TRUE AND salario IS NOT NULL) as salario_maximo,
        (SELECT MIN(salario) FROM empleados WHERE activo = TRUE AND salario IS NOT NULL) as salario_minimo;
END //
DELIMITER ;

-- Crear trigger para actualizar fecha_actualizacion en empleados
DELIMITER //
CREATE TRIGGER tr_empleados_actualizacion 
BEFORE UPDATE ON empleados
FOR EACH ROW
BEGIN
    SET NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
END //
DELIMITER ;

-- Crear trigger para actualizar ultimo_acceso en usuarios
DELIMITER //
CREATE TRIGGER tr_usuarios_ultimo_acceso 
BEFORE UPDATE ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.ultimo_acceso IS NULL THEN
        SET NEW.ultimo_acceso = CURRENT_TIMESTAMP;
    END IF;
END //
DELIMITER ;

-- Mostrar información de la base de datos creada
SELECT 'Base de datos salon_belleza creada exitosamente' as mensaje;
SELECT 'Usuario administrador creado: admin / admin123' as credenciales;
SELECT 'Empleados de ejemplo insertados: 6 registros' as empleados_ejemplo;

-- Mostrar estructura de las tablas
SHOW TABLES;
DESCRIBE usuarios;
DESCRIBE empleados;
