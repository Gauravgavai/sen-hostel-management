package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.senhostel.model.LiveDashboardStats;
import com.senhostel.util.DBConnection;

public class RealtimeDAO {

    public LiveDashboardStats getDashboardStats() {
        LiveDashboardStats stats = new LiveDashboardStats();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String roomStatsSql =
                    "SELECT " +
                    "COUNT(*) AS total_rooms, " +
                    "SUM(CASE WHEN status = 'AVAILABLE' THEN 1 ELSE 0 END) AS available_rooms, " +
                    "SUM(CASE WHEN status = 'FULL' THEN 1 ELSE 0 END) AS full_rooms, " +
                    "SUM(CASE WHEN status = 'MAINTENANCE' THEN 1 ELSE 0 END) AS maintenance_rooms, " +
                    "IFNULL(SUM(capacity), 0) AS total_beds, " +
                    "IFNULL(SUM(occupied_beds), 0) AS occupied_beds, " +
                    "IFNULL(SUM(monthly_fee), 0) AS total_room_monthly_fee, " +
                    "IFNULL(AVG(monthly_fee), 0) AS avg_room_monthly_fee " +
                    "FROM rooms";

            ps = con.prepareStatement(roomStatsSql);
            rs = ps.executeQuery();

            if (rs.next()) {
                stats.setTotalRooms(rs.getInt("total_rooms"));
                stats.setAvailableRooms(rs.getInt("available_rooms"));
                stats.setFullRooms(rs.getInt("full_rooms"));
                stats.setMaintenanceRooms(rs.getInt("maintenance_rooms"));
                stats.setTotalBeds(rs.getInt("total_beds"));
                stats.setOccupiedBeds(rs.getInt("occupied_beds"));
                stats.setTotalRoomMonthlyFee(rs.getDouble("total_room_monthly_fee"));
                stats.setAverageRoomMonthlyFee(rs.getDouble("avg_room_monthly_fee"));
            }

            rs.close();
            ps.close();

            String feeStatsSql =
                    "SELECT " +
                    "COUNT(*) AS fee_plans_count, " +
                    "IFNULL(SUM(monthly_fee), 0) AS total_fee_structure_amount, " +
                    "IFNULL(AVG(monthly_fee), 0) AS avg_fee_structure_amount, " +
                    "IFNULL(MAX(monthly_fee), 0) AS highest_fee, " +
                    "IFNULL(MIN(monthly_fee), 0) AS lowest_fee " +
                    "FROM fee_structure";

            ps = con.prepareStatement(feeStatsSql);
            rs = ps.executeQuery();

            if (rs.next()) {
                stats.setFeePlansCount(rs.getInt("fee_plans_count"));
                stats.setTotalFeeStructureAmount(rs.getDouble("total_fee_structure_amount"));
                stats.setAverageFeeStructureAmount(rs.getDouble("avg_fee_structure_amount"));
                stats.setHighestFee(rs.getDouble("highest_fee"));
                stats.setLowestFee(rs.getDouble("lowest_fee"));
            }

            stats.setVacantBeds(stats.getTotalBeds() - stats.getOccupiedBeds());
            stats.setLastUpdated(new SimpleDateFormat("dd-MM-yyyy hh:mm:ss a").format(new Date()));

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return stats;
    }

    public boolean allocateRoom(int studentId, int roomId) {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;
        ResultSet rs = null;
        boolean status = false;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String roomCheckSql = "SELECT capacity, occupied_beds, status FROM rooms WHERE room_id = ?";
            ps1 = con.prepareStatement(roomCheckSql);
            ps1.setInt(1, roomId);
            rs = ps1.executeQuery();

            int capacity = 0;
            int occupiedBeds = 0;
            String roomStatus = "";

            if (rs.next()) {
                capacity = rs.getInt("capacity");
                occupiedBeds = rs.getInt("occupied_beds");
                roomStatus = rs.getString("status");
            } else {
                return false;
            }

            if ("MAINTENANCE".equalsIgnoreCase(roomStatus) || occupiedBeds >= capacity) {
                return false;
            }

            String allocationSql = "INSERT INTO room_allocation(student_id, room_id, status) VALUES (?, ?, 'ACTIVE')";
            ps2 = con.prepareStatement(allocationSql);
            ps2.setInt(1, studentId);
            ps2.setInt(2, roomId);
            int inserted = ps2.executeUpdate();

            int newOccupiedBeds = occupiedBeds + 1;
            String newRoomStatus = (newOccupiedBeds >= capacity) ? "FULL" : "AVAILABLE";

            String updateRoomSql = "UPDATE rooms SET occupied_beds = ?, status = ? WHERE room_id = ?";
            ps3 = con.prepareStatement(updateRoomSql);
            ps3.setInt(1, newOccupiedBeds);
            ps3.setString(2, newRoomStatus);
            ps3.setInt(3, roomId);

            int updated = ps3.executeUpdate();

            if (inserted > 0 && updated > 0) {
                con.commit();
                status = true;
            } else {
                con.rollback();
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
            try { if (ps3 != null) ps3.close(); } catch (Exception e) {}
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (Exception e) {}
        }

        return status;
    }

    public boolean deallocateRoom(int allocationId) {
        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;
        ResultSet rs = null;
        boolean status = false;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String fetchSql =
                    "SELECT ra.room_id, r.capacity, r.occupied_beds " +
                    "FROM room_allocation ra " +
                    "JOIN rooms r ON ra.room_id = r.room_id " +
                    "WHERE ra.allocation_id = ? AND ra.status = 'ACTIVE'";
            ps1 = con.prepareStatement(fetchSql);
            ps1.setInt(1, allocationId);
            rs = ps1.executeQuery();

            int roomId = 0;
            int capacity = 0;
            int occupiedBeds = 0;

            if (rs.next()) {
                roomId = rs.getInt("room_id");
                capacity = rs.getInt("capacity");
                occupiedBeds = rs.getInt("occupied_beds");
            } else {
                return false;
            }

            String allocationUpdateSql = "UPDATE room_allocation SET status = 'INACTIVE' WHERE allocation_id = ?";
            ps2 = con.prepareStatement(allocationUpdateSql);
            ps2.setInt(1, allocationId);
            int allocationUpdated = ps2.executeUpdate();

            int newOccupiedBeds = Math.max(0, occupiedBeds - 1);
            String newRoomStatus = (newOccupiedBeds == 0) ? "AVAILABLE" : (newOccupiedBeds >= capacity ? "FULL" : "AVAILABLE");

            String roomUpdateSql = "UPDATE rooms SET occupied_beds = ?, status = ? WHERE room_id = ?";
            ps3 = con.prepareStatement(roomUpdateSql);
            ps3.setInt(1, newOccupiedBeds);
            ps3.setString(2, newRoomStatus);
            ps3.setInt(3, roomId);
            int roomUpdated = ps3.executeUpdate();

            if (allocationUpdated > 0 && roomUpdated > 0) {
                con.commit();
                status = true;
            } else {
                con.rollback();
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
            try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
            try { if (ps3 != null) ps3.close(); } catch (Exception e) {}
            try { if (con != null) { con.setAutoCommit(true); con.close(); } } catch (Exception e) {}
        }

        return status;
    }

    public boolean updateRoomVacancy(int roomId, int occupiedBeds, String statusText) {
        Connection con = null;
        PreparedStatement ps = null;
        boolean status = false;

        try {
            con = DBConnection.getConnection();

            String sql = "UPDATE rooms SET occupied_beds = ?, status = ? WHERE room_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, occupiedBeds);
            ps.setString(2, statusText);
            ps.setInt(3, roomId);

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return status;
    }

    public boolean updateFeeStructure(int feeId, double monthlyFee, double lateFee, String remarks) {
        Connection con = null;
        PreparedStatement ps = null;
        boolean status = false;

        try {
            con = DBConnection.getConnection();

            String sql = "UPDATE fee_structure SET monthly_fee = ?, late_fee = ?, remarks = ? WHERE fee_id = ?";
            ps = con.prepareStatement(sql);
            ps.setDouble(1, monthlyFee);
            ps.setDouble(2, lateFee);
            ps.setString(3, remarks);
            ps.setInt(4, feeId);

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return status;
    }
}
