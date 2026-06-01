package com.senhostel.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.QRCheckin;
import com.senhostel.model.ScanAnalytics;
import com.senhostel.util.DBConnection;

public class QRCheckinV2DAO {

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
            close(rs, ps, con);
        }
        return name;
    }

    public String generateStudentToken(int studentId) {
        long now = System.currentTimeMillis();
        return "STU-" + studentId + "-" + now + "-QR";
    }

    public String generateVisitorToken(String visitorName, String mobile) {
        long now = System.currentTimeMillis();
        return "VIS-" + mobile + "-" + now + "-QR";
    }

    public Timestamp getExpiryAfterMinutes(int minutes) {
        return new Timestamp(System.currentTimeMillis() + (minutes * 60L * 1000L));
    }

    public boolean isTokenExpired(Timestamp expiryTime) {
        if (expiryTime == null) return true;
        return expiryTime.before(new Timestamp(System.currentTimeMillis()));
    }

    public boolean validateStudentToken(String token) {
        return token != null && token.startsWith("STU-") && token.endsWith("-QR");
    }

    public boolean validateVisitorToken(String token) {
        return token != null && token.startsWith("VIS-") && token.endsWith("-QR");
    }

    public int extractStudentId(String token) {
        try {
            String[] parts = token.split("-");
            return Integer.parseInt(parts[1]);
        } catch (Exception e) {
            return 0;
        }
    }

    public boolean alreadyMarkedToday(int studentId) {
        boolean exists = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT checkin_id FROM qr_checkins WHERE student_id=? AND checkin_date=CURDATE() AND qr_type='STUDENT' LIMIT 1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            exists = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, con);
        }
        return exists;
    }

    public boolean saveStudentCheckin(int studentId, String qrToken, String remarks, Timestamp expiryTime) {
        boolean result = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO qr_checkins(student_id, qr_token, qr_type, checkin_type, status, remarks, expiry_time, checkin_date) VALUES (?, ?, 'STUDENT', 'ENTRY', 'SUCCESS', ?, ?, CURDATE())";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, qrToken);
            ps.setString(3, remarks);
            ps.setTimestamp(4, expiryTime);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(null, ps, con);
        }
        return result;
    }

    public boolean saveVisitorCheckin(String visitorName, String visitorMobile, String qrToken, String remarks, Timestamp expiryTime) {
        boolean result = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO qr_checkins(visitor_name, visitor_mobile, qr_token, qr_type, checkin_type, status, remarks, expiry_time, checkin_date) VALUES (?, ?, ?, 'VISITOR', 'ENTRY', 'SUCCESS', ?, ?, CURDATE())";
            ps = con.prepareStatement(sql);
            ps.setString(1, visitorName);
            ps.setString(2, visitorMobile);
            ps.setString(3, qrToken);
            ps.setString(4, remarks);
            ps.setTimestamp(5, expiryTime);
            result = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(null, ps, con);
        }
        return result;
    }

    public Timestamp getLatestExpiryByToken(String token) {
        Timestamp expiry = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT expiry_time FROM qr_checkins WHERE qr_token=? ORDER BY checkin_id DESC LIMIT 1";
            ps = con.prepareStatement(sql);
            ps.setString(1, token);
            rs = ps.executeQuery();
            if (rs.next()) {
                expiry = rs.getTimestamp("expiry_time");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, con);
        }
        return expiry;
    }

    public void saveVoiceLog(Integer studentId, String commandText, String intent, String languageCode) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO qr_voice_logs(student_id, command_text, detected_intent, language_code) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);

            if (studentId == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, studentId);
            }

            ps.setString(2, commandText);
            ps.setString(3, intent);
            ps.setString(4, languageCode);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(null, ps, con);
        }
    }

    public List<QRCheckin> getStudentHistory(int studentId) {
        List<QRCheckin> list = new ArrayList<QRCheckin>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM qr_checkins WHERE student_id=? ORDER BY checkin_id DESC LIMIT 20";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, con);
        }
        return list;
    }

    public List<QRCheckin> getAllRecentScans() {
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
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, con);
        }
        return list;
    }

    public ScanAnalytics getAnalytics() {
        ScanAnalytics analytics = new ScanAnalytics();
        Connection con = null;
        PreparedStatement ps1 = null, ps2 = null, ps3 = null, ps4 = null;
        ResultSet rs1 = null, rs2 = null, rs3 = null, rs4 = null;

        try {
            con = DBConnection.getConnection();

            ps1 = con.prepareStatement("SELECT COUNT(*) FROM qr_checkins WHERE checkin_date=CURDATE() AND qr_type='STUDENT'");
            rs1 = ps1.executeQuery();
            if (rs1.next()) analytics.setTodayStudentScans(rs1.getInt(1));

            ps2 = con.prepareStatement("SELECT COUNT(*) FROM qr_checkins WHERE checkin_date=CURDATE() AND qr_type='VISITOR'");
            rs2 = ps2.executeQuery();
            if (rs2.next()) analytics.setTodayVisitorScans(rs2.getInt(1));

            ps3 = con.prepareStatement("SELECT COUNT(*) FROM qr_checkins");
            rs3 = ps3.executeQuery();
            if (rs3.next()) analytics.setTotalScans(rs3.getInt(1));

            ps4 = con.prepareStatement("SELECT COUNT(DISTINCT student_id) FROM qr_checkins WHERE checkin_date=CURDATE() AND qr_type='STUDENT'");
            rs4 = ps4.executeQuery();
            if (rs4.next()) analytics.setLiveAttendanceCount(rs4.getInt(1));

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs1!=null) rs1.close(); } catch(Exception e) {}
            try { if(rs2!=null) rs2.close(); } catch(Exception e) {}
            try { if(rs3!=null) rs3.close(); } catch(Exception e) {}
            try { if(rs4!=null) rs4.close(); } catch(Exception e) {}
            try { if(ps1!=null) ps1.close(); } catch(Exception e) {}
            try { if(ps2!=null) ps2.close(); } catch(Exception e) {}
            try { if(ps3!=null) ps3.close(); } catch(Exception e) {}
            try { if(ps4!=null) ps4.close(); } catch(Exception e) {}
            try { if(con!=null) con.close(); } catch(Exception e) {}
        }
        return analytics;
    }

    private QRCheckin mapRow(ResultSet rs) throws Exception {
        QRCheckin q = new QRCheckin();
        q.setCheckinId(rs.getInt("checkin_id"));

        int sid = rs.getInt("student_id");
        if (rs.wasNull()) {
            q.setStudentId(null);
        } else {
            q.setStudentId(sid);
        }

        q.setVisitorName(rs.getString("visitor_name"));
        q.setVisitorMobile(rs.getString("visitor_mobile"));
        q.setQrToken(rs.getString("qr_token"));
        q.setQrType(rs.getString("qr_type"));
        q.setCheckinType(rs.getString("checkin_type"));
        q.setStatus(rs.getString("status"));
        q.setRemarks(rs.getString("remarks"));
        q.setExpiryTime(rs.getTimestamp("expiry_time"));
        q.setCheckinDate(rs.getDate("checkin_date"));
        q.setCheckinTime(rs.getTimestamp("checkin_time"));
        return q;
    }

    private void close(ResultSet rs, PreparedStatement ps, Connection con) {
        try { if(rs!=null) rs.close(); } catch(Exception e) {}
        try { if(ps!=null) ps.close(); } catch(Exception e) {}
        try { if(con!=null) con.close(); } catch(Exception e) {}
    }
}