# Configuración de Variables de Entorno

Este proyecto requiere variables de entorno para las credenciales de la base de datos.

## Configuración

### Opción 1: Variables de Entorno del Sistema

Configure las siguientes variables de entorno en su sistema:

- `DB_URL`: URL de conexión a la base de datos
- `DB_USER`: Usuario de la base de datos
- `DB_PASSWORD`: Contraseña de la base de datos

#### Windows (PowerShell):
```powershell
$env:DB_URL="jdbc:mysql://mysql-260164cb-chatgptnuevo-2b0b.b.aivencloud.com:16379/salon_belleza?ssl-mode=REQUIRED&serverTimezone=UTC"
$env:DB_USER="avnadmin"
$env:DB_PASSWORD="su_contraseña_aqui"
```

#### Windows (CMD):
```cmd
set DB_URL=jdbc:mysql://mysql-260164cb-chatgptnuevo-2b0b.b.aivencloud.com:16379/salon_belleza?ssl-mode=REQUIRED&serverTimezone=UTC
set DB_USER=avnadmin
set DB_PASSWORD=su_contraseña_aqui
```

#### Linux/Mac:
```bash
export DB_URL="jdbc:mysql://mysql-260164cb-chatgptnuevo-2b0b.b.aivencloud.com:16379/salon_belleza?ssl-mode=REQUIRED&serverTimezone=UTC"
export DB_USER="avnadmin"
export DB_PASSWORD="su_contraseña_aqui"
```

### Opción 2: Propiedades del Sistema Java

También puede pasar las propiedades como argumentos al iniciar la aplicación:

```bash
java -DDB_URL="..." -DDB_USER="..." -DDB_PASSWORD="..." -jar aplicacion.jar
```

### Opción 3: Configuración en el Servidor de Aplicaciones

Para aplicaciones web desplegadas en Tomcat, puede configurar las variables de entorno en:

- `setenv.sh` (Linux/Mac) o `setenv.bat` (Windows)
- Variables de entorno del sistema operativo
- Archivo de contexto de la aplicación

## Seguridad

⚠️ **IMPORTANTE**: Nunca incluya credenciales reales en el código fuente o en archivos que se suban al control de versiones.

- Las credenciales se cargan desde variables de entorno en tiempo de ejecución
- El archivo `.env.example` es solo un template - no contiene credenciales reales
- Asegúrese de que `.env` esté en `.gitignore` si decide usarlo

## Desarrollo Local

Para desarrollo local, puede usar la configuración local en `persistence-local.xml` que no requiere variables de entorno (usa configuración de base de datos local).

