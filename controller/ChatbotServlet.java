package com.senhostel.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.ChatbotDAO;

@WebServlet("/chatbot")
public class ChatbotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        PrintWriter out = response.getWriter();

        if (session == null || session.getAttribute("studentId") == null) {
            out.print("{\"reply\":\"Session expired. Please login again.\"}");
            out.flush();
            return;
        }

        int studentId = Integer.parseInt(session.getAttribute("studentId").toString());
        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            out.print("{\"reply\":\"Please type your question first.\"}");
            out.flush();
            return;
        }

        String userMessage = message.trim().toLowerCase();
        ChatbotDAO dao = new ChatbotDAO();
        String botReply;

        if (userMessage.contains("room") || userMessage.contains("my room") || userMessage.contains("room status")) {
            botReply = dao.getStudentRoomStatus(studentId);

        } else if (userMessage.contains("fee") || userMessage.contains("due") || userMessage.contains("pending fee")) {
            botReply = dao.getStudentFeeDue(studentId);

        } else if (userMessage.contains("complaint") || userMessage.contains("complaints") || userMessage.contains("issue")) {
            botReply = dao.getComplaintStatus(studentId);

        } else if (userMessage.contains("profile") || userMessage.contains("my profile") || userMessage.contains("details")) {
            botReply = dao.getStudentProfile(studentId);

        } else if (userMessage.contains("vacant") || userMessage.contains("available room") || userMessage.contains("vacancy")) {
            botReply = dao.getVacantRooms();

        } else if (userMessage.contains("help")) {
            botReply = "You can ask: room status, fee due, complaint status, my profile, vacant rooms.";

        } else {
            botReply = "Sorry, I did not understand that. Try asking: room status, fee due, complaint status, my profile, or vacant rooms.";
        }

        botReply = botReply.replace("\"", "\\\"");
        out.print("{\"reply\":\"" + botReply + "\"}");
        out.flush();
    }
}