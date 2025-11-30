<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Empleados - Salon de Belleza</title>
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
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 600;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            transform: translateY(-2px);
        }
        .employee-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 4px solid #667eea;
        }
        .employee-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 6px 12px;
            border-radius: 20px;
        }
        .cargo-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 0.75rem;
            padding: 4px 8px;
            border-radius: 12px;
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
                        <i class="bi bi-people-fill me-2"></i>
                        Gestión de Empleados (Memoria)
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/empleados/memory?accion=nuevo" 
                           class="btn btn-primary">
                            <i class="bi bi-person-plus me-2"></i>
                            Nuevo Empleado
                        </a>
                    </div>
                </div>

                <!-- Mensajes -->
                <c:if test="${param.error == 'error-actualizacion'}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        Error al actualizar el empleado
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.error == 'error-eliminacion'}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        Error al eliminar el empleado
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.mensaje == 'empleado-creado'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        Empleado creado exitosamente
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.mensaje == 'empleado-actualizado'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        Empleado actualizado exitosamente
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${param.mensaje == 'empleado-eliminado'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        Empleado eliminado exitosamente
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Lista de empleados -->
                <c:choose>
                    <c:when test="${empty empleados}">
                        <div class="text-center py-5">
                            <div class="card">
                                <div class="card-body py-5">
                                    <i class="bi bi-people display-1 text-muted mb-3"></i>
                                    <h3 class="text-muted">No hay empleados registrados</h3>
                                    <p class="text-muted">Comienza agregando tu primer empleado</p>
                                    <a href="${pageContext.request.contextPath}/admin/empleados/memory?accion=nuevo" 
                                       class="btn btn-primary">
                                        <i class="bi bi-person-plus me-2"></i>
                                        Agregar Empleado
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <c:forEach var="empleado" items="${empleados}">
                                <div class="col-md-6 col-lg-4 mb-4">
                                    <div class="card employee-card h-100">
                                        <div class="card-body">
                                            <div class="d-flex align-items-start mb-3">
                                                <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" 
                                                     style="width: 50px; height: 50px;">
                                                    <i class="bi bi-person-fill fs-5"></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <h5 class="card-title mb-1">${empleado.nombre} ${empleado.apellido}</h5>
                                                    <span class="cargo-badge">${empleado.cargo}</span>
                                                </div>
                                                <span class="status-badge ${empleado.activo ? 'bg-success' : 'bg-danger'}">
                                                    ${empleado.activo ? 'Activo' : 'Inactivo'}
                                                </span>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <div class="d-flex align-items-center mb-2">
                                                    <i class="bi bi-telephone me-2 text-muted"></i>
                                                    <small class="text-muted">${empleado.telefono}</small>
                                                </div>
                                                <div class="d-flex align-items-center mb-2">
                                                    <i class="bi bi-envelope me-2 text-muted"></i>
                                                    <small class="text-muted">${empleado.email}</small>
                                                </div>
                                                <c:if test="${not empty empleado.salario}">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <i class="bi bi-currency-dollar me-2 text-muted"></i>
                                                        <small class="text-muted">
                                                            <fmt:formatNumber value="${empleado.salario}" type="currency" currencySymbol="$"/>
                                                        </small>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty empleado.direccion}">
                                                    <div class="d-flex align-items-start">
                                                        <i class="bi bi-geo-alt me-2 text-muted mt-1"></i>
                                                        <small class="text-muted">${empleado.direccion}</small>
                                                    </div>
                                                </c:if>
                                            </div>
                                            
                                            <div class="d-flex gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/empleados/memory?accion=editar&id=${empleado.id}" 
                                                   class="btn btn-outline-primary btn-sm flex-fill">
                                                    <i class="bi bi-pencil me-1"></i>
                                                    Editar
                                                </a>
                                                <button class="btn btn-outline-danger btn-sm flex-fill" 
                                                        onclick="eliminarEmpleado(${empleado.id}, '${empleado.nombre} ${empleado.apellido}')">
                                                    <i class="bi bi-trash me-1"></i>
                                                    Eliminar
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>

    <!-- Modal de confirmación -->
    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>¿Estás seguro de que deseas eliminar al empleado <strong id="empleadoNombre"></strong>?</p>
                    <p class="text-muted small">Esta acción no se puede deshacer.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="id" id="empleadoId">
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function eliminarEmpleado(id, nombre) {
            document.getElementById('empleadoId').value = id;
            document.getElementById('empleadoNombre').textContent = nombre;
            new bootstrap.Modal(document.getElementById('confirmModal')).show();
        }
    </script>
</body>
</html>
