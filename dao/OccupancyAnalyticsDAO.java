package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.PredictionPoint;
import com.senhostel.util.DBConnection;

public class OccupancyAnalyticsDAO {

    public double getCurrentOccupancy() {
        double current = 0.0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT occupancy_percent FROM occupancy_history ORDER BY snapshot_date DESC LIMIT 1";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                current = rs.getDouble("occupancy_percent");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return current;
    }

    public List<Double> getLast7DaysOccupancy() {
        List<Double> list = new ArrayList<Double>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT occupancy_percent FROM occupancy_history ORDER BY snapshot_date DESC LIMIT 7";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getDouble("occupancy_percent"));
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

    public List<PredictionPoint> predictNext7Days() {
        List<PredictionPoint> predictions = new ArrayList<PredictionPoint>();
        List<Double> history = getLast7DaysOccupancy();

        double avg = 0.0;
        for (double value : history) {
            avg += value;
        }
        if (!history.isEmpty()) {
            avg = avg / history.size();
        }

        java.time.LocalDate today = java.time.LocalDate.now();

        for (int i = 1; i <= 7; i++) {
            double adjustment = (i % 2 == 0) ? 1.5 : 0.8;
            double predicted = avg + adjustment;
            if (predicted > 100) predicted = 100;

            predictions.add(new PredictionPoint(today.plusDays(i).toString(), Math.round(predicted * 100.0) / 100.0));
        }

        return predictions;
    }

    public String getRiskLevel(double peak) {
        if (peak > 90) return "High";
        if (peak >= 75) return "Medium";
        return "Low";
    }
}
