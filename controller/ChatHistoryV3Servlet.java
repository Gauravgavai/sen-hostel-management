package com.senhostel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotV3DAO;
import com.senhostel.model.ChatHistory;

@WebServlet("/chatHistoryV3")
public class ChatHistoryV3Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();

        if (session == null || session.getAttribute("studentId") == null) {
            out.print("{\"status\":\"error\",\"message\":\"Session expired.\"}");
            return;
        }

        int studentId = Integer.parseInt(session.getAttribute("studentId").toString());

        ChatbotV3DAO dao = new ChatbotV3DAO();
        List<ChatHistory> history = dao.getChatHistoryByRole("student", studentId);

        StringBuilder json = new StringBuilder();
        json.append("{\"status\":\"success\",\"history\":[");

        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm a");

        for (int i = 0; i < history.size(); i++) {
            ChatHistory c = history.get(i);
            json.append("{")
                .append("\"chatId\":").append(c.getChatId()).append(",")
                .append("\"userMessage\":\"").append(c.getUserMessage().replace("\\", "\\\\").replace("\"", "\\\"")).append("\",")
                .append("\"botReply\":\"").append(c.getBotReply().replace("\\", "\\\\").replace("\"", "\\\"")).append("\",")
                .append("\"createdAt\":\"").append(sdf.format(c.getCreatedAt())).append("\"")
                .append("}");

            if (i < history.size() - 1) {
                json.append(",");
            }
        }

        json.append("]}");
        out.print(json.toString());
    }
}