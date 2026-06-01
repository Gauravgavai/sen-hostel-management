<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mess Feedback</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f9; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; background: #273c75; color: white; padding: 20px; }
        .sidebar h2 { margin-top: 0; }
        .sidebar a { display: block; color: white; text-decoration: none; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .sidebar a:hover { color: #fbc531; }
        .content { flex: 1; padding: 30px; }
        .card { max-width: 700px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 8px rgba(0,0,0,0.1); }
        input, select, textarea, button { width: 100%; padding: 10px; margin-top: 5px; margin-bottom: 15px; }
        button { background: #273c75; color: white; border: none; cursor: pointer; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/studentMessMenu">Mess Menu</a>
        <a href="<%=request.getContextPath()%>/studentMessAttendance">Mess Attendance</a>
        <a href="<%=request.getContextPath()%>/student/mess-feedback.jsp">Mess Feedback</a>
    </div>

    <div class="content">
        <div class="card">
            <h2>Submit Mess Feedback</h2>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <form action="<%=request.getContextPath()%>/addMessFeedback" method="post">
                <label>Feedback Date</label>
                <input type="date" name="feedbackDate" required>

                <label>Rating</label>
                <select name="rating" required>
                    <option value="">-- Select Rating --</option>
                    <option value="1">1 - Poor</option>
                    <option value="2">2 - Average</option>
                    <option value="3">3 - Good</option>
                    <option value="4">4 - Very Good</option>
                    <option value="5">5 - Excellent</option>
                </select>

                <label>Comments</label>
                <textarea name="comments" rows="5" placeholder="Write your feedback here..." required></textarea>

                <button type="submit">Submit Feedback</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>