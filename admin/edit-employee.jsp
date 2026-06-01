<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.senhostel.model.Employee" %>
<%
    Employee emp = (Employee) request.getAttribute("employee");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Employee</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 30px; }
        .card {
            max-width: 900px; margin: auto; background: white; padding: 25px;
            border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .grid-2, .grid-3 { display: grid; gap: 15px; }
        .grid-2 { grid-template-columns: 1fr 1fr; }
        .grid-3 { grid-template-columns: 1fr 1fr 1fr; }
        label { font-weight: bold; display:block; margin-bottom: 6px; }
        input, select, textarea {
            width: 100%; padding: 11px 12px; border: 1px solid #dcdde1; border-radius: 8px; margin-bottom: 15px;
        }
        textarea { min-height: 90px; }
        button {
            background: #273c75; color: white; border: none; padding: 12px 18px;
            border-radius: 8px; cursor: pointer; font-weight: bold;
        }
        a.back {
            display: inline-block; margin-bottom: 15px; text-decoration: none; color: #273c75; font-weight: bold;
        }
        @media(max-width: 768px){
            .grid-2, .grid-3 { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="card">
        <a class="back" href="<%=request.getContextPath()%>/viewEmployees">← Back to Employee Management</a>
        <h2>Edit Employee</h2>

        <form action="<%=request.getContextPath()%>/updateEmployee" method="post">
            <input type="hidden" name="employeeId" value="<%= emp.getEmployeeId() %>">

            <div class="grid-2">
                <div>
                    <label>Full Name</label>
                    <input type="text" name="fullName" value="<%= emp.getFullName() %>" required>
                </div>
                <div>
                    <label>Gender</label>
                    <select name="gender">
                        <option value="Male" <%= "Male".equals(emp.getGender()) ? "selected" : "" %>>Male</option>
                        <option value="Female" <%= "Female".equals(emp.getGender()) ? "selected" : "" %>>Female</option>
                        <option value="Other" <%= "Other".equals(emp.getGender()) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
            </div>

            <div class="grid-3">
                <div>
                    <label>Phone</label>
                    <input type="text" name="phone" value="<%= emp.getPhone() %>" required>
                </div>
                <div>
                    <label>Email</label>
                    <input type="email" name="email" value="<%= emp.getEmail() %>">
                </div>
                <div>
                    <label>Emergency Contact</label>
                    <input type="text" name="emergencyContact" value="<%= emp.getEmergencyContact() %>">
                </div>
            </div>

            <div class="grid-3">
                <div>
                    <label>Role</label>
                    <select name="role">
                        <option value="Warden" <%= "Warden".equals(emp.getRole()) ? "selected" : "" %>>Warden</option>
                        <option value="Assistant Warden" <%= "Assistant Warden".equals(emp.getRole()) ? "selected" : "" %>>Assistant Warden</option>
                        <option value="Security" <%= "Security".equals(emp.getRole()) ? "selected" : "" %>>Security</option>
                        <option value="Cleaner" <%= "Cleaner".equals(emp.getRole()) ? "selected" : "" %>>Cleaner</option>
                        <option value="Mess Staff" <%= "Mess Staff".equals(emp.getRole()) ? "selected" : "" %>>Mess Staff</option>
                        <option value="Accountant" <%= "Accountant".equals(emp.getRole()) ? "selected" : "" %>>Accountant</option>
                        <option value="Caretaker" <%= "Caretaker".equals(emp.getRole()) ? "selected" : "" %>>Caretaker</option>
                    </select>
                </div>
                <div>
                    <label>Department</label>
                    <input type="text" name="department" value="<%= emp.getDepartment() %>">
                </div>
                <div>
                    <label>Shift Timing</label>
                    <input type="text" name="shiftTiming" value="<%= emp.getShiftTiming() %>">
                </div>
            </div>

            <div class="grid-3">
                <div>
                    <label>Salary</label>
                    <input type="number" step="0.01" name="salary" value="<%= emp.getSalary() %>" required>
                </div>
                <div>
                    <label>Joining Date</label>
                    <input type="date" name="joiningDate" value="<%= emp.getJoiningDate() %>" required>
                </div>
                <div>
                    <label>Status</label>
                    <select name="status">
                        <option value="Active" <%= "Active".equals(emp.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(emp.getStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>
            </div>

            <div class="grid-2">
                <div>
                    <label>Photo Path</label>
                    <input type="text" name="photoPath" value="<%= emp.getPhotoPath() %>">
                </div>
                <div>
                    <label>Address</label>
                    <textarea name="address"><%= emp.getAddress() %></textarea>
                </div>
            </div>

            <button type="submit">Update Employee</button>
        </form>
    </div>
</body>
</html>