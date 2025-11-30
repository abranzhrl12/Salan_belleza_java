<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrativo - Salon de Belleza</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
            --light-bg: #f8fafc;
            --dark-text: #1f2937;
            --border-radius: 12px;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--light-bg);
        }

        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: var(--shadow-lg);
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.85);
            border-radius: var(--border-radius);
            margin: 4px 8px;
            padding: 12px 16px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }

        .sidebar .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transition: left 0.5s;
        }

        .sidebar .nav-link:hover::before {
            left: 100%;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(8px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .main-content {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
            margin-left: 250px;
            padding: 0;
        }

        .stats-card {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: white;
            position: relative;
            overflow: hidden;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }

        .stats-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
        }

        .stats-card.border-left-primary::before { background: var(--primary-color); }
        .stats-card.border-left-success::before { background: var(--success-color); }
        .stats-card.border-left-info::before { background: var(--info-color); }
        .stats-card.border-left-warning::before { background: var(--warning-color); }

        .table-container {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }

        .avatar-sm {
            width: 40px;
            height: 40px;
            font-size: 16px;
        }

        .badge {
            font-size: 0.75rem;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .btn {
            border-radius: var(--border-radius);
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .table th {
            background-color: #f8fafc;
            border-bottom: 2px solid #e5e7eb;
            font-weight: 600;
            color: var(--dark-text);
            padding: 16px;
        }

        .table td {
            padding: 16px;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        .table tbody tr:hover {
            background-color: #f8fafc;
        }

        .card-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-bottom: 1px solid #e5e7eb;
            font-weight: 600;
            color: var(--dark-text);
        }

        .text-primary { color: var(--primary-color) !important; }
        .text-success { color: var(--success-color) !important; }
        .text-info { color: var(--info-color) !important; }
        .text-warning { color: var(--warning-color) !important; }

        .bg-primary { background-color: var(--primary-color) !important; }
        .bg-success { background-color: var(--success-color) !important; }
        .bg-info { background-color: var(--info-color) !important; }
        .bg-warning { background-color: var(--warning-color) !important; }

        .border-left-primary { border-left: 4px solid var(--primary-color) !important; }
        .border-left-success { border-left: 4px solid var(--success-color) !important; }
        .border-left-info { border-left: 4px solid var(--info-color) !important; }
        .border-left-warning { border-left: 4px solid var(--warning-color) !important; }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            .main-content {
                margin-left: 0;
            }
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
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                                <i class="bi bi-house-door me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/empleados/lista.jsp">
                                <i class="bi bi-people me-2"></i>
                                Empleados (BD)
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/empleados/memory">
                                <i class="bi bi-people-fill me-2"></i>
                                Empleados (Memoria)
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
                    <h1 class="h2">Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-download me-1"></i>
                                Exportar
                            </button>
                        </div>
                        <button type="button" class="btn btn-sm btn-primary">
                            <i class="bi bi-plus me-1"></i>
                            Nueva Cita
                        </button>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card border-left-primary">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                            Empleados Activos
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">12</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-people-fill fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card border-left-success">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                            Citas Hoy
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">8</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-calendar-check-fill fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card border-left-info">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                            Ventas del Mes
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">$15,420</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-currency-dollar fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card border-left-warning">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                            Clientes Nuevos
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">24</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="bi bi-person-plus-fill fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="table-container">
                            <div class="card-header bg-white">
                                <h6 class="m-0 font-weight-bold text-primary">Citas Recientes</h6>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Cliente</th>
                                                <th>Servicio</th>
                                                <th>Empleado</th>
                                                <th>Fecha</th>
                                                <th>Hora</th>
                                                <th>Estado</th>
                                                <th>Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2">
                                                            <i class="bi bi-person-fill"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold">María González</div>
                                                            <small class="text-muted">maria@email.com</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Corte y Peinado</td>
                                                <td>Ana López</td>
                                                <td>16 Oct 2024</td>
                                                <td>10:00 AM</td>
                                                <td><span class="badge bg-success">Confirmada</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-2">
                                                            <i class="bi bi-person-fill"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold">Carlos Rodríguez</div>
                                                            <small class="text-muted">carlos@email.com</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Coloración</td>
                                                <td>Carlos Martínez</td>
                                                <td>16 Oct 2024</td>
                                                <td>2:00 PM</td>
                                                <td><span class="badge bg-warning">Pendiente</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-2">
                                                            <i class="bi bi-person-fill"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold">Laura Sánchez</div>
                                                            <small class="text-muted">laura@email.com</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Manicure</td>
                                                <td>María González</td>
                                                <td>17 Oct 2024</td>
                                                <td>11:00 AM</td>
                                                <td><span class="badge bg-primary">Programada</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="avatar-sm bg-warning text-white rounded-circle d-flex align-items-center justify-content-center me-2">
                                                            <i class="bi bi-person-fill"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold">Pedro Torres</div>
                                                            <small class="text-muted">pedro@email.com</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>Tratamiento Facial</td>
                                                <td>Pedro Sánchez</td>
                                                <td>17 Oct 2024</td>
                                                <td>3:00 PM</td>
                                                <td><span class="badge bg-success">Confirmada</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="table-container">
                            <div class="card-header bg-white">
                                <h6 class="m-0 font-weight-bold text-primary" data-i18n="admin.active_emp.title">Empleados Activos</h6>
                            </div>
                            <div class="card-body p-4">
                                <div class="employee-item d-flex align-items-center p-3 mb-3 bg-light rounded-3 border-start border-4 border-primary">
                                    <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-4" style="width: 45px; height: 45px;">
                                        <i class="bi bi-person-fill fs-6"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-bold fs-6 mb-1">Ana López</div>
                                        <small class="text-muted">Estilista Senior</small>
                                    </div>
                                    <div class="ms-3">
                                        <span class="badge bg-success px-3 py-2">Disponible</span>
                                    </div>
                                </div>
                                
                                <div class="employee-item d-flex align-items-center p-3 mb-3 bg-light rounded-3 border-start border-4 border-success">
                                    <div class="avatar-sm bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-4" style="width: 45px; height: 45px;">
                                        <i class="bi bi-person-fill fs-6"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-bold fs-6 mb-1">Carlos Martínez</div>
                                        <small class="text-muted">Colorista</small>
                                    </div>
                                    <div class="ms-3">
                                        <span class="badge bg-warning px-3 py-2">Ocupado</span>
                                    </div>
                                </div>
                                
                                <div class="employee-item d-flex align-items-center p-3 mb-3 bg-light rounded-3 border-start border-4 border-info">
                                    <div class="avatar-sm bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-4" style="width: 45px; height: 45px;">
                                        <i class="bi bi-person-fill fs-6"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-bold fs-6 mb-1">María González</div>
                                        <small class="text-muted">Manicurista</small>
                                    </div>
                                    <div class="ms-3">
                                        <span class="badge bg-success px-3 py-2">Disponible</span>
                                    </div>
                                </div>
                                
                                <div class="employee-item d-flex align-items-center p-3 bg-light rounded-3 border-start border-4 border-warning">
                                    <div class="avatar-sm bg-warning text-white rounded-circle d-flex align-items-center justify-content-center me-4" style="width: 45px; height: 45px;">
                                        <i class="bi bi-person-fill fs-6"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="fw-bold fs-6 mb-1">Pedro Sánchez</div>
                                        <small class="text-muted">Esteticista</small>
                                    </div>
                                    <div class="ms-3">
                                        <span class="badge bg-primary px-3 py-2">En Descanso</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Activar navegación activa
        const currentPage = window.location.pathname;
        document.querySelectorAll('.sidebar .nav-link').forEach(link => {
            if (link.getAttribute('href') === currentPage) {
                link.classList.add('active');
            }
        });
    </script>
    <button id="langToggle" class="btn btn-dark" style="position: fixed; bottom: 30px; left: 30px; z-index: 1000; border-radius: 50%; width: 65px; height: 65px; padding: 0; display: flex; align-items: center; justify-content: center; font-weight: bold; border: 2px solid rgba(255,255,255,0.1); box-shadow: 0 10px 25px rgba(0,0,0,0.3); transition: transform 0.3s ease, box-shadow 0.3s ease;">
        <span style="font-size: 1.2rem;">🇺🇸</span>
    </button>
    <script src="../../js/translation.js"></script>
</body>
</html>