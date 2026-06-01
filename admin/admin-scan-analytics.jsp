<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session == null || session.getAttribute("adminId") == null){
        response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Scan Analytics</title>
    <style>
        body{margin:0;font-family:Arial,sans-serif;background:#f5f8ff;color:#0f172a}
        .wrap{max-width:1200px;margin:0 auto;padding:24px}
        .grid{display:grid;grid-template-columns:repeat(4,1fr);gap:18px}
        .card{background:#fff;border-radius:20px;padding:22px;box-shadow:0 12px 30px rgba(0,0,0,.06)}
        .label{font-size:13px;color:#64748b}
        .value{font-size:30px;font-weight:800;color:#1d4ed8;margin-top:8px}
        table{width:100%;margin-top:24px;border-collapse:collapse;background:#fff;border-radius:20px;overflow:hidden}
        th,td{padding:14px;border-bottom:1px solid #e5e7eb;text-align:left}
        th{background:#eff6ff;color:#1e3a8a}
        @media(max-width:900px){.grid{grid-template-columns:1fr 1fr}}
        @media(max-width:600px){.grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="wrap">
    <h2>Admin Scan Analytics Dashboard</h2>

    <div class="grid">
        <div class="card">
            <div class="label">Today Student Scans</div>
            <div class="value" id="todayStudentScans">0</div>
        </div>
        <div class="card">
            <div class="label">Today Visitor Scans</div>
            <div class="value" id="todayVisitorScans">0</div>
        </div>
        <div class="card">
            <div class="label">Total Scans</div>
            <div class="value" id="totalScans">0</div>
        </div>
        <div class="card">
            <div class="label">Live Attendance</div>
            <div class="value" id="liveAttendanceCount">0</div>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Student ID</th>
                <th>Visitor Name</th>
                <th>QR Type</th>
                <th>Status</th>
                <th>Remarks</th>
                <th>Time</th>
            </tr>
        </thead>
        <tbody id="historyBody">
            <tr><td colspan="7">Loading...</td></tr>
        </tbody>
    </table>
</div>

<script>
function loadAnalytics() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "<%=request.getContextPath()%>/adminAnalytics", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var res = JSON.parse(xhr.responseText);
            if (res.status === "success") {
                document.getElementById("todayStudentScans").innerText = res.todayStudentScans;
                document.getElementById("todayVisitorScans").innerText = res.todayVisitorScans;
                document.getElementById("totalScans").innerText = res.totalScans;
                document.getElementById("liveAttendanceCount").innerText = res.liveAttendanceCount;
            }
        }
    };
    xhr.send();
}

function loadHistory() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "<%=request.getContextPath()%>/qrHistoryV2?type=admin", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var res = JSON.parse(xhr.responseText);
            var body = document.getElementById("historyBody");
            body.innerHTML = "";

            if (res.status === "success" && res.history.length > 0) {
                for (var i = 0; i < res.history.length; i++) {
                    var h = res.history[i];
                    body.innerHTML += "<tr>"
                        + "<td>" + h.checkinId + "</td>"
                        + "<td>" + (h.studentId == null ? "-" : h.studentId) + "</td>"
                        + "<td>" + (h.visitorName || "-") + "</td>"
                        + "<td>" + h.qrType + "</td>"
                        + "<td>" + h.status + "</td>"
                        + "<td>" + h.remarks + "</td>"
                        + "<td>" + h.checkinTime + "</td>"
                        + "</tr>";
                }
            } else {
                body.innerHTML = "<tr><td colspan='7'>No history found.</td></tr>";
            }
        }
    };
    xhr.send();
}

loadAnalytics();
loadHistory();
setInterval(loadAnalytics, 10000);
</script>
</body>
</html>