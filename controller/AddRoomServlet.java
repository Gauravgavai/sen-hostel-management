package com.senhostel.controller;

import java.io.IOException;

import com.senhostel.dao.RoomDAO;
import com.senhostel.model.Room;
import com.senhostel.util.DBConnection; // optional, but tum already use kar rahe ho

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addRoom")
public class AddRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        String roomNumber = request.getParameter("roomNumber");
        String block = request.getParameter("block");
        int floor = Integer.parseInt(request.getParameter("floor"));
        String roomType = request.getParameter("roomType");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        int occupied = Integer.parseInt(request.getParameter("occupied"));
        double fees = Double.parseDouble(request.getParameter("fees"));
        String statusParam = request.getParameter("status");

        // Auto status update
        String status;
        if ("Maintenance".equalsIgnoreCase(statusParam)) {
            status = "Maintenance";
        } else if (occupied >= capacity) {
            status = "Full";
        } else {
            status = "Available";
        }

        Room room = new Room(roomNumber, block, floor, roomType, capacity, occupied, fees, status);
        RoomDAO dao = new RoomDAO();
        boolean ok = dao.addRoom(room);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/listRooms?success=Room added successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/add-room.jsp?error=Room insert failed or duplicate room number");
        }
    }
}