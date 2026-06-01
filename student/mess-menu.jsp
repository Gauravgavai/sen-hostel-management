<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.MessMenu" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mess Menu</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f9; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; background: #273c75; color: white; padding: 20px; }
        .sidebar h2 { margin-top: 0; }
        .sidebar a { display: block; color: white; text-decoration: none; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.2); }
        .sidebar a:hover { color: #fbc531; }
        .content { flex: 1; padding: 30px; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 8px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background: #273c75; color: white; }
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
            <h2>Mess Menu</h2>
            <table>
                <tr>
                    <th>Date</th>
                    <th>Breakfast</th>
                    <th>Lunch</th>
                    <th>Dinner</th>
                    <th>Special Note</th>
                </tr>
                <%
                    List<MessMenu> menuList = (List<MessMenu>) request.getAttribute("menuList");
                    if(menuList != null && !menuList.isEmpty()) {
                        for(MessMenu m : menuList) {
                %>
                <tr>
                    <td><%= m.getMenuDate() %></td>
                    <td><%= m.getBreakfast() %></td>
                    <td><%= m.getLunch() %></td>
                    <td><%= m.getDinner() %></td>
                    <td><%= m.getSpecialNote() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5">No menu found.</td>
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