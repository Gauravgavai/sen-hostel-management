package com.senhostel.controller;

import java.io.IOException;
import java.util.List;

import com.senhostel.dao.VisitorDAO;
import com.senhostel.model.Visitor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/adminVisitors")
public class AdminVisitorListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        VisitorDAO dao = new VisitorDAO();
        List<Visitor> visitorList = dao.getAllVisitors();

        request.setAttribute("visitorList", visitorList);
        request.getRequestDispatcher("/admin/visitor-list.jsp").forward(request, response);
    }
}