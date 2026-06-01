package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.Complaint;
import com.senhostel.util.DBConnection;

public class ComplaintDAO {

    public boolean addComplaint(Complaint complaint) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO complaints(student_id, title, description, category, status, admin_remark) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, complaint.getStudentId());
            ps.setString(2, complaint.getTitle());
            ps.setString(3, complaint.getDescription());
            ps.setString(4, complaint.getCategory());
            ps.setString(5, "Pending");
            ps.setString(6, "");

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<Complaint> getComplaintsByStudentId(int studentId) {
        List<Complaint> list = new ArrayList<Complaint>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT c.*, s.name FROM complaints c JOIN students s ON c.student_id = s.id WHERE c.student_id=? ORDER BY c.complaint_id DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Complaint c = new Complaint();
                c.setComplaintId(rs.getInt("complaint_id"));
                c.setStudentId(rs.getInt("student_id"));
                c.setStudentName(rs.getString("name"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setCategory(rs.getString("category"));
                c.setStatus(rs.getString("status"));
                c.setAdminRemark(rs.getString("admin_remark"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(c);
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

    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<Complaint>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT c.*, s.name FROM complaints c JOIN students s ON c.student_id = s.id ORDER BY c.complaint_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Complaint c = new Complaint();
                c.setComplaintId(rs.getInt("complaint_id"));
                c.setStudentId(rs.getInt("student_id"));
                c.setStudentName(rs.getString("name"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setCategory(rs.getString("category"));
                c.setStatus(rs.getString("status"));
                c.setAdminRemark(rs.getString("admin_remark"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(c);
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

    public boolean updateComplaintStatus(int complaintId, String statusText, String adminRemark) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE complaints SET status=?, admin_remark=? WHERE complaint_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, statusText);
            ps.setString(2, adminRemark);
            ps.setInt(3, complaintId);

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

	public int getPendingComplaintCount(int studentId) {
		// TODO Auto-generated method stub
		return 0;
	}
}