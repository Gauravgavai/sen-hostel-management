package com.senhostel.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.senhostel.model.Student;
import com.senhostel.util.DBConnection;

public class StudentDAO {

    public List<String[]> getAllStudentsBasic() {
        List<String[]> list = new ArrayList<String[]>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT id, name, email FROM students ORDER BY name ASC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                String[] row = new String[3];
                row[0] = String.valueOf(rs.getInt("id"));
                row[1] = rs.getString("name");
                row[2] = rs.getString("email");
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

    public String[] getStudentById(int studentId) {
        String[] student = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT id, name, email FROM students WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                student = new String[3];
                student[0] = String.valueOf(rs.getInt("id"));
                student[1] = rs.getString("name");
                student[2] = rs.getString("email");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return student;
    }

    public boolean isEmailExists(String email) {
        boolean exists = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT id FROM students WHERE email = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
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

    public boolean registerStudent(Student s) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            String sql = "INSERT INTO students (" +
                    "name, email, password, contact_number, alternate_contact, " +
                    "permanent_address, gender, dob, college_name, course, academic_year, " +
                    "student_id_card, government_id_proof, parent_guardian_contact, " +
                    "local_guardian_details, emergency_contact_name, emergency_contact_relation, " +
                    "emergency_contact_number, blood_group, medical_history, chronic_conditions, " +
                    "dietary_preference, room_type_preference, ac_preference, study_habits, " +
                    "interests_hobbies, vehicle_registration, device_mac_address, " +
                    "police_verification_form, passport_photo, rules_agreed" +
                    ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

            ps = con.prepareStatement(sql);

            int i = 1;
            ps.setString(i++, s.getName());
            ps.setString(i++, s.getEmail());
            ps.setString(i++, s.getPassword());
            ps.setString(i++, s.getContactNumber());
            ps.setString(i++, s.getAlternateContact());
            ps.setString(i++, s.getPermanentAddress());
            ps.setString(i++, s.getGender());
            ps.setDate(i++, s.getDob());
            ps.setString(i++, s.getCollegeName());
            ps.setString(i++, s.getCourse());
            ps.setString(i++, s.getAcademicYear());
            ps.setString(i++, s.getStudentIdCard());
            ps.setString(i++, s.getGovernmentIdProof());
            ps.setString(i++, s.getParentGuardianContact());
            ps.setString(i++, s.getLocalGuardianDetails());
            ps.setString(i++, s.getEmergencyContactName());
            ps.setString(i++, s.getEmergencyContactRelation());
            ps.setString(i++, s.getEmergencyContactNumber());
            ps.setString(i++, s.getBloodGroup());
            ps.setString(i++, s.getMedicalHistory());
            ps.setString(i++, s.getChronicConditions());
            ps.setString(i++, s.getDietaryPreference());
            ps.setString(i++, s.getRoomTypePreference());
            ps.setString(i++, s.getAcPreference());
            ps.setString(i++, s.getStudyHabits());
            ps.setString(i++, s.getInterestsHobbies());
            ps.setString(i++, s.getVehicleRegistration());
            ps.setString(i++, s.getDeviceMacAddress());
            ps.setString(i++, s.getPoliceVerificationForm());
            ps.setString(i++, s.getPassportPhoto());
            ps.setBoolean(i++, s.isRulesAgreed());

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public Student getFullProfileById(int studentId) {
        Student s = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM students WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();

            if (rs.next()) {
                s = new Student();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                s.setContactNumber(rs.getString("contact_number"));
                s.setAlternateContact(rs.getString("alternate_contact"));
                s.setPermanentAddress(rs.getString("permanent_address"));
                s.setGender(rs.getString("gender"));
                s.setDob(rs.getDate("dob"));
                s.setCollegeName(rs.getString("college_name"));
                s.setCourse(rs.getString("course"));
                s.setAcademicYear(rs.getString("academic_year"));
                s.setParentGuardianContact(rs.getString("parent_guardian_contact"));
                s.setLocalGuardianDetails(rs.getString("local_guardian_details"));
                s.setEmergencyContactName(rs.getString("emergency_contact_name"));
                s.setEmergencyContactRelation(rs.getString("emergency_contact_relation"));
                s.setEmergencyContactNumber(rs.getString("emergency_contact_number"));
                s.setBloodGroup(rs.getString("blood_group"));
                s.setMedicalHistory(rs.getString("medical_history"));
                s.setChronicConditions(rs.getString("chronic_conditions"));
                s.setDietaryPreference(rs.getString("dietary_preference"));
                s.setRoomTypePreference(rs.getString("room_type_preference"));
                s.setAcPreference(rs.getString("ac_preference"));
                s.setStudyHabits(rs.getString("study_habits"));
                s.setInterestsHobbies(rs.getString("interests_hobbies"));
                s.setVehicleRegistration(rs.getString("vehicle_registration"));
                s.setDeviceMacAddress(rs.getString("device_mac_address"));
                s.setStudentIdCard(rs.getString("student_id_card"));
                s.setGovernmentIdProof(rs.getString("government_id_proof"));
                s.setPoliceVerificationForm(rs.getString("police_verification_form"));
                s.setPassportPhoto(rs.getString("passport_photo"));
                s.setRulesAgreed(rs.getBoolean("rules_agreed"));
                try {
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                } catch (Exception ex) {
                    s.setCreatedAt(null);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return s;
    }

    public boolean updateStudentProfile(Student s) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            String sql = "UPDATE students SET " +
                    "name=?, contact_number=?, alternate_contact=?, permanent_address=?, " +
                    "gender=?, dob=?, college_name=?, course=?, academic_year=?, " +
                    "parent_guardian_contact=?, local_guardian_details=?, emergency_contact_name=?, " +
                    "emergency_contact_relation=?, emergency_contact_number=?, blood_group=?, " +
                    "medical_history=?, chronic_conditions=?, dietary_preference=?, " +
                    "room_type_preference=?, ac_preference=?, study_habits=?, interests_hobbies=?, " +
                    "vehicle_registration=?, device_mac_address=? " +
                    "WHERE id=?";

            ps = con.prepareStatement(sql);

            int i = 1;
            ps.setString(i++, s.getName());
            ps.setString(i++, s.getContactNumber());
            ps.setString(i++, s.getAlternateContact());
            ps.setString(i++, s.getPermanentAddress());
            ps.setString(i++, s.getGender());
            ps.setDate(i++, s.getDob());
            ps.setString(i++, s.getCollegeName());
            ps.setString(i++, s.getCourse());
            ps.setString(i++, s.getAcademicYear());
            ps.setString(i++, s.getParentGuardianContact());
            ps.setString(i++, s.getLocalGuardianDetails());
            ps.setString(i++, s.getEmergencyContactName());
            ps.setString(i++, s.getEmergencyContactRelation());
            ps.setString(i++, s.getEmergencyContactNumber());
            ps.setString(i++, s.getBloodGroup());
            ps.setString(i++, s.getMedicalHistory());
            ps.setString(i++, s.getChronicConditions());
            ps.setString(i++, s.getDietaryPreference());
            ps.setString(i++, s.getRoomTypePreference());
            ps.setString(i++, s.getAcPreference());
            ps.setString(i++, s.getStudyHabits());
            ps.setString(i++, s.getInterestsHobbies());
            ps.setString(i++, s.getVehicleRegistration());
            ps.setString(i++, s.getDeviceMacAddress());
            ps.setInt(i++, s.getId());

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }

    public boolean updateStudentPassword(int studentId, String oldPassword, String newPassword) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            String checkSql = "SELECT id FROM students WHERE id=? AND password=?";
            ps = con.prepareStatement(checkSql);
            ps.setInt(1, studentId);
            ps.setString(2, oldPassword);
            rs = ps.executeQuery();

            if (!rs.next()) {
                return false;
            }

            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}

            String updateSql = "UPDATE students SET password=? WHERE id=?";
            ps = con.prepareStatement(updateSql);
            ps.setString(1, newPassword);
            ps.setInt(2, studentId);

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }

        return status;
    }
}
