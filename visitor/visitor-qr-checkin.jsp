<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Visitor QR Check-in</title>
    <script src="https://cdn.jsdelivr.net/npm/qrcode/build/qrcode.min.js"></script>
    <style>
        body{font-family:Arial,sans-serif;background:#f8fafc;margin:0}
        .box{max-width:780px;margin:40px auto;background:#fff;padding:24px;border-radius:22px;box-shadow:0 15px 40px rgba(0,0,0,.08)}
        input{width:100%;padding:14px;margin-bottom:14px;border:1px solid #cbd5e1;border-radius:14px}
        button{padding:14px 18px;border:none;border-radius:14px;background:#1d4ed8;color:#fff;font-weight:700;cursor:pointer}
        #qrcode{margin-top:20px;padding:16px;background:#fff}
    </style>
</head>
<body>
<div class="box">
    <h2>Visitor QR Generate</h2>
    <input type="text" id="visitorName" placeholder="Visitor Name">
    <input type="text" id="visitorMobile" placeholder="Mobile Number">
    <button onclick="generateVisitorQR()">Generate Visitor QR</button>
    <div id="expiryText" style="margin-top:16px;color:#475569;"></div>
    <div id="qrcode"></div>
</div>

<script>
function generateVisitorQR() {
    var name = document.getElementById("visitorName").value.trim();
    var mobile = document.getElementById("visitorMobile").value.trim();

    if (!name || !mobile) {
        alert("Enter visitor name and mobile.");
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "<%=request.getContextPath()%>/qrCheckinV2", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var res = JSON.parse(xhr.responseText);
            if (res.status === "success") {
                document.getElementById("qrcode").innerHTML = "";
                QRCode.toCanvas(res.token, { width: 220 }, function(error, canvas) {
                    if (!error) document.getElementById("qrcode").appendChild(canvas);
                });
                document.getElementById("expiryText").innerText = "Expiry: " + res.expiry;
            } else {
                alert(res.message);
            }
        }
    };

    xhr.send("action=visitorGenerate&visitorName=" + encodeURIComponent(name) + "&visitorMobile=" + encodeURIComponent(mobile));
}
</script>
</body>
</html>