<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Visitor Request</title>
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
            max-width: 800px;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        label { font-weight: bold; }
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
        <a href="<%=request.getContextPath()%>/student/add-visitor.jsp">Add Visitor</a>
        <a href="<%=request.getContextPath()%>/studentVisitors">My Visitors</a>
    </div>

    <div class="content">
        <div class="card">
            <h2>Visitor Request Form</h2>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <form action="<%=request.getContextPath()%>/addVisitorRequest" method="post">
                <label>Visitor Name</label>
                <input type="text" name="visitorName" required>

                <label>Mobile Number</label>
                <input type="text" name="mobile" required>

                <label>Relation</label>
                <select name="relationType" required>
                    <option value="">-- Select Relation --</option>
                    <option value="Parent">Parent</option>
                    <option value="Guardian">Guardian</option>
                    <option value="Sibling">Sibling</option>
                    <option value="Friend">Friend</option>
                    <option value="Relative">Relative</option>
                </select>

                <label>Purpose</label>
                <textarea name="purpose" rows="4" required></textarea>

                <label>Visit Date</label>
                <input type="date" name="visitDate" required>

                <label>Expected In Time</label>
                <input type="time" name="expectedInTime" required>

                <button type="submit">Submit Visitor Request</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>