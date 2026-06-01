package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.ChatAnalytics;
import com.senhostel.model.ChatFAQ;
import com.senhostel.model.ChatHistory;
import com.senhostel.util.DBConnection;

public class ChatbotV3DAO {

    public String getStudentName(int studentId) {
        String name = "Student";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT name FROM students WHERE id=?")) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return name;
    }

    public String getAdminName(int adminId) {
        String name = "Admin";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT name FROM admins WHERE id=?")) {
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return name;
    }

    public List<ChatFAQ> getActiveFAQs(String roleType) {
        List<ChatFAQ> list = new ArrayList<ChatFAQ>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM chatbot_faq WHERE role_type=? AND status='Active'")) {
            ps.setString(1, roleType);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ChatFAQ faq = new ChatFAQ();
                faq.setFaqId(rs.getInt("faq_id"));
                faq.setQuestion(rs.getString("question"));
                faq.setAnswer(rs.getString("answer"));
                faq.setIntentName(rs.getString("intent_name"));
                faq.setRoleType(rs.getString("role_type"));
                faq.setStatus(rs.getString("status"));
                faq.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(faq);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addFAQ(ChatFAQ faq) {
        boolean status = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO chatbot_faq(question, answer, intent_name, role_type, status) VALUES(?,?,?,?,?)")) {

            ps.setString(1, faq.getQuestion());
            ps.setString(2, faq.getAnswer());
            ps.setString(3, faq.getIntentName());
            ps.setString(4, faq.getRoleType());
            ps.setString(5, faq.getStatus());

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public String getStudentRoomStatus(int studentId) {
        String reply = "No room allocation found for your account.";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT r.room_number, r.room_type, a.status " +
                     "FROM room_allocations a JOIN rooms r ON a.room_id=r.room_id " +
                     "WHERE a.student_id=? ORDER BY a.allocation_id DESC LIMIT 1")) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Your room is " + rs.getString("room_number") +
                        " (" + rs.getString("room_type") + ") and status is " +
                        rs.getString("status") + ".";
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch room details right now.";
        }
        return reply;
    }

    public String getStudentFeeDue(int studentId) {
        String reply = "No fee data found.";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT IFNULL(SUM(total_amount),0) total_amount, IFNULL(SUM(paid_amount),0) paid_amount, IFNULL(SUM(due_amount),0) due_amount FROM fees WHERE student_id=?")) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Total fee: ₹" + rs.getDouble("total_amount") +
                        ", Paid: ₹" + rs.getDouble("paid_amount") +
                        ", Due: ₹" + rs.getDouble("due_amount") + ".";
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch fee details right now.";
        }
        return reply;
    }

    public String getComplaintStatus(int studentId) {
        String reply = "No complaint found.";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT complaint_title, status FROM complaints WHERE student_id=? ORDER BY complaint_id DESC LIMIT 1")) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Your latest complaint '" + rs.getString("complaint_title") +
                        "' is currently " + rs.getString("status") + ".";
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch complaint status right now.";
        }
        return reply;
    }

    public String getStudentProfile(int studentId) {
        String reply = "Profile not found.";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT name, email, mobile, course FROM students WHERE id=?")) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                reply = "Name: " + rs.getString("name") + ", Email: " + rs.getString("email")
                        + ", Mobile: " + rs.getString("mobile") + ", Course: " + rs.getString("course") + ".";
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch profile right now.";
        }
        return reply;
    }

    public String getVacantRooms() {
        String reply = "No vacant rooms available.";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT room_number, room_type, capacity, current_occupancy FROM rooms WHERE current_occupancy < capacity ORDER BY room_number LIMIT 5")) {

            ResultSet rs = ps.executeQuery();
            StringBuilder sb = new StringBuilder();
            int count = 0;

            while (rs.next()) {
                count++;
                sb.append("Room ").append(rs.getString("room_number"))
                  .append(" (").append(rs.getString("room_type"))
                  .append(", ").append(rs.getInt("current_occupancy"))
                  .append("/").append(rs.getInt("capacity"))
                  .append(" occupied), ");
            }
            rs.close();

            if (count > 0) {
                reply = "Available rooms: " + sb.substring(0, sb.length() - 2) + ".";
            }
        } catch (Exception e) {
            e.printStackTrace();
            reply = "Unable to fetch room vacancy right now.";
        }
        return reply;
    }

    public String getAdminSummary() {
        String reply = "Admin dashboard summary unavailable.";

        try (Connection con = DBConnection.getConnection()) {
            int students = 0, rooms = 0, complaints = 0, dueCount = 0;

            PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM students");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) students = rs1.getInt(1);
            rs1.close(); ps1.close();

            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM rooms");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) rooms = rs2.getInt(1);
            rs2.close(); ps2.close();

            PreparedStatement ps3 = con.prepareStatement("SELECT COUNT(*) FROM complaints");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) complaints = rs3.getInt(1);
            rs3.close(); ps3.close();

            PreparedStatement ps4 = con.prepareStatement("SELECT COUNT(*) FROM fees WHERE due_amount > 0");
            ResultSet rs4 = ps4.executeQuery();
            if (rs4.next()) dueCount = rs4.getInt(1);
            rs4.close(); ps4.close();

            reply = "Hostel summary: Total students " + students +
                    ", Total rooms " + rooms +
                    ", Total complaints " + complaints +
                    ", Fee defaulters " + dueCount + ".";
        } catch (Exception e) {
            e.printStackTrace();
        }

        return reply;
    }

    public int saveChatHistory(int userId, String roleType, String userMessage, String botReply, String intentName, String sourceType, double confidenceScore) {
        int chatId = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO chatbot_history(student_id, user_message, bot_reply, intent_name, role_type, source_type, confidence_score) VALUES(?,?,?,?,?,?,?)",
                     PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setString(2, userMessage);
            ps.setString(3, botReply);
            ps.setString(4, intentName);
            ps.setString(5, roleType);
            ps.setString(6, sourceType);
            ps.setDouble(7, confidenceScore);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                chatId = rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return chatId;
    }

    public boolean saveFeedback(int chatId, int studentId, String feedbackType) {
        boolean status = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO chatbot_feedback(chat_id, student_id, feedback_type) VALUES(?,?,?)")) {

            ps.setInt(1, chatId);
            ps.setInt(2, studentId);
            ps.setString(3, feedbackType);

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public List<ChatHistory> getChatHistoryByRole(String roleType, int userId) {
        List<ChatHistory> list = new ArrayList<ChatHistory>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT * FROM chatbot_history WHERE role_type=? AND student_id=? ORDER BY chat_id DESC LIMIT 20")) {

            ps.setString(1, roleType);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

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
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public ChatAnalytics getAnalytics() {
        ChatAnalytics analytics = new ChatAnalytics();

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM chatbot_history");
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) analytics.setTotalChats(rs1.getInt(1));
            rs1.close(); ps1.close();

            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM chatbot_history WHERE source_type='faq'");
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) analytics.setTotalFaqHits(rs2.getInt(1));
            rs2.close(); ps2.close();

            PreparedStatement ps3 = con.prepareStatement("SELECT COUNT(*) FROM chatbot_history WHERE source_type='ai_fallback'");
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) analytics.setTotalAiFallbacks(rs3.getInt(1));
            rs3.close(); ps3.close();

            PreparedStatement ps4 = con.prepareStatement("SELECT COUNT(*) FROM chatbot_feedback WHERE feedback_type='helpful'");
            ResultSet rs4 = ps4.executeQuery();
            if (rs4.next()) analytics.setHelpfulCount(rs4.getInt(1));
            rs4.close(); ps4.close();

            PreparedStatement ps5 = con.prepareStatement("SELECT COUNT(*) FROM chatbot_feedback WHERE feedback_type='not_helpful'");
            ResultSet rs5 = ps5.executeQuery();
            if (rs5.next()) analytics.setNotHelpfulCount(rs5.getInt(1));
            rs5.close(); ps5.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return analytics;
    }
}