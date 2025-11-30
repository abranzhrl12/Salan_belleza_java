package com.salonbelleza.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.HashMap;
import java.util.Map;

/**
 * Clase utilitaria para manejar el EntityManager de JPA
 * Implementa el patrón Singleton para asegurar una única instancia
 * @author Sistema Salon Belleza
 */
public class JPAUtil {
    
    private static final String PERSISTENCE_UNIT_NAME = "salon-belleza-pu";
    
    private static EntityManagerFactory entityManagerFactory;
    private static final ThreadLocal<EntityManager> threadLocal = new ThreadLocal<>();
    
    static {
        // Inicialización diferida para evitar errores en el bloque estático
        System.out.println("JPAUtil: Inicialización diferida configurada");
    }
    
    /**
     * Obtiene las propiedades de conexión desde variables de entorno
     * @return Map con las propiedades de conexión
     */
    private static Map<String, String> getConnectionProperties() {
        Map<String, String> properties = new HashMap<>();
        
        // Obtener valores desde variables de entorno o propiedades del sistema
        String dbUrl = DatabaseConfig.getUrl();
        String dbUser = DatabaseConfig.getUser();
        String dbPassword = DatabaseConfig.getPassword();
        
        // Solo agregar propiedades si tienen valores (no vacíos)
        if (dbUrl != null && !dbUrl.trim().isEmpty()) {
            properties.put("jakarta.persistence.jdbc.url", dbUrl);
        }
        if (dbUser != null && !dbUser.trim().isEmpty()) {
            properties.put("jakarta.persistence.jdbc.user", dbUser);
        }
        if (dbPassword != null && !dbPassword.trim().isEmpty()) {
            properties.put("jakarta.persistence.jdbc.password", dbPassword);
        }
        
        return properties;
    }
    
    /**
     * Inicializa el EntityManagerFactory si no está inicializado
     */
    private static void initializeEntityManagerFactory() {
        if (entityManagerFactory == null) {
            synchronized (JPAUtil.class) {
                if (entityManagerFactory == null) {
                    try {
                        System.out.println("Intentando inicializar EntityManagerFactory...");
                        Map<String, String> properties = getConnectionProperties();
                        if (properties.isEmpty()) {
                            System.out.println("Advertencia: No se encontraron variables de entorno para la base de datos");
                        }
                        entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME, properties);
                        System.out.println("EntityManagerFactory inicializado correctamente");
                    } catch (Exception e) {
                        System.err.println("Error al inicializar EntityManagerFactory: " + e.getMessage());
                        e.printStackTrace();
                        
                        // Intentar con configuración local como fallback
                        try {
                            System.out.println("Intentando con configuración local...");
                            entityManagerFactory = Persistence.createEntityManagerFactory("salon-belleza-pu-local");
                            System.out.println("EntityManagerFactory inicializado con configuración local");
                        } catch (Exception e2) {
                            System.err.println("Error al inicializar con configuración local: " + e2.getMessage());
                            e2.printStackTrace();
                            throw new RuntimeException("Error al inicializar JPA", e);
                        }
                    }
                }
            }
        }
    }
    
    /**
     * Obtiene una instancia del EntityManager
     * @return EntityManager
     */
    public static EntityManager getEntityManager() {
        // Inicializar el EntityManagerFactory si no está inicializado
        initializeEntityManagerFactory();
        
        EntityManager entityManager = threadLocal.get();
        
        if (entityManager == null || !entityManager.isOpen()) {
            entityManager = entityManagerFactory.createEntityManager();
            threadLocal.set(entityManager);
            System.out.println("Nuevo EntityManager creado para el hilo actual");
        }
        
        return entityManager;
    }
    
    /**
     * Cierra el EntityManager del hilo actual
     */
    public static void closeEntityManager() {
        EntityManager entityManager = threadLocal.get();
        
        if (entityManager != null && entityManager.isOpen()) {
            entityManager.close();
            threadLocal.remove();
            System.out.println("EntityManager cerrado para el hilo actual");
        }
    }
    
    /**
     * Inicia una transacción
     */
    public static void beginTransaction() {
        EntityManager entityManager = getEntityManager();
        if (!entityManager.getTransaction().isActive()) {
            entityManager.getTransaction().begin();
            System.out.println("Transacción iniciada");
        }
    }
    
    /**
     * Confirma la transacción actual
     */
    public static void commitTransaction() {
        EntityManager entityManager = getEntityManager();
        if (entityManager.getTransaction().isActive()) {
            entityManager.getTransaction().commit();
            System.out.println("Transacción confirmada");
        }
    }
    
    /**
     * Revierte la transacción actual
     */
    public static void rollbackTransaction() {
        EntityManager entityManager = getEntityManager();
        if (entityManager.getTransaction().isActive()) {
            entityManager.getTransaction().rollback();
            System.out.println("Transacción revertida");
        }
    }
    
    /**
     * Cierra el EntityManagerFactory
     * Debe ser llamado al finalizar la aplicación
     */
    public static void closeEntityManagerFactory() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
            System.out.println("EntityManagerFactory cerrado");
        }
    }
    
    /**
     * Verifica si el EntityManagerFactory está abierto
     * @return true si está abierto, false en caso contrario
     */
    public static boolean isEntityManagerFactoryOpen() {
        return entityManagerFactory != null && entityManagerFactory.isOpen();
    }
}