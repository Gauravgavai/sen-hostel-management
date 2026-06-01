package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.Room;
import com.senhostel.model.RoomAllocation;
import com.senhostel.util.DBConnection;

public class RoomAllocationDAO {

    public boolean allocateRoom(int studentId, int roomId) {
        Connection con = null;
        PreparedStatement psStudentActive = null;
        PreparedStatement psRoom = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdateRoom = null;
        ResultSet rsStudentActive = null;
        ResultSet rsRoom = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String checkStudentActive = "SELECT allocation_id FROM room_allocation WHERE student_id=? AND status='ACTIVE'";
            psStudentActive = con.prepareStatement(checkStudentActive);
            psStudentActive.setInt(1, studentId);
            rsStudentActive = psStudentActive.executeQuery();

            if (rsStudentActive.next()) {
                con.rollback();
                return false;
            }

            String roomSql = "SELECT room_id, capacity, occupied, status FROM rooms WHERE room_id=?";
            psRoom = con.prepareStatement(roomSql);
            psRoom.setInt(1, roomId);
            rsRoom = psRoom.executeQuery();

            if (!rsRoom.next()) {
                con.rollback();
                return false;
            }

            int capacity = rsRoom.getInt("capacity");
            int occupied = rsRoom.getInt("occupied");
            String roomStatus = rsRoom.getString("status");

            if ("Full".equalsIgnoreCase(roomStatus) || "Maintenance".equalsIgnoreCase(roomStatus) || occupied >= capacity) {
                con.rollback();
                return false;
            }

            String insertSql = "INSERT INTO room_allocation(student_id, room_id, allocation_date, status) VALUES (?, ?, CURDATE(), 'ACTIVE')";
            psInsert = con.prepareStatement(insertSql);
            psInsert.setInt(1, studentId);
            psInsert.setInt(2, roomId);

            int inserted = psInsert.executeUpdate();

            int newOccupied = occupied + 1;
            String newStatus = (newOccupied >= capacity) ? "Full" : "Available";

            String updateRoomSql = "UPDATE rooms SET occupied=?, status=? WHERE room_id=?";
            psUpdateRoom = con.prepareStatement(updateRoomSql);
            psUpdateRoom.setInt(1, newOccupied);
            psUpdateRoom.setString(2, newStatus);
            psUpdateRoom.setInt(3, roomId);

            int updated = psUpdateRoom.executeUpdate();

            if (inserted > 0 && updated > 0) {
                con.commit();
                return true;
            } else {
                con.rollback();
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            return false;
        } finally {
            try { if (rsStudentActive != null) rsStudentActive.close(); } catch (Exception e) {}
            try { if (rsRoom != null) rsRoom.close(); } catch (Exception e) {}
            try { if (psStudentActive != null) psStudentActive.close(); } catch (Exception e) {}
            try { if (psRoom != null) psRoom.close(); } catch (Exception e) {}
            try { if (psInsert != null) psInsert.close(); } catch (Exception e) {}
            try { if (psUpdateRoom != null) psUpdateRoom.close(); } catch (Exception e) {}
            try { if (con != null) con.setAutoCommit(true); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public List<RoomAllocation> getAllAllocations() {
        List<RoomAllocation> list = new ArrayList<RoomAllocation>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT ra.allocation_id, ra.student_id, ra.room_id, ra.allocation_date, ra.deallocation_date, ra.status, " +
                         "s.name AS student_name, s.email, r.room_number, r.block, r.capacity, r.occupied " +
                         "FROM room_allocation ra " +
                         "JOIN students s ON ra.student_id = s.id " +
                         "JOIN rooms r ON ra.room_id = r.room_id " +
                         "ORDER BY ra.allocation_id DESC";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                RoomAllocation ra = new RoomAllocation();
                ra.setAllocationId(rs.getInt("allocation_id"));
                ra.setStudentId(rs.getInt("student_id"));
                ra.setRoomId(rs.getInt("room_id"));
                ra.setAllocationDate(rs.getDate("allocation_date"));
                ra.setDeallocationDate(rs.getDate("deallocation_date"));
                ra.setStatus(rs.getString("status"));
                ra.setStudentName(rs.getString("student_name"));
                ra.setEmail(rs.getString("email"));
                ra.setRoomNumber(rs.getString("room_number"));
                ra.setBlock(rs.getString("block"));
                ra.setCapacity(rs.getInt("capacity"));
                ra.setOccupied(rs.getInt("occupied"));
                ra.setVacancy(rs.getInt("capacity") - rs.getInt("occupied"));
                list.add(ra);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return list;
    }

    public boolean deactivateAllocation(int allocationId) {
        Connection con = null;
        PreparedStatement psGet = null;
        PreparedStatement psUpdateAllocation = null;
        PreparedStatement psUpdateRoom = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String getSql = "SELECT room_id, status FROM room_allocation WHERE allocation_id=?";
            psGet = con.prepareStatement(getSql);
            psGet.setInt(1, allocationId);
            rs = psGet.executeQuery();

            if (!rs.next()) {
                con.rollback();
                return false;
            }

            int roomId = rs.getInt("room_id");
            String allocStatus = rs.getString("status");

            if (!"ACTIVE".equalsIgnoreCase(allocStatus)) {
                con.rollback();
                return false;
            }

            String updateAllocSql = "UPDATE room_allocation SET status='INACTIVE', deallocation_date=CURDATE() WHERE allocation_id=?";
            psUpdateAllocation = con.prepareStatement(updateAllocSql);
            psUpdateAllocation.setInt(1, allocationId);

            int allocUpdated = psUpdateAllocation.executeUpdate();

            String updateRoomSql = "UPDATE rooms SET occupied = CASE WHEN occupied > 0 THEN occupied - 1 ELSE 0 END, status='Available' WHERE room_id=?";
            psUpdateRoom = con.prepareStatement(updateRoomSql);
            psUpdateRoom.setInt(1, roomId);

            int roomUpdated = psUpdateRoom.executeUpdate();

            if (allocUpdated > 0 && roomUpdated > 0) {
                con.commit();
                return true;
            } else {
                con.rollback();
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (psGet != null) psGet.close(); } catch (Exception e) {}
            try { if (psUpdateAllocation != null) psUpdateAllocation.close(); } catch (Exception e) {}
            try { if (psUpdateRoom != null) psUpdateRoom.close(); } catch (Exception e) {}
            try { if (con != null) con.setAutoCommit(true); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }

    public RoomAllocation getActiveAllocationByStudentId(int studentId) {
        RoomAllocation ra = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT ra.allocation_id, ra.allocation_date, ra.status, " +
                         "r.room_id, r.room_number, r.block, r.capacity, r.occupied " +
                         "FROM room_allocation ra " +
                         "JOIN rooms r ON ra.room_id = r.room_id " +
                         "WHERE ra.student_id=? AND ra.status='ACTIVE'";

            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                ra = new RoomAllocation();
                ra.setAllocationId(rs.getInt("allocation_id"));
                ra.setAllocationDate(rs.getDate("allocation_date"));
                ra.setStatus(rs.getString("status"));
                ra.setRoomId(rs.getInt("room_id"));
                ra.setRoomNumber(rs.getString("room_number"));
                ra.setBlock(rs.getString("block"));
                ra.setCapacity(rs.getInt("capacity"));
                ra.setOccupied(rs.getInt("occupied"));
                ra.setVacancy(rs.getInt("capacity") - rs.getInt("occupied"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        return ra;
    }

	public Room getCurrentRoomForStudent(int studentId) {
		// TODO Auto-generated method stub
		return null;
	}
}