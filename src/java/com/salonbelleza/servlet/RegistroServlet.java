package com.salonbelleza.servlet;

import com.salonbelleza.dao.UsuarioDAO;
import com.salonbelleza.model.RolUsuario;
import com.salonbelleza.model.Usuario;
import com.salonbelleza.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet para manejar el registro de nuevos usuarios
 * @author Sistema Salon Belleza
 */
public class RegistroServlet extends HttpServlet {
    
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Mostrar formulario de registro
        request.getRequestDispatcher("/registro.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String nombreCompleto = request.getParameter("nombreCompleto");
        
        System.out.println("Intento de registro para usuario: " + username);
        
        // Validaciones básicas
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            nombreCompleto == null || nombreCompleto.trim().isEmpty()) {
            
            System.out.println("Intento de registro con campos vacíos");
            request.setAttribute("error", "Por favor, complete todos los campos");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }
        
        // Validar que las contraseñas coincidan
        if (!password.equals(confirmPassword)) {
            System.out.println("Las contraseñas no coinciden para usuario: " + username);
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }
        
        // Validar longitud mínima de contraseña
        if (password.length() < 6) {
            System.out.println("Contraseña muy corta para usuario: " + username);
            request.setAttribute("error", "La contraseña debe tener al menos 6 caracteres");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }
        
        try {
            // Verificar si el usuario ya existe
            if (usuarioDAO.existeUsername(username)) {
                System.out.println("Usuario ya existe: " + username);
                request.setAttribute("error", "El nombre de usuario ya está en uso");
                request.getRequestDispatcher("/registro.jsp").forward(request, response);
                return;
            }
            
            // Verificar si el email ya existe
            if (usuarioDAO.existeEmail(email)) {
                System.out.println("Email ya existe: " + email);
                request.setAttribute("error", "El email ya está registrado");
                request.getRequestDispatcher("/registro.jsp").forward(request, response);
                return;
            }
            
            // Crear nuevo usuario
            Usuario nuevoUsuario = new Usuario(
                username.trim(),
                password,
                email.trim(),
                nombreCompleto.trim(),
                RolUsuario.ADMIN // Por defecto, los nuevos usuarios son admin
            );
            
            // Guardar usuario
            usuarioDAO.guardar(nuevoUsuario);
            
            System.out.println("Usuario registrado exitosamente: " + username);
            
            // Redirigir al login con mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/login.jsp?mensaje=registro-exitoso");
            
        } catch (Exception e) {
            System.out.println("Error durante el registro para usuario: " + username + " - " + e.getMessage());
            request.setAttribute("error", "Error interno del servidor. Intente nuevamente.");
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        } finally {
            // Cerrar EntityManager
            JPAUtil.closeEntityManager();
        }
    }
}
