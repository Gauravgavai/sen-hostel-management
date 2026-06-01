package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.senhostel.util.DBConnection;

public class PushSubscriberDAO {

    public boolean existsSubscription(String userType, int userId, String endpoint) {
        boolean exists = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT subscriber_id FROM push_subscribers WHERE user_type=? AND user_id=? AND endpoint=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, userType);
            ps.setInt(2, userId);
            ps.setString(3, endpoint);
            rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return exists;
    }

    public boolean saveOrUpdateSubscription(String userType, int userId, String endpoint, String p256dh, String authKey) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            if (existsSubscription(userType, userId, endpoint)) {
                String sql = "UPDATE push_subscribers SET p256dh=?, auth_key=? WHERE user_type=? AND user_id=? AND endpoint=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, p256dh);
                ps.setString(2, authKey);
                ps.setString(3, userType);
                ps.setInt(4, userId);
                ps.setString(5, endpoint);
            } else {
                String sql = "INSERT INTO push_subscribers(user_type, user_id, endpoint, p256dh, auth_key) VALUES (?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, userType);
                ps.setInt(2, userId);
                ps.setString(3, endpoint);
                ps.setString(4, p256dh);
                ps.setString(5, authKey);
            }

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
