<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.FeeStructure" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fee Structure List</title>
</head>
<body>
    <h2>Fee Structure List</h2>

    <% if(request.getParameter("success") != null){ %>
        <p style="color:green;"><%= request.getParameter("success") %></p>
    <% } %>

    <a href="<%=request.getContextPath()%>/admin/add-fee-structure.jsp">Add New Fee Structure</a>
    <br><br>

    <table border="1" cellpadding="10">
        <tr>
            <th>ID</th>
            <th>Room Type</th>
            <th>Monthly Fee</th>
            <th>Late Fee</th>
            <th>Remarks</th>
        </tr>

        <%
            List<FeeStructure> feeStructureList = (List<FeeStructure>) request.getAttribute("feeStructureList");
            if(feeStructureList != null && !feeStructureList.isEmpty()) {
                for(FeeStructure fs : feeStructureList) {
        %>
        <tr>
            <td><%= fs.getFeeId() %></td>
            <td><%= fs.getRoomType() %></td>
            <td><%= fs.getMonthlyFee() %></td>
            <td><%= fs.getLateFee() %></td>
            <td><%= fs.getRemarks() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="5">No fee structure found.</td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>