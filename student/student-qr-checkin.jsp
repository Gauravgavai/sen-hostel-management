<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session == null || session.getAttribute("studentId") == null){
        response.sendRedirect(request.getContextPath() + "/student/student-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student QR Check-in</title>
    <style>
        *{box-sizing:border-box;}
        body{
            margin:0;
            font-family:Arial,sans-serif;
            background:linear-gradient(135deg,#ecfeff,#eff6ff,#f8fafc);
        }
        .layout{display:flex;min-height:100vh;}
        .sidebar{
            width:250px;
            background:linear-gradient(180deg,#0f172a,#1e293b);
            color:#fff;
            padding:22px 16px;
        }
        .sidebar h2{margin:0 0 20px;}
        .sidebar a{
            display:block;
            color:#cbd5e1;
            text-decoration:none;
            padding:12px 14px;
            border-radius:12px;
            margin-bottom:8px;
        }
        .sidebar a:hover{background:rgba(255,255,255,0.10);color:#fff;}
        .content{flex:1;padding:28px;}
        .card{
            background:#fff;
            border-radius:22px;
            padding:24px;
            box-shadow:0 18px 40px rgba(0,0,0,0.08);
            margin-bottom:22px;
        }
        .card h1{margin-top:0;color:#0f172a;}
        .card p{color:#64748b;}
        .check-box{
            padding:22px;
            border-radius:20px;
            background:linear-gradient(135deg,#eff6ff,#ffffff);
            border:1px solid #dbeafe;
        }
        .btn{
            border:none;
            padding:14px 18px;
            border-radius:14px;
            font-weight:700;
            cursor:pointer;
            margin-right:10px;
            margin-top:10px;
        }
        .btn-primary{background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#fff;}
        .btn-dark{background:#0f172a;color:#fff;}
        .status{
            margin-top:18px;
            padding:16px;
            border-radius:14px;
            background:#f8fafc;
            border:1px solid #cbd5e1;
            min-height:60px;
            color:#334155;
        }
        @media(max-width:700px){
            .layout{flex-direction:column;}
            .sidebar{width:100%;}
            .content{padding:16px;}
        }
    </style>
</head>
<body>
<div class="layout">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/student-dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/student/student-qr-pass.jsp">QR Pass</a>
        <a href="<%=request.getContextPath()%>/student/student-qr-checkin.jsp">QR Check-in</a>
    </div>

    <div class="content">
        <div class="card">
            <h1>QR Self Check-in</h1>
            <p>Use this page to confirm your hostel entry attendance. No manual URL needed, this is directly linked from dashboard and QR Pass page.</p>
        </div>

        <div class="card">
            <div class="check-box">
                <h3 style="margin-top:0;">Confirm Attendance Entry</h3>
                <p>Click below to save your QR self check-in log.</p>
                <button class="btn btn-primary" onclick="markCheckin()">Confirm Check-in</button>
                <button class="btn btn-dark" onclick="window.location.href='<%=request.getContextPath()%>/student/student-qr-pass.jsp'">Back to QR Pass</button>
                <div class="status" id="statusBox">Waiting for your action...</div>
            </div>
        </div>
    </div>
</div>

<script>
    function markCheckin(){
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/qrCheckin", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4){
                if(xhr.status === 200){
                    var res = JSON.parse(xhr.responseText);
                    document.getElementById("statusBox").innerText = res.message;
                    if('speechSynthesis' in window){
                        var utter = new SpeechSynthesisUtterance(res.message);
                        utter.lang = 'en-US';
                        window.speechSynthesis.speak(utter);
                    }
                } else {
                    document.getElementById("statusBox").innerText = "Server error. Try again.";
                }
            }
        };

        xhr.send("action=studentSelfCheckin");
    }
</script>
</body>
</html>