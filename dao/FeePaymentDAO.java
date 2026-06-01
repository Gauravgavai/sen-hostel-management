package com.senhostel.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.FeePayment;
import com.senhostel.util.DBConnection;

public class FeePaymentDAO {

    public boolean addPayment(FeePayment payment) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            String sql = "INSERT INTO fee_payments(bill_id, student_id, amount_paid, payment_date, payment_mode, remarks) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, payment.getBillId());
            ps.setInt(2, payment.getStudentId());
            ps.setDouble(3, payment.getAmountPaid());
            ps.setDate(4, payment.getPaymentDate());
            ps.setString(5, payment.getPaymentMode());
            ps.setString(6, payment.getRemarks());

            status = ps.executeUpdate() > 0;

            if (status) {
                FeeBillDAO billDAO = new FeeBillDAO();
                billDAO.updateBillStatus(payment.getBillId());
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public List<FeePayment> getAllPayments() {
        List<FeePayment> list = new ArrayList<FeePayment>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String sql = "SELECT p.payment_id, p.bill_id, p.student_id, s.name, p.amount_paid, p.payment_date, p.payment_mode, p.remarks " +
                         "FROM fee_payments p JOIN students s ON p.student_id = s.id ORDER BY p.payment_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                FeePayment payment = new FeePayment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setBillId(rs.getInt("bill_id"));
                payment.setStudentId(rs.getInt("student_id"));
                payment.setStudentName(rs.getString("name"));
                payment.setAmountPaid(rs.getDouble("amount_paid"));
                payment.setPaymentDate(rs.getDate("payment_date"));
                payment.setPaymentMode(rs.getString("payment_mode"));
                payment.setRemarks(rs.getString("remarks"));
                list.add(payment);
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