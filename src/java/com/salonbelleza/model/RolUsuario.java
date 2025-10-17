package com.salonbelleza.model;

/**
 * Enum que define los roles de usuario en el sistema
 * @author Sistema Salon Belleza
 */
public enum RolUsuario {
    ADMIN("Administrador", "Acceso completo al sistema"),
    RECEPCIONISTA("Recepcionista", "Gestión de citas y clientes"),
    ESTILISTA("Estilista", "Gestión de servicios y citas asignadas"),
    GERENTE("Gerente", "Gestión de empleados y reportes");
    
    private final String descripcion;
    private final String permisos;
    
    RolUsuario(String descripcion, String permisos) {
        this.descripcion = descripcion;
        this.permisos = permisos;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public String getPermisos() {
        return permisos;
    }
    
    @Override
    public String toString() {
        return descripcion;
    }
}
