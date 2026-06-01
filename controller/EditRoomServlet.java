package com.senhostel.controller;

import java.io.IOException;

import com.senhostel.dao.RoomDAO;
import com.senhostel.model.Room;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/editRoom")
public class EditRoomServlet extends HttpServlet {
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
        Room room = dao.getRoomById(id);

        if (room == null) {
            response.sendRedirect(request.getContextPath() + "/listRooms?error=Room not found");
            return;
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("/admin/edit-room.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String roomNumber = request.getParameter("roomNumber");
        String block = request.getParameter("block");
        int floor = Integer.parseInt(request.getParameter("floor"));
        String roomType = request.getParameter("roomType");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        int occupied = Integer.parseInt(request.getParameter("occupied"));
        double fees = Double.parseDouble(request.getParameter("fees"));
        String statusParam = request.getParameter("status");

        String status;
        if ("Maintenance".equalsIgnoreCase(statusParam)) {
            status = "Maintenance";
        } else if (occupied >= capacity) {
            status = "Full";
        } else {
            status = "Available";
        }

        Room room = new Room(roomNumber, block, floor, roomType, capacity, occupied, fees, status);
        room.setRoomId(roomId);

        RoomDAO dao = new RoomDAO();
        boolean ok = dao.updateRoom(room);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/listRooms?success=Room updated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/listRooms?error=Unable to update room");
        }
    }
}