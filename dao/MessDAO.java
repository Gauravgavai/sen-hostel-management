package com.senhostel.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.MessAttendance;
import com.senhostel.model.MessFeedback;
import com.senhostel.model.MessMenu;
import com.senhostel.util.DBConnection;

public class MessDAO {

    public boolean addOrUpdateMenu(MessMenu menu) {
        boolean status = false;
        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String checkSql = "SELECT menu_id FROM mess_menu WHERE menu_date=?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setDate(1, menu.getMenuDate());
            rs = checkPs.executeQuery();

            if (rs.next()) {
                String updateSql = "UPDATE mess_menu SET breakfast=?, lunch=?, dinner=?, special_note=? WHERE menu_date=?";
                ps = con.prepareStatement(updateSql);
                ps.setString(1, menu.getBreakfast());
                ps.setString(2, menu.getLunch());
                ps.setString(3, menu.getDinner());
                ps.setString(4, menu.getSpecialNote());
                ps.setDate(5, menu.getMenuDate());
            } else {
                String insertSql = "INSERT INTO mess_menu(menu_date, breakfast, lunch, dinner, special_note) VALUES (?, ?, ?, ?, ?)";
                ps = con.prepareStatement(insertSql);
                ps.setDate(1, menu.getMenuDate());
                ps.setString(2, menu.getBreakfast());
                ps.setString(3, menu.getLunch());
                ps.setString(4, menu.getDinner());
                ps.setString(5, menu.getSpecialNote());
            }

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(checkPs != null) checkPs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<MessMenu> getAllMenus() {
        List<MessMenu> list = new ArrayList<MessMenu>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM mess_menu ORDER BY menu_date DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                MessMenu m = new MessMenu();
                m.setMenuId(rs.getInt("menu_id"));
                m.setMenuDate(rs.getDate("menu_date"));
                m.setBreakfast(rs.getString("breakfast"));
                m.setLunch(rs.getString("lunch"));
                m.setDinner(rs.getString("dinner"));
                m.setSpecialNote(rs.getString("special_note"));
                m.setCreatedAt(rs.getTimestamp("created_at"));
                m.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(m);
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

    public boolean markAttendance(MessAttendance attendance) {
        boolean status = false;
        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String checkSql = "SELECT attendance_id FROM mess_attendance WHERE student_id=? AND attendance_date=?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, attendance.getStudentId());
            checkPs.setDate(2, attendance.getAttendanceDate());
            rs = checkPs.executeQuery();

            if (rs.next()) {
                String updateSql = "UPDATE mess_attendance SET breakfast_status=?, lunch_status=?, dinner_status=?, marked_at=NOW() WHERE student_id=? AND attendance_date=?";
                ps = con.prepareStatement(updateSql);
                ps.setString(1, attendance.getBreakfastStatus());
                ps.setString(2, attendance.getLunchStatus());
                ps.setString(3, attendance.getDinnerStatus());
                ps.setInt(4, attendance.getStudentId());
                ps.setDate(5, attendance.getAttendanceDate());
            } else {
                String insertSql = "INSERT INTO mess_attendance(student_id, attendance_date, breakfast_status, lunch_status, dinner_status) VALUES (?, ?, ?, ?, ?)";
                ps = con.prepareStatement(insertSql);
                ps.setInt(1, attendance.getStudentId());
                ps.setDate(2, attendance.getAttendanceDate());
                ps.setString(3, attendance.getBreakfastStatus());
                ps.setString(4, attendance.getLunchStatus());
                ps.setString(5, attendance.getDinnerStatus());
            }

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(checkPs != null) checkPs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<MessAttendance> getAttendanceByStudentId(int studentId) {
        List<MessAttendance> list = new ArrayList<MessAttendance>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT ma.*, s.name FROM mess_attendance ma JOIN students s ON ma.student_id=s.id WHERE ma.student_id=? ORDER BY attendance_date DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                MessAttendance m = new MessAttendance();
                m.setAttendanceId(rs.getInt("attendance_id"));
                m.setStudentId(rs.getInt("student_id"));
                m.setStudentName(rs.getString("name"));
                m.setAttendanceDate(rs.getDate("attendance_date"));
                m.setBreakfastStatus(rs.getString("breakfast_status"));
                m.setLunchStatus(rs.getString("lunch_status"));
                m.setDinnerStatus(rs.getString("dinner_status"));
                m.setMarkedAt(rs.getTimestamp("marked_at"));
                list.add(m);
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

    public List<MessAttendance> getAllAttendance() {
        List<MessAttendance> list = new ArrayList<MessAttendance>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT ma.*, s.name FROM mess_attendance ma JOIN students s ON ma.student_id=s.id ORDER BY attendance_date DESC, ma.attendance_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                MessAttendance m = new MessAttendance();
                m.setAttendanceId(rs.getInt("attendance_id"));
                m.setStudentId(rs.getInt("student_id"));
                m.setStudentName(rs.getString("name"));
                m.setAttendanceDate(rs.getDate("attendance_date"));
                m.setBreakfastStatus(rs.getString("breakfast_status"));
                m.setLunchStatus(rs.getString("lunch_status"));
                m.setDinnerStatus(rs.getString("dinner_status"));
                m.setMarkedAt(rs.getTimestamp("marked_at"));
                list.add(m);
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

    public boolean addFeedback(MessFeedback feedback) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO mess_feedback(student_id, feedback_date, rating, comments) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, feedback.getStudentId());
            ps.setDate(2, feedback.getFeedbackDate());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComments());

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<MessFeedback> getAllFeedback() {
        List<MessFeedback> list = new ArrayList<MessFeedback>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT mf.*, s.name FROM mess_feedback mf JOIN students s ON mf.student_id=s.id ORDER BY feedback_date DESC, feedback_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                MessFeedback f = new MessFeedback();
                f.setFeedbackId(rs.getInt("feedback_id"));
                f.setStudentId(rs.getInt("student_id"));
                f.setStudentName(rs.getString("name"));
                f.setFeedbackDate(rs.getDate("feedback_date"));
                f.setRating(rs.getInt("rating"));
                f.setComments(rs.getString("comments"));
                f.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(f);
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

	public String getTodayMenu() {
		// TODO Auto-generated method stub
		return null;
	}
}
