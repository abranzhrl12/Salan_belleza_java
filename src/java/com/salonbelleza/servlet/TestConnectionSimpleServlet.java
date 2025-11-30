package com.salonbelleza.servlet;

import com.salonbelleza.util.JPAUtilSimple;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Servlet para probar la conexión a la base de datos (versión simple)
 * @author Sistema Salon Belleza
 */
public class TestConnectionSimpleServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Prueba de Conexión Simple</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println(".info { color: blue; }");
        out.println("pre { background: #f5f5f5; padding: 10px; border-radius: 5px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Prueba de Conexión Simple</h1>");
        
        // 1. Probar conexión JDBC directa
        out.println("<h2>1. Prueba de Conexión JDBC Directa</h2>");
        testDirectJDBCConnection(out);
        
        // 2. Probar JPA Simple
        out.println("<h2>2. Prueba de Conexión JPA Simple</h2>");
        testJPASimpleConnection(out);
        
        // 3. Información del sistema
        out.println("<h2>3. Información del Sistema</h2>");
        out.println("<p><strong>Java Version:</strong> " + System.getProperty("java.version") + "</p>");
        out.println("<p><strong>Java Home:</strong> " + System.getProperty("java.home") + "</p>");
        
        out.println("<p><a href='test.html'>← Volver a la página de pruebas</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
    
    private void testDirectJDBCConnection(PrintWriter out) {
        try {
            // Cargar el driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            out.println("<p class='success'>✓ Driver MySQL cargado correctamente</p>");
            
            // Intentar conexión directa
            String url = "jdbc:mysql://mysql-107aa7fd-abranzhrl-4e03.b.aivencloud.com:20392/defaultdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            String user = "avnadmin";
            String password = "AVNS_GZboWAl71WBqaN0vBCh";
            
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                out.println("<p class='success'>✓ Conexión JDBC directa exitosa</p>");
                out.println("<p class='info'>Base de datos: " + conn.getCatalog() + "</p>");
                out.println("<p class='info'>URL: " + conn.getMetaData().getURL() + "</p>");
            }
            
        } catch (ClassNotFoundException e) {
            out.println("<p class='error'>✗ Driver MySQL no encontrado: " + e.getMessage() + "</p>");
        } catch (SQLException e) {
            out.println("<p class='error'>✗ Error de conexión JDBC: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error inesperado: " + e.getMessage() + "</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
    }
    
    private void testJPASimpleConnection(PrintWriter out) {
        try {
            // Probar la conexión JPA Simple
            EntityManager em = JPAUtilSimple.getEntityManager();
            out.println("<p class='success'>✓ EntityManager creado correctamente</p>");
            
            // Probar una consulta simple
            Long count = em.createQuery("SELECT COUNT(u) FROM Usuario u", Long.class).getSingleResult();
            out.println("<p class='info'>Número de usuarios en la base de datos: " + count + "</p>");
            
            JPAUtilSimple.closeEntityManager();
            out.println("<p class='success'>✓ EntityManager cerrado correctamente</p>");
            
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error en JPA Simple:</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            out.println("<p>Stack trace completo:</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
    }
}
