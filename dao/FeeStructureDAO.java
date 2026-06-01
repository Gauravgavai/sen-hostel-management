package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.FeeStructure;
import com.senhostel.util.DBConnection;

public class FeeStructureDAO {

    public boolean addFeeStructure(FeeStructure fs) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO fee_structure(room_type, monthly_fee, late_fee, remarks) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, fs.getRoomType());
            ps.setDouble(2, fs.getMonthlyFee());
            ps.setDouble(3, fs.getLateFee());
            ps.setString(4, fs.getRemarks());

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<FeeStructure> getAllFeeStructures() {
        List<FeeStructure> list = new ArrayList<FeeStructure>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM fee_structure ORDER BY fee_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()) {
                FeeStructure fs = new FeeStructure();
                fs.setFeeId(rs.getInt("fee_id"));
                fs.setRoomType(rs.getString("room_type"));
                fs.setMonthlyFee(rs.getDouble("monthly_fee"));
                fs.setLateFee(rs.getDouble("late_fee"));
                fs.setRemarks(rs.getString("remarks"));
                list.add(fs);
            }

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return list;
    }
}