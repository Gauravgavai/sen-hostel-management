<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.senhostel.model.Student" %>
<%
    if(session == null || session.getAttribute("studentId") == null){
        response.sendRedirect(request.getContextPath() + "/student/student-login.jsp");
        return;
    }

    Student s = (Student) request.getAttribute("studentProfile");
    if (s == null) {
        s = new Student();
    }

    String succMsg = (String) session.getAttribute("succMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    session.removeAttribute("succMsg");
    session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Profile</title>
    <style>
        body{
            font-family: Arial, sans-serif;
            background:#f4f7fb;
            margin:0;
            padding:30px;
        }
        .container{
            width:92%;
            margin:auto;
        }
        .topbar{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:20px;
            flex-wrap:wrap;
            gap:10px;
        }
        .topbar h2{
            margin:0;
        }
        .btn-link{
            text-decoration:none;
            background:#2563eb;
            color:#fff;
            padding:10px 16px;
            border-radius:8px;
            font-size:14px;
        }
        .alert{
            padding:12px 15px;
            border-radius:8px;
            margin-bottom:15px;
            font-size:14px;
        }
        .success{
            background:#e8f5e9;
            color:#1b5e20;
            border:1px solid #a5d6a7;
        }
        .error{
            background:#ffebee;
            color:#b71c1c;
            border:1px solid #ef9a9a;
        }
        .layout{
            display:grid;
            grid-template-columns: 1.05fr 1fr;
            gap:20px;
        }
        .card{
            background:#fff;
            border-radius:14px;
            padding:18px;
            box-shadow:0 6px 18px rgba(0,0,0,0.08);
            margin-bottom:18px;
        }
        .card h3{
            margin-top:0;
            margin-bottom:15px;
            color:#1e293b;
        }
        .info-row{
            margin-bottom:8px;
            line-height:1.5;
            font-size:14px;
        }
        .label{
            font-weight:bold;
            color:#334155;
        }
        label{
            display:block;
            margin-top:12px;
            margin-bottom:6px;
            font-size:13px;
            font-weight:bold;
            color:#334155;
        }
        input, textarea, select{
            width:100%;
            padding:10px 12px;
            border:1px solid #cbd5e1;
            border-radius:8px;
            font-size:14px;
            box-sizing:border-box;
        }
        textarea{
            resize:vertical;
            min-height:70px;
        }
        .submit-btn{
            margin-top:16px;
            background:#2563eb;
            color:white;
            border:none;
            padding:11px 18px;
            border-radius:8px;
            font-size:14px;
            cursor:pointer;
        }
        .submit-btn.secondary{
            background:#475569;
        }
        .section-badge{
            display:inline-block;
            background:#e0f2fe;
            color:#0369a1;
            padding:4px 10px;
            border-radius:999px;
            font-size:12px;
            margin-bottom:10px;
        }
        .doc-item{
            padding:8px 10px;
            background:#f8fafc;
            border:1px solid #e2e8f0;
            border-radius:8px;
            margin-bottom:8px;
            font-size:14px;
        }
        @media(max-width:900px){
            .layout{
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="topbar">
        <h2>My Profile</h2>
        <a href="<%=request.getContextPath()%>/studentDashboard" class="btn-link">Back to Dashboard</a>
    </div>

    <% if (succMsg != null) { %>
        <div class="alert success"><%= succMsg %></div>
    <% } %>

    <% if (errorMsg != null) { %>
        <div class="alert error"><%= errorMsg %></div>
    <% } %>

    <div class="layout">
        <div>
            <div class="card">
                <div class="section-badge">Basic Info</div>
                <h3>Personal Details</h3>
                <div class="info-row"><span class="label">Name:</span> <%= s.getName() != null ? s.getName() : "-" %></div>
                <div class="info-row"><span class="label">Email:</span> <%= s.getEmail() != null ? s.getEmail() : "-" %></div>
                <div class="info-row"><span class="label">Mobile:</span> <%= s.getContactNumber() != null ? s.getContactNumber() : "-" %></div>
                <div class="info-row"><span class="label">Alternate Contact:</span> <%= s.getAlternateContact() != null ? s.getAlternateContact() : "-" %></div>
                <div class="info-row"><span class="label">Gender:</span> <%= s.getGender() != null ? s.getGender() : "-" %></div>
                <div class="info-row"><span class="label">DOB:</span> <%= s.getDob() != null ? s.getDob() : "-" %></div>
                <div class="info-row"><span class="label">Permanent Address:</span> <%= s.getPermanentAddress() != null ? s.getPermanentAddress() : "-" %></div>
                <div class="info-row"><span class="label">Account Created:</span> <%= s.getCreatedAt() != null ? s.getCreatedAt() : "Not available" %></div>
            </div>

            <div class="card">
                <div class="section-badge">Academic Info</div>
                <h3>College Details</h3>
                <div class="info-row"><span class="label">College:</span> <%= s.getCollegeName() != null ? s.getCollegeName() : "-" %></div>
                <div class="info-row"><span class="label">Course:</span> <%= s.getCourse() != null ? s.getCourse() : "-" %></div>
                <div class="info-row"><span class="label">Academic Year:</span> <%= s.getAcademicYear() != null ? s.getAcademicYear() : "-" %></div>
            </div>

            <div class="card">
                <div class="section-badge">Guardian / Emergency</div>
                <h3>Emergency Contact</h3>
                <div class="info-row"><span class="label">Parent/Guardian Contact:</span> <%= s.getParentGuardianContact() != null ? s.getParentGuardianContact() : "-" %></div>
                <div class="info-row"><span class="label">Local Guardian Details:</span> <%= s.getLocalGuardianDetails() != null ? s.getLocalGuardianDetails() : "-" %></div>
                <div class="info-row"><span class="label">Emergency Contact Name:</span> <%= s.getEmergencyContactName() != null ? s.getEmergencyContactName() : "-" %></div>
                <div class="info-row"><span class="label">Relation:</span> <%= s.getEmergencyContactRelation() != null ? s.getEmergencyContactRelation() : "-" %></div>
                <div class="info-row"><span class="label">Emergency Number:</span> <%= s.getEmergencyContactNumber() != null ? s.getEmergencyContactNumber() : "-" %></div>
            </div>

            <div class="card">
                <div class="section-badge">Health / Lifestyle</div>
                <h3>Health Details</h3>
                <div class="info-row"><span class="label">Blood Group:</span> <%= s.getBloodGroup() != null ? s.getBloodGroup() : "-" %></div>
                <div class="info-row"><span class="label">Medical History:</span> <%= s.getMedicalHistory() != null ? s.getMedicalHistory() : "-" %></div>
                <div class="info-row"><span class="label">Chronic Conditions:</span> <%= s.getChronicConditions() != null ? s.getChronicConditions() : "-" %></div>
                <div class="info-row"><span class="label">Dietary Preference:</span> <%= s.getDietaryPreference() != null ? s.getDietaryPreference() : "-" %></div>
                <div class="info-row"><span class="label">Room Type Preference:</span> <%= s.getRoomTypePreference() != null ? s.getRoomTypePreference() : "-" %></div>
                <div class="info-row"><span class="label">AC Preference:</span> <%= s.getAcPreference() != null ? s.getAcPreference() : "-" %></div>
                <div class="info-row"><span class="label">Study Habits:</span> <%= s.getStudyHabits() != null ? s.getStudyHabits() : "-" %></div>
                <div class="info-row"><span class="label">Interests/Hobbies:</span> <%= s.getInterestsHobbies() != null ? s.getInterestsHobbies() : "-" %></div>
                <div class="info-row"><span class="label">Vehicle Registration:</span> <%= s.getVehicleRegistration() != null ? s.getVehicleRegistration() : "-" %></div>
                <div class="info-row"><span class="label">Device MAC Address:</span> <%= s.getDeviceMacAddress() != null ? s.getDeviceMacAddress() : "-" %></div>
            </div>

            <div class="card">
                <div class="section-badge">Documents</div>
                <h3>Uploaded Docs</h3>
                <div class="doc-item">Student ID Card: <%= s.getStudentIdCard() != null ? s.getStudentIdCard() : "Not uploaded" %></div>
                <div class="doc-item">Government ID Proof: <%= s.getGovernmentIdProof() != null ? s.getGovernmentIdProof() : "Not uploaded" %></div>
                <div class="doc-item">Police Verification Form: <%= s.getPoliceVerificationForm() != null ? s.getPoliceVerificationForm() : "Not uploaded" %></div>
                <div class="doc-item">Passport Photo: <%= s.getPassportPhoto() != null ? s.getPassportPhoto() : "Not uploaded" %></div>
            </div>
        </div>

        <div>
            <div class="card">
                <div class="section-badge">Edit Profile</div>
                <h3>Update Details</h3>
                <form action="<%=request.getContextPath()%>/studentProfile" method="post">
                    <input type="hidden" name="action" value="updateProfile">

                    <label>Name</label>
                    <input type="text" name="name" value="<%= s.getName() != null ? s.getName() : "" %>" required>

                    <label>Mobile</label>
                    <input type="text" name="contactNumber" value="<%= s.getContactNumber() != null ? s.getContactNumber() : "" %>">

                    <label>Alternate Contact</label>
                    <input type="text" name="alternateContact" value="<%= s.getAlternateContact() != null ? s.getAlternateContact() : "" %>">

                    <label>Permanent Address</label>
                    <textarea name="permanentAddress"><%= s.getPermanentAddress() != null ? s.getPermanentAddress() : "" %></textarea>

                    <label>Gender</label>
                    <select name="gender">
                        <option value="">Select Gender</option>
                        <option value="Male" <%= "Male".equalsIgnoreCase(s.getGender()) ? "selected" : "" %>>Male</option>
                        <option value="Female" <%= "Female".equalsIgnoreCase(s.getGender()) ? "selected" : "" %>>Female</option>
                        <option value="Other" <%= "Other".equalsIgnoreCase(s.getGender()) ? "selected" : "" %>>Other</option>
                    </select>

                    <label>DOB</label>
                    <input type="date" name="dob" value="<%= s.getDob() != null ? s.getDob() : "" %>">

                    <label>College Name</label>
                    <input type="text" name="collegeName" value="<%= s.getCollegeName() != null ? s.getCollegeName() : "" %>">

                    <label>Course</label>
                    <input type="text" name="course" value="<%= s.getCourse() != null ? s.getCourse() : "" %>">

                    <label>Academic Year</label>
                    <input type="text" name="academicYear" value="<%= s.getAcademicYear() != null ? s.getAcademicYear() : "" %>">

                    <label>Parent / Guardian Contact</label>
                    <input type="text" name="parentGuardianContact" value="<%= s.getParentGuardianContact() != null ? s.getParentGuardianContact() : "" %>">

                    <label>Local Guardian Details</label>
                    <textarea name="localGuardianDetails"><%= s.getLocalGuardianDetails() != null ? s.getLocalGuardianDetails() : "" %></textarea>

                    <label>Emergency Contact Name</label>
                    <input type="text" name="emergencyContactName" value="<%= s.getEmergencyContactName() != null ? s.getEmergencyContactName() : "" %>">

                    <label>Emergency Contact Relation</label>
                    <input type="text" name="emergencyContactRelation" value="<%= s.getEmergencyContactRelation() != null ? s.getEmergencyContactRelation() : "" %>">

                    <label>Emergency Contact Number</label>
                    <input type="text" name="emergencyContactNumber" value="<%= s.getEmergencyContactNumber() != null ? s.getEmergencyContactNumber() : "" %>">

                    <label>Blood Group</label>
                    <input type="text" name="bloodGroup" value="<%= s.getBloodGroup() != null ? s.getBloodGroup() : "" %>">

                    <label>Medical History</label>
                    <textarea name="medicalHistory"><%= s.getMedicalHistory() != null ? s.getMedicalHistory() : "" %></textarea>

                    <label>Chronic Conditions</label>
                    <textarea name="chronicConditions"><%= s.getChronicConditions() != null ? s.getChronicConditions() : "" %></textarea>

                    <label>Dietary Preference</label>
                    <input type="text" name="dietaryPreference" value="<%= s.getDietaryPreference() != null ? s.getDietaryPreference() : "" %>">

                    <label>Room Type Preference</label>
                    <input type="text" name="roomTypePreference" value="<%= s.getRoomTypePreference() != null ? s.getRoomTypePreference() : "" %>">

                    <label>AC Preference</label>
                    <input type="text" name="acPreference" value="<%= s.getAcPreference() != null ? s.getAcPreference() : "" %>">

                    <label>Study Habits</label>
                    <textarea name="studyHabits"><%= s.getStudyHabits() != null ? s.getStudyHabits() : "" %></textarea>

                    <label>Interests & Hobbies</label>
                    <textarea name="interestsHobbies"><%= s.getInterestsHobbies() != null ? s.getInterestsHobbies() : "" %></textarea>

                    <label>Vehicle Registration</label>
                    <input type="text" name="vehicleRegistration" value="<%= s.getVehicleRegistration() != null ? s.getVehicleRegistration() : "" %>">

                    <label>Device MAC Address</label>
                    <input type="text" name="deviceMacAddress" value="<%= s.getDeviceMacAddress() != null ? s.getDeviceMacAddress() : "" %>">

                    <button type="submit" class="submit-btn">Save Changes</button>
                </form>
            </div>

            <div class="card">
                <div class="section-badge">Security</div>
                <h3>Change Password</h3>
                <form action="<%=request.getContextPath()%>/studentProfile" method="post">
                    <input type="hidden" name="action" value="changePassword">

                    <label>Old Password</label>
                    <input type="password" name="oldPassword" required>

                    <label>New Password</label>
                    <input type="password" name="newPassword" required>

                    <label>Confirm New Password</label>
                    <input type="password" name="confirmPassword" required>

                    <button type="submit" class="submit-btn secondary">Change Password</button>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
