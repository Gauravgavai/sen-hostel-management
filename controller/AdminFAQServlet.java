package com.senhostel.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotV3DAO;
import com.senhostel.model.ChatFAQ;

@WebServlet("/adminFaq")
public class AdminFAQServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        ChatbotV3DAO dao = new ChatbotV3DAO();
        List<ChatFAQ> faqList = dao.getActiveFAQs("student");

        request.setAttribute("faqList", faqList);
        request.getRequestDispatcher("/admin/faq-training.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        ChatFAQ faq = new ChatFAQ();
        faq.setQuestion(request.getParameter("question"));
        faq.setAnswer(request.getParameter("answer"));
        faq.setIntentName(request.getParameter("intentName"));
        faq.setRoleType(request.getParameter("roleType"));
        faq.setStatus("Active");

        ChatbotV3DAO dao = new ChatbotV3DAO();
        dao.addFAQ(faq);

        response.sendRedirect(request.getContextPath() + "/adminFaq");
    }
}