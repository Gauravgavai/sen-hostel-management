<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminUser = (String) session.getAttribute("adminUser");
    if (adminUser == null) {
        response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
        return;
    }

    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    Integer totalRooms = (Integer) request.getAttribute("totalRooms");
    Integer vacantRooms = (Integer) request.getAttribute("vacantRooms");
    Integer pendingComplaints = (Integer) request.getAttribute("pendingComplaints");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (totalStudents == null) totalStudents = 0;
    if (totalRooms == null) totalRooms = 0;
    if (vacantRooms == null) vacantRooms = 0;
    if (pendingComplaints == null) pendingComplaints = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:Arial, sans-serif;
        }
        body{
            background:#020617;
            color:#e5e7eb;
        }

        /* SIDEBAR */
        .sidebar{
            width:240px;
            height:100vh;
            background:linear-gradient(180deg,#020617,#020617 45%,#020617);
            border-right:1px solid rgba(148,163,184,0.25);
            position:fixed;
            left:0;
            top:0;
            padding:22px 18px;
            overflow-y:auto;
        }
        .sidebar h2{
            color:#22d3ee;
            margin-bottom:22px;
            font-size:18px;
            letter-spacing:0.08em;
            text-transform:uppercase;
        }
        .nav-section-title{
            font-size:11px;
            text-transform:uppercase;
            letter-spacing:0.14em;
            color:#64748b;
            margin:16px 4px 6px;
        }
        .sidebar a{
            display:block;
            color:#cbd5e1;
            text-decoration:none;
            padding:9px 10px;
            margin:3px 0;
            border-radius:8px;
            transition:0.25s;
            font-size:14px;
        }
        .sidebar a:hover{
            background:#1e293b;
            color:#22d3ee;
            transform:translateX(2px);
        }

        /* MAIN AREA */
        .main{
            margin-left:260px;
            padding:26px 30px 40px;
        }

        .topbar{
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:10px;
            margin-bottom:24px;
        }
        .top-left{
            display:flex;
            flex-direction:column;
            gap:4px;
        }
        .topbar h1{
            font-size:24px;
        }
        .subtitle{
            font-size:13px;
            color:#9ca3af;
        }
        .pill{
            display:inline-block;
            padding:4px 10px;
            border-radius:999px;
            border:1px solid rgba(148,163,184,0.4);
            font-size:11px;
            color:#93c5fd;
        }
        .logout-btn{
            background:#ef4444;
            color:white;
            padding:9px 16px;
            border-radius:999px;
            text-decoration:none;
            font-size:13px;
            font-weight:bold;
        }
        .logout-btn:hover{
            background:#dc2626;
        }

        /* SUMMARY STRIP */
        .summary-strip{
            background:radial-gradient(circle at top left, rgba(56,189,248,0.12), transparent 55%), 
                        radial-gradient(circle at bottom right, rgba(129,140,248,0.18), transparent 60%), 
                        #020617;
            border:1px solid rgba(148,163,184,0.28);
            border-radius:16px;
            padding:16px 18px;
            margin-bottom:22px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:10px;
        }
        .summary-strip-text{
            font-size:13px;
            color:#cbd5e1;
        }
        .summary-strip-text span{
            color:#e5e7eb;
            font-weight:bold;
        }
        .quick-actions{
            display:flex;
            gap:10px;
            flex-wrap:wrap;
        }
        .btn-outline{
            padding:8px 14px;
            border-radius:999px;
            border:1px solid #38bdf8;
            color:#e0f2fe;
            font-size:12px;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            gap:6px;
        }
        .btn-outline:hover{
            background:#0f172a;
        }

        /* CARDS GRID */
        .section-title{
            font-size:16px;
            margin-bottom:8px;
        }
        .section-subtitle{
            font-size:13px;
            color:#9ca3af;
            margin-bottom:14px;
        }

        .cards{
            display:grid;
            grid-template-columns:repeat(auto-fit, minmax(210px, 1fr));
            gap:16px;
        }
        .card{
            background:#020617;
            padding:18px 18px 16px;
            border-radius:14px;
            border:1px solid rgba(148,163,184,0.25);
            box-shadow:0 14px 35px rgba(15,23,42,0.6);
            position:relative;
            overflow:hidden;
        }
        .card::before{
            content:"";
            position:absolute;
            right:-30px;
            top:-30px;
            width:90px;
            height:90px;
            border-radius:50%;
            background:radial-gradient(circle, rgba(56,189,248,0.25), transparent 55%);
            opacity:0.5;
        }
        .card-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:6px;
        }
        .card-title{
            font-size:13px;
            color:#cbd5e1;
        }
        .card-badge{
            font-size:10px;
            padding:2px 8px;
            border-radius:999px;
            border:1px solid rgba(148,163,184,0.4);
            color:#a5b4fc;
        }
        .card-value{
            font-size:30px;
            font-weight:bold;
            color:#22d3ee;
            margin:4px 0;
        }
        .card-meta{
            font-size:11px;
            color:#9ca3af;
        }

        /* SPECIAL COLORS */
        .card-danger .card-value{
            color:#fb7185;
        }
        .card-success .card-value{
            color:#4ade80;
        }

        /* OVERVIEW SECTION */
        .section{
            margin-top:26px;
            background:#020617;
            border-radius:16px;
            border:1px solid rgba(148,163,184,0.25);
            padding:18px 18px 20px;
        }
        .modules-grid{
            display:grid;
            grid-template-columns:repeat(auto-fit, minmax(220px, 1fr));
            gap:16px;
            margin-top:12px;
        }
        .module-card{
            background:#020617;
            border-radius:12px;
            border:1px solid rgba(148,163,184,0.25);
            padding:14px;
        }
        .module-title{
            font-size:14px;
            margin-bottom:6px;
        }
        .module-desc{
            font-size:12px;
            color:#9ca3af;
            margin-bottom:10px;
        }
        .module-link{
            font-size:12px;
            color:#93c5fd;
            text-decoration:none;
        }
        .module-link:hover{
            text-decoration:underline;
        }

        .error{
            margin-top:16px;
            background:#7f1d1d;
            color:#fecaca;
            padding:10px;
            border-radius:10px;
            font-size:13px;
        }

        @media (max-width: 780px) {
            .main{
                margin-left:0;
                padding:20px;
            }
            .sidebar{
                position:static;
                width:100%;
                height:auto;
                display:flex;
                flex-wrap:wrap;
                gap:6px;
            }
            .sidebar h2{
                width:100%;
            }
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Hostel Admin</h2>

    <div class="nav-section-title">Main</div>
    <a href="<%= request.getContextPath() %>/adminDashboard">Dashboard</a>
    <a href="<%=request.getContextPath()%>/viewStudents">Students</a>
    <a href="<%=request.getContextPath()%>/listRooms">Rooms</a>

    <div class="nav-section-title">Operations</div>
    <a href="<%=request.getContextPath()%>/listFeeBills">Fees</a>
    <a href="<%=request.getContextPath()%>/adminComplaints">Complaints</a>
    <a href="<%=request.getContextPath()%>/adminVisitors">Visitors</a>
    <a href="<%=request.getContextPath()%>/adminMessDashboard">Mess</a>
    <a href="<%=request.getContextPath()%>/reportsDashboard">Reports</a>

    <div class="nav-section-title">Advanced</div>
    <a href="<%=request.getContextPath()%>/listRoomAllocations">Room Allocation</a>
    <a href="<%=request.getContextPath()%>/viewEmployees">Employees</a>
    <a href="<%=request.getContextPath()%>/viewEvents">Event Calendar</a>
    <a href="<%=request.getContextPath()%>/admin/admin-qr-scanner.jsp">QR Scanner</a>
    <a href="<%=request.getContextPath()%>/admin/admin-qr-scanner-v2.jsp">QR Scanner V2 Ultra</a>
    <a href="<%=request.getContextPath()%>/admin/admin-scan-analytics.jsp">Scan Analytics</a>

    <div class="nav-section-title">Account</div>
    <a href="<%= request.getContextPath() %>/adminLogout">Logout</a>
</div>

<div class="main">
    <div class="topbar">
        <div class="top-left">
            <h1>Welcome, <%= adminUser %></h1>
            <div class="subtitle">
                Central control panel for hostel rooms, students, fees and daily operations.
            </div>
            <span class="pill">Live admin console • GHRU Hostel</span>
        </div>
        <a class="logout-btn" href="<%= request.getContextPath() %>/adminLogout">Logout</a>
    </div>

    <div class="summary-strip">
        <div class="summary-strip-text">
            <span><%= totalStudents %></span> students •
            <span><%= totalRooms %></span> rooms •
            <span><%= vacantRooms %></span> currently available •
            <span><%= pendingComplaints %></span> complaints pending
        </div>
        <div class="quick-actions">
            <a href="<%=request.getContextPath()%>/listRoomAllocations" class="btn-outline">Manage Allocations</a>
            <a href="<%=request.getContextPath()%>/listFeeBills" class="btn-outline">View Fees</a>
            <a href="<%=request.getContextPath()%>/admin/admin-qr-scanner-v2.jsp" class="btn-outline">Open QR Scanner</a>
        </div>
    </div>

    <% if (errorMessage != null) { %>
        <div class="error"><%= errorMessage %></div>
    <% } %>

    <div>
        <div class="section-title">Key Metrics</div>
        <div class="section-subtitle">
            Snapshot of current hostel status based on live data from the system.
        </div>

        <div class="cards">
            <div class="card card-success">
                <div class="card-header">
                    <div class="card-title">Total Students</div>
                    <div class="card-badge">Overview</div>
                </div>
                <div class="card-value"><%= totalStudents %></div>
                <div class="card-meta">Number of active students registered in the system.</div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-title">Total Rooms</div>
                    <div class="card-badge">Infrastructure</div>
                </div>
                <div class="card-value"><%= totalRooms %></div>
                <div class="card-meta">All rooms currently configured in the hostel database.</div>
            </div>

            <div class="card card-success">
                <div class="card-header">
                    <div class="card-title">Available Rooms</div>
                    <div class="card-badge">Vacancy</div>
                </div>
                <div class="card-value"><%= vacantRooms %></div>
                <div class="card-meta">Rooms that are not fully occupied and can be allocated.</div>
            </div>

            <div class="card <%= (pendingComplaints > 0 ? "card-danger" : "") %>">
                <div class="card-header">
                    <div class="card-title">Pending Complaints</div>
                    <div class="card-badge">Service</div>
                </div>
                <div class="card-value"><%= pendingComplaints %></div>
                <div class="card-meta">
                    Student complaints waiting for admin/warden action.
                </div>
            </div>
        </div>
    </div>

    <div class="section">
        <h2 class="section-title">Modules Overview</h2>
        <p class="section-subtitle">
            Quickly jump into the most used areas of the hostel management system.
        </p>

        <div class="modules-grid">
            <div class="module-card">
                <div class="module-title">Student Management</div>
                <div class="module-desc">
                    View all registered students and link their allocations and fee history.
                </div>
                <a class="module-link" href="<%=request.getContextPath()%>/viewStudents">Open student list →</a>
            </div>

            <div class="module-card">
                <div class="module-title">Fee & Defaulter Tracking</div>
                <div class="module-desc">
                    Check generated fee bills, payments and defaulter reports in one place.
                </div>
                <a class="module-link" href="<%=request.getContextPath()%>/listFeeBills">Go to fee module →</a>
            </div>

            <div class="module-card">
                <div class="module-title">Complaints & Service Desk</div>
                <div class="module-desc">
                    Monitor, assign and resolve student complaints with live status updates.
                </div>
                <a class="module-link" href="<%=request.getContextPath()%>/adminComplaints">Manage complaints →</a>
            </div>

            <div class="module-card">
                <div class="module-title">Visitors & QR Check-ins</div>
                <div class="module-desc">
                    Track visitors, approvals and QR gate check-ins with scan analytics.
                </div>
                <a class="module-link" href="<%=request.getContextPath()%>/adminVisitors">View visitors →</a>
            </div>

            <div class="module-card">
                <div class="module-title">Mess & Attendance</div>
                <div class="module-desc">
                    Update mess menu, review feedback and monitor daily mess attendance.
                </div>
                <a class="module-link" href="<%=request.getContextPath()%>/adminMessDashboard">Open mess dashboard →</a>
            </div>

            <div class="module-card">
                <div class="module-title">Reports & Analytics</div>
                <div class="module-desc">
                    Export fee, occupancy and QR scan reports for audits and monthly reviews.
                </div>
                <a class="module-link" href="<%=request.getContextPath()%>/reportsDashboard">Open reports module →</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>