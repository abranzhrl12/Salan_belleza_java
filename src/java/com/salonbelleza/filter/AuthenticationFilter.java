package com.salonbelleza.filter;

import com.salonbelleza.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filtro de autenticación para proteger rutas administrativas
 * Verifica que el usuario esté autenticado y tenga permisos de administrador
 * @author Sistema Salon Belleza
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = "/admin/*")
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthenticationFilter inicializado");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        System.out.println("Verificando autenticación para: " + path);
        
        // Verificar si el usuario está autenticado
        if (session == null || session.getAttribute("usuario") == null) {
            System.out.println("Acceso no autorizado a: " + path + " - Usuario no autenticado");
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=no-autenticado");
            return;
        }
        
        // Verificar si el usuario tiene permisos de administrador
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!usuario.esAdmin()) {
            System.out.println("Acceso denegado a: " + path + " - Usuario sin permisos de administrador: " + usuario.getUsername());
            httpResponse.sendRedirect(contextPath + "/error/403.jsp");
            return;
        }
        
        // Verificar si el usuario está activo
        if (!usuario.getActivo()) {
            System.out.println("Acceso denegado a: " + path + " - Usuario inactivo: " + usuario.getUsername());
            session.invalidate();
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=usuario-inactivo");
            return;
        }
        
        System.out.println("Acceso autorizado para usuario: " + usuario.getUsername() + " a: " + path);
        
        // Continuar con la cadena de filtros
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("AuthenticationFilter destruido");
    }
}
