package com.senhostel.controller;

import java.io.IOException;
import java.util.List;

import com.senhostel.dao.ComplaintDAO;
import com.senhostel.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/adminComplaints")
public class AdminComplaintListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        ComplaintDAO dao = new ComplaintDAO();
        List<Complaint> complaintList = dao.getAllComplaints();

        request.setAttribute("complaintList", complaintList);
        request.getRequestDispatcher("/admin/complaint-list.jsp").forward(request, response);
    }
}