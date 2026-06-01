<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Room</title>
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
            background:#007bff;
            color:white;
            border:none;
            padding:12px;
            border-radius:6px;
            cursor:pointer;
        }
        button:hover{
            background:#0056b3;
        }
        .error{
            color:red;
            text-align:center;
            margin-bottom:10px;
        }
        .link{
            text-align:center;
            margin-top:15px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Add New Room</h2>

    <% if(request.getParameter("error") != null){ %>
        <div class="error">Room insert failed or duplicate room number.</div>
    <% } %>

    <form action="<%=request.getContextPath()%>/addRoom" method="post">
        <label>Room Number</label>
        <input type="text" name="roomNumber" required>

        <label>Block</label>
        <input type="text" name="block" required>

        <label>Floor</label>
        <input type="number" name="floor" required>

        <label>Room Type</label>
        <select name="roomType" required>
            <option value="">Select Type</option>
            <option value="Single">Single</option>
            <option value="Double">Double</option>
            <option value="Triple">Triple</option>
            <option value="Dormitory">Dormitory</option>
        </select>

        <label>Capacity</label>
        <input type="number" name="capacity" required>

        <label>Occupied</label>
        <input type="number" name="occupied" value="0" required>

        <label>Fees</label>
        <input type="number" step="0.01" name="fees" required>

        <label>Status</label>
        <select name="status" required>
            <option value="Available">Available</option>
            <option value="Full">Full</option>
            <option value="Maintenance">Maintenance</option>
        </select>

        <button type="submit">Add Room</button>
    </form>

    <div class="link">
        <a href="<%=request.getContextPath()%>/listRooms">View Room List</a>
    </div>
</div>
</body>
</html>