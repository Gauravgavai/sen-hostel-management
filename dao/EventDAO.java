package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.Event;
import com.senhostel.util.DBConnection;

public class EventDAO {

    public boolean addEvent(Event event) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String sql = "INSERT INTO events(event_title, event_description, event_date, event_time, venue, organizer, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, event.getEventTitle());
            ps.setString(2, event.getEventDescription());
            ps.setDate(3, event.getEventDate());
            ps.setString(4, event.getEventTime());
            ps.setString(5, event.getVenue());
            ps.setString(6, event.getOrganizer());
            ps.setString(7, event.getStatus());

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return status;
    }

    public List<Event> getAllEvents() {
        List<Event> list = new ArrayList<Event>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM events ORDER BY event_date ASC, event_time ASC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Event e = new Event();
                e.setEventId(rs.getInt("event_id"));
                e.setEventTitle(rs.getString("event_title"));
                e.setEventDescription(rs.getString("event_description"));
                e.setEventDate(rs.getDate("event_date"));
                e.setEventTime(rs.getString("event_time"));
                e.setVenue(rs.getString("venue"));
                e.setOrganizer(rs.getString("organizer"));
                e.setStatus(rs.getString("status"));
                e.setCreatedAt(rs.getTimestamp("created_at"));
                e.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(e);
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

    public boolean saveOrUpdateRSVP(int eventId, int studentId, String responseStatus) {
        boolean status = false;
        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String checkSql = "SELECT rsvp_id FROM event_rsvp WHERE event_id=? AND student_id=?";
            checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, eventId);
            checkPs.setInt(2, studentId);
            rs = checkPs.executeQuery();

            if (rs.next()) {
                String updateSql = "UPDATE event_rsvp SET response_status=?, responded_at=NOW() WHERE event_id=? AND student_id=?";
                ps = con.prepareStatement(updateSql);
                ps.setString(1, responseStatus);
                ps.setInt(2, eventId);
                ps.setInt(3, studentId);
            } else {
                String insertSql = "INSERT INTO event_rsvp(event_id, student_id, response_status) VALUES (?, ?, ?)";
                ps = con.prepareStatement(insertSql);
                ps.setInt(1, eventId);
                ps.setInt(2, studentId);
                ps.setString(3, responseStatus);
            }

            status = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(checkPs != null) checkPs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public String getStudentRSVPStatus(int eventId, int studentId) {
        String response = "";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT response_status FROM event_rsvp WHERE event_id=? AND student_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, eventId);
            ps.setInt(2, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                response = rs.getString("response_status");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        return response;
    }

	public Event getNextEventForStudent(int studentId) {
		// TODO Auto-generated method stub
		return null;
	}
}