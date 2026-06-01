<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate Fee Bill</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f6fa; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar {
            width: 230px;
            background: #2f3640;
            color: white;
            padding: 20px;
        }
        .sidebar h2 { margin-top: 0; font-size: 22px; }
        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 10px 0;
            border-bottom: 1px solid #444;
        }
        .sidebar a:hover { color: #00a8ff; }
        .content {
            flex: 1;
            padding: 30px;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            max-width: 700px;
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
        button:hover { background: #192a56; }
        .error { color: red; }
    </style>
</head>
<body>
<div class="wrapper">

    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/listFeeStructures">Fee Structure</a>
        <a href="<%=request.getContextPath()%>/showGenerateFeeBill">Generate Bill</a>
        <a href="<%=request.getContextPath()%>/listFeeBills">Bill List</a>
        <a href="<%=request.getContextPath()%>/showAddFeePayment">Add Payment</a>
        <a href="<%=request.getContextPath()%>/defaultersReport">Defaulters Report</a>
    </div>

    <div class="content">
        <div class="card">
            <h2>Generate Fee Bill</h2>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <form action="<%=request.getContextPath()%>/generateFeeBill" method="post">
                <label>Select Student</label>
                <select name="studentId" required>
                    <option value="">-- Select Student --</option>
                    <%
                        List<String[]> studentList = (List<String[]>) request.getAttribute("studentList");
                        if(studentList != null){
                            for(String[] student : studentList){
                    %>
                    <option value="<%= student[0] %>">
                        <%= student[0] %> - <%= student[1] %> (<%= student[2] %>)
                    </option>
                    <%
                            }
                        }
                    %>
                </select>

                <label>Bill Month</label>
                <input type="number" name="billMonth" min="1" max="12" required>

                <label>Bill Year</label>
                <input type="number" name="billYear" required>

                <label>Total Amount</label>
                <input type="number" step="0.01" name="totalAmount" required>

                <label>Due Date</label>
                <input type="date" name="dueDate" required>

                <button type="submit">Generate Bill</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>