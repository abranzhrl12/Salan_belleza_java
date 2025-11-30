package com.salonbelleza.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet básico para probar que la aplicación funciona
 * @author Sistema Salon Belleza
 */
public class BasicTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Prueba Básica</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println(".success { color: green; font-size: 18px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>✅ Aplicación Funcionando Correctamente</h1>");
        out.println("<p class='success'>✓ Servlet básico ejecutándose</p>");
        out.println("<p class='success'>✓ Java funcionando: " + System.getProperty("java.version") + "</p>");
        out.println("<p class='success'>✓ Servidor Tomcat funcionando</p>");
        out.println("<p><a href='test.html'>← Volver a la página de pruebas</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}
