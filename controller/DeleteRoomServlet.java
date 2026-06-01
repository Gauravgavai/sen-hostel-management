package com.senhostel.controller;

import java.io.IOException;

import com.senhostel.dao.RoomDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/deleteRoom")
public class DeleteRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        RoomDAO dao = new RoomDAO();
        boolean ok = dao.deleteRoom(id);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/listRooms?success=Room deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/listRooms?error=Unable to delete room");
        }
    }
}