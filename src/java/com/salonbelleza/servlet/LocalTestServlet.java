package com.salonbelleza.servlet;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
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
 * Servlet para probar la conexión a base de datos local
 * @author Sistema Salon Belleza
 */
public class LocalTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Prueba de Base de Datos Local</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println(".info { color: blue; }");
        out.println(".warning { color: orange; }");
        out.println("pre { background: #f5f5f5; padding: 10px; border-radius: 5px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Prueba de Base de Datos Local</h1>");
        
        // 1. Probar conexión JDBC local
        out.println("<h2>1. Prueba de Conexión JDBC Local</h2>");
        testLocalJDBCConnection(out);
        
        // 2. Probar JPA local
        out.println("<h2>2. Prueba de Conexión JPA Local</h2>");
        testLocalJPAConnection(out);
        
        // 3. Información del sistema
        out.println("<h2>3. Información del Sistema</h2>");
        out.println("<p><strong>Java Version:</strong> " + System.getProperty("java.version") + "</p>");
        out.println("<p><strong>Java Home:</strong> " + System.getProperty("java.home") + "</p>");
        
        out.println("<p><a href='test-simple.html'>← Volver a la página de pruebas</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
    
    private void testLocalJDBCConnection(PrintWriter out) {
        try {
            // Cargar el driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            out.println("<p class='success'>✓ Driver MySQL cargado correctamente</p>");
            
            // Intentar conexión local
            String url = "jdbc:mysql://localhost:3306/salon_belleza?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            String user = "root";
            String password = "";
            
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                out.println("<p class='success'>✓ Conexión JDBC local exitosa</p>");
                out.println("<p class='info'>Base de datos: " + conn.getCatalog() + "</p>");
                out.println("<p class='info'>URL: " + conn.getMetaData().getURL() + "</p>");
            }
            
        } catch (ClassNotFoundException e) {
            out.println("<p class='error'>✗ Driver MySQL no encontrado: " + e.getMessage() + "</p>");
        } catch (SQLException e) {
            out.println("<p class='error'>✗ Error de conexión JDBC local: " + e.getMessage() + "</p>");
            out.println("<p class='warning'>💡 Posibles soluciones:</p>");
            out.println("<ul>");
            out.println("<li>Instalar MySQL Server localmente</li>");
            out.println("<li>Crear la base de datos 'salon_belleza'</li>");
            out.println("<li>Verificar que MySQL esté ejecutándose en el puerto 3306</li>");
            out.println("<li>Configurar usuario 'root' sin contraseña</li>");
            out.println("</ul>");
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
    
    private void testLocalJPAConnection(PrintWriter out) {
        EntityManagerFactory emf = null;
        try {
            // Probar la conexión JPA local
            emf = Persistence.createEntityManagerFactory("salon-belleza-pu-local");
            out.println("<p class='success'>✓ EntityManagerFactory local creado correctamente</p>");
            
            EntityManager em = emf.createEntityManager();
            out.println("<p class='success'>✓ EntityManager local creado correctamente</p>");
            
            // Probar una consulta simple
            Long count = em.createQuery("SELECT COUNT(u) FROM Usuario u", Long.class).getSingleResult();
            out.println("<p class='info'>Número de usuarios en la base de datos local: " + count + "</p>");
            
            em.close();
            out.println("<p class='success'>✓ EntityManager local cerrado correctamente</p>");
            
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error en JPA local:</p>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            out.println("<p class='warning'>💡 Para usar JPA local necesitas:</p>");
            out.println("<ul>");
            out.println("<li>MySQL Server instalado y ejecutándose</li>");
            out.println("<li>Base de datos 'salon_belleza' creada</li>");
            out.println("<li>Tablas creadas (las entidades JPA las crearán automáticamente)</li>");
            out.println("</ul>");
            out.println("<p>Stack trace completo:</p>");
            out.println("<pre>");
            e.printStackTrace(out);
            out.println("</pre>");
        } finally {
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }
}
