<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuración - Salon de Belleza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .setup-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center min-vh-100 align-items-center">
            <div class="col-md-8 col-lg-6">
                <div class="card setup-card border-0">
                    <div class="card-header bg-primary text-white text-center py-4">
                        <i class="bi bi-gear-fill display-4 mb-3"></i>
                        <h3 class="mb-0">Configuración del Sistema</h3>
                        <p class="mb-0 opacity-75">Salon de Belleza - Panel de Administración</p>
                    </div>
                    <div class="card-body p-4">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            <strong>Instrucciones:</strong> Sigue estos pasos para configurar el sistema.
                        </div>
                        
                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body text-center">
                                        <i class="bi bi-database-fill text-primary display-4 mb-3"></i>
                                        <h5 class="card-title">1. Inicializar Base de Datos</h5>
                                        <p class="card-text text-muted">
                                            Crea las tablas y usuario administrador por defecto.
                                        </p>
                                        <a href="${pageContext.request.contextPath}/init-data" 
                                           class="btn btn-primary w-100" target="_blank">
                                            <i class="bi bi-play-fill me-2"></i>
                                            Inicializar BD
                                        </a>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body text-center">
                                        <i class="bi bi-person-check-fill text-success display-4 mb-3"></i>
                                        <h5 class="card-title">2. Acceder al Panel</h5>
                                        <p class="card-text text-muted">
                                            Usa las credenciales por defecto para acceder.
                                        </p>
                                        <a href="${pageContext.request.contextPath}/login.jsp" 
                                           class="btn btn-success w-100">
                                            <i class="bi bi-box-arrow-in-right me-2"></i>
                                            Ir al Login
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <h6 class="text-primary">
                                <i class="bi bi-key-fill me-2"></i>
                                Credenciales por Defecto:
                            </h6>
                            <div class="bg-light p-3 rounded">
                                <div class="row">
                                    <div class="col-md-6">
                                        <strong>Usuario:</strong> admin
                                    </div>
                                    <div class="col-md-6">
                                        <strong>Contraseña:</strong> admin123
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="col-12">
                                        <strong>Email:</strong> admin@salon.com
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <h6 class="text-warning">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                Importante:
                            </h6>
                            <ul class="list-unstyled text-muted">
                                <li><i class="bi bi-check-circle me-2 text-success"></i>La base de datos se creará automáticamente</li>
                                <li><i class="bi bi-check-circle me-2 text-success"></i>Se creará un usuario administrador</li>
                                <li><i class="bi bi-check-circle me-2 text-success"></i>Podrás gestionar empleados y citas</li>
                                <li><i class="bi bi-shield-exclamation me-2 text-warning"></i>Cambia la contraseña después del primer acceso</li>
                            </ul>
                        </div>
                        
                        <div class="d-grid gap-2 mt-4">
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                                <i class="bi bi-house me-2"></i>
                                Volver al Inicio
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
