package com.senhostel.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.senhostel.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        int totalStudents = 0;
        int totalRooms = 0;
        int vacantRooms = 0;
        int pendingComplaints = 0;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            ps = con.prepareStatement("SELECT COUNT(*) FROM students");
            rs = ps.executeQuery();
            if (rs.next()) totalStudents = rs.getInt(1);
            rs.close();
            ps.close();

            ps = con.prepareStatement("SELECT COUNT(*) FROM rooms");
            rs = ps.executeQuery();
            if (rs.next()) totalRooms = rs.getInt(1);
            rs.close();
            ps.close();

            ps = con.prepareStatement("SELECT COUNT(*) FROM rooms WHERE status='Available'");
            rs = ps.executeQuery();
            if (rs.next()) vacantRooms = rs.getInt(1);
            rs.close();
            ps.close();

            ps = con.prepareStatement("SELECT COUNT(*) FROM complaints WHERE status='Pending'");
            rs = ps.executeQuery();
            if (rs.next()) pendingComplaints = rs.getInt(1);
            rs.close();
            ps.close();

            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("vacantRooms", vacantRooms);
            request.setAttribute("pendingComplaints", pendingComplaints);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load dashboard data.");
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}