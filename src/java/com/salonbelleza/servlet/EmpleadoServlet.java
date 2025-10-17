package com.salonbelleza.servlet;

import com.salonbelleza.dao.EmpleadoDAO;
import com.salonbelleza.model.CargoEmpleado;
import com.salonbelleza.model.Empleado;
import com.salonbelleza.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

/**
 * Servlet para la gestión de empleados (CRUD)
 * @author Sistema Salon Belleza
 */
@WebServlet(name = "EmpleadoServlet", urlPatterns = "/admin/empleados")
public class EmpleadoServlet extends HttpServlet {
    
    private final EmpleadoDAO empleadoDAO = new EmpleadoDAO();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        try {
            switch (accion != null ? accion : "listar") {
                case "nuevo":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "editar":
                    mostrarFormularioEditar(request, response);
                    break;
                case "eliminar":
                    eliminarEmpleado(request, response);
                    break;
                case "buscar":
                    buscarEmpleados(request, response);
                    break;
                default:
                    listarEmpleados(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error en GET del EmpleadoServlet: " + e.getMessage());
            request.setAttribute("error", "Error interno del servidor");
            request.getRequestDispatcher("/admin/empleados/lista.jsp").forward(request, response);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        try {
            switch (accion) {
                case "guardar":
                    guardarEmpleado(request, response);
                    break;
                case "actualizar":
                    actualizarEmpleado(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/empleados");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error en POST del EmpleadoServlet: " + e.getMessage());
            request.setAttribute("error", "Error interno del servidor");
            request.getRequestDispatcher("/admin/empleados/lista.jsp").forward(request, response);
        } finally {
            JPAUtil.closeEntityManager();
        }
    }
    
    /**
     * Lista todos los empleados
     */
    private void listarEmpleados(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Empleado> empleados = empleadoDAO.listarActivos();
        request.setAttribute("empleados", empleados);
        request.setAttribute("totalEmpleados", empleados.size());
        
        request.getRequestDispatcher("/admin/empleados/lista.jsp").forward(request, response);
    }
    
    /**
     * Muestra el formulario para crear un nuevo empleado
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("cargos", CargoEmpleado.values());
        request.setAttribute("accion", "nuevo");
        request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
    }
    
    /**
     * Muestra el formulario para editar un empleado existente
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr);
            Optional<Empleado> empleadoOpt = empleadoDAO.buscarPorId(id);
            
            if (empleadoOpt.isPresent()) {
                request.setAttribute("empleado", empleadoOpt.get());
                request.setAttribute("cargos", CargoEmpleado.values());
                request.setAttribute("accion", "editar");
                request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=empleado-no-encontrado");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
        }
    }
    
    /**
     * Guarda un nuevo empleado
     */
    private void guardarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Empleado empleado = crearEmpleadoDesdeRequest(request);
            
            // Validar que el email no exista
            if (empleadoDAO.existeEmail(empleado.getEmail())) {
                request.setAttribute("error", "Ya existe un empleado con este email");
                request.setAttribute("cargos", CargoEmpleado.values());
                request.setAttribute("accion", "nuevo");
                request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                return;
            }
            
            empleadoDAO.guardar(empleado);
            
            System.out.println("Empleado creado exitosamente: " + empleado.getNombreCompleto());
            response.sendRedirect(request.getContextPath() + "/admin/empleados?mensaje=empleado-creado");
            
        } catch (Exception e) {
            System.out.println("Error al crear empleado: " + e.getMessage());
            request.setAttribute("error", "Error al crear empleado: " + e.getMessage());
            request.setAttribute("cargos", CargoEmpleado.values());
            request.setAttribute("accion", "nuevo");
            request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
        }
    }
    
    /**
     * Actualiza un empleado existente
     */
    private void actualizarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr);
            Optional<Empleado> empleadoOpt = empleadoDAO.buscarPorId(id);
            
            if (!empleadoOpt.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=empleado-no-encontrado");
                return;
            }
            
            Empleado empleado = empleadoOpt.get();
            actualizarEmpleadoDesdeRequest(empleado, request);
            
            // Validar que el email no exista en otro empleado
            Optional<Empleado> empleadoConEmail = empleadoDAO.buscarPorEmail(empleado.getEmail());
            if (empleadoConEmail.isPresent() && !empleadoConEmail.get().getId().equals(empleado.getId())) {
                request.setAttribute("error", "Ya existe otro empleado con este email");
                request.setAttribute("empleado", empleado);
                request.setAttribute("cargos", CargoEmpleado.values());
                request.setAttribute("accion", "editar");
                request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                return;
            }
            
            empleadoDAO.actualizar(empleado);
            
            System.out.println("Empleado actualizado exitosamente: " + empleado.getNombreCompleto());
            response.sendRedirect(request.getContextPath() + "/admin/empleados?mensaje=empleado-actualizado");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
        } catch (Exception e) {
            System.out.println("Error al actualizar empleado: " + e.getMessage());
            request.setAttribute("error", "Error al actualizar empleado: " + e.getMessage());
            request.setAttribute("cargos", CargoEmpleado.values());
            request.setAttribute("accion", "editar");
            request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
        }
    }
    
    /**
     * Elimina un empleado (eliminación lógica)
     */
    private void eliminarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr);
            Optional<Empleado> empleadoOpt = empleadoDAO.buscarPorId(id);
            
            if (empleadoOpt.isPresent()) {
                empleadoDAO.eliminar(id);
                System.out.println("Empleado eliminado exitosamente: " + empleadoOpt.get().getNombreCompleto());
                response.sendRedirect(request.getContextPath() + "/admin/empleados?mensaje=empleado-eliminado");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=empleado-no-encontrado");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
        }
    }
    
    /**
     * Busca empleados por nombre
     */
    private void buscarEmpleados(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String termino = request.getParameter("termino");
        
        if (termino == null || termino.trim().isEmpty()) {
            listarEmpleados(request, response);
            return;
        }
        
        List<Empleado> empleados = empleadoDAO.buscarPorNombre(termino.trim());
        request.setAttribute("empleados", empleados);
        request.setAttribute("terminoBusqueda", termino.trim());
        request.setAttribute("totalEmpleados", empleados.size());
        
        request.getRequestDispatcher("/admin/empleados/lista.jsp").forward(request, response);
    }
    
    /**
     * Crea un nuevo empleado desde los parámetros de la petición
     */
    private Empleado crearEmpleadoDesdeRequest(HttpServletRequest request) {
        Empleado empleado = new Empleado();
        
        empleado.setNombre(request.getParameter("nombre"));
        empleado.setApellido(request.getParameter("apellido"));
        empleado.setEmail(request.getParameter("email"));
        empleado.setTelefono(request.getParameter("telefono"));
        empleado.setDireccion(request.getParameter("direccion"));
        
        // Fecha de nacimiento
        String fechaNacimientoStr = request.getParameter("fechaNacimiento");
        if (fechaNacimientoStr != null && !fechaNacimientoStr.trim().isEmpty()) {
            try {
                empleado.setFechaNacimiento(LocalDate.parse(fechaNacimientoStr, DATE_FORMATTER));
            } catch (DateTimeParseException e) {
                System.out.println("Fecha de nacimiento inválida: " + fechaNacimientoStr);
            }
        }
        
        // Fecha de contratación
        String fechaContratacionStr = request.getParameter("fechaContratacion");
        if (fechaContratacionStr != null && !fechaContratacionStr.trim().isEmpty()) {
            try {
                empleado.setFechaContratacion(LocalDate.parse(fechaContratacionStr, DATE_FORMATTER));
            } catch (DateTimeParseException e) {
                System.out.println("Fecha de contratación inválida: " + fechaContratacionStr);
                empleado.setFechaContratacion(LocalDate.now());
            }
        } else {
            empleado.setFechaContratacion(LocalDate.now());
        }
        
        // Cargo
        String cargoStr = request.getParameter("cargo");
        if (cargoStr != null && !cargoStr.trim().isEmpty()) {
            try {
                empleado.setCargo(CargoEmpleado.valueOf(cargoStr));
            } catch (IllegalArgumentException e) {
                System.out.println("Cargo inválido: " + cargoStr);
                empleado.setCargo(CargoEmpleado.ASISTENTE);
            }
        } else {
            empleado.setCargo(CargoEmpleado.ASISTENTE);
        }
        
        // Salario
        String salarioStr = request.getParameter("salario");
        if (salarioStr != null && !salarioStr.trim().isEmpty()) {
            try {
                empleado.setSalario(new BigDecimal(salarioStr));
            } catch (NumberFormatException e) {
                System.out.println("Salario inválido: " + salarioStr);
            }
        }
        
        return empleado;
    }
    
    /**
     * Actualiza un empleado existente desde los parámetros de la petición
     */
    private void actualizarEmpleadoDesdeRequest(Empleado empleado, HttpServletRequest request) {
        empleado.setNombre(request.getParameter("nombre"));
        empleado.setApellido(request.getParameter("apellido"));
        empleado.setEmail(request.getParameter("email"));
        empleado.setTelefono(request.getParameter("telefono"));
        empleado.setDireccion(request.getParameter("direccion"));
        
        // Fecha de nacimiento
        String fechaNacimientoStr = request.getParameter("fechaNacimiento");
        if (fechaNacimientoStr != null && !fechaNacimientoStr.trim().isEmpty()) {
            try {
                empleado.setFechaNacimiento(LocalDate.parse(fechaNacimientoStr, DATE_FORMATTER));
            } catch (DateTimeParseException e) {
                System.out.println("Fecha de nacimiento inválida: " + fechaNacimientoStr);
            }
        }
        
        // Fecha de contratación
        String fechaContratacionStr = request.getParameter("fechaContratacion");
        if (fechaContratacionStr != null && !fechaContratacionStr.trim().isEmpty()) {
            try {
                empleado.setFechaContratacion(LocalDate.parse(fechaContratacionStr, DATE_FORMATTER));
            } catch (DateTimeParseException e) {
                System.out.println("Fecha de contratación inválida: " + fechaContratacionStr);
            }
        }
        
        // Cargo
        String cargoStr = request.getParameter("cargo");
        if (cargoStr != null && !cargoStr.trim().isEmpty()) {
            try {
                empleado.setCargo(CargoEmpleado.valueOf(cargoStr));
            } catch (IllegalArgumentException e) {
                System.out.println("Cargo inválido: " + cargoStr);
            }
        }
        
        // Salario
        String salarioStr = request.getParameter("salario");
        if (salarioStr != null && !salarioStr.trim().isEmpty()) {
            try {
                empleado.setSalario(new BigDecimal(salarioStr));
            } catch (NumberFormatException e) {
                System.out.println("Salario inválido: " + salarioStr);
            }
        }
    }
}