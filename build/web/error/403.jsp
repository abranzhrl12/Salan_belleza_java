<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso Denegado - Salon de Belleza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .error-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }
        .error-icon {
            font-size: 8rem;
            color: #ffc107;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card error-card border-0 text-center">
                    <div class="card-body p-5">
                        <i class="bi bi-shield-exclamation error-icon"></i>
                        <h1 class="display-4 fw-bold text-warning mb-3">403</h1>
                        <h2 class="h3 mb-4">Acceso Denegado</h2>
                        <p class="lead text-muted mb-4">
                            No tiene permisos para acceder a esta página. Contacte al administrador si cree que esto es un error.
                        </p>
                        <div class="d-flex gap-3 justify-content-center">
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-lg">
                                <i class="bi bi-box-arrow-in-right me-2"></i>
                                Iniciar Sesión
                            </a>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-lg">
                                <i class="bi bi-house-fill me-2"></i>
                                Ir al Inicio
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
