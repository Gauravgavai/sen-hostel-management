package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.senhostel.util.DBConnection;

public class ChatbotDAO {

    public String getStudentRoomStatus(int studentId) {
        String reply = "No room allocation found for your account.";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT r.room_number, r.room_type, a.status " +
                         "FROM room_allocations a " +
                         "JOIN rooms r ON a.room_id = r.room_id " +
                         "WHERE a.student_id = ? " +
                         "ORDER BY a.allocation_id DESC LIMIT 1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Your room is " + rs.getString("room_number") +
                        " (" + rs.getString("room_type") + "), allocation status: " +
                        rs.getString("status") + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch room status right now.";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return reply;
    }

    public String getStudentFeeDue(int studentId) {
        String reply = "No fee record found.";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT IFNULL(SUM(total_amount),0) AS total_amount, " +
                         "IFNULL(SUM(paid_amount),0) AS paid_amount, " +
                         "IFNULL(SUM(due_amount),0) AS due_amount " +
                         "FROM fees WHERE student_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                double total = rs.getDouble("total_amount");
                double paid = rs.getDouble("paid_amount");
                double due = rs.getDouble("due_amount");

                reply = "Your total hostel fee is ₹" + total +
                        ", paid amount is ₹" + paid +
                        ", and due amount is ₹" + due + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch fee details right now.";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return reply;
    }

    public String getComplaintStatus(int studentId) {
        String reply = "No complaint record found.";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT complaint_title, status, created_at " +
                         "FROM complaints WHERE student_id = ? " +
                         "ORDER BY complaint_id DESC LIMIT 1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Your latest complaint '" + rs.getString("complaint_title") +
                        "' is currently marked as " + rs.getString("status") + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch complaint status right now.";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return reply;
    }

    public String getStudentProfile(int studentId) {
        String reply = "Profile not found.";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT name, email, mobile, course FROM students WHERE id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Your profile: Name - " + rs.getString("name") +
                        ", Email - " + rs.getString("email") +
                        ", Mobile - " + rs.getString("mobile") +
                        ", Course - " + rs.getString("course") + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch profile right now.";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return reply;
    }

    public String getVacantRooms() {
        String reply = "No vacant room data found.";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT room_number, room_type, capacity " +
                         "FROM rooms WHERE current_occupancy < capacity " +
                         "ORDER BY room_number LIMIT 5";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            StringBuilder sb = new StringBuilder();
            int count = 0;

            while (rs.next()) {
                count++;
                sb.append("Room ").append(rs.getString("room_number"))
                  .append(" (").append(rs.getString("room_type"))
                  .append(", capacity ").append(rs.getInt("capacity"))
                  .append("), ");
            }

            if (count > 0) {
                reply = "Available vacant rooms: " + sb.toString();
                if (reply.endsWith(", ")) {
                    reply = reply.substring(0, reply.length() - 2) + ".";
                }
            } else {
                reply = "Currently, no vacant rooms are available.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch vacant room data right now.";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return reply;
    }
}