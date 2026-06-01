<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.Employee" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Management</title>
    <style>
        *{box-sizing:border-box;}
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f9; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 240px; background: #1e272e; color: white; padding: 20px; }
        .sidebar h2 { margin-top: 0; font-size: 22px; }
        .sidebar a { display: block; color: #d2dae2; text-decoration: none; padding: 12px 10px; margin-bottom: 6px; border-radius: 6px; }
        .sidebar a:hover { background: #485460; color: #fff; }
        .content { flex: 1; padding: 30px; }
        .page-title { margin-bottom: 20px; }
        .stats { display: grid; grid-template-columns: repeat(4,1fr); gap: 15px; margin-bottom: 25px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .stat-card h3 { margin: 0 0 8px; color: #555; font-size: 16px; }
        .stat-card p { margin: 0; font-size: 28px; font-weight: bold; color: #273c75; }
        .card { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 25px; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; }
        label { font-weight: bold; display: block; margin-bottom: 6px; color: #333; }
        input, select, textarea { width: 100%; padding: 11px 12px; border: 1px solid #dcdde1; border-radius: 8px; margin-bottom: 15px; }
        textarea { resize: vertical; min-height: 90px; }
        button {
            background: #273c75; color: white; border: none; padding: 12px 20px;
            border-radius: 8px; cursor: pointer; font-weight: bold;
        }
        button:hover { background: #192a56; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { padding: 12px; border-bottom: 1px solid #eee; text-align: left; vertical-align: top; }
        th { background: #273c75; color: white; }
        .badge-active {
            background: #d4f8e8; color: #1e824c; padding: 6px 10px; border-radius: 20px; font-size: 12px; font-weight: bold;
        }
        .badge-inactive {
            background: #ffe0e0; color: #c0392b; padding: 6px 10px; border-radius: 20px; font-size: 12px; font-weight: bold;
        }
        .actions a {
            text-decoration: none; padding: 8px 12px; border-radius: 6px; color: white; margin-right: 5px; font-size: 13px;
        }
        .edit-btn { background: #00a8ff; }
        .delete-btn { background: #e84118; }
        .photo-box {
            width: 55px; height: 55px; border-radius: 50%; background: #dfe6e9;
            display: flex; align-items: center; justify-content: center; font-weight: bold; color: #2d3436;
        }
        @media(max-width: 992px){
            .stats, .grid-2, .grid-3 { grid-template-columns: 1fr; }
            .sidebar { width: 210px; }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/viewEmployees">Employee Management</a>
    </div>

    <div class="content">
        <div class="page-title">
            <h1>Employee Management</h1>
            <p>Manage hostel staff records, roles, shifts and employment status.</p>
        </div>

        <div class="stats">
            <div class="stat-card">
                <h3>Total Employees</h3>
                <p><%= request.getAttribute("totalEmployees") %></p>
            </div>
            <div class="stat-card">
                <h3>Active Employees</h3>
                <p><%= request.getAttribute("activeEmployees") %></p>
            </div>
            <div class="stat-card">
                <h3>Inactive Employees</h3>
                <p><%= request.getAttribute("inactiveEmployees") %></p>
            </div>
            <div class="stat-card">
                <h3>Wardens</h3>
                <p><%= request.getAttribute("wardensCount") %></p>
            </div>
        </div>

        <div class="card">
            <h2>Add New Employee</h2>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>

            <form action="<%=request.getContextPath()%>/addEmployee" method="post">
                <div class="grid-2">
                    <div>
                        <label>Full Name</label>
                        <input type="text" name="fullName" required>
                    </div>
                    <div>
                        <label>Gender</label>
                        <select name="gender">
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>

                <div class="grid-3">
                    <div>
                        <label>Phone</label>
                        <input type="text" name="phone" required>
                    </div>
                    <div>
                        <label>Email</label>
                        <input type="email" name="email">
                    </div>
                    <div>
                        <label>Emergency Contact</label>
                        <input type="text" name="emergencyContact">
                    </div>
                </div>

                <div class="grid-3">
                    <div>
                        <label>Role</label>
                        <select name="role" required>
                            <option value="Warden">Warden</option>
                            <option value="Assistant Warden">Assistant Warden</option>
                            <option value="Security">Security</option>
                            <option value="Cleaner">Cleaner</option>
                            <option value="Mess Staff">Mess Staff</option>
                            <option value="Accountant">Accountant</option>
                            <option value="Caretaker">Caretaker</option>
                        </select>
                    </div>
                    <div>
                        <label>Department</label>
                        <input type="text" name="department" placeholder="Administration / Security / Mess">
                    </div>
                    <div>
                        <label>Shift Timing</label>
                        <input type="text" name="shiftTiming" placeholder="8 AM - 4 PM">
                    </div>
                </div>

                <div class="grid-3">
                    <div>
                        <label>Salary</label>
                        <input type="number" step="0.01" name="salary" required>
                    </div>
                    <div>
                        <label>Joining Date</label>
                        <input type="date" name="joiningDate" required>
                    </div>
                    <div>
                        <label>Status</label>
                        <select name="status">
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="grid-2">
                    <div>
                        <label>Photo Path</label>
                        <input type="text" name="photoPath" placeholder="assets/images/staff1.jpg">
                    </div>
                    <div>
                        <label>Address</label>
                        <textarea name="address"></textarea>
                    </div>
                </div>

                <button type="submit">Add Employee</button>
            </form>
        </div>

        <div class="card">
            <h2>All Employees</h2>
            <table>
                <tr>
                    <th>Profile</th>
                    <th>Employee Info</th>
                    <th>Role & Shift</th>
                    <th>Salary</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>

                <%
                    List<Employee> employeeList = (List<Employee>) request.getAttribute("employeeList");
                    if(employeeList != null && !employeeList.isEmpty()) {
                        for(Employee emp : employeeList) {
                            String initials = "";
                            if(emp.getFullName() != null && emp.getFullName().length() > 0) {
                                String[] words = emp.getFullName().split(" ");
                                for(String w : words){
                                    if(w.length() > 0) initials += w.substring(0,1).toUpperCase();
                                }
                            }
                %>
                <tr>
                    <td>
                        <div class="photo-box"><%= initials %></div>
                    </td>
                    <td>
                        <strong><%= emp.getFullName() %></strong><br>
                        ID: EMP-<%= emp.getEmployeeId() %><br>
                        Phone: <%= emp.getPhone() %><br>
                        Email: <%= emp.getEmail() %><br>
                        Joined: <%= emp.getJoiningDate() %>
                    </td>
                    <td>
                        <strong><%= emp.getRole() %></strong><br>
                        Dept: <%= emp.getDepartment() %><br>
                        Shift: <%= emp.getShiftTiming() %>
                    </td>
                    <td>₹ <%= emp.getSalary() %></td>
                    <td>
                        <% if("Active".equalsIgnoreCase(emp.getStatus())) { %>
                            <span class="badge-active"><%= emp.getStatus() %></span>
                        <% } else { %>
                            <span class="badge-inactive"><%= emp.getStatus() %></span>
                        <% } %>
                    </td>
                    <td class="actions">
                        <a class="edit-btn" href="<%=request.getContextPath()%>/editEmployee?id=<%= emp.getEmployeeId() %>">Edit</a>
                        <a class="delete-btn" href="<%=request.getContextPath()%>/deleteEmployee?id=<%= emp.getEmployeeId() %>"
                           onclick="return confirm('Are you sure you want to delete this employee?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6">No employees found.</td>
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