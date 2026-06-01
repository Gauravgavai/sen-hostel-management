package com.senhostel.controller;

import java.io.IOException;
import java.sql.Date;

import com.senhostel.dao.VisitorDAO;
import com.senhostel.model.Visitor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addVisitorRequest")
public class AddVisitorRequestServlet extends HttpServlet {
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

            Visitor visitor = new Visitor();
            visitor.setStudentId(studentId);
            visitor.setVisitorName(request.getParameter("visitorName"));
            visitor.setMobile(request.getParameter("mobile"));
            visitor.setRelationType(request.getParameter("relationType"));
            visitor.setPurpose(request.getParameter("purpose"));
            visitor.setVisitDate(Date.valueOf(request.getParameter("visitDate")));
            visitor.setExpectedInTime(request.getParameter("expectedInTime"));

            VisitorDAO dao = new VisitorDAO();
            boolean status = dao.addVisitorRequest(visitor);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/studentVisitors?success=Visitor request submitted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/add-visitor.jsp?error=Unable to submit visitor request");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/add-visitor.jsp?error=Invalid data");
        }
    }
}