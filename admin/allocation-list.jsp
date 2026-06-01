<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.RoomAllocation" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Room Allocation List</title>
    <style>
        body{
            font-family: Arial, sans-serif;
            background:#f4f6f9;
            margin:0;
            padding:30px;
        }
        .container{
            width:98%;
            margin:auto;
            background:#fff;
            padding:20px;
            border-radius:10px;
            box-shadow:0 0 10px rgba(0,0,0,0.1);
        }
        h2{
            text-align:center;
            margin-bottom:20px;
        }
        table{
            width:100%;
            border-collapse:collapse;
        }
        table, th, td{
            border:1px solid #ccc;
        }
        th, td{
            padding:10px;
            text-align:center;
        }
        th{
            background:#007bff;
            color:white;
        }
        .top-link{
            margin-bottom:15px;
            display:flex;
            justify-content:space-between;
            align-items:center;
        }
        .top-link a{
            text-decoration:none;
            background:#28a745;
            color:#fff;
            padding:10px 14px;
            border-radius:6px;
        }
        .msg{
            padding:10px;
            border-radius:5px;
            margin-bottom:15px;
        }
        .success{ background:#d1e7dd; color:#0f5132; }
        .error{ background:#f8d7da; color:#842029; }
        .btn-deactivate{
            background:#dc3545;
            color:#fff;
            padding:6px 10px;
            text-decoration:none;
            border-radius:4px;
            font-size:13px;
        }
        .inactive{
            color:#6c757d;
            font-weight:bold;
        }
        .active{
            color:#198754;
            font-weight:bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Room Allocation List</h2>

    <% if(request.getParameter("success") != null){ %>
        <div class="msg success"><%= request.getParameter("success") %></div>
    <% } %>

    <% if(request.getParameter("error") != null){ %>
        <div class="msg error"><%= request.getParameter("error") %></div>
    <% } %>

    <div class="top-link">
        <a href="<%=request.getContextPath()%>/admin/allocate-room.jsp">+ Allocate Room</a>
        <a href="<%=request.getContextPath()%>/adminDashboard">Back to Dashboard</a>
    </div>

    <table>
        <tr>
            <th>ID</th>
            <th>Student</th>
            <th>Email</th>
            <th>Room</th>
            <th>Block</th>
            <th>Allocated On</th>
            <th>Deallocated On</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <%
            List<RoomAllocation> allocationList = (List<RoomAllocation>) request.getAttribute("allocationList");
            if(allocationList != null && !allocationList.isEmpty()){
                for(RoomAllocation ra : allocationList){
        %>
        <tr>
            <td><%= ra.getAllocationId() %></td>
            <td><%= ra.getStudentName() %></td>
            <td><%= ra.getEmail() %></td>
            <td><%= ra.getRoomNumber() %></td>
            <td><%= ra.getBlock() %></td>
            <td><%= ra.getAllocationDate() %></td>
            <td><%= ra.getDeallocationDate() == null ? "-" : ra.getDeallocationDate() %></td>
            <td>
                <% if("ACTIVE".equalsIgnoreCase(ra.getStatus())) { %>
                    <span class="active">ACTIVE</span>
                <% } else { %>
                    <span class="inactive">INACTIVE</span>
                <% } %>
            </td>
            <td>
                <% if("ACTIVE".equalsIgnoreCase(ra.getStatus())) { %>
                    <a class="btn-deactivate"
                       href="<%=request.getContextPath()%>/deactivateRoomAllocation?id=<%= ra.getAllocationId() %>"
                       onclick="return confirm('Deactivate this allocation?');">
                       Deactivate
                    </a>
                <% } else { %>
                    -
                <% } %>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="9">No allocations found.</td>
        </tr>
        <%
            }
        %>
    </table>
</div>
</body>
</html>