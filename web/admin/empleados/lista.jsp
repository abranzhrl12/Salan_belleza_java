<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        .table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .avatar-sm {
            width: 40px;
            height: 40px;
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
                    <h1 class="h2">Gestión de Empleados</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-download me-1"></i>
                                Exportar
                            </button>
                        </div>
                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#nuevoEmpleadoModal">
                            <i class="bi bi-plus me-1"></i>
                            Nuevo Empleado
                        </button>
                    </div>
                </div>

                <!-- Filtros -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control" placeholder="Buscar empleado..." id="searchInput">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="cargoFilter">
                            <option value="">Todos los cargos</option>
                            <option value="ESTILISTA">Estilista</option>
                            <option value="MANICURISTA">Manicurista</option>
                            <option value="ESTETICISTA">Esteticista</option>
                            <option value="RECEPCIONISTA">Recepcionista</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" id="estadoFilter">
                            <option value="">Todos los estados</option>
                            <option value="true">Activo</option>
                            <option value="false">Inactivo</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-outline-secondary w-100" onclick="limpiarFiltros()">
                            <i class="bi bi-arrow-clockwise"></i>
                        </button>
                    </div>
                </div>

                <!-- Tabla de Empleados -->
                <div class="table-container">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="empleadosTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Empleado</th>
                                    <th>Cargo</th>
                                    <th>Teléfono</th>
                                    <th>Email</th>
                                    <th>Fecha Ingreso</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                <i class="bi bi-person-fill"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">Ana López</div>
                                                <small class="text-muted">ID: EMP001</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-primary">Estilista</span></td>
                                    <td>+1 (555) 123-4567</td>
                                    <td>ana.lopez@salon.com</td>
                                    <td>15 Ene 2023</td>
                                    <td><span class="badge bg-success">Activo</span></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary" title="Ver">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning" title="Editar">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" title="Eliminar">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                <i class="bi bi-person-fill"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">Carlos Martínez</div>
                                                <small class="text-muted">ID: EMP002</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-info">Colorista</span></td>
                                    <td>+1 (555) 234-5678</td>
                                    <td>carlos.martinez@salon.com</td>
                                    <td>22 Feb 2023</td>
                                    <td><span class="badge bg-success">Activo</span></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary" title="Ver">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning" title="Editar">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" title="Eliminar">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-warning text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                <i class="bi bi-person-fill"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">María González</div>
                                                <small class="text-muted">ID: EMP003</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-warning">Manicurista</span></td>
                                    <td>+1 (555) 345-6789</td>
                                    <td>maria.gonzalez@salon.com</td>
                                    <td>10 Mar 2023</td>
                                    <td><span class="badge bg-success">Activo</span></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary" title="Ver">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning" title="Editar">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" title="Eliminar">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                <i class="bi bi-person-fill"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">Pedro Sánchez</div>
                                                <small class="text-muted">ID: EMP004</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-success">Esteticista</span></td>
                                    <td>+1 (555) 456-7890</td>
                                    <td>pedro.sanchez@salon.com</td>
                                    <td>05 Abr 2023</td>
                                    <td><span class="badge bg-success">Activo</span></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary" title="Ver">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning" title="Editar">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" title="Eliminar">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center me-3">
                                                <i class="bi bi-person-fill"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold">Laura Torres</div>
                                                <small class="text-muted">ID: EMP005</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-secondary">Recepcionista</span></td>
                                    <td>+1 (555) 567-8901</td>
                                    <td>laura.torres@salon.com</td>
                                    <td>18 May 2023</td>
                                    <td><span class="badge bg-danger">Inactivo</span></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary" title="Ver">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-warning" title="Editar">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" title="Eliminar">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Paginación -->
                <nav aria-label="Paginación de empleados" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">Anterior</a>
                        </li>
                        <li class="page-item active">
                            <a class="page-link" href="#">1</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">2</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">3</a>
                        </li>
                        <li class="page-item">
                            <a class="page-link" href="#">Siguiente</a>
                        </li>
                    </ul>
                </nav>
            </main>
        </div>
    </div>

    <!-- Modal Nuevo Empleado -->
    <div class="modal fade" id="nuevoEmpleadoModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nuevo Empleado</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="nuevoEmpleadoForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="nombre" class="form-label">Nombre</label>
                                    <input type="text" class="form-control" id="nombre" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="apellido" class="form-label">Apellido</label>
                                    <input type="text" class="form-control" id="apellido" required>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="telefono" class="form-label">Teléfono</label>
                                    <input type="tel" class="form-control" id="telefono" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" required>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="cargo" class="form-label">Cargo</label>
                                    <select class="form-select" id="cargo" required>
                                        <option value="">Seleccionar cargo</option>
                                        <option value="ESTILISTA">Estilista</option>
                                        <option value="MANICURISTA">Manicurista</option>
                                        <option value="ESTETICISTA">Esteticista</option>
                                        <option value="RECEPCIONISTA">Recepcionista</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="salario" class="form-label">Salario</label>
                                    <input type="number" class="form-control" id="salario" step="0.01" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="direccion" class="form-label">Dirección</label>
                            <textarea class="form-control" id="direccion" rows="2"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" onclick="guardarEmpleado()">Guardar</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Filtros de búsqueda
        document.getElementById('searchInput').addEventListener('input', function() {
            filtrarTabla();
        });

        document.getElementById('cargoFilter').addEventListener('change', function() {
            filtrarTabla();
        });

        document.getElementById('estadoFilter').addEventListener('change', function() {
            filtrarTabla();
        });

        function filtrarTabla() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const cargoFilter = document.getElementById('cargoFilter').value;
            const estadoFilter = document.getElementById('estadoFilter').value;
            const rows = document.querySelectorAll('#empleadosTable tbody tr');

            rows.forEach(row => {
                const nombre = row.cells[0].textContent.toLowerCase();
                const cargo = row.cells[1].textContent;
                const estado = row.cells[5].textContent;

                const matchesSearch = nombre.includes(searchTerm);
                const matchesCargo = !cargoFilter || cargo.includes(cargoFilter);
                const matchesEstado = !estadoFilter || 
                    (estadoFilter === 'true' && estado.includes('Activo')) ||
                    (estadoFilter === 'false' && estado.includes('Inactivo'));

                if (matchesSearch && matchesCargo && matchesEstado) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function limpiarFiltros() {
            document.getElementById('searchInput').value = '';
            document.getElementById('cargoFilter').value = '';
            document.getElementById('estadoFilter').value = '';
            filtrarTabla();
        }

        function guardarEmpleado() {
            // Simular guardado
            alert('Empleado guardado exitosamente');
            document.getElementById('nuevoEmpleadoForm').reset();
            bootstrap.Modal.getInstance(document.getElementById('nuevoEmpleadoModal')).hide();
        }
    </script>
</body>
</html>