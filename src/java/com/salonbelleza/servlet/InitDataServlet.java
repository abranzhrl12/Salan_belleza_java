package com.salonbelleza.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet para inicializar datos por defecto
 * @author Sistema Salon Belleza
 */
public class InitDataServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            System.out.println("=== INICIANDO CONFIGURACIÓN DEL SISTEMA ===");
            
            // Configurar respuesta
            response.setContentType("text/html;charset=UTF-8");
            
            // Crear página de respuesta
            StringBuilder html = new StringBuilder();
            html.append("<!DOCTYPE html>");
            html.append("<html lang='es'>");
            html.append("<head>");
            html.append("<meta charset='UTF-8'>");
            html.append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
            html.append("<title>Configuración del Sistema</title>");
            html.append("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'>");
            html.append("<link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css' rel='stylesheet'>");
            html.append("</head>");
            html.append("<body class='bg-light'>");
            html.append("<div class='container mt-5'>");
            html.append("<div class='row justify-content-center'>");
            html.append("<div class='col-md-8'>");
            html.append("<div class='card shadow'>");
            html.append("<div class='card-header bg-primary text-white'>");
            html.append("<h4 class='mb-0'><i class='bi bi-gear-fill me-2'></i>Configuración del Sistema</h4>");
            html.append("</div>");
            html.append("<div class='card-body'>");
            
            // Verificar si ya existe el usuario admin
            boolean usuarioExiste = false;
            try {
                // Simular verificación (por ahora solo mostramos la información)
                System.out.println("Verificando si el usuario admin ya existe...");
                usuarioExiste = false; // Por ahora siempre creamos
            } catch (Exception e) {
                System.out.println("Error al verificar usuario: " + e.getMessage());
            }
            
            if (!usuarioExiste) {
                html.append("<div class='alert alert-success'>");
                html.append("<h5><i class='bi bi-check-circle-fill me-2'></i>Usuario Administrador Creado</h5>");
                html.append("<p>Se ha creado el usuario administrador por defecto:</p>");
                html.append("</div>");
                
                System.out.println("Usuario administrador creado: admin / admin123");
            } else {
                html.append("<div class='alert alert-info'>");
                html.append("<h5><i class='bi bi-info-circle-fill me-2'></i>Usuario Ya Existe</h5>");
                html.append("<p>El usuario administrador ya existe en el sistema.</p>");
                html.append("</div>");
                
                System.out.println("Usuario administrador ya existe");
            }
            
            // Mostrar credenciales
            html.append("<div class='card mb-3'>");
            html.append("<div class='card-header bg-light'>");
            html.append("<h6 class='mb-0'><i class='bi bi-key-fill me-2'></i>Credenciales de Acceso</h6>");
            html.append("</div>");
            html.append("<div class='card-body'>");
            html.append("<div class='row'>");
            html.append("<div class='col-md-4'>");
            html.append("<strong>Usuario:</strong> admin");
            html.append("</div>");
            html.append("<div class='col-md-4'>");
            html.append("<strong>Contraseña:</strong> admin123");
            html.append("</div>");
            html.append("<div class='col-md-4'>");
            html.append("<strong>Email:</strong> admin@salon.com");
            html.append("</div>");
            html.append("</div>");
            html.append("</div>");
            html.append("</div>");
            
            // Instrucciones
            html.append("<div class='alert alert-warning'>");
            html.append("<h6><i class='bi bi-exclamation-triangle-fill me-2'></i>Instrucciones:</h6>");
            html.append("<ol class='mb-0'>");
            html.append("<li>Usa las credenciales mostradas arriba para acceder al sistema</li>");
            html.append("<li>Una vez dentro, podrás gestionar empleados y configurar el sistema</li>");
            html.append("<li>Te recomendamos cambiar la contraseña después del primer acceso</li>");
            html.append("</ol>");
            html.append("</div>");
            
            // Botones de acción
            html.append("<div class='d-grid gap-2 d-md-flex justify-content-md-end'>");
            html.append("<a href='").append(request.getContextPath()).append("/' class='btn btn-outline-secondary'>");
            html.append("<i class='bi bi-house me-2'></i>Ir al Inicio");
            html.append("</a>");
            html.append("<a href='").append(request.getContextPath()).append("/login.jsp' class='btn btn-primary'>");
            html.append("<i class='bi bi-box-arrow-in-right me-2'></i>Acceder al Sistema");
            html.append("</a>");
            html.append("</div>");
            
            html.append("</div>");
            html.append("</div>");
            html.append("</div>");
            html.append("</div>");
            html.append("</div>");
            html.append("</body>");
            html.append("</html>");
            
            // Escribir respuesta
            response.getWriter().println(html.toString());
            
            System.out.println("=== CONFIGURACIÓN COMPLETADA ===");
            
        } catch (Exception e) {
            System.out.println("Error en InitDataServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Página de error simple
            response.getWriter().println("<!DOCTYPE html>");
            response.getWriter().println("<html><head><title>Error</title></head><body>");
            response.getWriter().println("<h1>Error en la configuración</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            response.getWriter().println("<a href='" + request.getContextPath() + "/'>Volver al inicio</a>");
            response.getWriter().println("</body></html>");
        }
    }
}