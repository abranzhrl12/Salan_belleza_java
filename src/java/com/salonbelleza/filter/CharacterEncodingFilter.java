package com.salonbelleza.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filtro para establecer la codificación de caracteres UTF-8
 * Asegura que todas las peticiones y respuestas usen UTF-8
 * @author Sistema Salon Belleza
 */
@WebFilter(filterName = "CharacterEncodingFilter", urlPatterns = "/*")
public class CharacterEncodingFilter implements Filter {
    private static final String ENCODING = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("CharacterEncodingFilter inicializado");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Establecer codificación para la petición
        if (httpRequest.getCharacterEncoding() == null) {
            httpRequest.setCharacterEncoding(ENCODING);
        }
        
        // Establecer codificación para la respuesta
        httpResponse.setCharacterEncoding(ENCODING);
        httpResponse.setContentType("text/html; charset=" + ENCODING);
        
        System.out.println("Codificación UTF-8 establecida para: " + httpRequest.getRequestURI());
        
        // Continuar con la cadena de filtros
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("CharacterEncodingFilter destruido");
    }
}
