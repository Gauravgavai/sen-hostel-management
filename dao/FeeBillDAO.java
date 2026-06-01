package com.senhostel.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.FeeBill;
import com.senhostel.util.DBConnection;

public class FeeBillDAO {

    public boolean generateBill(FeeBill bill) {
        boolean status = false;
        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String checkSql = "SELECT bill_id FROM fee_bills WHERE student_id=? AND bill_month=? AND bill_year=?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, bill.getStudentId());
            checkPs.setInt(2, bill.getBillMonth());
            checkPs.setInt(3, bill.getBillYear());

            rs = checkPs.executeQuery();
            if (rs.next()) {
                return false;
            }

            String insertSql = "INSERT INTO fee_bills(student_id, bill_month, bill_year, total_amount, due_date, bill_status) VALUES (?, ?, ?, ?, ?, ?)";
            insertPs = con.prepareStatement(insertSql);
            insertPs.setInt(1, bill.getStudentId());
            insertPs.setInt(2, bill.getBillMonth());
            insertPs.setInt(3, bill.getBillYear());
            insertPs.setDouble(4, bill.getTotalAmount());
            insertPs.setDate(5, bill.getDueDate());
            insertPs.setString(6, "UNPAID");

            status = insertPs.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(checkPs != null) checkPs.close(); } catch(Exception e) {}
            try { if(insertPs != null) insertPs.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<FeeBill> getAllBills() {
        List<FeeBill> list = new ArrayList<FeeBill>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String sql = "SELECT b.bill_id, b.student_id, s.name, b.bill_month, b.bill_year, b.total_amount, " +
                         "IFNULL(SUM(p.amount_paid),0) AS paid_amount, " +
                         "(b.total_amount - IFNULL(SUM(p.amount_paid),0)) AS balance_amount, " +
                         "b.due_date, b.bill_status " +
                         "FROM fee_bills b " +
                         "JOIN students s ON b.student_id = s.id " +
                         "LEFT JOIN fee_payments p ON b.bill_id = p.bill_id " +
                         "GROUP BY b.bill_id, b.student_id, s.name, b.bill_month, b.bill_year, b.total_amount, b.due_date, b.bill_status " +
                         "ORDER BY b.bill_id DESC";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                FeeBill bill = new FeeBill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setStudentId(rs.getInt("student_id"));
                bill.setStudentName(rs.getString("name"));
                bill.setBillMonth(rs.getInt("bill_month"));
                bill.setBillYear(rs.getInt("bill_year"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaidAmount(rs.getDouble("paid_amount"));
                bill.setBalanceAmount(rs.getDouble("balance_amount"));
                bill.setDueDate(rs.getDate("due_date"));
                bill.setBillStatus(rs.getString("bill_status"));
                list.add(bill);
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

    public List<FeeBill> getDefaulters() {
        List<FeeBill> list = new ArrayList<FeeBill>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String sql = "SELECT b.bill_id, b.student_id, s.name, b.bill_month, b.bill_year, b.total_amount, " +
                         "IFNULL(SUM(p.amount_paid),0) AS paid_amount, " +
                         "(b.total_amount - IFNULL(SUM(p.amount_paid),0)) AS balance_amount, " +
                         "b.due_date, b.bill_status " +
                         "FROM fee_bills b " +
                         "JOIN students s ON b.student_id = s.id " +
                         "LEFT JOIN fee_payments p ON b.bill_id = p.bill_id " +
                         "GROUP BY b.bill_id, b.student_id, s.name, b.bill_month, b.bill_year, b.total_amount, b.due_date, b.bill_status " +
                         "HAVING (b.total_amount - IFNULL(SUM(p.amount_paid),0)) > 0 " +
                         "ORDER BY b.bill_id DESC";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                FeeBill bill = new FeeBill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setStudentId(rs.getInt("student_id"));
                bill.setStudentName(rs.getString("name"));
                bill.setBillMonth(rs.getInt("bill_month"));
                bill.setBillYear(rs.getInt("bill_year"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaidAmount(rs.getDouble("paid_amount"));
                bill.setBalanceAmount(rs.getDouble("balance_amount"));
                bill.setDueDate(rs.getDate("due_date"));
                bill.setBillStatus(rs.getString("bill_status"));
                list.add(bill);
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

    public void updateBillStatus(int billId) {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String sql = "SELECT total_amount, IFNULL((SELECT SUM(amount_paid) FROM fee_payments WHERE bill_id=?),0) AS paid FROM fee_bills WHERE bill_id=?";
            ps1 = con.prepareStatement(sql);
            ps1.setInt(1, billId);
            ps1.setInt(2, billId);
            rs = ps1.executeQuery();

            if (rs.next()) {
                double total = rs.getDouble("total_amount");
                double paid = rs.getDouble("paid");

                String status = "UNPAID";
                if (paid > 0 && paid < total) {
                    status = "PARTIAL";
                } else if (paid >= total) {
                    status = "PAID";
                }

                String updateSql = "UPDATE fee_bills SET bill_status=? WHERE bill_id=?";
                ps2 = con.prepareStatement(updateSql);
                ps2.setString(1, status);
                ps2.setInt(2, billId);
                ps2.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps1 != null) ps1.close(); } catch(Exception e) {}
            try { if(ps2 != null) ps2.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
    }

	public boolean generateBill(int studentId, int billMonth, int billYear, double totalAmount, Date dueDate) {
		// TODO Auto-generated method stub
		return false;
	}
}