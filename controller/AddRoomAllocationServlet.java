package com.senhostel.controller;

import java.io.IOException;

import com.senhostel.dao.RoomAllocationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addRoomAllocation")
public class AddRoomAllocationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            RoomAllocationDAO dao = new RoomAllocationDAO();
            boolean success = dao.allocateRoom(studentId, roomId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/listRoomAllocations?success=Room allocated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/allocate-room.jsp?error=Student already allocated or room unavailable");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/allocate-room.jsp?error=Invalid input");
        }
    }
}