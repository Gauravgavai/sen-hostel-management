<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.senhostel.model.Event" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hostel Events</title>
    <style>
        *{box-sizing:border-box;}
        body { font-family: Arial, sans-serif; margin: 0; background: #f6f8fc; }
        .wrapper { display:flex; min-height:100vh; }
        .sidebar { width:230px; background:#273c75; color:white; padding:20px; }
        .sidebar h2 { margin-top:0; }
        .sidebar a { display:block; color:white; text-decoration:none; padding:10px 0; border-bottom:1px solid rgba(255,255,255,0.2); }
        .sidebar a:hover { color:#fbc531; }
        .content { flex:1; padding:30px; }
        .card { background:white; padding:22px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.08); margin-bottom:20px; }
        .event-card { border:1px solid #e5e7eb; border-radius:12px; padding:16px; margin-bottom:15px; background:#fbfdff; }
        select, button { padding:10px 12px; border-radius:8px; margin-top:8px; }
        button { background:#273c75; color:white; border:none; cursor:pointer; font-weight:bold; }
        .success { color:green; font-weight:bold; }
        .error { color:red; font-weight:bold; }
        .badge-upcoming, .badge-completed, .badge-cancelled {
            padding:6px 10px; border-radius:20px; font-size:12px; font-weight:bold; display:inline-block; margin-bottom:10px;
        }
        .badge-upcoming { background:#dbeafe; color:#1d4ed8; }
        .badge-completed { background:#dcfce7; color:#15803d; }
        .badge-cancelled { background:#fee2e2; color:#dc2626; }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/studentEvents">Events Calendar</a>
    </div>

    <div class="content">
        <div class="card">
            <h1>Hostel Events</h1>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>
        </div>

        <%
            List<Event> eventList = (List<Event>) request.getAttribute("eventList");
            Map<Integer, String> rsvpMap = (Map<Integer, String>) request.getAttribute("rsvpMap");

            if(eventList != null && !eventList.isEmpty()) {
                for(Event e : eventList) {
        %>
        <div class="event-card">
            <% if("Upcoming".equalsIgnoreCase(e.getStatus())) { %>
                <span class="badge-upcoming"><%= e.getStatus() %></span>
            <% } else if("Completed".equalsIgnoreCase(e.getStatus())) { %>
                <span class="badge-completed"><%= e.getStatus() %></span>
            <% } else { %>
                <span class="badge-cancelled"><%= e.getStatus() %></span>
            <% } %>

            <h3><%= e.getEventTitle() %></h3>
            <p><%= e.getEventDescription() %></p>
            <p><strong>Date:</strong> <%= e.getEventDate() %> | <strong>Time:</strong> <%= e.getEventTime() %></p>
            <p><strong>Venue:</strong> <%= e.getVenue() %> | <strong>Organizer:</strong> <%= e.getOrganizer() %></p>
            <p><strong>Your Response:</strong> <%= rsvpMap.get(e.getEventId()) == null || rsvpMap.get(e.getEventId()).equals("") ? "No response yet" : rsvpMap.get(e.getEventId()) %></p>

            <form action="<%=request.getContextPath()%>/respondEvent" method="post">
                <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                <select name="responseStatus" required>
                    <option value="">-- Select Response --</option>
                    <option value="Going">Going</option>
                    <option value="Interested">Interested</option>
                    <option value="Not Going">Not Going</option>
                </select>
                <button type="submit">Submit RSVP</button>
            </form>
        </div>
        <% }} else { %>
        <div class="card">
            <p>No events available right now.</p>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>