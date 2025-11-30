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

-- ============================================
-- TABLAS ADICIONALES PARA SISTEMA COMPLETO
-- ============================================

-- Tabla de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NULL,
    direccion VARCHAR(200) NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    notas TEXT NULL,
    INDEX idx_email (email),
    INDEX idx_telefono (telefono),
    INDEX idx_activo (activo),
    INDEX idx_fecha_registro (fecha_registro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Servicios
CREATE TABLE IF NOT EXISTS servicios (
    id_servicio BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    precio DECIMAL(10,2) NOT NULL,
    duracion_minutos INT NOT NULL DEFAULT 60,
    categoria ENUM('CORTE', 'COLORACION', 'MANICURE', 'PEDICURE', 'TRATAMIENTO_FACIAL', 'MASAJE', 'MAQUILLAJE', 'OTROS') NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_categoria (categoria),
    INDEX idx_activo (activo),
    INDEX idx_precio (precio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Citas
CREATE TABLE IF NOT EXISTS citas (
    id_cita BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    id_empleado BIGINT NOT NULL,
    id_servicio BIGINT NOT NULL,
    fecha_cita DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado ENUM('PROGRAMADA', 'CONFIRMADA', 'EN_PROGRESO', 'COMPLETADA', 'CANCELADA', 'NO_ASISTIO') NOT NULL DEFAULT 'PROGRAMADA',
    notas TEXT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio) ON DELETE CASCADE,
    INDEX idx_fecha_cita (fecha_cita),
    INDEX idx_estado (estado),
    INDEX idx_empleado_fecha (id_empleado, fecha_cita),
    INDEX idx_cliente_fecha (id_cliente, fecha_cita)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Ventas
CREATE TABLE IF NOT EXISTS ventas (
    id_venta BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NULL,
    id_empleado BIGINT NOT NULL,
    id_cita BIGINT NULL,
    fecha_venta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    impuestos DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('EFECTIVO', 'TARJETA', 'TRANSFERENCIA', 'CHEQUE') NOT NULL,
    estado ENUM('PENDIENTE', 'COMPLETADA', 'CANCELADA', 'REEMBOLSADA') NOT NULL DEFAULT 'COMPLETADA',
    notas TEXT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE SET NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE CASCADE,
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita) ON DELETE SET NULL,
    INDEX idx_fecha_venta (fecha_venta),
    INDEX idx_estado (estado),
    INDEX idx_metodo_pago (metodo_pago),
    INDEX idx_empleado_fecha (id_empleado, fecha_venta)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Detalle de Ventas
CREATE TABLE IF NOT EXISTS detalle_ventas (
    id_detalle BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_venta BIGINT NOT NULL,
    id_servicio BIGINT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio) ON DELETE CASCADE,
    INDEX idx_venta (id_venta),
    INDEX idx_servicio (id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Inventario/Productos
CREATE TABLE IF NOT EXISTS productos (
    id_producto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion TEXT NULL,
    categoria ENUM('SHAMPOO', 'ACONDICIONADOR', 'TINTE', 'TRATAMIENTO', 'HERRAMIENTAS', 'COSMETICOS', 'OTROS') NOT NULL,
    marca VARCHAR(50) NULL,
    codigo_barras VARCHAR(50) NULL UNIQUE,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 5,
    proveedor VARCHAR(100) NULL,
    fecha_vencimiento DATE NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NULL,
    INDEX idx_categoria (categoria),
    INDEX idx_activo (activo),
    INDEX idx_stock (stock_actual),
    INDEX idx_codigo_barras (codigo_barras)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Movimientos de Inventario
CREATE TABLE IF NOT EXISTS movimientos_inventario (
    id_movimiento BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto BIGINT NOT NULL,
    tipo_movimiento ENUM('ENTRADA', 'SALIDA', 'AJUSTE') NOT NULL,
    cantidad INT NOT NULL,
    motivo VARCHAR(200) NOT NULL,
    fecha_movimiento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_empleado BIGINT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE SET NULL,
    INDEX idx_producto (id_producto),
    INDEX idx_fecha (fecha_movimiento),
    INDEX idx_tipo (tipo_movimiento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de Horarios de Empleados
CREATE TABLE IF NOT EXISTS horarios_empleados (
    id_horario BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_empleado BIGINT NOT NULL,
    dia_semana ENUM('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO', 'DOMINGO') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE CASCADE,
    INDEX idx_empleado_dia (id_empleado, dia_semana),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- DATOS DE EJEMPLO
-- ============================================

-- Insertar clientes de ejemplo
INSERT INTO clientes (nombre, apellido, email, telefono, fecha_nacimiento, direccion) VALUES
('María', 'González', 'maria@email.com', '555-1001', '1985-03-15', 'Calle Principal 123'),
('Carlos', 'Rodríguez', 'carlos@email.com', '555-1002', '1990-07-22', 'Avenida Central 456'),
('Laura', 'Sánchez', 'laura@email.com', '555-1003', '1988-11-08', 'Plaza Mayor 789'),
('Pedro', 'Torres', 'pedro@email.com', '555-1004', '1992-05-30', 'Calle Secundaria 321');

-- Insertar servicios de ejemplo
INSERT INTO servicios (nombre_servicio, descripcion, precio, duracion_minutos, categoria) VALUES
('Corte y Peinado', 'Corte de cabello y peinado profesional', 25.00, 60, 'CORTE'),
('Coloración Completa', 'Tinte de cabello con productos premium', 45.00, 120, 'COLORACION'),
('Manicure Básica', 'Manicure con esmaltado', 15.00, 45, 'MANICURE'),
('Tratamiento Facial', 'Limpieza facial profunda', 35.00, 90, 'TRATAMIENTO_FACIAL'),
('Pedicure Spa', 'Pedicure con tratamiento de spa', 25.00, 75, 'PEDICURE'),
('Masaje Relajante', 'Masaje corporal relajante', 40.00, 60, 'MASAJE');

-- Insertar citas de ejemplo
INSERT INTO citas (id_cliente, id_empleado, id_servicio, fecha_cita, hora_inicio, hora_fin, estado) VALUES
(1, 1, 1, '2024-10-16', '10:00:00', '11:00:00', 'CONFIRMADA'),
(2, 2, 2, '2024-10-16', '14:00:00', '16:00:00', 'PENDIENTE'),
(3, 3, 3, '2024-10-17', '11:00:00', '11:45:00', 'PROGRAMADA'),
(4, 4, 4, '2024-10-17', '15:00:00', '16:30:00', 'CONFIRMADA');

-- Insertar productos de ejemplo
INSERT INTO productos (nombre_producto, descripcion, categoria, marca, precio_compra, precio_venta, stock_actual, stock_minimo) VALUES
('Shampoo Profesional', 'Shampoo para todo tipo de cabello', 'SHAMPOO', 'L\'Oréal', 8.50, 15.00, 20, 5),
('Tinte Rubio Claro', 'Tinte permanente rubio claro', 'TINTE', 'Wella', 12.00, 25.00, 15, 3),
('Esmalte Rojo', 'Esmalte de uñas color rojo', 'COSMETICOS', 'OPI', 3.50, 8.00, 50, 10),
('Crema Hidratante', 'Crema hidratante facial', 'TRATAMIENTO', 'Nivea', 5.00, 12.00, 25, 5);

-- Insertar horarios de empleados
INSERT INTO horarios_empleados (id_empleado, dia_semana, hora_inicio, hora_fin) VALUES
(1, 'LUNES', '09:00:00', '18:00:00'),
(1, 'MARTES', '09:00:00', '18:00:00'),
(1, 'MIERCOLES', '09:00:00', '18:00:00'),
(1, 'JUEVES', '09:00:00', '18:00:00'),
(1, 'VIERNES', '09:00:00', '18:00:00'),
(2, 'LUNES', '10:00:00', '19:00:00'),
(2, 'MARTES', '10:00:00', '19:00:00'),
(2, 'MIERCOLES', '10:00:00', '19:00:00'),
(2, 'JUEVES', '10:00:00', '19:00:00'),
(2, 'VIERNES', '10:00:00', '19:00:00');

-- ============================================
-- VISTAS Y PROCEDIMIENTOS ADICIONALES
-- ============================================

-- Vista para estadísticas del dashboard
CREATE VIEW vista_estadisticas_dashboard AS
SELECT 
    (SELECT COUNT(*) FROM empleados WHERE activo = TRUE) as total_empleados,
    (SELECT COUNT(*) FROM citas WHERE fecha_cita = CURDATE() AND estado IN ('CONFIRMADA', 'EN_PROGRESO')) as citas_hoy,
    (SELECT COALESCE(SUM(total), 0) FROM ventas WHERE MONTH(fecha_venta) = MONTH(CURDATE()) AND YEAR(fecha_venta) = YEAR(CURDATE())) as ventas_mes,
    (SELECT COUNT(*) FROM clientes WHERE MONTH(fecha_registro) = MONTH(CURDATE()) AND YEAR(fecha_registro) = YEAR(CURDATE())) as clientes_nuevos_mes;

-- Vista para citas recientes
CREATE VIEW vista_citas_recientes AS
SELECT 
    c.id_cita,
    cl.nombre as cliente_nombre,
    cl.apellido as cliente_apellido,
    cl.email as cliente_email,
    s.nombre_servicio,
    CONCAT(e.nombre, ' ', e.apellido) as empleado_nombre,
    c.fecha_cita,
    c.hora_inicio,
    c.estado
FROM citas c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
JOIN servicios s ON c.id_servicio = s.id_servicio
JOIN empleados e ON c.id_empleado = e.id_empleado
WHERE c.fecha_cita >= CURDATE()
ORDER BY c.fecha_cita, c.hora_inicio
LIMIT 10;

-- Mostrar información de la base de datos creada
SELECT 'Base de datos salon_belleza creada exitosamente' as mensaje;
SELECT 'Usuario administrador creado: admin / admin123' as credenciales;
SELECT 'Empleados de ejemplo insertados: 6 registros' as empleados_ejemplo;
SELECT 'Clientes de ejemplo insertados: 4 registros' as clientes_ejemplo;
SELECT 'Servicios de ejemplo insertados: 6 registros' as servicios_ejemplo;
SELECT 'Citas de ejemplo insertadas: 4 registros' as citas_ejemplo;
SELECT 'Productos de ejemplo insertados: 4 registros' as productos_ejemplo;

-- Mostrar estructura de las tablas
SHOW TABLES;
DESCRIBE usuarios;
DESCRIBE empleados;
DESCRIBE clientes;
DESCRIBE servicios;
DESCRIBE citas;
DESCRIBE ventas;
DESCRIBE productos;
