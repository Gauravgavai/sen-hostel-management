<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session == null || session.getAttribute("studentId") == null) {
        response.sendRedirect(request.getContextPath() + "/student/student-login.jsp");
        return;
    }

    String studentName = session.getAttribute("studentName") != null
            ? session.getAttribute("studentName").toString()
            : "Student";

    String studentEmail = session.getAttribute("studentEmail") != null
            ? session.getAttribute("studentEmail").toString()
            : "Not Available";

    String studentMobile = session.getAttribute("studentMobile") != null
            ? session.getAttribute("studentMobile").toString()
            : "Not Available";

    String roomNumber = session.getAttribute("roomNumber") != null
            ? session.getAttribute("roomNumber").toString()
            : "Not Assigned";

    String passStatus = session.getAttribute("passStatus") != null
            ? session.getAttribute("passStatus").toString()
            : "ACTIVE";

    String qrData = "STUDENT_ID=" + session.getAttribute("studentId")
            + "|NAME=" + studentName
            + "|ROOM=" + roomNumber
            + "|STATUS=" + passStatus;

    String qrImageUrl = request.getContextPath() + "/GenerateQRCode?qrText=" + java.net.URLEncoder.encode(qrData, "UTF-8");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student QR Pass V2</title>

    <link rel="manifest" href="<%=request.getContextPath()%>/manifest.json">
    <meta name="theme-color" content="#1d4ed8">
    <link rel="apple-touch-icon" href="<%=request.getContextPath()%>/assets/icon-192.png">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background:
                radial-gradient(circle at top left, rgba(37, 99, 235, 0.12), transparent 25%),
                linear-gradient(135deg, #eff6ff, #f8fbff, #eef2ff);
            color: #0f172a;
        }

        .wrapper {
            min-height: 100vh;
            display: flex;
        }

        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #0f172a, #1e293b);
            color: white;
            padding: 24px 18px;
        }

        .sidebar h2 {
            margin: 0 0 20px;
            font-size: 22px;
            letter-spacing: 0.5px;
        }

        .sidebar a {
            display: block;
            text-decoration: none;
            color: #cbd5e1;
            padding: 12px 14px;
            margin-bottom: 10px;
            border-radius: 12px;
            transition: 0.3s ease;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.10);
            color: white;
        }

        .content {
            flex: 1;
            padding: 28px;
        }

        .top-banner {
            background: white;
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 16px 40px rgba(15,23,42,0.08);
            margin-bottom: 22px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .top-banner h1 {
            margin: 0 0 8px;
            font-size: 30px;
            color: #0f172a;
        }

        .top-banner p {
            margin: 0;
            color: #64748b;
            line-height: 1.7;
            max-width: 720px;
        }

        .install-btn {
            display: none;
            border: none;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            padding: 14px 20px;
            border-radius: 14px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 10px 22px rgba(37,99,235,0.20);
        }

        .network-badge {
            display: inline-block;
            margin-top: 14px;
            padding: 10px 14px;
            border-radius: 999px;
            background: #ecfeff;
            color: #0f766e;
            border: 1px solid #99f6e4;
            font-weight: bold;
            font-size: 13px;
        }

        .main-grid {
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 22px;
        }

        .card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 18px 40px rgba(15,23,42,0.08);
            overflow: hidden;
        }

        .card-header {
            padding: 22px 24px;
            border-bottom: 1px solid #e2e8f0;
            background: linear-gradient(135deg, #ffffff, #f8fafc);
        }

        .card-header h2 {
            margin: 0;
            font-size: 22px;
            color: #1e293b;
        }

        .card-header p {
            margin: 8px 0 0;
            color: #64748b;
            line-height: 1.6;
        }

        .card-body {
            padding: 24px;
        }

        .student-meta {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 22px;
        }

        .meta-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 16px;
        }

        .meta-label {
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            color: #64748b;
            margin-bottom: 8px;
        }

        .meta-value {
            font-size: 16px;
            font-weight: bold;
            color: #0f172a;
            word-break: break-word;
        }

        .status-pill {
            display: inline-block;
            padding: 10px 14px;
            border-radius: 999px;
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
            font-weight: bold;
            font-size: 13px;
        }

        .qr-panel {
            text-align: center;
            padding: 8px;
        }

        .qr-frame {
            background: linear-gradient(180deg, #ffffff, #f8fafc);
            border: 1px solid #dbeafe;
            border-radius: 24px;
            padding: 24px;
            box-shadow: inset 0 0 0 1px rgba(37,99,235,0.04);
        }

        .qr-frame img {
            width: 260px;
            max-width: 100%;
            height: auto;
            margin: 0 auto 16px;
            display: block;
            border-radius: 18px;
            background: white;
            padding: 12px;
            box-shadow: 0 10px 20px rgba(15,23,42,0.06);
        }

        .qr-note {
            margin: 0;
            color: #64748b;
            line-height: 1.7;
            font-size: 14px;
        }

        .action-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .btn {
            border: none;
            padding: 14px 18px;
            border-radius: 14px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            box-shadow: 0 12px 22px rgba(37,99,235,0.18);
        }

        .btn-secondary {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
        }

        .btn-dark {
            background: #0f172a;
            color: white;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .info-list {
            display: grid;
            gap: 14px;
        }

        .info-item {
            display: flex;
            gap: 14px;
            align-items: flex-start;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 16px;
        }

        .info-icon {
            width: 42px;
            height: 42px;
            min-width: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, #dbeafe, #bfdbfe);
            color: #1d4ed8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .info-text h4 {
            margin: 0 0 6px;
            color: #0f172a;
            font-size: 16px;
        }

        .info-text p {
            margin: 0;
            color: #64748b;
            line-height: 1.7;
            font-size: 14px;
        }

        .footer-note {
            margin-top: 22px;
            background: white;
            border-radius: 18px;
            padding: 16px 18px;
            box-shadow: 0 10px 24px rgba(15,23,42,0.05);
            color: #64748b;
            line-height: 1.7;
            font-size: 14px;
        }

        @media (max-width: 992px) {
            .main-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .content {
                padding: 16px;
            }

            .top-banner h1 {
                font-size: 24px;
            }

            .student-meta {
                grid-template-columns: 1fr;
            }

            .action-row {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/student-dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/student/student-profile.jsp">My Profile</a>
        <a href="<%=request.getContextPath()%>/student/student-qr-pass-v2.jsp">QR Pass V2</a>
        <a href="<%=request.getContextPath()%>/student/ai-chatbot-v2.jsp">AI Chatbot</a>
        <a href="<%=request.getContextPath()%>/LogoutServlet">Logout</a>
    </div>

    <div class="content">
        <div class="top-banner">
            <div>
                <h1>Student QR Pass V2</h1>
                <p>
                    This digital hostel pass shows your live student QR identity card with a mobile-friendly layout, clean design, and installable app support.
                </p>
                <span class="network-badge" id="networkBadge">● Online Mode</span>
            </div>

            <button id="installBtn" class="install-btn">Install App</button>
        </div>

        <div class="main-grid">
            <div class="card">
                <div class="card-header">
                    <h2>Student Pass Details</h2>
                    <p>Your hostel identity details are shown below. Keep this QR pass ready for attendance scan or entry verification.</p>
                </div>

                <div class="card-body">
                    <div class="student-meta">
                        <div class="meta-box">
                            <div class="meta-label">Student Name</div>
                            <div class="meta-value"><%= studentName %></div>
                        </div>

                        <div class="meta-box">
                            <div class="meta-label">Email</div>
                            <div class="meta-value"><%= studentEmail %></div>
                        </div>

                        <div class="meta-box">
                            <div class="meta-label">Mobile</div>
                            <div class="meta-value"><%= studentMobile %></div>
                        </div>

                        <div class="meta-box">
                            <div class="meta-label">Room Number</div>
                            <div class="meta-value"><%= roomNumber %></div>
                        </div>
                    </div>

                    <div style="margin-bottom:20px;">
                        <div class="meta-label">Pass Status</div>
                        <span class="status-pill"><%= passStatus %></span>
                    </div>

                    <div class="action-row">
                        <button class="btn btn-primary" onclick="window.print()">Print Pass</button>
                        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/student/student-dashboard.jsp">Back to Dashboard</a>
                        <button class="btn btn-dark" onclick="downloadQrImage()">Download QR</button>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h2>Live QR Pass</h2>
                    <p>Show this QR code to the hostel authority for verification or attendance scanning.</p>
                </div>

                <div class="card-body qr-panel">
                    <div class="qr-frame">
                        <img id="qrImage" src="<%= qrImageUrl %>" alt="Student QR Code">
                        <p class="qr-note">
                            QR data includes your student session identity, room number, and pass status for quick verification.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div style="margin-top:22px;" class="card">
            <div class="card-header">
                <h2>Usage Instructions</h2>
                <p>Important guidelines for using your QR hostel pass properly.</p>
            </div>

            <div class="card-body">
                <div class="info-list">
                    <div class="info-item">
                        <div class="info-icon">1</div>
                        <div class="info-text">
                            <h4>Keep it ready</h4>
                            <p>Open this page before entering hostel gate or attendance area so scanning becomes quick and smooth.</p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">2</div>
                        <div class="info-text">
                            <h4>Do not share</h4>
                            <p>Your QR pass is linked with your student identity, so do not send screenshots casually to others.</p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">3</div>
                        <div class="info-text">
                            <h4>Use install mode</h4>
                            <p>After installing the app, you can open this pass in a cleaner standalone mode from your mobile home screen.</p>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-icon">4</div>
                        <div class="info-text">
                            <h4>Check status</h4>
                            <p>If your pass status changes from ACTIVE, contact hostel administration before using the QR for verification.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer-note">
            If some values like room number, mobile, or email are missing, then session attributes are not being set during login or dashboard loading. In that case, update your login servlet or dashboard servlet to store those values in session before opening this page.
        </div>
    </div>
</div>

<script>
let deferredPrompt = null;

function updateNetworkStatus() {
    const badge = document.getElementById("networkBadge");
    if (!badge) return;

    if (navigator.onLine) {
        badge.textContent = "● Online Mode";
        badge.style.background = "#ecfeff";
        badge.style.color = "#0f766e";
        badge.style.border = "1px solid #99f6e4";
    } else {
        badge.textContent = "● Offline Mode";
        badge.style.background = "#fef2f2";
        badge.style.color = "#b91c1c";
        badge.style.border = "1px solid #fecaca";
    }
}

if ("serviceWorker" in navigator) {
    window.addEventListener("load", function() {
        navigator.serviceWorker.register("<%=request.getContextPath()%>/sw.js")
            .then(function(registration) {
                console.log("Service Worker registered:", registration.scope);
            })
            .catch(function(error) {
                console.log("Service Worker registration failed:", error);
            });
    });
}

window.addEventListener("beforeinstallprompt", function(e) {
    e.preventDefault();
    deferredPrompt = e;
    const installBtn = document.getElementById("installBtn");
    if (installBtn) {
        installBtn.style.display = "inline-block";
    }
});

const installBtn = document.getElementById("installBtn");
if (installBtn) {
    installBtn.addEventListener("click", async function() {
        if (!deferredPrompt) return;
        deferredPrompt.prompt();
        const choiceResult = await deferredPrompt.userChoice;
        console.log("Install result:", choiceResult.outcome);
        deferredPrompt = null;
        installBtn.style.display = "none";
    });
}

window.addEventListener("online", updateNetworkStatus);
window.addEventListener("offline", updateNetworkStatus);
updateNetworkStatus();

function downloadQrImage() {
    const qrImage = document.getElementById("qrImage");
    if (!qrImage) return;

    fetch(qrImage.src)
        .then(response => response.blob())
        .then(blob => {
            const a = document.createElement("a");
            a.href = URL.createObjectURL(blob);
            a.download = "student-qr-pass.png";
            a.click();
            URL.revokeObjectURL(a.href);
        })
        .catch(error => {
            console.log("QR download failed:", error);
            alert("Unable to download QR right now.");
        });
}
</script>

</body>
</html>
