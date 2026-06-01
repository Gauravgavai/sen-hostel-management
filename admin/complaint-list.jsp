<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.Complaint" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Complaints</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f6fa; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar {
            width: 230px;
            background: #2f3640;
            color: white;
            padding: 20px;
        }
        .sidebar h2 { margin-top: 0; }
        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 10px 0;
            border-bottom: 1px solid #444;
        }
        .sidebar a:hover { color: #00a8ff; }
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
            vertical-align: top;
        }
        th { background: #c23616; color: white; }
        select, textarea {
            width: 100%;
            padding: 6px;
            margin-bottom: 5px;
        }
        button {
            background: #273c75;
            color: white;
            border: none;
            padding: 7px 12px;
            cursor: pointer;
        }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
<div class="wrapper">

    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/adminComplaints">Complaint List</a>
        <a href="<%=request.getContextPath()%>/listFeeBills">Fee Bills</a>
        <a href="<%=request.getContextPath()%>/defaultersReport">Defaulters</a>
    </div>

    <div class="content">
        <div class="card">
            <h2>Complaint List</h2>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <table>
                <tr>
                    <th>ID</th>
                    <th>Student</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Admin Remark</th>
                    <th>Created</th>
                    <th>Update Status</th>
                </tr>

                <%
                    List<Complaint> complaintList = (List<Complaint>) request.getAttribute("complaintList");
                    if(complaintList != null && !complaintList.isEmpty()) {
                        for(Complaint c : complaintList) {
                %>
                <tr>
                    <td><%= c.getComplaintId() %></td>
                    <td><%= c.getStudentId() %> - <%= c.getStudentName() %></td>
                    <td><%= c.getTitle() %></td>
                    <td><%= c.getCategory() %></td>
                    <td><%= c.getDescription() %></td>
                    <td><%= c.getStatus() %></td>
                    <td><%= c.getAdminRemark() %></td>
                    <td><%= c.getCreatedAt() %></td>
                    <td>
                        <form action="<%=request.getContextPath()%>/updateComplaintStatus" method="post">
                            <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">

                            <select name="status" required>
                                <option value="Pending" <%= "Pending".equals(c.getStatus()) ? "selected" : "" %>>Pending</option>
                                <option value="In Progress" <%= "In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                                <option value="Resolved" <%= "Resolved".equals(c.getStatus()) ? "selected" : "" %>>Resolved</option>
                            </select>

                            <textarea name="adminRemark" rows="3" placeholder="Enter admin remark"><%= c.getAdminRemark() != null ? c.getAdminRemark() : "" %></textarea>

                            <button type="submit">Update</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="9">No complaints found.</td>
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