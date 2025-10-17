package com.salonbelleza.dao;

import com.salonbelleza.model.CargoEmpleado;
import com.salonbelleza.model.Empleado;
import com.salonbelleza.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

/**
 * DAO para la gestión de empleados
 * Implementa operaciones CRUD y consultas específicas
 * @author Sistema Salon Belleza
 */
public class EmpleadoDAO {
    
    /**
     * Guarda un nuevo empleado en la base de datos
     * @param empleado Empleado a guardar
     * @return Empleado guardado con ID asignado
     */
    public Empleado guardar(Empleado empleado) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            JPAUtil.beginTransaction();
            entityManager.persist(empleado);
            JPAUtil.commitTransaction();
            System.out.println("Empleado guardado exitosamente: " + empleado.getNombreCompleto());
            return empleado;
        } catch (Exception e) {
            JPAUtil.rollbackTransaction();
            System.out.println("Error al guardar empleado: " + empleado.getNombreCompleto() + " - " + e.getMessage());
            throw new RuntimeException("Error al guardar empleado", e);
        }
    }
    
    /**
     * Actualiza un empleado existente
     * @param empleado Empleado a actualizar
     * @return Empleado actualizado
     */
    public Empleado actualizar(Empleado empleado) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            JPAUtil.beginTransaction();
            empleado.actualizarFechaModificacion();
            Empleado empleadoActualizado = entityManager.merge(empleado);
            JPAUtil.commitTransaction();
            System.out.println("Empleado actualizado exitosamente: " + empleado.getNombreCompleto());
            return empleadoActualizado;
        } catch (Exception e) {
            JPAUtil.rollbackTransaction();
            System.out.println("Error al actualizar empleado: " + empleado.getNombreCompleto() + " - " + e.getMessage());
            throw new RuntimeException("Error al actualizar empleado", e);
        }
    }
    
    /**
     * Elimina un empleado por ID (eliminación lógica)
     * @param id ID del empleado a eliminar
     */
    public void eliminar(Long id) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            JPAUtil.beginTransaction();
            Empleado empleado = entityManager.find(Empleado.class, id);
            if (empleado != null) {
                empleado.setActivo(false);
                empleado.actualizarFechaModificacion();
                entityManager.merge(empleado);
                JPAUtil.commitTransaction();
                System.out.println("Empleado desactivado exitosamente: " + empleado.getNombreCompleto());
            } else {
                System.out.println("Empleado no encontrado para eliminar: " + id);
            }
        } catch (Exception e) {
            JPAUtil.rollbackTransaction();
            System.out.println("Error al eliminar empleado con ID: " + id + " - " + e.getMessage());
            throw new RuntimeException("Error al eliminar empleado", e);
        }
    }
    
    /**
     * Elimina físicamente un empleado por ID
     * @param id ID del empleado a eliminar
     */
    public void eliminarFisicamente(Long id) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            JPAUtil.beginTransaction();
            Empleado empleado = entityManager.find(Empleado.class, id);
            if (empleado != null) {
                entityManager.remove(empleado);
                JPAUtil.commitTransaction();
                System.out.println("Empleado eliminado físicamente: " + empleado.getNombreCompleto());
            } else {
                System.out.println("Empleado no encontrado para eliminar: " + id);
            }
        } catch (Exception e) {
            JPAUtil.rollbackTransaction();
            System.out.println("Error al eliminar empleado con ID: " + id + " - " + e.getMessage());
            throw new RuntimeException("Error al eliminar empleado", e);
        }
    }
    
    /**
     * Busca un empleado por ID
     * @param id ID del empleado
     * @return Optional con el empleado encontrado
     */
    public Optional<Empleado> buscarPorId(Long id) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            Empleado empleado = entityManager.find(Empleado.class, id);
            return Optional.ofNullable(empleado);
        } catch (Exception e) {
            System.out.println("Error al buscar empleado por ID: " + id + " - " + e.getMessage());
            throw new RuntimeException("Error al buscar empleado", e);
        }
    }
    
    /**
     * Busca un empleado por email
     * @param email Email del empleado
     * @return Optional con el empleado encontrado
     */
    public Optional<Empleado> buscarPorEmail(String email) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Empleado> query = entityManager.createQuery(
                "SELECT e FROM Empleado e WHERE e.email = :email", Empleado.class);
            query.setParameter("email", email);
            
            Empleado empleado = query.getSingleResult();
            return Optional.of(empleado);
        } catch (Exception e) {
            System.out.println("Empleado no encontrado con email: " + email);
            return Optional.empty();
        }
    }
    
    /**
     * Obtiene todos los empleados
     * @return Lista de todos los empleados
     */
    public List<Empleado> listarTodos() {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Empleado> query = entityManager.createQuery(
                "SELECT e FROM Empleado e ORDER BY e.nombre, e.apellido", Empleado.class);
            return query.getResultList();
        } catch (Exception e) {
            System.out.println("Error al listar empleados - " + e.getMessage());
            throw new RuntimeException("Error al listar empleados", e);
        }
    }
    
    /**
     * Obtiene empleados activos
     * @return Lista de empleados activos
     */
    public List<Empleado> listarActivos() {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Empleado> query = entityManager.createQuery(
                "SELECT e FROM Empleado e WHERE e.activo = true ORDER BY e.nombre, e.apellido", Empleado.class);
            return query.getResultList();
        } catch (Exception e) {
            System.out.println("Error al listar empleados activos - " + e.getMessage());
            throw new RuntimeException("Error al listar empleados activos", e);
        }
    }
    
    /**
     * Obtiene empleados por cargo
     * @param cargo Cargo a filtrar
     * @return Lista de empleados con el cargo especificado
     */
    public List<Empleado> listarPorCargo(CargoEmpleado cargo) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Empleado> query = entityManager.createQuery(
                "SELECT e FROM Empleado e WHERE e.cargo = :cargo AND e.activo = true ORDER BY e.nombre, e.apellido", 
                Empleado.class);
            query.setParameter("cargo", cargo);
            return query.getResultList();
        } catch (Exception e) {
            System.out.println("Error al listar empleados por cargo: " + cargo + " - " + e.getMessage());
            throw new RuntimeException("Error al listar empleados por cargo", e);
        }
    }
    
    /**
     * Busca empleados por nombre o apellido
     * @param terminoBusqueda Término de búsqueda
     * @return Lista de empleados que coinciden con la búsqueda
     */
    public List<Empleado> buscarPorNombre(String terminoBusqueda) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Empleado> query = entityManager.createQuery(
                "SELECT e FROM Empleado e WHERE (LOWER(e.nombre) LIKE LOWER(:termino) OR LOWER(e.apellido) LIKE LOWER(:termino)) AND e.activo = true ORDER BY e.nombre, e.apellido", 
                Empleado.class);
            query.setParameter("termino", "%" + terminoBusqueda + "%");
            return query.getResultList();
        } catch (Exception e) {
            System.out.println("Error al buscar empleados por nombre: " + terminoBusqueda + " - " + e.getMessage());
            throw new RuntimeException("Error al buscar empleados", e);
        }
    }
    
    /**
     * Verifica si existe un empleado con el email dado
     * @param email Email del empleado
     * @return true si existe, false en caso contrario
     */
    public boolean existeEmail(String email) {
        return buscarPorEmail(email).isPresent();
    }
    
    /**
     * Obtiene el conteo total de empleados activos
     * @return Número de empleados activos
     */
    public long contarActivos() {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Long> query = entityManager.createQuery(
                "SELECT COUNT(e) FROM Empleado e WHERE e.activo = true", Long.class);
            return query.getSingleResult();
        } catch (Exception e) {
            System.out.println("Error al contar empleados activos - " + e.getMessage());
            throw new RuntimeException("Error al contar empleados", e);
        }
    }
    
    /**
     * Obtiene el conteo de empleados por cargo
     * @param cargo Cargo a contar
     * @return Número de empleados con el cargo especificado
     */
    public long contarPorCargo(CargoEmpleado cargo) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Long> query = entityManager.createQuery(
                "SELECT COUNT(e) FROM Empleado e WHERE e.cargo = :cargo AND e.activo = true", Long.class);
            query.setParameter("cargo", cargo);
            return query.getSingleResult();
        } catch (Exception e) {
            System.out.println("Error al contar empleados por cargo: " + cargo + " - " + e.getMessage());
            throw new RuntimeException("Error al contar empleados por cargo", e);
        }
    }
}