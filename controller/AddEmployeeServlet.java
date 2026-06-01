package com.senhostel.controller;

import java.io.IOException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.EmployeeDAO;
import com.senhostel.model.Employee;

@WebServlet("/addEmployee")
public class AddEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        try {
            Employee emp = new Employee();
            emp.setFullName(request.getParameter("fullName"));
            emp.setGender(request.getParameter("gender"));
            emp.setPhone(request.getParameter("phone"));
            emp.setEmail(request.getParameter("email"));
            emp.setRole(request.getParameter("role"));
            emp.setDepartment(request.getParameter("department"));
            emp.setShiftTiming(request.getParameter("shiftTiming"));
            emp.setSalary(Double.parseDouble(request.getParameter("salary")));
            emp.setJoiningDate(Date.valueOf(request.getParameter("joiningDate")));
            emp.setAddress(request.getParameter("address"));
            emp.setEmergencyContact(request.getParameter("emergencyContact"));
            emp.setPhotoPath(request.getParameter("photoPath"));
            emp.setStatus(request.getParameter("status"));

            EmployeeDAO dao = new EmployeeDAO();
            boolean status = dao.addEmployee(emp);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/viewEmployees?success=Employee added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/viewEmployees?error=Unable to add employee");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/viewEmployees?error=Invalid employee data");
        }
    }
}