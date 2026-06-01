<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.Visitor" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Visitors</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f9; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar {
            width: 220px;
            background: #273c75;
            color: white;
            padding: 20px;
        }
        .sidebar h2 { margin-top: 0; }
        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }
        .sidebar a:hover { color: #fbc531; }
        .content { flex: 1; padding: 30px; }
        .card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background: #273c75;
            color: white;
        }
        .success { color: green; }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/student/add-visitor.jsp">Add Visitor</a>
        <a href="<%=request.getContextPath()%>/studentVisitors">My Visitors</a>
    </div>

    <div class="content">
        <div class="card">
            <h2>My Visitor Logs</h2>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Visitor Name</th>
                    <th>Mobile</th>
                    <th>Relation</th>
                    <th>Purpose</th>
                    <th>Visit Date</th>
                    <th>Expected Time</th>
                    <th>Approval</th>
                    <th>Visit Status</th>
                    <th>Admin Remark</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                </tr>

                <%
                    List<Visitor> visitorList = (List<Visitor>) request.getAttribute("visitorList");
                    if(visitorList != null && !visitorList.isEmpty()) {
                        for(Visitor v : visitorList) {
                %>
                <tr>
                    <td><%= v.getVisitorId() %></td>
                    <td><%= v.getVisitorName() %></td>
                    <td><%= v.getMobile() %></td>
                    <td><%= v.getRelationType() %></td>
                    <td><%= v.getPurpose() %></td>
                    <td><%= v.getVisitDate() %></td>
                    <td><%= v.getExpectedInTime() %></td>
                    <td><%= v.getApprovalStatus() %></td>
                    <td><%= v.getVisitStatus() %></td>
                    <td><%= v.getAdminRemark() %></td>
                    <td><%= v.getActualInTime() %></td>
                    <td><%= v.getActualOutTime() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="12">No visitor logs found.</td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>
</div>
</body>
</html>