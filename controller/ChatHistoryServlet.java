package com.senhostel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotV2DAO;
import com.senhostel.model.ChatHistory;

@WebServlet("/chatHistory")
public class ChatHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            out.print("{\"status\":\"error\",\"message\":\"Session expired. Please login again.\"}");
            out.flush();
            return;
        }

        int studentId = Integer.parseInt(session.getAttribute("studentId").toString());

        ChatbotV2DAO dao = new ChatbotV2DAO();
        List<ChatHistory> historyList = dao.getChatHistoryByStudent(studentId);

        StringBuilder json = new StringBuilder();
        json.append("{\"status\":\"success\",\"history\":[");

        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm a");

        for (int i = 0; i < historyList.size(); i++) {
            ChatHistory chat = historyList.get(i);

            String userMessage = chat.getUserMessage().replace("\\", "\\\\").replace("\"", "\\\"");
            String botReply = chat.getBotReply().replace("\\", "\\\\").replace("\"", "\\\"");
            String intentName = chat.getIntentName() == null ? "" : chat.getIntentName().replace("\\", "\\\\").replace("\"", "\\\"");
            String createdAt = chat.getCreatedAt() == null ? "" : sdf.format(chat.getCreatedAt());

            json.append("{")
                .append("\"userMessage\":\"").append(userMessage).append("\",")
                .append("\"botReply\":\"").append(botReply).append("\",")
                .append("\"intentName\":\"").append(intentName).append("\",")
                .append("\"createdAt\":\"").append(createdAt).append("\"")
                .append("}");

            if (i < historyList.size() - 1) {
                json.append(",");
            }
        }

        json.append("]}");
        out.print(json.toString());
        out.flush();
    }
}