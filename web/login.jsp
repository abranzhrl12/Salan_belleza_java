<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Salon de Belleza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card login-card border-0">
                    <div class="card-header login-header text-center py-4">
                        <i class="bi bi-scissors display-4 mb-3"></i>
                        <h3 class="mb-0" data-i18n="login.title">Salon de Belleza</h3>
                        <p class="mb-0 opacity-75" data-i18n="login.subtitle">Sistema de Gestión</p>
                    </div>
                    <div class="card-body p-4">
                        <!-- Mensajes de error -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <!-- Mensajes de éxito -->
                        <c:if test="${param.mensaje == 'logout-exitoso'}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                Sesión cerrada exitosamente
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${param.error == 'no-autenticado'}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="bi bi-shield-exclamation me-2"></i>
                                Debe iniciar sesión para acceder a esta página
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${param.error == 'usuario-inactivo'}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-person-x-fill me-2"></i>
                                Su cuenta ha sido desactivada
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${param.mensaje == 'registro-exitoso'}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                Cuenta creada exitosamente. Ya puede iniciar sesión.
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label" data-i18n="login.user">
                                    <i class="bi bi-person-fill me-2"></i>Usuario
                                </label>
                                <input type="text" 
                                       class="form-control form-control-lg" 
                                       id="username" 
                                       name="username" 
                                       placeholder="Ingrese su usuario"
                                       data-i18n="login.user.placeholder"
                                       required
                                       autocomplete="username">
                            </div>
                            
                            <div class="mb-4">
                                <label for="password" class="form-label" data-i18n="login.pass">
                                    <i class="bi bi-lock-fill me-2"></i>Contraseña
                                </label>
                                <input type="password" 
                                       class="form-control form-control-lg" 
                                       id="password" 
                                       name="password" 
                                       placeholder="Ingrese su contraseña"
                                       data-i18n="login.pass.placeholder"
                                       required
                                       autocomplete="current-password">
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-login btn-lg" data-i18n="login.btn">
                                    <i class="bi bi-box-arrow-in-right me-2"></i>
                                    Iniciar Sesión
                                </button>
                            </div>
                        </form>
                        
                        <div class="text-center mt-4">
                            <small class="text-muted" data-i18n="login.secure">
                                <i class="bi bi-shield-check me-1"></i>
                                Acceso seguro y encriptado
                            </small>
                        </div>
                        
                        <hr class="my-4">
                        
                        <div class="text-center">
                            <p class="mb-0" data-i18n="login.no_account">¿No tienes una cuenta?</p>
                            <a href="${pageContext.request.contextPath}/registro" class="btn btn-outline-primary" data-i18n="login.create_account">
                                <i class="bi bi-person-plus-fill me-2"></i>
                                Crear Cuenta
                            </a>
                        </div>
                        
                        <hr class="my-4">
                        
                        <div class="text-center">
                            <p class="mb-0 text-muted" data-i18n="login.first_time">¿Primera vez usando el sistema?</p>
                            <a href="${pageContext.request.contextPath}/setup.jsp" class="btn btn-outline-warning" data-i18n="login.setup">
                                <i class="bi bi-gear me-2"></i>
                                Configurar Sistema
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none" data-i18n="login.back">
                        <i class="bi bi-arrow-left me-2"></i>
                        Volver al inicio
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <button id="langToggle" class="btn btn-dark" style="position: fixed; bottom: 30px; left: 30px; z-index: 1000; border-radius: 50%; width: 65px; height: 65px; padding: 0; display: flex; align-items: center; justify-content: center; font-weight: bold; border: 2px solid rgba(255,255,255,0.1); box-shadow: 0 10px 25px rgba(0,0,0,0.3); transition: transform 0.3s ease, box-shadow 0.3s ease;">
        <span style="font-size: 1.2rem;">🇺🇸</span>
    </button>
    <script src="js/translation.js"></script>
</body>
</html>
