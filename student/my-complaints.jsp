<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.Complaint" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Complaints</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f6fa; }
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
        <a href="<%=request.getContextPath()%>/student/add-complaint.jsp">Submit Complaint</a>
        <a href="<%=request.getContextPath()%>/studentComplaints">My Complaints</a>
    </div>

    <div class="content">
        <div class="card">
            <h2>My Complaints</h2>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Admin Remark</th>
                    <th>Created At</th>
                    <th>Updated At</th>
                </tr>

                <%
                    List<Complaint> complaintList = (List<Complaint>) request.getAttribute("complaintList");
                    if(complaintList != null && !complaintList.isEmpty()) {
                        for(Complaint c : complaintList) {
                %>
                <tr>
                    <td><%= c.getComplaintId() %></td>
                    <td><%= c.getTitle() %></td>
                    <td><%= c.getCategory() %></td>
                    <td><%= c.getDescription() %></td>
                    <td><%= c.getStatus() %></td>
                    <td><%= c.getAdminRemark() %></td>
                    <td><%= c.getCreatedAt() %></td>
                    <td><%= c.getUpdatedAt() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8">No complaints found.</td>
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