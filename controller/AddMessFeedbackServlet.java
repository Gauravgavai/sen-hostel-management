package com.senhostel.controller;

import java.io.IOException;
import java.sql.Date;

import com.senhostel.dao.MessDAO;
import com.senhostel.model.MessFeedback;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addMessFeedback")
public class AddMessFeedbackServlet extends HttpServlet {
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

            MessFeedback feedback = new MessFeedback();
            feedback.setStudentId(studentId);
            feedback.setFeedbackDate(Date.valueOf(request.getParameter("feedbackDate")));
            feedback.setRating(Integer.parseInt(request.getParameter("rating")));
            feedback.setComments(request.getParameter("comments"));

            MessDAO dao = new MessDAO();
            boolean status = dao.addFeedback(feedback);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/student/mess-feedback.jsp?success=Feedback submitted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/mess-feedback.jsp?error=Unable to submit feedback");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/mess-feedback.jsp?error=Invalid feedback data");
        }
    }
}