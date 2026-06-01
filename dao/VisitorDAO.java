package com.senhostel.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.Visitor;
import com.senhostel.util.DBConnection;

public class VisitorDAO {

    public boolean addVisitorRequest(Visitor visitor) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO visitors(student_id, visitor_name, mobile, relation_type, purpose, visit_date, expected_in_time, approval_status, visit_status, admin_remark) VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending', 'Not Arrived', '')";
            ps = con.prepareStatement(sql);
            ps.setInt(1, visitor.getStudentId());
            ps.setString(2, visitor.getVisitorName());
            ps.setString(3, visitor.getMobile());
            ps.setString(4, visitor.getRelationType());
            ps.setString(5, visitor.getPurpose());
            ps.setDate(6, visitor.getVisitDate());
            ps.setString(7, visitor.getExpectedInTime());

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<Visitor> getVisitorsByStudentId(int studentId) {
        List<Visitor> list = new ArrayList<Visitor>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT v.*, s.name FROM visitors v JOIN students s ON v.student_id = s.id WHERE v.student_id=? ORDER BY v.visitor_id DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Visitor v = new Visitor();
                v.setVisitorId(rs.getInt("visitor_id"));
                v.setStudentId(rs.getInt("student_id"));
                v.setStudentName(rs.getString("name"));
                v.setVisitorName(rs.getString("visitor_name"));
                v.setMobile(rs.getString("mobile"));
                v.setRelationType(rs.getString("relation_type"));
                v.setPurpose(rs.getString("purpose"));
                v.setVisitDate(rs.getDate("visit_date"));
                v.setExpectedInTime(rs.getString("expected_in_time"));
                v.setActualInTime(rs.getTimestamp("actual_in_time"));
                v.setActualOutTime(rs.getTimestamp("actual_out_time"));
                v.setApprovalStatus(rs.getString("approval_status"));
                v.setVisitStatus(rs.getString("visit_status"));
                v.setAdminRemark(rs.getString("admin_remark"));
                v.setCreatedAt(rs.getTimestamp("created_at"));
                v.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(v);
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

    public List<Visitor> getAllVisitors() {
        List<Visitor> list = new ArrayList<Visitor>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT v.*, s.name FROM visitors v JOIN students s ON v.student_id = s.id ORDER BY v.visitor_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Visitor v = new Visitor();
                v.setVisitorId(rs.getInt("visitor_id"));
                v.setStudentId(rs.getInt("student_id"));
                v.setStudentName(rs.getString("name"));
                v.setVisitorName(rs.getString("visitor_name"));
                v.setMobile(rs.getString("mobile"));
                v.setRelationType(rs.getString("relation_type"));
                v.setPurpose(rs.getString("purpose"));
                v.setVisitDate(rs.getDate("visit_date"));
                v.setExpectedInTime(rs.getString("expected_in_time"));
                v.setActualInTime(rs.getTimestamp("actual_in_time"));
                v.setActualOutTime(rs.getTimestamp("actual_out_time"));
                v.setApprovalStatus(rs.getString("approval_status"));
                v.setVisitStatus(rs.getString("visit_status"));
                v.setAdminRemark(rs.getString("admin_remark"));
                v.setCreatedAt(rs.getTimestamp("created_at"));
                v.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(v);
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

    public boolean updateApprovalStatus(int visitorId, String approvalStatus, String adminRemark) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE visitors SET approval_status=?, admin_remark=? WHERE visitor_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, approvalStatus);
            ps.setString(2, adminRemark);
            ps.setInt(3, visitorId);

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    public boolean checkInVisitor(int visitorId) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE visitors SET actual_in_time=NOW(), visit_status='Checked In' WHERE visitor_id=? AND approval_status='Approved'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, visitorId);

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    public boolean checkOutVisitor(int visitorId) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE visitors SET actual_out_time=NOW(), visit_status='Checked Out' WHERE visitor_id=? AND visit_status='Checked In'";
            ps = con.prepareStatement(sql);
            ps.setInt(1, visitorId);

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }
}