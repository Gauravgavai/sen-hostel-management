<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Fee Payment</title>
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
        .readonly-box {
            background: #f1f2f6;
        }
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
            <h2>Add Fee Payment</h2>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <form action="<%=request.getContextPath()%>/addFeePayment" method="post">
                <label>Bill ID</label>
                <input class="readonly-box" type="number" name="billId"
                       value="<%= request.getAttribute("billId") != null ? request.getAttribute("billId") : "" %>" required readonly>

                <label>Student ID</label>
                <input class="readonly-box" type="number" name="studentId"
                       value="<%= request.getAttribute("studentId") != null ? request.getAttribute("studentId") : "" %>" required readonly>

                <label>Student Name</label>
                <input class="readonly-box" type="text"
                       value="<%= request.getAttribute("studentName") != null ? request.getAttribute("studentName") : "" %>" readonly>

                <label>Student Email</label>
                <input class="readonly-box" type="text"
                       value="<%= request.getAttribute("studentEmail") != null ? request.getAttribute("studentEmail") : "" %>" readonly>

                <label>Amount Paid</label>
                <input type="number" step="0.01" name="amountPaid" required>

                <label>Payment Date</label>
                <input type="date" name="paymentDate" required>

                <label>Payment Mode</label>
                <select name="paymentMode" required>
                    <option value="">-- Select Mode --</option>
                    <option value="Cash">Cash</option>
                    <option value="UPI">UPI</option>
                    <option value="Card">Card</option>
                    <option value="Bank Transfer">Bank Transfer</option>
                </select>

                <label>Remarks</label>
                <textarea name="remarks"></textarea>

                <button type="submit">Save Payment</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>