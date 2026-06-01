<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.FeeBill" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fee Bill List</title>
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
        th { background: #273c75; color: white; }
        .btn {
            display: inline-block;
            padding: 6px 12px;
            background: #44bd32;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .btn:hover { background: #218c2b; }
        .success { color: green; }
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
            <h2>Fee Bill List</h2>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <a class="btn" href="<%=request.getContextPath()%>/showGenerateFeeBill">Generate New Bill</a>

            <table>
                <tr>
                    <th>Bill ID</th>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Month</th>
                    <th>Year</th>
                    <th>Total</th>
                    <th>Paid</th>
                    <th>Balance</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>

                <%
                    List<FeeBill> billList = (List<FeeBill>) request.getAttribute("billList");
                    if(billList != null && !billList.isEmpty()) {
                        for(FeeBill bill : billList) {
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
                    <td>
                        <a class="btn"
                           href="<%=request.getContextPath()%>/showAddFeePayment?billId=<%=bill.getBillId()%>&studentId=<%=bill.getStudentId()%>">
                           Add Payment
                        </a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="11">No fee bills found.</td>
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