package com.senhostel.controller;

import java.io.IOException;
import java.util.List;

import com.senhostel.dao.MessDAO;
import com.senhostel.model.MessAttendance;
import com.senhostel.model.MessFeedback;
import com.senhostel.model.MessMenu;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/adminMessDashboard")
public class AdminMessDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        MessDAO dao = new MessDAO();
        List<MessMenu> menuList = dao.getAllMenus();
        List<MessAttendance> attendanceList = dao.getAllAttendance();
        List<MessFeedback> feedbackList = dao.getAllFeedback();

        request.setAttribute("menuList", menuList);
        request.setAttribute("attendanceList", attendanceList);
        request.setAttribute("feedbackList", feedbackList);

        request.getRequestDispatcher("/admin/mess-management.jsp").forward(request, response);
    }
}