package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.ChatHistory;
import com.senhostel.util.DBConnection;

public class ChatbotV2DAO {

    public String getStudentName(int studentId) {
        String name = "Student";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT name FROM students WHERE id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return name;
    }

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
                reply = "Your allocated room is " + rs.getString("room_number") +
                        " (" + rs.getString("room_type") + ") and current status is " +
                        rs.getString("status") + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch room status right now.";
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return reply;
    }

    public String getStudentFeeDue(int studentId) {
        String reply = "No fee data found.";
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

                reply = "Your total fee is ₹" + total + ", paid amount is ₹" + paid +
                        ", and current due is ₹" + due + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch fee details right now.";
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
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
            String sql = "SELECT complaint_title, status FROM complaints " +
                         "WHERE student_id = ? ORDER BY complaint_id DESC LIMIT 1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Your latest complaint '" + rs.getString("complaint_title") +
                        "' is currently " + rs.getString("status") + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch complaint status right now.";
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
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
                reply = "Profile details - Name: " + rs.getString("name") +
                        ", Email: " + rs.getString("email") +
                        ", Mobile: " + rs.getString("mobile") +
                        ", Course: " + rs.getString("course") + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch profile details right now.";
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return reply;
    }

    public String getVacantRooms() {
        String reply = "No vacant room data available.";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT room_number, room_type, capacity, current_occupancy " +
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
                  .append(", ").append(rs.getInt("current_occupancy"))
                  .append("/").append(rs.getInt("capacity")).append(" occupied), ");
            }

            if (count > 0) {
                reply = "Top vacant rooms: " + sb.toString();
                if (reply.endsWith(", ")) {
                    reply = reply.substring(0, reply.length() - 2) + ".";
                }
            } else {
                reply = "Currently there are no vacant rooms.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch vacant rooms right now.";
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return reply;
    }

    public boolean saveChatHistory(int studentId, String userMessage, String botReply, String intentName) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO chatbot_history(student_id, user_message, bot_reply, intent_name) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, userMessage);
            ps.setString(3, botReply);
            ps.setString(4, intentName);

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<ChatHistory> getChatHistoryByStudent(int studentId) {
        List<ChatHistory> list = new ArrayList<ChatHistory>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM chatbot_history WHERE student_id = ? ORDER BY chat_id DESC LIMIT 20";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                ChatHistory chat = new ChatHistory();
                chat.setChatId(rs.getInt("chat_id"));
                chat.setStudentId(rs.getInt("student_id"));
                chat.setUserMessage(rs.getString("user_message"));
                chat.setBotReply(rs.getString("bot_reply"));
                chat.setIntentName(rs.getString("intent_name"));
                chat.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(chat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return list;
    }
}