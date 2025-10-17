package com.salonbelleza.servlet;

import com.salonbelleza.dao.UsuarioDAO;
import com.salonbelleza.model.Usuario;
import com.salonbelleza.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Optional;

/**
 * Servlet para manejar el proceso de autenticación de usuarios
 * @author Sistema Salon Belleza
 */
@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    
    // private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Si el usuario ya está autenticado, redirigir al panel de administración
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }
        
        // Mostrar página de login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("Intento de login para usuario: " + username);
        
        // Validaciones básicas
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            System.out.println("Intento de login con campos vacíos");
            request.setAttribute("error", "Por favor, complete todos los campos");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Autenticar usuario
            Optional<Usuario> usuarioOpt = usuarioDAO.autenticar(username.trim(), password);
            
            if (usuarioOpt.isPresent()) {
                Usuario usuario = usuarioOpt.get();
                
                // Crear sesión
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                session.setAttribute("username", usuario.getUsername());
                session.setAttribute("nombreCompleto", usuario.getNombreCompleto());
                session.setAttribute("rol", usuario.getRol().toString());
                
                // Establecer tiempo de vida de la sesión (30 minutos)
                session.setMaxInactiveInterval(30 * 60);
                
                System.out.println("Login exitoso para usuario: " + usuario.getUsername() + " con rol: " + usuario.getRol());
                
                // Redirigir según el rol
                String redirectPath = request.getContextPath() + "/admin/dashboard.jsp";
                response.sendRedirect(redirectPath);
                
            } else {
                System.out.println("Login fallido para usuario: " + username);
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.out.println("Error durante el proceso de login para usuario: " + username + " - " + e.getMessage());
            request.setAttribute("error", "Error interno del servidor. Intente nuevamente.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            // Cerrar EntityManager
            JPAUtil.closeEntityManager();
        }
    }
}
