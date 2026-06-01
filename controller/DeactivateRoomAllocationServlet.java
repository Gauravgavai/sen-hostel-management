package com.senhostel.controller;

import java.io.IOException;

import com.senhostel.dao.RoomAllocationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/deactivateRoomAllocation")
public class DeactivateRoomAllocationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        try {
            int allocationId = Integer.parseInt(request.getParameter("id"));

            RoomAllocationDAO dao = new RoomAllocationDAO();
            boolean success = dao.deactivateAllocation(allocationId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/listRoomAllocations?success=Allocation deactivated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/listRoomAllocations?error=Unable to deactivate allocation");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/listRoomAllocations?error=Invalid allocation id");
        }
    }
}