package com.salonbelleza.dao;

import com.salonbelleza.model.RolUsuario;
import com.salonbelleza.model.Usuario;
import com.salonbelleza.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

/**
 * DAO para la gestión de usuarios
 * Implementa operaciones CRUD y consultas específicas
 * @author Sistema Salon Belleza
 */
public class UsuarioDAO {
    
    /**
     * Guarda un nuevo usuario en la base de datos
     * @param usuario Usuario a guardar
     * @return Usuario guardado con ID asignado
     */
    public Usuario guardar(Usuario usuario) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            JPAUtil.beginTransaction();
            entityManager.persist(usuario);
            JPAUtil.commitTransaction();
            System.out.println("Usuario guardado exitosamente: " + usuario.getUsername());
            return usuario;
        } catch (Exception e) {
            JPAUtil.rollbackTransaction();
            System.out.println("Error al guardar usuario: " + usuario.getUsername() + " - " + e.getMessage());
            throw new RuntimeException("Error al guardar usuario", e);
        }
    }
    
    /**
     * Actualiza un usuario existente
     * @param usuario Usuario a actualizar
     * @return Usuario actualizado
     */
    public Usuario actualizar(Usuario usuario) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            JPAUtil.beginTransaction();
            Usuario usuarioActualizado = entityManager.merge(usuario);
            JPAUtil.commitTransaction();
            System.out.println("Usuario actualizado exitosamente: " + usuario.getUsername());
            return usuarioActualizado;
        } catch (Exception e) {
            JPAUtil.rollbackTransaction();
            System.out.println("Error al actualizar usuario: " + usuario.getUsername() + " - " + e.getMessage());
            throw new RuntimeException("Error al actualizar usuario", e);
        }
    }
    
    /**
     * Elimina un usuario por ID
     * @param id ID del usuario a eliminar
     */
    public void eliminar(Long id) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            JPAUtil.beginTransaction();
            Usuario usuario = entityManager.find(Usuario.class, id);
            if (usuario != null) {
                entityManager.remove(usuario);
                JPAUtil.commitTransaction();
                System.out.println("Usuario eliminado exitosamente: " + usuario.getUsername());
            } else {
                System.out.println("Usuario no encontrado para eliminar: " + id);
            }
        } catch (Exception e) {
            JPAUtil.rollbackTransaction();
            System.out.println("Error al eliminar usuario con ID: " + id + " - " + e.getMessage());
            throw new RuntimeException("Error al eliminar usuario", e);
        }
    }
    
    /**
     * Busca un usuario por ID
     * @param id ID del usuario
     * @return Optional con el usuario encontrado
     */
    public Optional<Usuario> buscarPorId(Long id) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            Usuario usuario = entityManager.find(Usuario.class, id);
            return Optional.ofNullable(usuario);
        } catch (Exception e) {
            System.out.println("Error al buscar usuario por ID: " + id + " - " + e.getMessage());
            throw new RuntimeException("Error al buscar usuario", e);
        }
    }
    
    /**
     * Busca un usuario por nombre de usuario
     * @param username Nombre de usuario
     * @return Optional con el usuario encontrado
     */
    public Optional<Usuario> buscarPorUsername(String username) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Usuario> query = entityManager.createQuery(
                "SELECT u FROM Usuario u WHERE u.username = :username", Usuario.class);
            query.setParameter("username", username);
            
            Usuario usuario = query.getSingleResult();
            return Optional.of(usuario);
        } catch (NoResultException e) {
            System.out.println("Usuario no encontrado: " + username);
            return Optional.empty();
        } catch (Exception e) {
            System.out.println("Error al buscar usuario por username: " + username + " - " + e.getMessage());
            throw new RuntimeException("Error al buscar usuario", e);
        }
    }
    
    /**
     * Busca un usuario por email
     * @param email Email del usuario
     * @return Optional con el usuario encontrado
     */
    public Optional<Usuario> buscarPorEmail(String email) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Usuario> query = entityManager.createQuery(
                "SELECT u FROM Usuario u WHERE u.email = :email", Usuario.class);
            query.setParameter("email", email);
            
            Usuario usuario = query.getSingleResult();
            return Optional.of(usuario);
        } catch (NoResultException e) {
            System.out.println("Usuario no encontrado con email: " + email);
            return Optional.empty();
        } catch (Exception e) {
            System.out.println("Error al buscar usuario por email: " + email + " - " + e.getMessage());
            throw new RuntimeException("Error al buscar usuario", e);
        }
    }
    
    /**
     * Obtiene todos los usuarios
     * @return Lista de todos los usuarios
     */
    public List<Usuario> listarTodos() {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Usuario> query = entityManager.createQuery(
                "SELECT u FROM Usuario u ORDER BY u.fechaCreacion DESC", Usuario.class);
            return query.getResultList();
        } catch (Exception e) {
            System.out.println("Error al listar usuarios - " + e.getMessage());
            throw new RuntimeException("Error al listar usuarios", e);
        }
    }
    
    /**
     * Obtiene usuarios por rol
     * @param rol Rol a filtrar
     * @return Lista de usuarios con el rol especificado
     */
    public List<Usuario> listarPorRol(RolUsuario rol) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Usuario> query = entityManager.createQuery(
                "SELECT u FROM Usuario u WHERE u.rol = :rol ORDER BY u.nombreCompleto", Usuario.class);
            query.setParameter("rol", rol);
            return query.getResultList();
        } catch (Exception e) {
            System.out.println("Error al listar usuarios por rol: " + rol + " - " + e.getMessage());
            throw new RuntimeException("Error al listar usuarios por rol", e);
        }
    }
    
    /**
     * Obtiene usuarios activos
     * @return Lista de usuarios activos
     */
    public List<Usuario> listarActivos() {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Usuario> query = entityManager.createQuery(
                "SELECT u FROM Usuario u WHERE u.activo = true ORDER BY u.nombreCompleto", Usuario.class);
            return query.getResultList();
        } catch (Exception e) {
            System.out.println("Error al listar usuarios activos - " + e.getMessage());
            throw new RuntimeException("Error al listar usuarios activos", e);
        }
    }
    
    /**
     * Verifica si existe un usuario con el username dado
     * @param username Nombre de usuario
     * @return true si existe, false en caso contrario
     */
    public boolean existeUsername(String username) {
        return buscarPorUsername(username).isPresent();
    }
    
    /**
     * Verifica si existe un usuario con el email dado
     * @param email Email del usuario
     * @return true si existe, false en caso contrario
     */
    public boolean existeEmail(String email) {
        return buscarPorEmail(email).isPresent();
    }
    
    /**
     * Autentica un usuario por username y password
     * @param username Nombre de usuario
     * @param password Contraseña
     * @return Optional con el usuario autenticado
     */
    public Optional<Usuario> autenticar(String username, String password) {
        EntityManager entityManager = JPAUtil.getEntityManager();
        try {
            TypedQuery<Usuario> query = entityManager.createQuery(
                "SELECT u FROM Usuario u WHERE u.username = :username AND u.password = :password AND u.activo = true", 
                Usuario.class);
            query.setParameter("username", username);
            query.setParameter("password", password);
            
            Usuario usuario = query.getSingleResult();
            
            // Actualizar último acceso
            usuario.actualizarUltimoAcceso();
            actualizar(usuario);
            
            return Optional.of(usuario);
        } catch (NoResultException e) {
            System.out.println("Autenticación fallida para usuario: " + username);
            return Optional.empty();
        } catch (Exception e) {
            System.out.println("Error al autenticar usuario: " + username + " - " + e.getMessage());
            throw new RuntimeException("Error al autenticar usuario", e);
        }
    }
}