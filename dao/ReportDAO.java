package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.ReportRow;
import com.senhostel.util.DBConnection;

public class ReportDAO {

    public int getTotalRooms() {
        return getCount("SELECT COUNT(*) FROM rooms");
    }

    public int getOccupiedRooms() {
        return getCount("SELECT COUNT(DISTINCT room_id) FROM room_allocations WHERE status='Allocated'");
    }

    public int getVacantRooms() {
        return getTotalRooms() - getOccupiedRooms();
    }

    public int getDefaultersCount() {
        return getCount("SELECT COUNT(*) FROM fees WHERE due_amount > 0");
    }

    public double getTotalFeeCollected() {
        return getSum("SELECT IFNULL(SUM(paid_amount),0) FROM fees");
    }

    public double getTotalFeeDue() {
        return getSum("SELECT IFNULL(SUM(due_amount),0) FROM fees");
    }

    public List<ReportRow> getOccupancyReport() {
        List<ReportRow> list = new ArrayList<ReportRow>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT r.room_number, r.room_type, r.capacity, COUNT(a.student_id) AS occupied, (r.capacity - COUNT(a.student_id)) AS vacant " +
                         "FROM rooms r LEFT JOIN room_allocations a ON r.room_id = a.room_id AND a.status='Allocated' " +
                         "GROUP BY r.room_id, r.room_number, r.room_type, r.capacity ORDER BY r.room_number";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                ReportRow row = new ReportRow();
                row.setCol1(rs.getString("room_number"));
                row.setCol2(rs.getString("room_type"));
                row.setCol3(String.valueOf(rs.getInt("capacity")));
                row.setCol4(String.valueOf(rs.getInt("occupied")));
                row.setCol5(String.valueOf(rs.getInt("vacant")));
                list.add(row);
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

    public List<ReportRow> getDefaultersReport() {
        List<ReportRow> list = new ArrayList<ReportRow>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT s.id, s.name, s.email, f.fee_month, f.due_amount " +
                         "FROM fees f JOIN students s ON f.student_id = s.id " +
                         "WHERE f.due_amount > 0 ORDER BY f.due_amount DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                ReportRow row = new ReportRow();
                row.setCol1(String.valueOf(rs.getInt("id")));
                row.setCol2(rs.getString("name"));
                row.setCol3(rs.getString("email"));
                row.setCol4(rs.getString("fee_month"));
                row.setCol5(String.valueOf(rs.getDouble("due_amount")));
                list.add(row);
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

    public List<ReportRow> getFeeCollectionReport() {
        List<ReportRow> list = new ArrayList<ReportRow>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT s.id, s.name, f.fee_month, f.total_amount, f.paid_amount " +
                         "FROM fees f JOIN students s ON f.student_id = s.id ORDER BY f.created_at DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                ReportRow row = new ReportRow();
                row.setCol1(String.valueOf(rs.getInt("id")));
                row.setCol2(rs.getString("name"));
                row.setCol3(rs.getString("fee_month"));
                row.setCol4(String.valueOf(rs.getDouble("total_amount")));
                row.setCol5(String.valueOf(rs.getDouble("paid_amount")));
                list.add(row);
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

    private int getCount(String sql) {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if(rs.next()) {
                count = rs.getInt(1);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return count;
    }

    private double getSum(String sql) {
        double sum = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if(rs.next()) {
                sum = rs.getDouble(1);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return sum;
    }
}