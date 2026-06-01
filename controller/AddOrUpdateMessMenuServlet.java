package com.senhostel.controller;

import java.io.IOException;
import java.sql.Date;

import com.senhostel.dao.MessDAO;
import com.senhostel.model.MessMenu;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/saveMessMenu")
public class AddOrUpdateMessMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        try {
            MessMenu menu = new MessMenu();
            menu.setMenuDate(Date.valueOf(request.getParameter("menuDate")));
            menu.setBreakfast(request.getParameter("breakfast"));
            menu.setLunch(request.getParameter("lunch"));
            menu.setDinner(request.getParameter("dinner"));
            menu.setSpecialNote(request.getParameter("specialNote"));

            MessDAO dao = new MessDAO();
            boolean status = dao.addOrUpdateMenu(menu);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/adminMessDashboard?success=Menu saved successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/adminMessDashboard?error=Unable to save menu");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/adminMessDashboard?error=Invalid menu data");
        }
    }
}