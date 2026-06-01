<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.senhostel.model.Room" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Room</title>
    <style>
        body{
            font-family: Arial, sans-serif;
            background:#f4f6f9;
            margin:0;
            padding:30px;
        }
        .container{
            width:500px;
            margin:auto;
            background:#fff;
            padding:25px;
            border-radius:10px;
            box-shadow:0 0 10px rgba(0,0,0,0.1);
        }
        h2{
            text-align:center;
            margin-bottom:20px;
        }
        input, select{
            width:100%;
            padding:10px;
            margin:8px 0 16px 0;
            border:1px solid #ccc;
            border-radius:6px;
        }
        button{
            width:100%;
            background:#ffc107;
            color:#000;
            border:none;
            padding:12px;
            border-radius:6px;
            cursor:pointer;
        }
        button:hover{
            background:#e0a800;
        }
        .link{
            text-align:center;
            margin-top:15px;
        }
    </style>
</head>
<body>
<%
    Room room = (Room) request.getAttribute("room");
%>
<div class="container">
    <h2>Edit Room</h2>

    <form action="<%=request.getContextPath()%>/editRoom" method="post">
        <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">

        <label>Room Number</label>
        <input type="text" name="roomNumber" value="<%= room.getRoomNumber() %>" required>

        <label>Block</label>
        <input type="text" name="block" value="<%= room.getBlock() %>" required>

        <label>Floor</label>
        <input type="number" name="floor" value="<%= room.getFloor() %>" required>

        <label>Room Type</label>
        <select name="roomType" required>
            <option value="Single" <%= "Single".equals(room.getRoomType()) ? "selected" : "" %>>Single</option>
            <option value="Double" <%= "Double".equals(room.getRoomType()) ? "selected" : "" %>>Double</option>
            <option value="Triple" <%= "Triple".equals(room.getRoomType()) ? "selected" : "" %>>Triple</option>
            <option value="Dormitory" <%= "Dormitory".equals(room.getRoomType()) ? "selected" : "" %>>Dormitory</option>
        </select>

        <label>Capacity</label>
        <input type="number" name="capacity" value="<%= room.getCapacity() %>" required>

        <label>Occupied</label>
        <input type="number" name="occupied" value="<%= room.getOccupied() %>" required>

        <label>Fees</label>
        <input type="number" step="0.01" name="fees" value="<%= room.getFees() %>" required>

        <label>Status</label>
        <select name="status" required>
            <option value="Available" <%= "Available".equals(room.getStatus()) ? "selected" : "" %>>Available</option>
            <option value="Full" <%= "Full".equals(room.getStatus()) ? "selected" : "" %>>Full</option>
            <option value="Maintenance" <%= "Maintenance".equals(room.getStatus()) ? "selected" : "" %>>Maintenance</option>
        </select>

        <button type="submit">Update Room</button>
    </form>

    <div class="link">
        <a href="<%=request.getContextPath()%>/listRooms">Back to Room List</a>
    </div>
</div>
</body>
</html>