<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.senhostel.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Allocate Room</title>
    <style>
        body{
            font-family: Arial, sans-serif;
            background:#f4f6f9;
            margin:0;
            padding:30px;
        }
        .container{
            width:550px;
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
        label{
            font-weight:bold;
        }
        select, button{
            width:100%;
            padding:10px;
            margin:8px 0 16px 0;
            border:1px solid #ccc;
            border-radius:6px;
        }
        button{
            background:#007bff;
            color:white;
            border:none;
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
        .info{
            background:#eef6ff;
            border-left:4px solid #007bff;
            padding:10px;
            margin-bottom:15px;
            border-radius:6px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Allocate Room</h2>

    <div class="info">
        Only unallocated students and rooms with available vacancy are shown.
    </div>

    <% if(request.getParameter("error") != null){ %>
        <div class="error"><%= request.getParameter("error") %></div>
    <% } %>

    <form action="<%=request.getContextPath()%>/addRoomAllocation" method="post">

        <label>Select Student</label>
        <select name="studentId" required>
            <option value="">Select Student</option>
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.getConnection();
                    String sql = "SELECT s.id, s.name, s.email " +
                                 "FROM students s " +
                                 "WHERE s.id NOT IN (" +
                                 "    SELECT ra.student_id FROM room_allocation ra WHERE ra.status='ACTIVE'" +
                                 ") ORDER BY s.name";
                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    while(rs.next()){
            %>
                <option value="<%= rs.getInt("id") %>">
                    <%= rs.getString("name") %> - <%= rs.getString("email") %>
                </option>
            <%
                    }
                } catch(Exception e){
                    e.printStackTrace();
                } finally {
                    try { if(rs != null) rs.close(); } catch(Exception e){}
                    try { if(ps != null) ps.close(); } catch(Exception e){}
                    try { if(con != null) con.close(); } catch(Exception e){}
                }
            %>
        </select>

        <label>Select Available Room</label>
        <select name="roomId" required>
            <option value="">Select Room</option>
            <%
                Connection con2 = null;
                PreparedStatement ps2 = null;
                ResultSet rs2 = null;

                try {
                    con2 = DBConnection.getConnection();
                    String sql2 = "SELECT room_id, room_number, block, capacity, occupied, status " +
                                  "FROM rooms " +
                                  "WHERE status='Available' AND occupied < capacity " +
                                  "ORDER BY room_number";
                    ps2 = con2.prepareStatement(sql2);
                    rs2 = ps2.executeQuery();

                    while(rs2.next()){
                        int capacity = rs2.getInt("capacity");
                        int occupied = rs2.getInt("occupied");
                        int vacancy = capacity - occupied;
            %>
                <option value="<%= rs2.getInt("room_id") %>">
                    Room <%= rs2.getString("room_number") %> | Block <%= rs2.getString("block") %> |
                    Occupied <%= occupied %>/<%= capacity %> | Vacancy <%= vacancy %>
                </option>
            <%
                    }
                } catch(Exception e){
                    e.printStackTrace();
                } finally {
                    try { if(rs2 != null) rs2.close(); } catch(Exception e){}
                    try { if(ps2 != null) ps2.close(); } catch(Exception e){}
                    try { if(con2 != null) con2.close(); } catch(Exception e){}
                }
            %>
        </select>

        <button type="submit">Allocate Room</button>
    </form>

    <div class="link">
        <a href="<%=request.getContextPath()%>/listRoomAllocations">View Allocation List</a>
    </div>
</div>
</body>
</html>