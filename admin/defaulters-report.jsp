<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.FeeBill" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Defaulters Report</title>
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
        }
        th { background: #c23616; color: white; }
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
            <h2>Defaulters Report</h2>

            <table>
                <tr>
                    <th>Bill ID</th>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Month</th>
                    <th>Year</th>
                    <th>Total</th>
                    <th>Paid</th>
                    <th>Balance</th>
                    <th>Due Date</th>
                    <th>Status</th>
                </tr>

                <%
                    List<FeeBill> defaultersList = (List<FeeBill>) request.getAttribute("defaultersList");
                    if(defaultersList != null && !defaultersList.isEmpty()) {
                        for(FeeBill bill : defaultersList) {
                %>
                <tr>
                    <td><%= bill.getBillId() %></td>
                    <td><%= bill.getStudentId() %></td>
                    <td><%= bill.getStudentName() %></td>
                    <td><%= bill.getBillMonth() %></td>
                    <td><%= bill.getBillYear() %></td>
                    <td><%= bill.getTotalAmount() %></td>
                    <td><%= bill.getPaidAmount() %></td>
                    <td><%= bill.getBalanceAmount() %></td>
                    <td><%= bill.getDueDate() %></td>
                    <td><%= bill.getBillStatus() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="10">No defaulters found.</td>
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