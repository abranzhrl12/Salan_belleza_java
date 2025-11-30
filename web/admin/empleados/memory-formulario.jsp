<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty empleado ? 'Nuevo Empleado' : 'Editar Empleado'} - Salon de Belleza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 4px 0;
            transition: all 0.3s ease;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.1);
        }
        .main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 600;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            transform: translateY(-2px);
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
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
                        <h4 class="text-white">
                            <i class="bi bi-scissors me-2"></i>
                            Salon Belleza
                        </h4>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                                <i class="bi bi-speedometer2 me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/empleados/memory">
                                <i class="bi bi-people-fill me-2"></i>
                                Empleados (Memoria)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/empleados">
                                <i class="bi bi-people me-2"></i>
                                Empleados (BD)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                <i class="bi bi-box-arrow-right me-2"></i>
                                Cerrar Sesión
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="bi bi-person-${empty empleado ? 'plus' : 'pencil'} me-2"></i>
                        ${empty empleado ? 'Nuevo Empleado' : 'Editar Empleado'}
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/empleados/memory" 
                           class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-2"></i>
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

                <!-- Formulario -->
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/admin/empleados/memory" method="post" id="empleadoForm">
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
                                        <i class="bi bi-person me-1"></i>
                                        Nombre *
                                    </label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                           value="${empleado.nombre}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="apellido" class="form-label">
                                        <i class="bi bi-person me-1"></i>
                                        Apellido *
                                    </label>
                                    <input type="text" class="form-control" id="apellido" name="apellido" 
                                           value="${empleado.apellido}" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="telefono" class="form-label">
                                        <i class="bi bi-telephone me-1"></i>
                                        Teléfono *
                                    </label>
                                    <input type="tel" class="form-control" id="telefono" name="telefono" 
                                           value="${empleado.telefono}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        <i class="bi bi-envelope me-1"></i>
                                        Email *
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${empleado.email}" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="cargo" class="form-label">
                                        <i class="bi bi-briefcase me-1"></i>
                                        Cargo *
                                    </label>
                                    <select class="form-select" id="cargo" name="cargo" required>
                                        <option value="">Seleccionar cargo</option>
                                        <c:forEach var="cargo" items="${cargos}">
                                            <option value="${cargo}" ${empleado.cargo == cargo ? 'selected' : ''}>
                                                ${cargo}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="salario" class="form-label">
                                        <i class="bi bi-currency-dollar me-1"></i>
                                        Salario
                                    </label>
                                    <input type="number" class="form-control" id="salario" name="salario" 
                                           value="${empleado.salario}" step="0.01" min="0">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fechaNacimiento" class="form-label">
                                        <i class="bi bi-calendar me-1"></i>
                                        Fecha de Nacimiento
                                    </label>
                                    <input type="date" class="form-control" id="fechaNacimiento" name="fechaNacimiento" 
                                           value="${empleado.fechaNacimiento}">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">
                                        <i class="bi bi-info-circle me-1"></i>
                                        Estado
                                    </label>
                                    <div class="form-control-plaintext">
                                        <span class="badge ${empleado.activo ? 'bg-success' : 'bg-danger'}">
                                            ${empleado.activo ? 'Activo' : 'Inactivo'}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="direccion" class="form-label">
                                <i class="bi bi-geo-alt me-1"></i>
                                Dirección
                            </label>
                            <textarea class="form-control" id="direccion" name="direccion" rows="3">${empleado.direccion}</textarea>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/admin/empleados/memory" 
                               class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-2"></i>
                                Cancelar
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle me-2"></i>
                                ${empty empleado ? 'Crear Empleado' : 'Actualizar Empleado'}
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
        document.getElementById('empleadoForm').addEventListener('submit', function(e) {
            const nombre = document.getElementById('nombre').value.trim();
            const apellido = document.getElementById('apellido').value.trim();
            const telefono = document.getElementById('telefono').value.trim();
            const email = document.getElementById('email').value.trim();
            const cargo = document.getElementById('cargo').value;

            if (!nombre || !apellido || !telefono || !email || !cargo) {
                e.preventDefault();
                alert('Por favor, complete todos los campos obligatorios.');
                return;
            }

            // Validar email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Por favor, ingrese un email válido.');
                return;
            }

            // Validar teléfono (básico)
            const telefonoRegex = /^[\d\s\-\+\(\)]+$/;
            if (!telefonoRegex.test(telefono)) {
                e.preventDefault();
                alert('Por favor, ingrese un teléfono válido.');
                return;
            }
        });

        // Auto-format teléfono
        document.getElementById('telefono').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 0) {
                if (value.length <= 3) {
                    value = value;
                } else if (value.length <= 6) {
                    value = value.slice(0, 3) + '-' + value.slice(3);
                } else {
                    value = value.slice(0, 3) + '-' + value.slice(3, 6) + '-' + value.slice(6, 10);
                }
            }
            e.target.value = value;
        });
    </script>
</body>
</html>
