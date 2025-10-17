<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Empleados - Salon de Belleza</title>
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
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.1);
        }
        .badge-cargo {
            font-size: 0.75rem;
            padding: 0.5em 0.75em;
        }
        .btn-action {
            padding: 0.25rem 0.5rem;
            margin: 0 2px;
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
                            <a class="nav-link" href="dashboard.jsp">
                                <i class="bi bi-speedometer2 me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="empleados">
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
                        <i class="bi bi-people-fill me-2"></i>
                        Gestión de Empleados
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="empleados?accion=nuevo" class="btn btn-primary">
                            <i class="bi bi-person-plus-fill me-1"></i>
                            Nuevo Empleado
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
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        Empleado eliminado exitosamente
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Filtros y búsqueda -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="get" action="empleados" class="row g-3">
                            <div class="col-md-6">
                                <label for="termino" class="form-label">Buscar empleado</label>
                                <div class="input-group">
                                    <input type="text" 
                                           class="form-control" 
                                           id="termino" 
                                           name="termino" 
                                           placeholder="Nombre o apellido..."
                                           value="${terminoBusqueda}">
                                    <button class="btn btn-outline-secondary" type="submit" name="accion" value="buscar">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label for="cargo" class="form-label">Filtrar por cargo</label>
                                <select class="form-select" id="cargo" name="cargo">
                                    <option value="">Todos los cargos</option>
                                    <option value="ESTILISTA">Estilista</option>
                                    <option value="COLORISTA">Colorista</option>
                                    <option value="MANICURISTA">Manicurista</option>
                                    <option value="ESTETICISTA">Esteticista</option>
                                    <option value="RECEPCIONISTA">Recepcionista</option>
                                    <option value="SUPERVISOR">Supervisor</option>
                                    <option value="GERENTE">Gerente</option>
                                    <option value="ASISTENTE">Asistente</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2" name="accion" value="buscar">
                                    <i class="bi bi-funnel me-1"></i>
                                    Filtrar
                                </button>
                                <a href="empleados" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-clockwise me-1"></i>
                                    Limpiar
                                </a>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Tabla de empleados -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="bi bi-list-ul me-2"></i>
                            Lista de Empleados
                            <span class="badge bg-primary ms-2">${totalEmpleados}</span>
                        </h5>
                        <div class="btn-group btn-group-sm" role="group">
                            <button type="button" class="btn btn-outline-secondary">
                                <i class="bi bi-download"></i>
                            </button>
                            <button type="button" class="btn btn-outline-secondary">
                                <i class="bi bi-printer"></i>
                            </button>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty empleados}">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Nombre Completo</th>
                                                <th>Email</th>
                                                <th>Teléfono</th>
                                                <th>Cargo</th>
                                                <th>Fecha Contratación</th>
                                                <th>Salario</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="empleado" items="${empleados}">
                                                <tr>
                                                    <td>
                                                        <span class="badge bg-secondary">#${empleado.id}</span>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                                <i class="bi bi-person-fill"></i>
                                                            </div>
                                                            <div>
                                                                <strong>${empleado.nombreCompleto}</strong>
                                                                <br>
                                                                <small class="text-muted">${empleado.email}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${empleado.email}</td>
                                                    <td>
                                                        <i class="bi bi-telephone me-1"></i>
                                                        ${empleado.telefono}
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-cargo bg-info">${empleado.cargo.descripcion}</span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${empleado.fechaContratacion}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty empleado.salario}">
                                                                <fmt:formatNumber value="${empleado.salario}" type="currency" currencySymbol="$"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">No especificado</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empleado.activo}">
                                                                <span class="badge bg-success">Activo</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-danger">Inactivo</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="empleados?accion=editar&id=${empleado.id}" 
                                                               class="btn btn-outline-primary btn-action" 
                                                               title="Editar">
                                                                <i class="bi bi-pencil"></i>
                                                            </a>
                                                            <button type="button" 
                                                                    class="btn btn-outline-danger btn-action" 
                                                                    title="Eliminar"
                                                                    onclick="confirmarEliminacion(${empleado.id}, '${empleado.nombreCompleto}')">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="bi bi-people display-1 text-muted"></i>
                                    <h4 class="text-muted mt-3">No se encontraron empleados</h4>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty terminoBusqueda}">
                                                No se encontraron empleados que coincidan con "${terminoBusqueda}"
                                            </c:when>
                                            <c:otherwise>
                                                Aún no hay empleados registrados en el sistema
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <a href="empleados?accion=nuevo" class="btn btn-primary">
                                        <i class="bi bi-person-plus-fill me-1"></i>
                                        Agregar Primer Empleado
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Modal de confirmación de eliminación -->
    <div class="modal fade" id="modalEliminar" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                        Confirmar Eliminación
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>¿Está seguro de que desea eliminar al empleado <strong id="nombreEmpleado"></strong>?</p>
                    <p class="text-muted small">Esta acción no se puede deshacer.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="#" id="btnConfirmarEliminar" class="btn btn-danger">
                        <i class="bi bi-trash me-1"></i>
                        Eliminar
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmarEliminacion(id, nombre) {
            document.getElementById('nombreEmpleado').textContent = nombre;
            document.getElementById('btnConfirmarEliminar').href = 'empleados?accion=eliminar&id=' + id;
            
            const modal = new bootstrap.Modal(document.getElementById('modalEliminar'));
            modal.show();
        }
    </script>
</body>
</html>
