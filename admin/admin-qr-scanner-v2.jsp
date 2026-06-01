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
    <title>Admin QR Scanner V2</title>
    <script src="https://unpkg.com/html5-qrcode"></script>
    <style>
        body{margin:0;font-family:Arial,sans-serif;background:#eef4ff}
        .wrap{max-width:1100px;margin:0 auto;padding:24px}
        .card{background:#fff;padding:24px;border-radius:22px;box-shadow:0 15px 35px rgba(0,0,0,.08)}
        .top{display:grid;grid-template-columns:1fr 1fr;gap:22px}
        #reader{width:100%}
        .result{padding:18px;border-radius:16px;background:#eff6ff;color:#1e3a8a;font-weight:700;margin-top:16px}
        .btn{padding:12px 16px;border:none;border-radius:12px;background:#1d4ed8;color:#fff;font-weight:700;cursor:pointer}
        @media(max-width:850px){.top{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h2>Admin QR Scanner V2 Ultra</h2>
        <div class="top">
            <div>
                <div id="reader"></div>
                <button class="btn" onclick="startScanner()">Start Scanner</button>
            </div>
            <div>
                <div class="result" id="scanResult">No scan yet.</div>
            </div>
        </div>
    </div>
</div>

<script>
let scannerStarted = false;
let html5QrCode = null;

function startScanner() {
    if (scannerStarted) return;

    html5QrCode = new Html5Qrcode("reader");
    scannerStarted = true;

    Html5Qrcode.getCameras().then(function(devices) {
        if (devices && devices.length) {
            html5QrCode.start(
                devices[0].id,
                { fps: 10, qrbox: 250 },
                function(decodedText) {
                    verifyScan(decodedText);
                    html5QrCode.stop();
                    scannerStarted = false;
                },
                function(errorMessage) {}
            );
        } else {
            alert("No camera found.");
        }
    }).catch(function(err) {
        alert("Camera error: " + err);
    });
}

function verifyScan(token) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "<%=request.getContextPath()%>/qrCheckinV2", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var res = JSON.parse(xhr.responseText);
            document.getElementById("scanResult").innerText = res.message;
        }
    };

    xhr.send("action=adminScanCheckin&qrToken=" + encodeURIComponent(token));
}
</script>
</body>
</html>