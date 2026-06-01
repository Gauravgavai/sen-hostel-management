package com.senhostel.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.EmployeeDAO;

@WebServlet("/deleteEmployee")
public class DeleteEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        int employeeId = Integer.parseInt(request.getParameter("id"));

        EmployeeDAO dao = new EmployeeDAO();
        boolean status = dao.deleteEmployee(employeeId);

        if (status) {
            response.sendRedirect(request.getContextPath() + "/viewEmployees?success=Employee deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/viewEmployees?error=Unable to delete employee");
        }
    }
}