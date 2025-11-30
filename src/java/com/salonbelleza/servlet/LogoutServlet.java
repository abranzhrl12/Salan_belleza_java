package com.salonbelleza.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Servlet para manejar el cierre de sesión de usuarios
 * @author Sistema Salon Belleza
 */
public class LogoutServlet extends HttpServlet {
    
    // private static final Logger logger = LoggerFactory.getLogger(LogoutServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarLogout(request, response);
    }
    
    /**
     * Procesa el cierre de sesión del usuario
     */
    private void procesarLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            String username = (String) session.getAttribute("username");
            
            // Invalidar la sesión
            session.invalidate();
            
            System.out.println("Logout exitoso para usuario: " + username);
        }
        
        // Redirigir a la página de login con mensaje de confirmación
        response.sendRedirect(request.getContextPath() + "/login.jsp?mensaje=logout-exitoso");
    }
}
