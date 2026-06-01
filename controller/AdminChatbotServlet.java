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

@WebServlet("/adminChatbot")
public class AdminChatbotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminUser") == null) {
            out.print("{\"reply\":\"Admin session expired. Please login again.\",\"chatId\":0}");
            return;
        }

        int adminId = 1;
        String userMessage = request.getParameter("message");

        if (userMessage == null || userMessage.trim().isEmpty()) {
            out.print("{\"reply\":\"Please type something.\",\"chatId\":0}");
            return;
        }

        String normalizedMessage = userMessage.trim().toLowerCase();
        ChatbotV3DAO dao = new ChatbotV3DAO();

        String botReply = "";
        String intentName = "admin_unknown";
        String sourceType = "rule_based";
        double confidence = 0.75;

        if (normalizedMessage.contains("summary") || normalizedMessage.contains("dashboard")
                || normalizedMessage.contains("hostel status")) {
            botReply = dao.getAdminSummary();
            intentName = "admin_summary";
            confidence = 0.97;
        } else {
            List<ChatFAQ> faqs = dao.getActiveFAQs("admin");
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
                intentName = "admin_ai_fallback";
                sourceType = "ai_fallback";
                confidence = 0.62;
            }
        }

        int chatId = dao.saveChatHistory(adminId, "admin", userMessage, botReply, intentName, sourceType, confidence);

        botReply = botReply.replace("\\", "\\\\").replace("\"", "\\\"");
        out.print("{\"reply\":\"" + botReply + "\",\"chatId\":" + chatId + "}");
    }
}