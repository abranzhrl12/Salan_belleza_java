<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${accion == 'editar'}">Editar Empleado</c:when>
            <c:otherwise>Nuevo Empleado</c:otherwise>
        </c:choose>
        - Salon de Belleza
    </title>
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
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
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
                        <i class="bi bi-scissors text-white display-4"></i>
                        <h5 class="text-white mt-2">Salon Belleza</h5>
                        <small class="text-white-50">Panel Administrativo</small>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="../dashboard.jsp">
                                <i class="bi bi-speedometer2 me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="../empleados">
                                <i class="bi bi-people-fill me-2"></i>
                                Empleados
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-person-check-fill me-2"></i>
                                Clientes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-calendar-check me-2"></i>
                                Citas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-scissors me-2"></i>
                                Servicios
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-graph-up me-2"></i>
                                Reportes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-gear-fill me-2"></i>
                                Configuración
                            </a>
                        </li>
                    </ul>
                    
                    <hr class="text-white-50">
                    
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" 
                           data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-2"></i>
                            <strong>${sessionScope.nombreCompleto}</strong>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
                            <li><a class="dropdown-item" href="#"><i class="bi bi-person me-2"></i>Perfil</a></li>
                            <li><a class="dropdown-item" href="#"><i class="bi bi-gear me-2"></i>Configuración</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión
                            </a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="bi bi-person-fill me-2"></i>
                        <c:choose>
                            <c:when test="${accion == 'editar'}">Editar Empleado</c:when>
                            <c:otherwise>Nuevo Empleado</c:otherwise>
                        </c:choose>
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="../empleados" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>
                            Volver a la Lista
                        </a>
                    </div>
                </div>

                <!-- Mensajes de error -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Formulario -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="bi bi-person-lines-fill me-2"></i>
                                    Información del Empleado
                                </h5>
                            </div>
                            <div class="card-body">
                                <form method="post" action="../empleados" novalidate>
                                    <input type="hidden" name="accion" value="${accion == 'editar' ? 'actualizar' : 'guardar'}">
                                    <c:if test="${accion == 'editar'}">
                                        <input type="hidden" name="id" value="${empleado.id}">
                                    </c:if>

                                    <div class="row g-3">
                                        <!-- Nombre -->
                                        <div class="col-md-6">
                                            <label for="nombre" class="form-label">
                                                <i class="bi bi-person me-1"></i>
                                                Nombre <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="nombre" 
                                                   name="nombre" 
                                                   value="${empleado.nombre}"
                                                   required
                                                   maxlength="50">
                                            <div class="invalid-feedback">
                                                Por favor, ingrese el nombre del empleado.
                                            </div>
                                        </div>

                                        <!-- Apellido -->
                                        <div class="col-md-6">
                                            <label for="apellido" class="form-label">
                                                <i class="bi bi-person me-1"></i>
                                                Apellido <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="apellido" 
                                                   name="apellido" 
                                                   value="${empleado.apellido}"
                                                   required
                                                   maxlength="50">
                                            <div class="invalid-feedback">
                                                Por favor, ingrese el apellido del empleado.
                                            </div>
                                        </div>

                                        <!-- Email -->
                                        <div class="col-md-6">
                                            <label for="email" class="form-label">
                                                <i class="bi bi-envelope me-1"></i>
                                                Email <span class="text-danger">*</span>
                                            </label>
                                            <input type="email" 
                                                   class="form-control" 
                                                   id="email" 
                                                   name="email" 
                                                   value="${empleado.email}"
                                                   required>
                                            <div class="invalid-feedback">
                                                Por favor, ingrese un email válido.
                                            </div>
                                        </div>

                                        <!-- Teléfono -->
                                        <div class="col-md-6">
                                            <label for="telefono" class="form-label">
                                                <i class="bi bi-telephone me-1"></i>
                                                Teléfono <span class="text-danger">*</span>
                                            </label>
                                            <input type="tel" 
                                                   class="form-control" 
                                                   id="telefono" 
                                                   name="telefono" 
                                                   value="${empleado.telefono}"
                                                   required
                                                   maxlength="20">
                                            <div class="invalid-feedback">
                                                Por favor, ingrese el teléfono del empleado.
                                            </div>
                                        </div>

                                        <!-- Fecha de Nacimiento -->
                                        <div class="col-md-6">
                                            <label for="fechaNacimiento" class="form-label">
                                                <i class="bi bi-calendar me-1"></i>
                                                Fecha de Nacimiento
                                            </label>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="fechaNacimiento" 
                                                   name="fechaNacimiento" 
                                                   value="<fmt:formatDate value='${empleado.fechaNacimiento}' pattern='yyyy-MM-dd'/>">
                                        </div>

                                        <!-- Fecha de Contratación -->
                                        <div class="col-md-6">
                                            <label for="fechaContratacion" class="form-label">
                                                <i class="bi bi-calendar-check me-1"></i>
                                                Fecha de Contratación <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" 
                                                   class="form-control" 
                                                   id="fechaContratacion" 
                                                   name="fechaContratacion" 
                                                   value="<fmt:formatDate value='${empleado.fechaContratacion}' pattern='yyyy-MM-dd'/>"
                                                   required>
                                            <div class="invalid-feedback">
                                                Por favor, seleccione la fecha de contratación.
                                            </div>
                                        </div>

                                        <!-- Cargo -->
                                        <div class="col-md-6">
                                            <label for="cargo" class="form-label">
                                                <i class="bi bi-briefcase me-1"></i>
                                                Cargo <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="cargo" name="cargo" required>
                                                <option value="">Seleccione un cargo</option>
                                                <c:forEach var="cargo" items="${cargos}">
                                                    <option value="${cargo}" 
                                                            ${empleado.cargo == cargo ? 'selected' : ''}>
                                                        ${cargo.descripcion}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="invalid-feedback">
                                                Por favor, seleccione un cargo.
                                            </div>
                                        </div>

                                        <!-- Salario -->
                                        <div class="col-md-6">
                                            <label for="salario" class="form-label">
                                                <i class="bi bi-currency-dollar me-1"></i>
                                                Salario
                                            </label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" 
                                                       class="form-control" 
                                                       id="salario" 
                                                       name="salario" 
                                                       value="${empleado.salario}"
                                                       step="0.01"
                                                       min="0"
                                                       placeholder="0.00">
                                            </div>
                                        </div>

                                        <!-- Dirección -->
                                        <div class="col-12">
                                            <label for="direccion" class="form-label">
                                                <i class="bi bi-geo-alt me-1"></i>
                                                Dirección
                                            </label>
                                            <textarea class="form-control" 
                                                      id="direccion" 
                                                      name="direccion" 
                                                      rows="3" 
                                                      maxlength="200"
                                                      placeholder="Ingrese la dirección completa del empleado">${empleado.direccion}</textarea>
                                        </div>
                                    </div>

                                    <hr class="my-4">

                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="../empleados" class="btn btn-secondary">
                                            <i class="bi bi-x-circle me-1"></i>
                                            Cancelar
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-check-circle me-1"></i>
                                            <c:choose>
                                                <c:when test="${accion == 'editar'}">Actualizar Empleado</c:when>
                                                <c:otherwise>Guardar Empleado</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Panel lateral con información adicional -->
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="mb-0">
                                    <i class="bi bi-info-circle me-2"></i>
                                    Información Adicional
                                </h6>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${accion == 'editar'}">
                                        <div class="mb-3">
                                            <strong>ID del Empleado:</strong>
                                            <span class="badge bg-secondary ms-2">#${empleado.id}</span>
                                        </div>
                                        <div class="mb-3">
                                            <strong>Fecha de Registro:</strong>
                                            <br>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${empleado.fechaCreacion}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                        <c:if test="${not empty empleado.fechaActualizacion}">
                                            <div class="mb-3">
                                                <strong>Última Actualización:</strong>
                                                <br>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${empleado.fechaActualizacion}" pattern="dd/MM/yyyy HH:mm"/>
                                                </small>
                                            </div>
                                        </c:if>
                                        <div class="mb-3">
                                            <strong>Estado:</strong>
                                            <c:choose>
                                                <c:when test="${empleado.activo}">
                                                    <span class="badge bg-success ms-2">Activo</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger ms-2">Inactivo</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-info">
                                            <i class="bi bi-lightbulb me-2"></i>
                                            <strong>Consejo:</strong> Todos los campos marcados con <span class="text-danger">*</span> son obligatorios.
                                        </div>
                                        <div class="alert alert-warning">
                                            <i class="bi bi-shield-exclamation me-2"></i>
                                            <strong>Importante:</strong> El email debe ser único en el sistema.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Ayuda rápida -->
                        <div class="card mt-3">
                            <div class="card-header">
                                <h6 class="mb-0">
                                    <i class="bi bi-question-circle me-2"></i>
                                    Ayuda Rápida
                                </h6>
                            </div>
                            <div class="card-body">
                                <small class="text-muted">
                                    <strong>Cargos disponibles:</strong><br>
                                    • <strong>Estilista:</strong> Cortes y peinados<br>
                                    • <strong>Colorista:</strong> Coloración y tratamientos químicos<br>
                                    • <strong>Manicurista:</strong> Cuidado de uñas<br>
                                    • <strong>Esteticista:</strong> Tratamientos faciales y corporales<br>
                                    • <strong>Recepcionista:</strong> Atención al cliente<br>
                                    • <strong>Supervisor:</strong> Supervisión del personal<br>
                                    • <strong>Gerente:</strong> Gestión general<br>
                                    • <strong>Asistente:</strong> Apoyo general
                                </small>
                            </div>
                        </div>
                    </div>
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

        // Establecer fecha de contratación por defecto si es nuevo empleado
        <c:if test="${accion != 'editar'}">
        document.addEventListener('DOMContentLoaded', function() {
            const fechaContratacion = document.getElementById('fechaContratacion');
            if (!fechaContratacion.value) {
                const today = new Date().toISOString().split('T')[0];
                fechaContratacion.value = today;
            }
        });
        </c:if>
    </script>
</body>
</html>
