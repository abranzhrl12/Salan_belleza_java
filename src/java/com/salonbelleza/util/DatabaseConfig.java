package com.salonbelleza.util;

/**
 * Clase utilitaria para leer configuración de base de datos desde variables de entorno
 * @author Sistema Salon Belleza
 */
public class DatabaseConfig {
    
    // Nombres de las variables de entorno
    private static final String ENV_DB_URL = "DB_URL";
    private static final String ENV_DB_USER = "DB_USER";
    private static final String ENV_DB_PASSWORD = "DB_PASSWORD";
    
    // Valores por defecto (solo para desarrollo local)
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/salon_belleza?serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";
    
    /**
     * Obtiene la URL de conexión a la base de datos desde variables de entorno
     * @return URL de la base de datos
     */
    public static String getUrl() {
        String url = System.getenv(ENV_DB_URL);
        if (url == null || url.trim().isEmpty()) {
            url = System.getProperty(ENV_DB_URL);
        }
        if (url == null || url.trim().isEmpty()) {
            url = DEFAULT_URL;
            System.out.println("DatabaseConfig: Usando URL por defecto (desarrollo local)");
        }
        return url;
    }
    
    /**
     * Obtiene el usuario de la base de datos desde variables de entorno
     * @return Usuario de la base de datos
     */
    public static String getUser() {
        String user = System.getenv(ENV_DB_USER);
        if (user == null || user.trim().isEmpty()) {
            user = System.getProperty(ENV_DB_USER);
        }
        if (user == null || user.trim().isEmpty()) {
            user = DEFAULT_USER;
            System.out.println("DatabaseConfig: Usando usuario por defecto (desarrollo local)");
        }
        return user;
    }
    
    /**
     * Obtiene la contraseña de la base de datos desde variables de entorno
     * @return Contraseña de la base de datos
     */
    public static String getPassword() {
        String password = System.getenv(ENV_DB_PASSWORD);
        if (password == null || password.trim().isEmpty()) {
            password = System.getProperty(ENV_DB_PASSWORD);
        }
        if (password == null || password.trim().isEmpty()) {
            password = DEFAULT_PASSWORD;
            System.out.println("DatabaseConfig: Usando contraseña por defecto (desarrollo local)");
        }
        return password;
    }
}

