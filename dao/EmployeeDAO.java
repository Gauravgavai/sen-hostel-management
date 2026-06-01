package com.senhostel.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.Employee;
import com.senhostel.util.DBConnection;

public class EmployeeDAO {

    public boolean addEmployee(Employee emp) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO employees(full_name, gender, phone, email, role, department, shift_timing, salary, joining_date, address, emergency_contact, photo_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, emp.getFullName());
            ps.setString(2, emp.getGender());
            ps.setString(3, emp.getPhone());
            ps.setString(4, emp.getEmail());
            ps.setString(5, emp.getRole());
            ps.setString(6, emp.getDepartment());
            ps.setString(7, emp.getShiftTiming());
            ps.setDouble(8, emp.getSalary());
            ps.setDate(9, emp.getJoiningDate());
            ps.setString(10, emp.getAddress());
            ps.setString(11, emp.getEmergencyContact());
            ps.setString(12, emp.getPhotoPath());
            ps.setString(13, emp.getStatus());

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<Employee>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM employees ORDER BY employee_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Employee emp = new Employee();
                emp.setEmployeeId(rs.getInt("employee_id"));
                emp.setFullName(rs.getString("full_name"));
                emp.setGender(rs.getString("gender"));
                emp.setPhone(rs.getString("phone"));
                emp.setEmail(rs.getString("email"));
                emp.setRole(rs.getString("role"));
                emp.setDepartment(rs.getString("department"));
                emp.setShiftTiming(rs.getString("shift_timing"));
                emp.setSalary(rs.getDouble("salary"));
                emp.setJoiningDate(rs.getDate("joining_date"));
                emp.setAddress(rs.getString("address"));
                emp.setEmergencyContact(rs.getString("emergency_contact"));
                emp.setPhotoPath(rs.getString("photo_path"));
                emp.setStatus(rs.getString("status"));
                emp.setCreatedAt(rs.getTimestamp("created_at"));
                emp.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(emp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return list;
    }

    public Employee getEmployeeById(int employeeId) {
        Employee emp = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM employees WHERE employee_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, employeeId);
            rs = ps.executeQuery();

            if (rs.next()) {
                emp = new Employee();
                emp.setEmployeeId(rs.getInt("employee_id"));
                emp.setFullName(rs.getString("full_name"));
                emp.setGender(rs.getString("gender"));
                emp.setPhone(rs.getString("phone"));
                emp.setEmail(rs.getString("email"));
                emp.setRole(rs.getString("role"));
                emp.setDepartment(rs.getString("department"));
                emp.setShiftTiming(rs.getString("shift_timing"));
                emp.setSalary(rs.getDouble("salary"));
                emp.setJoiningDate(rs.getDate("joining_date"));
                emp.setAddress(rs.getString("address"));
                emp.setEmergencyContact(rs.getString("emergency_contact"));
                emp.setPhotoPath(rs.getString("photo_path"));
                emp.setStatus(rs.getString("status"));
                emp.setCreatedAt(rs.getTimestamp("created_at"));
                emp.setUpdatedAt(rs.getTimestamp("updated_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return emp;
    }

    public boolean updateEmployee(Employee emp) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE employees SET full_name=?, gender=?, phone=?, email=?, role=?, department=?, shift_timing=?, salary=?, joining_date=?, address=?, emergency_contact=?, photo_path=?, status=? WHERE employee_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, emp.getFullName());
            ps.setString(2, emp.getGender());
            ps.setString(3, emp.getPhone());
            ps.setString(4, emp.getEmail());
            ps.setString(5, emp.getRole());
            ps.setString(6, emp.getDepartment());
            ps.setString(7, emp.getShiftTiming());
            ps.setDouble(8, emp.getSalary());
            ps.setDate(9, emp.getJoiningDate());
            ps.setString(10, emp.getAddress());
            ps.setString(11, emp.getEmergencyContact());
            ps.setString(12, emp.getPhotoPath());
            ps.setString(13, emp.getStatus());
            ps.setInt(14, emp.getEmployeeId());

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    public boolean deleteEmployee(int employeeId) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM employees WHERE employee_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, employeeId);

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    public int getTotalEmployees() {
        return getCountByQuery("SELECT COUNT(*) FROM employees");
    }

    public int getActiveEmployees() {
        return getCountByQuery("SELECT COUNT(*) FROM employees WHERE status='Active'");
    }

    public int getInactiveEmployees() {
        return getCountByQuery("SELECT COUNT(*) FROM employees WHERE status='Inactive'");
    }

    public int getWardensCount() {
        return getCountByQuery("SELECT COUNT(*) FROM employees WHERE role='Warden'");
    }

    private int getCountByQuery(String sql) {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return count;
    }
}