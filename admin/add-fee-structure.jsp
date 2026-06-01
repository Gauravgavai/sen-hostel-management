<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Fee Structure</title>
</head>
<body>
    <h2>Add Fee Structure</h2>

    <% if(request.getParameter("error") != null){ %>
        <p style="color:red;"><%= request.getParameter("error") %></p>
    <% } %>

    <form action="<%=request.getContextPath()%>/addFeeStructure" method="post">
        <label>Room Type:</label>
        <input type="text" name="roomType" required><br><br>

        <label>Monthly Fee:</label>
        <input type="number" step="0.01" name="monthlyFee" required><br><br>

        <label>Late Fee:</label>
        <input type="number" step="0.01" name="lateFee" value="0"><br><br>

        <label>Remarks:</label>
        <textarea name="remarks"></textarea><br><br>

        <button type="submit">Save</button>
    </form>

    <br>
    <a href="<%=request.getContextPath()%>/listFeeStructures">View Fee Structures</a>
</body>
</html>