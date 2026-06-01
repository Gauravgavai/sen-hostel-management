package com.senhostel.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotV3DAO;

@WebServlet("/chatFeedback")
public class ChatFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            out.print("{\"status\":\"error\",\"message\":\"Session expired.\"}");
            return;
        }

        int studentId = Integer.parseInt(session.getAttribute("studentId").toString());
        int chatId = Integer.parseInt(request.getParameter("chatId"));
        String feedbackType = request.getParameter("feedbackType");

        ChatbotV3DAO dao = new ChatbotV3DAO();
        boolean saved = dao.saveFeedback(chatId, studentId, feedbackType);

        if (saved) {
            out.print("{\"status\":\"success\",\"message\":\"Feedback saved.\"}");
        } else {
            out.print("{\"status\":\"error\",\"message\":\"Unable to save feedback.\"}");
        }
    }
}