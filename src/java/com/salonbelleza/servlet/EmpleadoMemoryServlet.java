package com.salonbelleza.servlet;

import com.salonbelleza.model.Empleado;
import com.salonbelleza.model.CargoEmpleado;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Servlet para manejar empleados en memoria (sin base de datos)
 * @author Sistema Salon Belleza
 */
public class EmpleadoMemoryServlet extends HttpServlet {
    
    private static final String EMPLEADOS_SESSION_KEY = "empleados_memoria";
    private static final AtomicLong idGenerator = new AtomicLong(1);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        List<Empleado> empleados = getEmpleadosFromSession(session);
        
        String accion = request.getParameter("accion");
        
        if ("nuevo".equals(accion)) {
            // Mostrar formulario para nuevo empleado
            request.setAttribute("cargos", CargoEmpleado.values());
            request.getRequestDispatcher("/admin/empleados/memory-formulario.jsp").forward(request, response);
        } else if ("editar".equals(accion)) {
            // Mostrar formulario para editar empleado
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    Long id = Long.parseLong(idStr);
                    Empleado empleado = buscarEmpleadoPorId(empleados, id);
                    if (empleado != null) {
                        request.setAttribute("empleado", empleado);
                        request.setAttribute("cargos", CargoEmpleado.values());
                        request.getRequestDispatcher("/admin/empleados/memory-formulario.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // ID inválido
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/empleados/memory");
        } else {
            // Mostrar lista de empleados
            request.setAttribute("empleados", empleados);
            request.getRequestDispatcher("/admin/empleados/memory-lista.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        List<Empleado> empleados = getEmpleadosFromSession(session);
        
        String accion = request.getParameter("accion");
        
        if ("crear".equals(accion)) {
            crearEmpleado(request, response, empleados, session);
        } else if ("actualizar".equals(accion)) {
            actualizarEmpleado(request, response, empleados, session);
        } else if ("eliminar".equals(accion)) {
            eliminarEmpleado(request, response, empleados, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/empleados/memory");
        }
    }
    
    private void crearEmpleado(HttpServletRequest request, HttpServletResponse response, 
                              List<Empleado> empleados, HttpSession session)
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
                request.getRequestDispatcher("/admin/empleados/memory-formulario.jsp").forward(request, response);
                return;
            }
            
            // Crear empleado
            Empleado empleado = new Empleado();
            empleado.setId(idGenerator.getAndIncrement());
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
                    empleado.setSalario(new BigDecimal(salarioStr.trim()));
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "El salario debe ser un número válido");
                    request.setAttribute("cargos", CargoEmpleado.values());
                    request.getRequestDispatcher("/admin/empleados/memory-formulario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Procesar fecha de nacimiento
            if (fechaNacimientoStr != null && !fechaNacimientoStr.trim().isEmpty()) {
                try {
                    empleado.setFechaNacimiento(LocalDate.parse(fechaNacimientoStr, DateTimeFormatter.ISO_LOCAL_DATE));
                } catch (Exception e) {
                    request.setAttribute("error", "La fecha de nacimiento debe tener el formato correcto");
                    request.setAttribute("cargos", CargoEmpleado.values());
                    request.getRequestDispatcher("/admin/empleados/memory-formulario.jsp").forward(request, response);
                    return;
                }
            }
            
            // Agregar empleado a la lista
            empleados.add(empleado);
            session.setAttribute(EMPLEADOS_SESSION_KEY, empleados);
            
            System.out.println("Empleado creado en memoria: " + empleado.getNombre() + " " + empleado.getApellido());
            
            response.sendRedirect(request.getContextPath() + "/admin/empleados/memory?mensaje=empleado-creado");
            
        } catch (Exception e) {
            System.out.println("Error al crear empleado: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error interno del servidor. Intente nuevamente.");
            request.setAttribute("cargos", CargoEmpleado.values());
            request.getRequestDispatcher("/admin/empleados/memory-formulario.jsp").forward(request, response);
        }
    }
    
    private void actualizarEmpleado(HttpServletRequest request, HttpServletResponse response, 
                                  List<Empleado> empleados, HttpSession session)
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados/memory");
                return;
            }
            
            Long id = Long.parseLong(idStr);
            Empleado empleado = buscarEmpleadoPorId(empleados, id);
            
            if (empleado == null) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados/memory");
                return;
            }
            
            // Actualizar datos
            empleado.setNombre(request.getParameter("nombre").trim());
            empleado.setApellido(request.getParameter("apellido").trim());
            empleado.setTelefono(request.getParameter("telefono").trim());
            empleado.setEmail(request.getParameter("email").trim());
            empleado.setCargo(CargoEmpleado.valueOf(request.getParameter("cargo")));
            empleado.setDireccion(request.getParameter("direccion"));
            
            String salarioStr = request.getParameter("salario");
            if (salarioStr != null && !salarioStr.trim().isEmpty()) {
                empleado.setSalario(new BigDecimal(salarioStr.trim()));
            }
            
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");
            if (fechaNacimientoStr != null && !fechaNacimientoStr.trim().isEmpty()) {
                empleado.setFechaNacimiento(LocalDate.parse(fechaNacimientoStr, DateTimeFormatter.ISO_LOCAL_DATE));
            }
            
            session.setAttribute(EMPLEADOS_SESSION_KEY, empleados);
            
            System.out.println("Empleado actualizado en memoria: " + empleado.getNombre() + " " + empleado.getApellido());
            
            response.sendRedirect(request.getContextPath() + "/admin/empleados/memory?mensaje=empleado-actualizado");
            
        } catch (Exception e) {
            System.out.println("Error al actualizar empleado: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/empleados/memory?error=error-actualizacion");
        }
    }
    
    private void eliminarEmpleado(HttpServletRequest request, HttpServletResponse response, 
                                List<Empleado> empleados, HttpSession session)
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            if (idStr == null) {
                response.sendRedirect(request.getContextPath() + "/admin/empleados/memory");
                return;
            }
            
            Long id = Long.parseLong(idStr);
            Empleado empleado = buscarEmpleadoPorId(empleados, id);
            
            if (empleado != null) {
                empleados.remove(empleado);
                session.setAttribute(EMPLEADOS_SESSION_KEY, empleados);
                System.out.println("Empleado eliminado de memoria: " + empleado.getNombre() + " " + empleado.getApellido());
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/empleados/memory?mensaje=empleado-eliminado");
            
        } catch (Exception e) {
            System.out.println("Error al eliminar empleado: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/empleados/memory?error=error-eliminacion");
        }
    }
    
    @SuppressWarnings("unchecked")
    private List<Empleado> getEmpleadosFromSession(HttpSession session) {
        List<Empleado> empleados = (List<Empleado>) session.getAttribute(EMPLEADOS_SESSION_KEY);
        if (empleados == null) {
            empleados = new ArrayList<>();
            session.setAttribute(EMPLEADOS_SESSION_KEY, empleados);
        }
        return empleados;
    }
    
    private Empleado buscarEmpleadoPorId(List<Empleado> empleados, Long id) {
        return empleados.stream()
                .filter(emp -> emp.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
}
