package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.Room;
import com.senhostel.util.DBConnection;

public class RoomDAO {

    public boolean addRoom(Room room) {
        boolean inserted = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO rooms (room_number, block, floor, room_type, capacity, occupied, fees, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getBlock());
            ps.setInt(3, room.getFloor());
            ps.setString(4, room.getRoomType());
            ps.setInt(5, room.getCapacity());
            ps.setInt(6, room.getOccupied());
            ps.setDouble(7, room.getFees());
            ps.setString(8, room.getStatus());

            inserted = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return inserted;
    }

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<Room>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT room_id, room_number, block, floor, room_type, capacity, occupied, fees, status FROM rooms ORDER BY room_id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setBlock(rs.getString("block"));
                r.setFloor(rs.getInt("floor"));
                r.setRoomType(rs.getString("room_type"));
                r.setCapacity(rs.getInt("capacity"));
                r.setOccupied(rs.getInt("occupied"));
                r.setFees(rs.getDouble("fees"));
                r.setStatus(rs.getString("status"));
                list.add(r);
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

    public Room getRoomById(int id) {
        Room r = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT room_id, room_number, block, floor, room_type, capacity, occupied, fees, status FROM rooms WHERE room_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setBlock(rs.getString("block"));
                r.setFloor(rs.getInt("floor"));
                r.setRoomType(rs.getString("room_type"));
                r.setCapacity(rs.getInt("capacity"));
                r.setOccupied(rs.getInt("occupied"));
                r.setFees(rs.getDouble("fees"));
                r.setStatus(rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return r;
    }

    public boolean updateRoom(Room room) {
        boolean updated = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "UPDATE rooms SET room_number=?, block=?, floor=?, room_type=?, capacity=?, occupied=?, fees=?, status=? WHERE room_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, room.getRoomNumber());
            ps.setString(2, room.getBlock());
            ps.setInt(3, room.getFloor());
            ps.setString(4, room.getRoomType());
            ps.setInt(5, room.getCapacity());
            ps.setInt(6, room.getOccupied());
            ps.setDouble(7, room.getFees());
            ps.setString(8, room.getStatus());
            ps.setInt(9, room.getRoomId());

            updated = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return updated;
    }

    public boolean deleteRoom(int id) {
        boolean deleted = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "DELETE FROM rooms WHERE room_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            deleted = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return deleted;
    }
}