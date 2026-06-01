<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Complaint</title>
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
            max-width: 750px;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
        }
        button {
            background: #273c75;
            color: white;
            border: none;
            padding: 10px 18px;
            cursor: pointer;
        }
        .error { color: red; }
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
            <h2>Submit Complaint</h2>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <form action="<%=request.getContextPath()%>/addComplaint" method="post">
                <label>Complaint Title</label>
                <input type="text" name="title" required>

                <label>Category</label>
                <select name="category" required>
                    <option value="">-- Select Category --</option>
                    <option value="Electrical">Electrical</option>
                    <option value="Plumbing">Plumbing</option>
                    <option value="Cleaning">Cleaning</option>
                    <option value="Internet">Internet</option>
                    <option value="Others">Others</option>
                </select>

                <label>Description</label>
                <textarea name="description" rows="6" required></textarea>

                <button type="submit">Submit Complaint</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>