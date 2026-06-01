<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session == null || session.getAttribute("studentId") == null){
        response.sendRedirect(request.getContextPath() + "/student/student-login.jsp");
        return;
    }

    String studentName = session.getAttribute("studentName") != null
            ? session.getAttribute("studentName").toString()
            : "Student";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fee Reminder Notifications</title>
    <link rel="manifest" href="<%=request.getContextPath()%>/manifest.json">
    <meta name="theme-color" content="#1d4ed8">
    <style>
        *{box-sizing:border-box;}
        body{
            margin:0;
            font-family:Arial,sans-serif;
            background:linear-gradient(135deg,#eff6ff,#f8fafc,#eef2ff);
            color:#0f172a;
        }
        .container{
            max-width:900px;
            margin:40px auto;
            padding:20px;
        }
        .hero, .card{
            background:#fff;
            border-radius:24px;
            box-shadow:0 18px 40px rgba(15,23,42,0.08);
            padding:28px;
            margin-bottom:22px;
        }
        h1{
            margin:0 0 10px;
            color:#1d4ed8;
        }
        p{
            color:#64748b;
            line-height:1.7;
        }
        .btn{
            border:none;
            background:linear-gradient(135deg,#2563eb,#1d4ed8);
            color:white;
            padding:14px 20px;
            border-radius:14px;
            font-weight:bold;
            cursor:pointer;
            margin-top:16px;
        }
        .status{
            margin-top:16px;
            padding:14px 16px;
            border-radius:14px;
            background:#eff6ff;
            color:#1d4ed8;
            font-weight:bold;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="hero">
        <h1>Fee Reminder Notifications</h1>
        <p>Hello <%=studentName%>, yaha se aap apne hostel fee due reminder notifications enable kar sakte ho.</p>
    </div>

    <div class="card">
        <h2 style="margin-top:0;">Enable Push Notifications</h2>
        <p>Allow notification permission and save your browser subscription for future fee alerts.</p>

        <button class="btn" onclick="enablePushNotifications()">Enable Notifications</button>
        <div class="status" id="statusBox">Waiting for action...</div>
    </div>
</div>

<script>
async function enablePushNotifications() {
    const statusBox = document.getElementById("statusBox");

    if (!("serviceWorker" in navigator) || !("PushManager" in window)) {
        statusBox.textContent = "Push notifications are not supported in this browser.";
        return;
    }

    try {
        const permission = await Notification.requestPermission();
        if (permission !== "granted") {
            statusBox.textContent = "Notification permission denied.";
            return;
        }

        const registration = await navigator.serviceWorker.register("<%=request.getContextPath()%>/sw.js");

        const vapidPublicKey = "YOUR_PUBLIC_VAPID_KEY";
        const convertedVapidKey = urlBase64ToUint8Array(vapidPublicKey);

        let subscription = await registration.pushManager.getSubscription();

        if (!subscription) {
            subscription = await registration.pushManager.subscribe({
                userVisibleOnly: true,
                applicationServerKey: convertedVapidKey
            });
        }

        const response = await fetch("<%=request.getContextPath()%>/savePushSubscriber", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(subscription.toJSON())
        });

        const result = await response.json();
        statusBox.textContent = result.message;

    } catch (error) {
        console.log(error);
        statusBox.textContent = "Error while enabling push notifications.";
    }
}

function urlBase64ToUint8Array(base64String) {
    const padding = "=".repeat((4 - base64String.length % 4) % 4);
    const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
    const rawData = window.atob(base64);
    return Uint8Array.from([...rawData].map(char => char.charCodeAt(0)));
}
</script>
</body>
</html>
