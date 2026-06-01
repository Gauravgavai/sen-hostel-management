<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.Event" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Event Calendar</title>
    <style>
        *{box-sizing:border-box;}
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f7fb; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 240px; background: #1f2937; color: white; padding: 20px; }
        .sidebar h2 { margin-top: 0; }
        .sidebar a { display: block; color: #d1d5db; text-decoration: none; padding: 12px 10px; border-radius: 8px; margin-bottom: 6px; }
        .sidebar a:hover { background: #374151; color: #fff; }
        .content { flex: 1; padding: 30px; }
        .card { background: white; padding: 22px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 24px; }
        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:15px; }
        .grid-3 { display:grid; grid-template-columns:1fr 1fr 1fr; gap:15px; }
        label { font-weight:bold; display:block; margin-bottom:6px; }
        input, textarea, select { width:100%; padding:11px 12px; border:1px solid #dcdde1; border-radius:8px; margin-bottom:15px; }
        textarea { min-height: 90px; }
        button { background:#1d4ed8; color:white; border:none; padding:12px 18px; border-radius:8px; cursor:pointer; font-weight:bold; }
        button:hover { background:#1e40af; }
        .success { color:green; font-weight:bold; }
        .error { color:red; font-weight:bold; }
        .event-card {
            border:1px solid #e5e7eb; border-radius:12px; padding:16px; margin-bottom:15px;
            background:#fbfdff;
        }
        .badge-upcoming, .badge-completed, .badge-cancelled {
            padding:6px 10px; border-radius:20px; font-size:12px; font-weight:bold; display:inline-block;
        }
        .badge-upcoming { background:#dbeafe; color:#1d4ed8; }
        .badge-completed { background:#dcfce7; color:#15803d; }
        .badge-cancelled { background:#fee2e2; color:#dc2626; }
        @media(max-width:900px){
            .grid-2, .grid-3 { grid-template-columns:1fr; }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/viewEvents">Event Calendar</a>
    </div>

    <div class="content">
        <div class="card">
            <h1>Event Calendar</h1>
            <p>Create and manage hostel events, notices and activities.</p>

            <% if(request.getParameter("success") != null){ %>
                <p class="success"><%= request.getParameter("success") %></p>
            <% } %>

            <% if(request.getParameter("error") != null){ %>
                <p class="error"><%= request.getParameter("error") %></p>
            <% } %>
        </div>

        <div class="card">
            <h2>Add New Event</h2>
            <form action="<%=request.getContextPath()%>/addEvent" method="post">
                <label>Event Title</label>
                <input type="text" name="eventTitle" required>

                <label>Description</label>
                <textarea name="eventDescription" required></textarea>

                <div class="grid-3">
                    <div>
                        <label>Event Date</label>
                        <input type="date" name="eventDate" required>
                    </div>
                    <div>
                        <label>Event Time</label>
                        <input type="text" name="eventTime" placeholder="6:00 PM">
                    </div>
                    <div>
                        <label>Status</label>
                        <select name="status">
                            <option value="Upcoming">Upcoming</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                </div>

                <div class="grid-2">
                    <div>
                        <label>Venue</label>
                        <input type="text" name="venue" placeholder="Hostel Ground / Common Hall">
                    </div>
                    <div>
                        <label>Organizer</label>
                        <input type="text" name="organizer" placeholder="Warden / Student Council">
                    </div>
                </div>

                <button type="submit">Add Event</button>
            </form>
        </div>

        <div class="card">
            <h2>All Events</h2>
            <%
                List<Event> eventList = (List<Event>) request.getAttribute("eventList");
                if(eventList != null && !eventList.isEmpty()) {
                    for(Event e : eventList) {
            %>
            <div class="event-card">
                <h3><%= e.getEventTitle() %></h3>
                <p><%= e.getEventDescription() %></p>
                <p><strong>Date:</strong> <%= e.getEventDate() %> | <strong>Time:</strong> <%= e.getEventTime() %></p>
                <p><strong>Venue:</strong> <%= e.getVenue() %> | <strong>Organizer:</strong> <%= e.getOrganizer() %></p>

                <% if("Upcoming".equalsIgnoreCase(e.getStatus())) { %>
                    <span class="badge-upcoming"><%= e.getStatus() %></span>
                <% } else if("Completed".equalsIgnoreCase(e.getStatus())) { %>
                    <span class="badge-completed"><%= e.getStatus() %></span>
                <% } else { %>
                    <span class="badge-cancelled"><%= e.getStatus() %></span>
                <% } %>
            </div>
            <% }} else { %>
            <p>No events found.</p>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>