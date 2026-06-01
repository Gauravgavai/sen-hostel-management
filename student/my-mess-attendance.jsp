<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.MessAttendance" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mess Attendance</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f9; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; background: #273c75; color: white; padding: 20px; }
        .sidebar h2 { margin-top: 0; }
        .sidebar a { display: block; color: white; text-decoration: none; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .sidebar a:hover { color: #fbc531; }
        .content { flex: 1; padding: 30px; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 8px rgba(0,0,0,0.1); margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background: #273c75; color: white; }
        .success { color: green; }
        .error { color: red; }
        label { font-weight: bold; }
        input, button { padding: 10px; margin-top: 5px; margin-bottom: 10px; }
        button { background: #273c75; color: white; border: none; cursor: pointer; }
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
            <h2>Mark Today's Meal Attendance</h2>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <form action="<%=request.getContextPath()%>/markMessAttendance" method="post">
                <label>Date</label><br>
                <input type="date" name="attendanceDate" required><br>

                <input type="checkbox" name="breakfastStatus" value="Yes"> Breakfast
                <input type="checkbox" name="lunchStatus" value="Yes"> Lunch
                <input type="checkbox" name="dinnerStatus" value="Yes"> Dinner
                <br><br>

                <button type="submit">Save Attendance</button>
            </form>
        </div>

        <div class="card">
            <h2>My Mess Attendance</h2>
            <table>
                <tr>
                    <th>Date</th>
                    <th>Breakfast</th>
                    <th>Lunch</th>
                    <th>Dinner</th>
                    <th>Marked At</th>
                </tr>

                <%
                    List<MessAttendance> attendanceList = (List<MessAttendance>) request.getAttribute("attendanceList");
                    if(attendanceList != null && !attendanceList.isEmpty()) {
                        for(MessAttendance a : attendanceList) {
                %>
                <tr>
                    <td><%= a.getAttendanceDate() %></td>
                    <td><%= a.getBreakfastStatus() %></td>
                    <td><%= a.getLunchStatus() %></td>
                    <td><%= a.getDinnerStatus() %></td>
                    <td><%= a.getMarkedAt() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5">No attendance found.</td>
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