package com.salonbelleza.model;

/**
 * Enum que define los cargos disponibles para los empleados del salón
 * @author Sistema Salon Belleza
 */
public enum CargoEmpleado {
    ESTILISTA("Estilista", "Realiza cortes, peinados y tratamientos capilares"),
    COLORISTA("Colorista", "Especialista en coloración y tratamientos químicos"),
    MANICURISTA("Manicurista", "Especialista en cuidado de uñas y manicure"),
    ESTETICISTA("Esteticista", "Especialista en tratamientos faciales y corporales"),
    RECEPCIONISTA("Recepcionista", "Atención al cliente y gestión de citas"),
    SUPERVISOR("Supervisor", "Supervisión del personal y operaciones"),
    GERENTE("Gerente", "Gestión general del salón"),
    ASISTENTE("Asistente", "Apoyo general en el salón");
    
    private final String descripcion;
    private final String responsabilidades;
    
    CargoEmpleado(String descripcion, String responsabilidades) {
        this.descripcion = descripcion;
        this.responsabilidades = responsabilidades;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public String getResponsabilidades() {
        return responsabilidades;
    }
    
    @Override
    public String toString() {
        return descripcion;
    }
}
