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
    <title>Admin QR Scanner</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html5-qrcode/2.3.8/html5-qrcode.min.js"></script>
    <style>
        *{box-sizing:border-box;}
        body{
            margin:0;
            font-family:Arial,sans-serif;
            background:linear-gradient(135deg,#f8fafc,#eff6ff,#eef2ff);
        }
        .layout{display:flex;min-height:100vh;}
        .sidebar{
            width:260px;
            background:linear-gradient(180deg,#111827,#1f2937);
            color:#fff;
            padding:22px 16px;
        }
        .sidebar h2{margin:0 0 20px;}
        .sidebar a{
            display:block;
            color:#d1d5db;
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
        .grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:22px;
        }
        #reader{
            width:100%;
            min-height:320px;
            border:2px dashed #93c5fd;
            border-radius:20px;
            padding:12px;
        }
        .result{
            padding:16px;
            border-radius:14px;
            background:#f8fafc;
            border:1px solid #cbd5e1;
            min-height:64px;
            color:#334155;
        }
        .btn{
            border:none;
            padding:14px 18px;
            border-radius:14px;
            font-weight:700;
            cursor:pointer;
            margin-top:14px;
            background:linear-gradient(135deg,#2563eb,#1d4ed8);
            color:#fff;
        }
        table{width:100%;border-collapse:collapse;}
        th,td{padding:12px;border-bottom:1px solid #e5e7eb;text-align:left;font-size:14px;}
        th{background:#f8fafc;}
        @media(max-width:900px){.grid{grid-template-columns:1fr;}}
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
        <h2>Admin Panel</h2>
        <a href="<%=request.getContextPath()%>/admin/admin-dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/admin-qr-scanner.jsp">QR Scanner</a>
    </div>

    <div class="content">
        <div class="card">
            <h1 style="margin-top:0;color:#0f172a;">Admin QR Scanner</h1>
            <p style="color:#64748b;">Scan student QR pass using camera and verify check-in directly from dashboard-linked page.</p>
        </div>

        <div class="grid">
            <div class="card">
                <h3 style="margin-top:0;">Live Scanner</h3>
                <div id="reader"></div>
                <button class="btn" onclick="startScanner()">Start Scanner</button>
            </div>

            <div class="card">
                <h3 style="margin-top:0;">Scan Result</h3>
                <div class="result" id="resultBox">Waiting for QR scan...</div>
            </div>
        </div>

        <div class="card">
            <h3 style="margin-top:0;">Recent Check-ins</h3>
            <div style="overflow:auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student ID</th>
                            <th>Token</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Time</th>
                        </tr>
                    </thead>
                    <tbody id="historyBody">
                        <tr><td colspan="6">Loading history...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    var scannerStarted = false;
    var html5QrCode = new Html5Qrcode("reader");

    function startScanner(){
        if(scannerStarted) return;
        scannerStarted = true;

        Html5Qrcode.getCameras().then(function(devices){
            if(devices && devices.length){
                var cameraId = devices[0].id;
                html5QrCode.start(
                    cameraId,
                    { fps: 10, qrbox: 250 },
                    function(decodedText){
                        document.getElementById("resultBox").innerText = "QR Detected: " + decodedText;
                        verifyQR(decodedText);
                        html5QrCode.stop();
                        scannerStarted = false;
                    },
                    function(errorMessage){}
                );
            }
        }).catch(function(err){
            document.getElementById("resultBox").innerText = "Camera error: " + err;
            scannerStarted = false;
        });
    }

    function verifyQR(token){
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/qrCheckin", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4 && xhr.status === 200){
                var res = JSON.parse(xhr.responseText);
                document.getElementById("resultBox").innerText = res.message;
                loadHistory();
            }
        };

        xhr.send("action=adminScanCheckin&qrToken=" + encodeURIComponent(token));
    }

    function loadHistory(){
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "<%=request.getContextPath()%>/qrHistory", true);

        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4 && xhr.status === 200){
                var res = JSON.parse(xhr.responseText);
                var body = document.getElementById("historyBody");
                body.innerHTML = "";

                if(res.status === "success" && res.data.length > 0){
                    for(var i=0;i<res.data.length;i++){
                        body.innerHTML += "<tr>"
                            + "<td>"+res.data[i].checkinId+"</td>"
                            + "<td>"+res.data[i].studentId+"</td>"
                            + "<td>"+res.data[i].qrToken+"</td>"
                            + "<td>"+res.data[i].checkinType+"</td>"
                            + "<td>"+res.data[i].statusValue+"</td>"
                            + "<td>"+res.data[i].checkinTime+"</td>"
                            + "</tr>";
                    }
                } else {
                    body.innerHTML = "<tr><td colspan='6'>No check-in records found.</td></tr>";
                }
            }
        };

        xhr.send();
    }

    loadHistory();
</script>
</body>
</html>