package com.senhostel.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotV3DAO;
import com.senhostel.model.ChatAnalytics;

@WebServlet("/chatAnalytics")
public class ChatAnalyticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        ChatbotV3DAO dao = new ChatbotV3DAO();
        ChatAnalytics analytics = dao.getAnalytics();

        request.setAttribute("analytics", analytics);
        request.getRequestDispatcher("/admin/chat-analytics.jsp").forward(request, response);
    }
}