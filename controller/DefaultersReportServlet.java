package com.senhostel.controller;

import java.io.IOException;
import java.util.List;

import com.senhostel.dao.FeeBillDAO;
import com.senhostel.model.FeeBill;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/defaultersReport")
public class DefaultersReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        FeeBillDAO dao = new FeeBillDAO();
        List<FeeBill> defaulterList = dao.getDefaulters();

        request.setAttribute("defaulterList", defaulterList);
        request.getRequestDispatcher("/admin/defaulters-report.jsp").forward(request, response);
    }
}