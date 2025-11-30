package com.salonbelleza.servlet;

import com.salonbelleza.dao.EmpleadoDAO;
import com.salonbelleza.model.CargoEmpleado;
import com.salonbelleza.model.Empleado;
import com.salonbelleza.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Servlet para manejar las operaciones CRUD de empleados
 * Sigue el patrón MVC - Controlador
 * @author Sistema Salon Belleza
 */
public class EmpleadoServlet extends HttpServlet {
    
    private final EmpleadoDAO empleadoDAO = new EmpleadoDAO();
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        try {
            switch (accion != null ? accion : "listar") {
                case "listar":
                    listarEmpleados(request, response);
                    break;
                case "nuevo":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "editar":
                    mostrarFormularioEditar(request, response);
                    break;
                case "ver":
                    verEmpleado(request, response);
                    break;
                case "eliminar":
                    eliminarEmpleado(request, response);
                    break;
                default:
                    listarEmpleados(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error en GET EmpleadoServlet: " + e.getMessage());
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
            switch (accion != null ? accion : "crear") {
                case "crear":
                    crearEmpleado(request, response);
                    break;
                case "actualizar":
                    actualizarEmpleado(request, response);
                    break;
                default:
                    listarEmpleados(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error en POST EmpleadoServlet: " + e.getMessage());
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
        
        try {
            List<Empleado> empleados = empleadoDAO.listarTodos();
            request.setAttribute("empleados", empleados);
            request.getRequestDispatcher("/admin/empleados/lista.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error al listar empleados: " + e.getMessage());
            request.setAttribute("error", "Error al cargar la lista de empleados");
            request.getRequestDispatcher("/admin/empleados/lista.jsp").forward(request, response);
        }
    }
    
    /**
     * Muestra el formulario para crear un nuevo empleado
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("cargos", CargoEmpleado.values());
        request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
    }
    
    /**
     * Muestra el formulario para editar un empleado existente
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-requerido");
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr);
            Empleado empleado = empleadoDAO.buscarPorId(id).orElse(null);
            
            if (empleado == null) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=empleado-no-encontrado");
                return;
            }
            
            request.setAttribute("empleado", empleado);
            request.setAttribute("cargos", CargoEmpleado.values());
            request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
        }
    }
    
    /**
     * Muestra los detalles de un empleado
     */
    private void verEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-requerido");
            return;
        }
        
        try {
            Long id = Long.parseLong(idStr);
            Empleado empleado = empleadoDAO.buscarPorId(id).orElse(null);
            
            if (empleado == null) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=empleado-no-encontrado");
                return;
            }
            
            request.setAttribute("empleado", empleado);
            request.getRequestDispatcher("/admin/empleados/detalle.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
        }
    }
    
    /**
     * Crea un nuevo empleado
     */
    private void crearEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obtener parámetros del formulario
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");
            String cargoStr = request.getParameter("cargo");
            String salarioStr = request.getParameter("salario");
            String direccion = request.getParameter("direccion");
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");
            
            // Validaciones básicas
            if (nombre == null || nombre.trim().isEmpty() ||
                apellido == null || apellido.trim().isEmpty() ||
                telefono == null || telefono.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                cargoStr == null || cargoStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Todos los campos obligatorios deben ser completados");
                request.setAttribute("cargos", CargoEmpleado.values());
                request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                return;
            }
            
            // Crear empleado
            Empleado empleado = new Empleado();
            empleado.setNombre(nombre.trim());
            empleado.setApellido(apellido.trim());
            empleado.setTelefono(telefono.trim());
            empleado.setEmail(email.trim());
            empleado.setCargo(CargoEmpleado.valueOf(cargoStr));
            empleado.setDireccion(direccion != null ? direccion.trim() : null);
            empleado.setActivo(true);
            
            // Procesar salario
            if (salarioStr != null && !salarioStr.trim().isEmpty()) {
                try {
                    empleado.setSalario(new BigDecimal(salarioStr));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "El salario debe ser un número válido");
                    request.setAttribute("cargos", CargoEmpleado.values());
                    request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Procesar fecha de nacimiento
            if (fechaNacimientoStr != null && !fechaNacimientoStr.trim().isEmpty()) {
                try {
                    empleado.setFechaNacimiento(LocalDate.parse(fechaNacimientoStr, DATE_FORMATTER));
                } catch (Exception e) {
                    request.setAttribute("error", "La fecha de nacimiento debe tener el formato correcto");
                    request.setAttribute("cargos", CargoEmpleado.values());
                    request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Verificar si el email ya existe
            if (empleadoDAO.existeEmail(email)) {
                request.setAttribute("error", "Ya existe un empleado con este email");
                request.setAttribute("cargos", CargoEmpleado.values());
                request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                return;
            }
            
            // Guardar empleado
            empleadoDAO.guardar(empleado);
            
            response.sendRedirect(request.getContextPath() + "/admin/empleados?mensaje=empleado-creado");
            
        } catch (Exception e) {
            System.out.println("Error al crear empleado: " + e.getMessage());
            request.setAttribute("error", "Error al crear el empleado: " + e.getMessage());
            request.setAttribute("cargos", CargoEmpleado.values());
            request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
        }
    }
    
    /**
     * Actualiza un empleado existente
     */
    private void actualizarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-requerido");
                return;
            }
            
            Long id = Long.parseLong(idStr);
            Empleado empleado = empleadoDAO.buscarPorId(id).orElse(null);
            
            if (empleado == null) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=empleado-no-encontrado");
                return;
            }
            
            // Obtener parámetros del formulario
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");
            String cargoStr = request.getParameter("cargo");
            String salarioStr = request.getParameter("salario");
            String direccion = request.getParameter("direccion");
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");
            String activoStr = request.getParameter("activo");
            
            // Validaciones básicas
            if (nombre == null || nombre.trim().isEmpty() ||
                apellido == null || apellido.trim().isEmpty() ||
                telefono == null || telefono.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                cargoStr == null || cargoStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Todos los campos obligatorios deben ser completados");
                request.setAttribute("empleado", empleado);
                request.setAttribute("cargos", CargoEmpleado.values());
                request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                return;
            }
            
            // Actualizar datos
            empleado.setNombre(nombre.trim());
            empleado.setApellido(apellido.trim());
            empleado.setTelefono(telefono.trim());
            empleado.setEmail(email.trim());
            empleado.setCargo(CargoEmpleado.valueOf(cargoStr));
            empleado.setDireccion(direccion != null ? direccion.trim() : null);
            empleado.setActivo(activoStr != null && activoStr.equals("true"));
            
            // Procesar salario
            if (salarioStr != null && !salarioStr.trim().isEmpty()) {
                try {
                    empleado.setSalario(new BigDecimal(salarioStr));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "El salario debe ser un número válido");
                    request.setAttribute("empleado", empleado);
                    request.setAttribute("cargos", CargoEmpleado.values());
                    request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Procesar fecha de nacimiento
            if (fechaNacimientoStr != null && !fechaNacimientoStr.trim().isEmpty()) {
                try {
                    empleado.setFechaNacimiento(LocalDate.parse(fechaNacimientoStr, DATE_FORMATTER));
                } catch (Exception e) {
                    request.setAttribute("error", "La fecha de nacimiento debe tener el formato correcto");
                    request.setAttribute("empleado", empleado);
                    request.setAttribute("cargos", CargoEmpleado.values());
                    request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Verificar si el email ya existe (excluyendo el empleado actual)
            if (!empleado.getEmail().equals(email) && empleadoDAO.existeEmail(email)) {
                request.setAttribute("error", "Ya existe un empleado con este email");
                request.setAttribute("empleado", empleado);
                request.setAttribute("cargos", CargoEmpleado.values());
                request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
                return;
            }
            
            // Actualizar empleado
            empleadoDAO.actualizar(empleado);
            
            response.sendRedirect(request.getContextPath() + "/admin/empleados?mensaje=empleado-actualizado");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
        } catch (Exception e) {
            System.out.println("Error al actualizar empleado: " + e.getMessage());
            request.setAttribute("error", "Error al actualizar el empleado: " + e.getMessage());
            request.setAttribute("cargos", CargoEmpleado.values());
            request.getRequestDispatcher("/admin/empleados/formulario.jsp").forward(request, response);
        }
    }
    
    /**
     * Elimina un empleado (eliminación lógica)
     */
    private void eliminarEmpleado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-requerido");
                return;
            }
            
            Long id = Long.parseLong(idStr);
            Empleado empleado = empleadoDAO.buscarPorId(id).orElse(null);
            
            if (empleado == null) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados?error=empleado-no-encontrado");
                return;
            }
            
            // Eliminar empleado (eliminación lógica)
            empleadoDAO.eliminar(id);
            
            response.sendRedirect(request.getContextPath() + "/admin/empleados?mensaje=empleado-eliminado");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=id-invalido");
        } catch (Exception e) {
            System.out.println("Error al eliminar empleado: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/empleados?error=error-eliminar");
        }
    }
}