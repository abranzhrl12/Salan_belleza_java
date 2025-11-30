<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulario de Empleado - Salon de Belleza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            margin: 5px 0;
            transition: all 0.3s ease;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }
        .main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <i class="bi bi-scissors display-4 text-white"></i>
                        <h5 class="text-white mt-2">Salon Belleza</h5>
                        <small class="text-white-50">Panel Administrativo</small>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                                <i class="bi bi-house-door me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/empleados/lista.jsp">
                                <i class="bi bi-people me-2"></i>
                                Empleados
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/clientes/lista.jsp">
                                <i class="bi bi-person-heart me-2"></i>
                                Clientes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/servicios/lista.jsp">
                                <i class="bi bi-scissors me-2"></i>
                                Servicios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/citas/lista.jsp">
                                <i class="bi bi-calendar-check me-2"></i>
                                Citas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/ventas/lista.jsp">
                                <i class="bi bi-currency-dollar me-2"></i>
                                Ventas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/inventario/lista.jsp">
                                <i class="bi bi-box-seam me-2"></i>
                                Inventario
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/reportes/lista.jsp">
                                <i class="bi bi-graph-up me-2"></i>
                                Reportes
                            </a>
                        </li>
                        <li class="nav-item mt-4">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/configuracion/lista.jsp">
                                <i class="bi bi-gear me-2"></i>
                                Configuración
                            </a>
                        </li>
                    </ul>
                    
                    <div class="mt-auto pt-3">
                        <div class="text-center">
                            <small class="text-white-50">Usuario: ${sessionScope.usuario.username}</small>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
                            <i class="bi bi-box-arrow-right me-2"></i>
                            Cerrar Sesión
                        </a>
                    </div>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <c:choose>
                            <c:when test="${not empty empleado}">
                                Editar Empleado
                            </c:when>
                            <c:otherwise>
                                Nuevo Empleado
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/empleados" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>
                            Volver a la Lista
                        </a>
                    </div>
                </div>

                <!-- Mensajes -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty mensaje}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        ${mensaje}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Formulario -->
                <div class="form-container p-4">
                    <form action="${pageContext.request.contextPath}/admin/empleados" method="post" id="empleadoForm">
                        <c:if test="${not empty empleado}">
                            <input type="hidden" name="id" value="${empleado.id}">
                            <input type="hidden" name="accion" value="actualizar">
                        </c:if>
                        <c:if test="${empty empleado}">
                            <input type="hidden" name="accion" value="crear">
                        </c:if>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">
                                        <i class="bi bi-person me-2"></i>Nombre *
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="nombre" 
                                           name="nombre" 
                                           value="${empleado.nombre}"
                                           required
                                           maxlength="50">
                                    <div class="invalid-feedback">
                                        El nombre es obligatorio y debe tener máximo 50 caracteres.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="apellido" class="form-label">
                                        <i class="bi bi-person me-2"></i>Apellido *
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="apellido" 
                                           name="apellido" 
                                           value="${empleado.apellido}"
                                           required
                                           maxlength="50">
                                    <div class="invalid-feedback">
                                        El apellido es obligatorio y debe tener máximo 50 caracteres.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="telefono" class="form-label">
                                        <i class="bi bi-telephone me-2"></i>Teléfono *
                                    </label>
                                    <input type="tel" 
                                           class="form-control" 
                                           id="telefono" 
                                           name="telefono" 
                                           value="${empleado.telefono}"
                                           required
                                           maxlength="20">
                                    <div class="invalid-feedback">
                                        El teléfono es obligatorio.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        <i class="bi bi-envelope me-2"></i>Email *
                                    </label>
                                    <input type="email" 
                                           class="form-control" 
                                           id="email" 
                                           name="email" 
                                           value="${empleado.email}"
                                           required
                                           maxlength="100">
                                    <div class="invalid-feedback">
                                        El email es obligatorio y debe tener un formato válido.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="cargo" class="form-label">
                                        <i class="bi bi-briefcase me-2"></i>Cargo *
                                    </label>
                                    <select class="form-select" id="cargo" name="cargo" required>
                                        <option value="">Seleccionar cargo</option>
                                        <c:forEach var="cargo" items="${cargos}">
                                            <option value="${cargo}" 
                                                    <c:if test="${empleado.cargo == cargo}">selected</c:if>>
                                                ${cargo.descripcion}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">
                                        Debe seleccionar un cargo.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="salario" class="form-label">
                                        <i class="bi bi-currency-dollar me-2"></i>Salario
                                    </label>
                                    <input type="number" 
                                           class="form-control" 
                                           id="salario" 
                                           name="salario" 
                                           value="${empleado.salario}"
                                           step="0.01"
                                           min="0">
                                    <div class="invalid-feedback">
                                        El salario debe ser un número válido.
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fechaNacimiento" class="form-label">
                                        <i class="bi bi-calendar me-2"></i>Fecha de Nacimiento
                                    </label>
                                    <input type="date" 
                                           class="form-control" 
                                           id="fechaNacimiento" 
                                           name="fechaNacimiento" 
                                           value="${empleado.fechaNacimiento}">
                                </div>
                            </div>
                            <c:if test="${not empty empleado}">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">
                                            <i class="bi bi-toggle-on me-2"></i>Estado
                                        </label>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" 
                                                   type="checkbox" 
                                                   id="activo" 
                                                   name="activo" 
                                                   value="true"
                                                   <c:if test="${empleado.activo}">checked</c:if>>
                                            <label class="form-check-label" for="activo">
                                                Empleado Activo
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <label for="direccion" class="form-label">
                                <i class="bi bi-geo-alt me-2"></i>Dirección
                            </label>
                            <textarea class="form-control" 
                                      id="direccion" 
                                      name="direccion" 
                                      rows="3" 
                                      maxlength="200">${empleado.direccion}</textarea>
                            <div class="form-text">
                                Máximo 200 caracteres.
                            </div>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/admin/empleados" class="btn btn-secondary">
                                <i class="bi bi-x-circle me-2"></i>
                                Cancelar
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle me-2"></i>
                                <c:choose>
                                    <c:when test="${not empty empleado}">
                                        Actualizar Empleado
                                    </c:when>
                                    <c:otherwise>
                                        Crear Empleado
                                    </c:otherwise>
                                </c:choose>
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validación del formulario
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var form = document.getElementById('empleadoForm');
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            }, false);
        })();

        // Validación en tiempo real
        document.querySelectorAll('#empleadoForm input, #empleadoForm select').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.checkValidity()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            });
        });

        // Validación de email único (simulada)
        document.getElementById('email').addEventListener('blur', function() {
            const email = this.value;
            if (email && email.includes('@')) {
                // Simular verificación de email único
                setTimeout(() => {
                    if (email === 'email@existente.com') {
                        this.setCustomValidity('Este email ya está registrado');
                        this.classList.add('is-invalid');
                    } else {
                        this.setCustomValidity('');
                        this.classList.remove('is-invalid');
                    }
                }, 500);
            }
        });
    </script>
</body>
</html>