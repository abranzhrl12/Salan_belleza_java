# Sistema de Gestión - Salon de Belleza

Sistema web desarrollado en Java para la gestión de un salón de belleza, implementando el patrón MVC con Servlets, JSP, JSTL y JPA.

## 🚀 Características

- **Arquitectura MVC**: Separación clara entre Modelo, Vista y Controlador
- **Tecnologías Java Web**: Servlets, JSP, JSTL
- **Persistencia**: JPA con Hibernate como proveedor
- **Base de Datos**: MySQL
- **Frontend**: Bootstrap 5 con diseño responsivo
- **Autenticación**: Sistema de login con filtros de seguridad
- **Gestión de Empleados**: CRUD completo con validaciones

## 🛠️ Tecnologías Utilizadas

- **Java 21**
- **Jakarta Servlet API 6.0**
- **Jakarta JSP API 3.1**
- **JSTL 3.0**
- **Jakarta Persistence API 3.1**
- **Hibernate 6.2**
- **MySQL 8.0**
- **Bootstrap 5.3**
- **Bootstrap Icons**
- **Maven**

## 📋 Requisitos del Sistema

- Java 21 o superior
- Apache Tomcat 10 o superior
- MySQL 8.0 o superior
- Maven 3.6 o superior
- IDE (NetBeans, IntelliJ IDEA, Eclipse)

## 🔧 Instalación y Configuración

### 1. Clonar el Proyecto

```bash
git clone [url-del-repositorio]
cd Proyecto_Salon_Belleza
```

### 2. Configurar la Base de Datos

1. Crear la base de datos MySQL:
```sql
CREATE DATABASE salon_belleza CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Ejecutar el script SQL:
```bash
mysql -u root -p salon_belleza < database/salon_belleza.sql
```

### 3. Configurar la Conexión a la Base de Datos

Editar el archivo `src/conf/META-INF/persistence.xml` y actualizar las credenciales:

```xml
<property name="jakarta.persistence.jdbc.user" value="tu_usuario"/>
<property name="jakarta.persistence.jdbc.password" value="tu_contraseña"/>
```

### 4. Compilar el Proyecto

```bash
mvn clean compile
```

### 5. Desplegar en Tomcat

1. Compilar el WAR:
```bash
mvn clean package
```

2. Copiar el archivo `target/salon-belleza.war` al directorio `webapps` de Tomcat

3. Iniciar Tomcat

## 🎯 Funcionalidades Implementadas

### Sistema de Autenticación
- Login seguro con validación de credenciales
- Filtros de autenticación para rutas protegidas
- Gestión de sesiones
- Logout seguro

### Gestión de Empleados
- **Listar empleados**: Vista paginada con filtros y búsqueda
- **Registrar empleado**: Formulario con validaciones completas
- **Editar empleado**: Modificación de datos existentes
- **Eliminar empleado**: Eliminación lógica (soft delete)
- **Búsqueda**: Por nombre, apellido o cargo

### Panel Administrativo
- Dashboard con estadísticas
- Navegación intuitiva
- Diseño responsivo
- Mensajes de confirmación y error

### Landing Page
- Página de inicio atractiva
- Información sobre servicios
- Diseño moderno con Bootstrap
- Enlaces al panel administrativo

## 🔐 Credenciales por Defecto

**Usuario Administrador:**
- Usuario: `admin`
- Contraseña: `admin123`
- Email: `admin@salonbelleza.com`

## 📁 Estructura del Proyecto

```
Proyecto_Salon_Belleza/
├── src/
│   ├── java/
│   │   └── com/salonbelleza/
│   │       ├── dao/                 # Data Access Objects
│   │       ├── filter/              # Filtros de seguridad
│   │       ├── model/               # Entidades JPA
│   │       ├── servlet/             # Controladores (Servlets)
│   │       └── util/                # Utilidades
│   └── conf/
│       └── META-INF/
│           └── persistence.xml      # Configuración JPA
├── web/
│   ├── admin/                       # Panel administrativo
│   │   ├── empleados/              # Gestión de empleados
│   │   └── dashboard.jsp           # Dashboard principal
│   ├── error/                      # Páginas de error
│   ├── login.jsp                   # Página de login
│   ├── index.html                  # Landing page
│   └── WEB-INF/
│       └── web.xml                 # Configuración web
├── database/
│   └── salon_belleza.sql           # Script de base de datos
├── pom.xml                         # Configuración Maven
└── README.md                       # Este archivo
```

## 🎨 Características del Diseño

- **Bootstrap 5**: Framework CSS moderno y responsivo
- **Bootstrap Icons**: Iconografía consistente
- **Gradientes**: Diseño visual atractivo
- **Cards**: Componentes organizados
- **Modales**: Confirmaciones de acciones
- **Alertas**: Mensajes informativos
- **Tablas responsivas**: Datos organizados

## 🔒 Seguridad

- Filtros de autenticación
- Validación de entrada
- Sanitización de datos
- Gestión segura de sesiones
- Protección contra inyección SQL (JPA)

## 📊 Base de Datos

### Tablas Principales

1. **usuarios**: Gestión de usuarios del sistema
2. **empleados**: Información de empleados del salón

### Características de la BD

- Índices optimizados
- Triggers para auditoría
- Vistas para consultas complejas
- Procedimientos almacenados
- Constraints de integridad

## 🚀 Uso del Sistema

### Acceso al Sistema

1. Navegar a `http://localhost:8080/salon-belleza/`
2. Hacer clic en "Acceso Admin"
3. Ingresar credenciales: `admin` / `admin123`

### Gestión de Empleados

1. Desde el dashboard, hacer clic en "Empleados"
2. Usar los botones para:
   - **Nuevo Empleado**: Agregar empleado
   - **Editar**: Modificar datos existentes
   - **Eliminar**: Desactivar empleado
   - **Buscar**: Filtrar por nombre o cargo

## 🛠️ Desarrollo

### Agregar Nuevas Funcionalidades

1. **Modelo**: Crear entidades JPA en `model/`
2. **DAO**: Implementar acceso a datos en `dao/`
3. **Controlador**: Crear servlets en `servlet/`
4. **Vista**: Desarrollar JSPs con Bootstrap
5. **Configuración**: Actualizar `web.xml` si es necesario

### Buenas Prácticas Implementadas

- Separación de responsabilidades (MVC)
- Validación en múltiples capas
- Manejo de errores centralizado
- Logging con SLF4J
- Código limpio y documentado
- Nomenclatura consistente

## 📝 Notas de Desarrollo

- El proyecto está configurado para Java 21
- Usa Jakarta EE (no Java EE)
- Compatible con Tomcat 10+
- Base de datos MySQL 8.0+
- Diseño completamente responsivo

## 🤝 Contribuciones

Para contribuir al proyecto:

1. Fork el repositorio
2. Crear una rama para la funcionalidad
3. Implementar los cambios
4. Probar exhaustivamente
5. Crear un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Para soporte técnico o consultas:

- Email: soporte@salonbelleza.com
- Documentación: [Wiki del proyecto]
- Issues: [GitHub Issues]

---

**Desarrollado con ❤️ para la gestión eficiente de salones de belleza**
