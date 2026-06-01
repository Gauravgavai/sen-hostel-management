package com.senhostel.controller;

import java.io.IOException;

import com.senhostel.dao.ComplaintDAO;
import com.senhostel.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addComplaint")
public class AddComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/student/student-login.jsp");
            return;
        }

        try {
            int studentId = Integer.parseInt(session.getAttribute("studentId").toString());

            Complaint complaint = new Complaint();
            complaint.setStudentId(studentId);
            complaint.setTitle(request.getParameter("title"));
            complaint.setDescription(request.getParameter("description"));
            complaint.setCategory(request.getParameter("category"));

            ComplaintDAO dao = new ComplaintDAO();
            boolean status = dao.addComplaint(complaint);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/studentComplaints?success=Complaint submitted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/add-complaint.jsp?error=Unable to submit complaint");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/add-complaint.jsp?error=Invalid data");
        }
    }
}