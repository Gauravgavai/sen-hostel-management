package com.senhostel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotV3DAO;
import com.senhostel.model.ChatFAQ;
import com.senhostel.util.AIIntegrationUtil;
import com.senhostel.util.TextMatcherUtil;

@WebServlet("/chatbotV3")
public class ChatbotV3Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            out.print("{\"reply\":\"Session expired. Please login again.\",\"chatId\":0}");
            return;
        }

        int studentId = Integer.parseInt(session.getAttribute("studentId").toString());
        String userMessage = request.getParameter("message");

        if (userMessage == null || userMessage.trim().isEmpty()) {
            out.print("{\"reply\":\"Please type something.\",\"chatId\":0}");
            return;
        }

        String normalizedMessage = userMessage.trim().toLowerCase();
        ChatbotV3DAO dao = new ChatbotV3DAO();

        String botReply = "";
        String intentName = "unknown";
        String sourceType = "rule_based";
        double confidence = 0.70;

        if (normalizedMessage.contains("hello") || normalizedMessage.contains("hi")
                || normalizedMessage.contains("hey") || normalizedMessage.contains("namaste")) {
            botReply = "Hello " + dao.getStudentName(studentId) + "! Ask me about room status, fee due, complaints, profile, vacant rooms, or hostel FAQs.";
            intentName = "greeting";
            confidence = 0.99;

        } else if (normalizedMessage.contains("room") || normalizedMessage.contains("mera room")) {
            botReply = dao.getStudentRoomStatus(studentId);
            intentName = "room_status";
            confidence = 0.95;

        } else if (normalizedMessage.contains("fee") || normalizedMessage.contains("due") || normalizedMessage.contains("meri fee")) {
            botReply = dao.getStudentFeeDue(studentId);
            intentName = "fee_due";
            confidence = 0.95;

        } else if (normalizedMessage.contains("complaint") || normalizedMessage.contains("issue")) {
            botReply = dao.getComplaintStatus(studentId);
            intentName = "complaint_status";
            confidence = 0.93;

        } else if (normalizedMessage.contains("profile") || normalizedMessage.contains("my details") || normalizedMessage.contains("meri profile")) {
            botReply = dao.getStudentProfile(studentId);
            intentName = "profile";
            confidence = 0.94;

        } else if (normalizedMessage.contains("vacant") || normalizedMessage.contains("khali") || normalizedMessage.contains("vacancy")) {
            botReply = dao.getVacantRooms();
            intentName = "vacant_rooms";
            confidence = 0.92;

        } else {
            List<ChatFAQ> faqs = dao.getActiveFAQs("student");
            List<String> questions = new ArrayList<String>();

            for (ChatFAQ faq : faqs) {
                questions.add(faq.getQuestion());
            }

            String bestMatch = TextMatcherUtil.findBestMatch(normalizedMessage, questions);

            if (bestMatch != null) {
                for (ChatFAQ faq : faqs) {
                    if (faq.getQuestion().equalsIgnoreCase(bestMatch)) {
                        botReply = faq.getAnswer();
                        intentName = faq.getIntentName();
                        sourceType = "faq";
                        confidence = 0.88;
                        break;
                    }
                }
            } else {
                botReply = AIIntegrationUtil.askOpenAI(userMessage);
                intentName = "ai_fallback";
                sourceType = "ai_fallback";
                confidence = 0.60;
            }
        }

        int chatId = dao.saveChatHistory(studentId, "student", userMessage, botReply, intentName, sourceType, confidence);

        botReply = botReply.replace("\\", "\\\\").replace("\"", "\\\"");
        intentName = intentName.replace("\\", "\\\\").replace("\"", "\\\"");
        sourceType = sourceType.replace("\\", "\\\\").replace("\"", "\\\"");

        out.print("{\"reply\":\"" + botReply + "\",\"chatId\":" + chatId + ",\"intent\":\"" + intentName + "\",\"source\":\"" + sourceType + "\"}");
    }
}