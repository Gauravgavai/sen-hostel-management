package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.QRCheckin;
import com.senhostel.util.DBConnection;

public class QRCheckinDAO {

    public String getStudentName(int studentId) {
        String name = "Student";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement("SELECT name FROM students WHERE id=?");
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e) {}
            try { if(ps!=null) ps.close(); } catch(Exception e) {}
            try { if(con!=null) con.close(); } catch(Exception e) {}
        }
        return name;
    }

    public String generateToken(int studentId) {
        return "STU-" + studentId + "-QR";
    }

    public boolean validateToken(String qrToken) {
        return qrToken != null && qrToken.startsWith("STU-") && qrToken.endsWith("-QR");
    }

    public int getStudentIdFromToken(String qrToken) {
        int studentId = 0;
        try {
            String[] parts = qrToken.split("-");
            studentId = Integer.parseInt(parts[1]);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return studentId;
    }

    public boolean saveCheckin(int studentId, String qrToken, String checkinType, String status, String remarks) {
        boolean result = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO qr_checkins(student_id, qr_token, checkin_type, status, remarks) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, qrToken);
            ps.setString(3, checkinType);
            ps.setString(4, status);
            ps.setString(5, remarks);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps!=null) ps.close(); } catch(Exception e) {}
            try { if(con!=null) con.close(); } catch(Exception e) {}
        }

        return result;
    }

    public void saveVoiceLog(int studentId, String commandText, String intent) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO qr_voice_logs(student_id, command_text, detected_intent) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, commandText);
            ps.setString(3, intent);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps!=null) ps.close(); } catch(Exception e) {}
            try { if(con!=null) con.close(); } catch(Exception e) {}
        }
    }

    public List<QRCheckin> getRecentCheckinsByStudent(int studentId) {
        List<QRCheckin> list = new ArrayList<QRCheckin>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM qr_checkins WHERE student_id=? ORDER BY checkin_id DESC LIMIT 10";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                QRCheckin q = new QRCheckin();
                q.setCheckinId(rs.getInt("checkin_id"));
                q.setStudentId(rs.getInt("student_id"));
                q.setQrToken(rs.getString("qr_token"));
                q.setCheckinType(rs.getString("checkin_type"));
                q.setStatus(rs.getString("status"));
                q.setCheckinTime(rs.getTimestamp("checkin_time"));
                q.setRemarks(rs.getString("remarks"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e) {}
            try { if(ps!=null) ps.close(); } catch(Exception e) {}
            try { if(con!=null) con.close(); } catch(Exception e) {}
        }

        return list;
    }

    public List<QRCheckin> getAllRecentCheckins() {
        List<QRCheckin> list = new ArrayList<QRCheckin>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM qr_checkins ORDER BY checkin_id DESC LIMIT 50";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                QRCheckin q = new QRCheckin();
                q.setCheckinId(rs.getInt("checkin_id"));
                q.setStudentId(rs.getInt("student_id"));
                q.setQrToken(rs.getString("qr_token"));
                q.setCheckinType(rs.getString("checkin_type"));
                q.setStatus(rs.getString("status"));
                q.setCheckinTime(rs.getTimestamp("checkin_time"));
                q.setRemarks(rs.getString("remarks"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e) {}
            try { if(ps!=null) ps.close(); } catch(Exception e) {}
            try { if(con!=null) con.close(); } catch(Exception e) {}
        }

        return list;
    }
}