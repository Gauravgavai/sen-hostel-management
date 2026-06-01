<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session == null || session.getAttribute("studentId") == null){
        response.sendRedirect(request.getContextPath() + "/student/student-login.jsp");
        return;
    }
    String studentName = session.getAttribute("studentName") != null ? session.getAttribute("studentName").toString() : "Student";
    String studentId = session.getAttribute("studentId").toString();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register Biometric</title>
    <style>
        body{
            margin:0;
            font-family:Arial,sans-serif;
            background:linear-gradient(135deg,#eff6ff,#f8fafc,#eef2ff);
        }
        .wrap{
            max-width:850px;
            margin:40px auto;
            padding:20px;
        }
        .card{
            background:#fff;
            border-radius:24px;
            box-shadow:0 18px 40px rgba(15,23,42,0.08);
            padding:28px;
        }
        .btn{
            border:none;
            background:linear-gradient(135deg,#2563eb,#1d4ed8);
            color:#fff;
            padding:14px 20px;
            border-radius:14px;
            font-weight:bold;
            cursor:pointer;
            margin-top:14px;
        }
        .status{
            margin-top:16px;
            padding:14px;
            border-radius:14px;
            background:#eff6ff;
            color:#1d4ed8;
            font-weight:bold;
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h1 style="margin-top:0;color:#1d4ed8;">Register Fingerprint / Passkey</h1>
        <p style="color:#64748b;line-height:1.7;">
            Hello <%=studentName%>, yaha se aap apne device ka fingerprint ya passkey register kar sakte ho.
        </p>

        <button class="btn" onclick="registerBiometric()">Register Biometric</button>
        <div class="status" id="statusBox">Waiting for action...</div>
    </div>
</div>

<script>
async function registerBiometric() {
    const statusBox = document.getElementById("statusBox");

    try {
        const response = await fetch("<%=request.getContextPath()%>/webauthn/register/start", {
            method: "POST"
        });

        const options = await response.json();
        options.challenge = base64ToArrayBuffer(options.challenge);
        options.user.id = base64ToArrayBuffer(options.user.id);

        const credential = await navigator.credentials.create({
            publicKey: options
        });

        const payload = {
            id: credential.id,
            rawId: arrayBufferToBase64(credential.rawId),
            type: credential.type
        };

        const finishResponse = await fetch("<%=request.getContextPath()%>/webauthn/register/finish", {
            method: "POST",
            headers: {"Content-Type":"application/json"},
            body: JSON.stringify(payload)
        });

        const result = await finishResponse.json();
        statusBox.textContent = result.message;

    } catch (e) {
        console.log(e);
        statusBox.textContent = "Biometric registration failed.";
    }
}

function base64ToArrayBuffer(base64) {
    const binary = atob(base64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
    return bytes.buffer;
}

function arrayBufferToBase64(buffer) {
    const bytes = new Uint8Array(buffer);
    let binary = "";
    for (let i = 0; i < bytes.byteLength; i++) binary += String.fromCharCode(bytes[i]);
    return btoa(binary);
}
</script>
</body>
</html>
