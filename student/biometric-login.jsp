<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Biometric Login</title>
</head>
<body style="font-family:Arial,sans-serif;background:linear-gradient(135deg,#eff6ff,#f8fafc,#eef2ff);margin:0;">
<div style="max-width:800px;margin:40px auto;padding:20px;">
    <div style="background:#fff;padding:28px;border-radius:24px;box-shadow:0 18px 40px rgba(15,23,42,0.08);">
        <h1 style="margin-top:0;color:#1d4ed8;">Biometric Login</h1>
        <input type="text" id="username" placeholder="Enter username/email"
               style="width:100%;padding:14px;border:1px solid #cbd5e1;border-radius:14px;margin-bottom:14px;">
        <button onclick="loginBiometric()"
                style="border:none;background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#fff;padding:14px 20px;border-radius:14px;font-weight:bold;cursor:pointer;">
            Login with Fingerprint
        </button>
        <div id="statusBox" style="margin-top:16px;padding:14px;border-radius:14px;background:#eff6ff;color:#1d4ed8;font-weight:bold;">
            Waiting for action...
        </div>
    </div>
</div>

<script>
async function loginBiometric() {
    const username = document.getElementById("username").value.trim();
    const statusBox = document.getElementById("statusBox");

    if (!username) {
        statusBox.textContent = "Please enter username first.";
        return;
    }

    try {
        const response = await fetch("webauthn/login/start", {
            method: "POST",
            headers: {"Content-Type":"application/x-www-form-urlencoded"},
            body: "username=" + encodeURIComponent(username)
        });

        const options = await response.json();
        options.challenge = base64ToArrayBuffer(options.challenge);

        if (options.allowCredentials) {
            options.allowCredentials = options.allowCredentials.map(c => ({
                ...c,
                id: base64ToArrayBuffer(c.id)
            }));
        }

        const assertion = await navigator.credentials.get({
            publicKey: options
        });

        const payload = {
            id: assertion.id,
            rawId: arrayBufferToBase64(assertion.rawId),
            type: assertion.type,
            username: username
        };

        const finishResponse = await fetch("webauthn/login/finish", {
            method: "POST",
            headers: {"Content-Type":"application/json"},
            body: JSON.stringify(payload)
        });

        const result = await finishResponse.json();
        statusBox.textContent = result.message;

        if (result.status === "success") {
            setTimeout(() => {
                window.location.href = "student/student-dashboard.jsp";
            }, 1000);
        }

    } catch (e) {
        console.log(e);
        statusBox.textContent = "Biometric login failed.";
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
