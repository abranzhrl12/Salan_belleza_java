package com.salonbelleza.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

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
        try {
            entityManagerFactory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
            System.out.println("EntityManagerFactory inicializado correctamente");
        } catch (Exception e) {
            System.out.println("Error al inicializar EntityManagerFactory: " + e.getMessage());
            throw new RuntimeException("Error al inicializar JPA", e);
        }
    }
    
    /**
     * Obtiene una instancia del EntityManager
     * @return EntityManager
     */
    public static EntityManager getEntityManager() {
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