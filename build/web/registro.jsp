<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Salon de Belleza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .register-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card register-card border-0">
                    <div class="card-header register-header text-center py-4">
                        <i class="bi bi-person-plus-fill display-4 mb-3"></i>
                        <h3 class="mb-0">Registro de Usuario</h3>
                        <p class="mb-0 opacity-75">Crear cuenta administrativa</p>
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
                        
                        <form action="${pageContext.request.contextPath}/registro" method="post" novalidate>
                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="bi bi-person-fill me-2"></i>Nombre de Usuario
                                </label>
                                <input type="text" 
                                       class="form-control form-control-lg" 
                                       id="username" 
                                       name="username" 
                                       placeholder="Ingrese su nombre de usuario"
                                       required
                                       minlength="3"
                                       maxlength="50"
                                       autocomplete="username">
                                <div class="invalid-feedback">
                                    El nombre de usuario debe tener entre 3 y 50 caracteres.
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="bi bi-envelope-fill me-2"></i>Email
                                </label>
                                <input type="email" 
                                       class="form-control form-control-lg" 
                                       id="email" 
                                       name="email" 
                                       placeholder="Ingrese su email"
                                       required
                                       autocomplete="email">
                                <div class="invalid-feedback">
                                    Por favor, ingrese un email válido.
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="nombreCompleto" class="form-label">
                                    <i class="bi bi-person-badge-fill me-2"></i>Nombre Completo
                                </label>
                                <input type="text" 
                                       class="form-control form-control-lg" 
                                       id="nombreCompleto" 
                                       name="nombreCompleto" 
                                       placeholder="Ingrese su nombre completo"
                                       required
                                       maxlength="100"
                                       autocomplete="name">
                                <div class="invalid-feedback">
                                    Por favor, ingrese su nombre completo.
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">
                                    <i class="bi bi-lock-fill me-2"></i>Contraseña
                                </label>
                                <input type="password" 
                                       class="form-control form-control-lg" 
                                       id="password" 
                                       name="password" 
                                       placeholder="Ingrese su contraseña"
                                       required
                                       minlength="6"
                                       autocomplete="new-password">
                                <div class="invalid-feedback">
                                    La contraseña debe tener al menos 6 caracteres.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label">
                                    <i class="bi bi-lock-fill me-2"></i>Confirmar Contraseña
                                </label>
                                <input type="password" 
                                       class="form-control form-control-lg" 
                                       id="confirmPassword" 
                                       name="confirmPassword" 
                                       placeholder="Confirme su contraseña"
                                       required
                                       minlength="6"
                                       autocomplete="new-password">
                                <div class="invalid-feedback">
                                    Las contraseñas deben coincidir.
                                </div>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-register btn-lg">
                                    <i class="bi bi-person-plus-fill me-2"></i>
                                    Crear Cuenta
                                </button>
                            </div>
                        </form>
                        
                        <hr class="my-4">
                        
                        <div class="text-center">
                            <p class="mb-0">¿Ya tienes una cuenta?</p>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary">
                                <i class="bi bi-box-arrow-in-right me-2"></i>
                                Iniciar Sesión
                            </a>
                        </div>
                        
                        <div class="text-center mt-4">
                            <small class="text-muted">
                                <i class="bi bi-shield-check me-1"></i>
                                Registro seguro y encriptado
                            </small>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none">
                        <i class="bi bi-arrow-left me-2"></i>
                        Volver al inicio
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validación del formulario
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
        
        // Validar que las contraseñas coincidan
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Las contraseñas no coinciden');
            } else {
                this.setCustomValidity('');
            }
        });
        
        // Validar contraseña en tiempo real
        document.getElementById('password').addEventListener('input', function() {
            const confirmPassword = document.getElementById('confirmPassword');
            if (confirmPassword.value !== '') {
                if (this.value !== confirmPassword.value) {
                    confirmPassword.setCustomValidity('Las contraseñas no coinciden');
                } else {
                    confirmPassword.setCustomValidity('');
                }
            }
        });
    </script>
</body>
</html>
