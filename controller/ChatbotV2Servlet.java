package com.senhostel.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotV2DAO;

@WebServlet("/chatbotV2")
public class ChatbotV2Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            out.print("{\"reply\":\"Session expired. Please login again.\",\"intent\":\"session_error\"}");
            out.flush();
            return;
        }

        int studentId = Integer.parseInt(session.getAttribute("studentId").toString());
        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            out.print("{\"reply\":\"Please type your message first.\",\"intent\":\"empty_message\"}");
            out.flush();
            return;
        }

        String userMessage = message.trim();
        String normalizedMessage = userMessage.toLowerCase();

        ChatbotV2DAO dao = new ChatbotV2DAO();
        String botReply = "";
        String intentName = "unknown";

        if (normalizedMessage.contains("hello") || normalizedMessage.contains("hi")
                || normalizedMessage.contains("hey") || normalizedMessage.contains("namaste")) {

            String studentName = dao.getStudentName(studentId);
            botReply = "Hello " + studentName + "! I am your hostel assistant. You can ask about room status, fee due, complaint status, profile, vacant rooms, or chat history.";
            intentName = "greeting";

        } else if (normalizedMessage.contains("room") || normalizedMessage.contains("mera room")
                || normalizedMessage.contains("my room") || normalizedMessage.contains("room status")) {

            botReply = dao.getStudentRoomStatus(studentId);
            intentName = "room_status";

        } else if (normalizedMessage.contains("fee") || normalizedMessage.contains("due")
                || normalizedMessage.contains("pending fee") || normalizedMessage.contains("meri fee")) {

            botReply = dao.getStudentFeeDue(studentId);
            intentName = "fee_due";

        } else if (normalizedMessage.contains("complaint") || normalizedMessage.contains("issue")
                || normalizedMessage.contains("problem") || normalizedMessage.contains("meri complaint")) {

            botReply = dao.getComplaintStatus(studentId);
            intentName = "complaint_status";

        } else if (normalizedMessage.contains("profile") || normalizedMessage.contains("details")
                || normalizedMessage.contains("meri profile") || normalizedMessage.contains("my details")) {

            botReply = dao.getStudentProfile(studentId);
            intentName = "profile";

        } else if (normalizedMessage.contains("vacant") || normalizedMessage.contains("vacancy")
                || normalizedMessage.contains("available room") || normalizedMessage.contains("khali")) {

            botReply = dao.getVacantRooms();
            intentName = "vacant_rooms";

        } else if (normalizedMessage.contains("history") || normalizedMessage.contains("chat history")) {
            botReply = "Use the Show History button to load your recent chat history.";
            intentName = "chat_history_help";

        } else if (normalizedMessage.contains("help") || normalizedMessage.contains("commands")) {
            botReply = "Supported questions: hello, room status, fee due, complaint status, my profile, vacant rooms, show chat history.";
            intentName = "help";

        } else {
            botReply = "Sorry, I could not understand that. Please ask something like room status, fee due, complaint status, my profile, vacant rooms, or help.";
            intentName = "unknown";
        }

        dao.saveChatHistory(studentId, userMessage, botReply, intentName);

        botReply = botReply.replace("\\", "\\\\").replace("\"", "\\\"");
        intentName = intentName.replace("\\", "\\\\").replace("\"", "\\\"");

        out.print("{\"reply\":\"" + botReply + "\",\"intent\":\"" + intentName + "\"}");
        out.flush();
    }
}