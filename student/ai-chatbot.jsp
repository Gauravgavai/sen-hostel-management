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
    <title>AI Chatbot - Student Panel</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #eef4ff, #f8fbff);
        }
        .wrapper {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 240px;
            background: #1f2937;
            color: white;
            padding: 20px;
        }
        .sidebar h2 {
            margin-top: 0;
            font-size: 22px;
        }
        .sidebar a {
            display: block;
            color: #d1d5db;
            text-decoration: none;
            padding: 12px 10px;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: 0.3s;
        }
        .sidebar a:hover {
            background: #374151;
            color: #fff;
        }
        .content {
            flex: 1;
            padding: 30px;
        }
        .header-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            margin-bottom: 24px;
        }
        .header-card h1 {
            margin: 0 0 8px;
            color: #1e3a8a;
        }
        .header-card p {
            margin: 0;
            color: #6b7280;
        }
        .chat-container {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 75vh;
        }
        .chat-top {
            background: #1d4ed8;
            color: white;
            padding: 18px 22px;
            font-size: 18px;
            font-weight: bold;
        }
        .chat-box {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: #f9fafb;
        }
        .message {
            max-width: 72%;
            padding: 12px 16px;
            margin-bottom: 14px;
            border-radius: 14px;
            line-height: 1.5;
            font-size: 15px;
            word-wrap: break-word;
        }
        .user {
            background: #dbeafe;
            color: #1e3a8a;
            margin-left: auto;
            border-bottom-right-radius: 4px;
        }
        .bot {
            background: #e5e7eb;
            color: #111827;
            margin-right: auto;
            border-bottom-left-radius: 4px;
        }
        .chat-input-area {
            display: flex;
            gap: 10px;
            padding: 16px;
            border-top: 1px solid #e5e7eb;
            background: #ffffff;
        }
        .chat-input-area input {
            flex: 1;
            padding: 14px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            font-size: 15px;
            outline: none;
        }
        .chat-input-area button {
            border: none;
            background: #2563eb;
            color: white;
            padding: 0 22px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }
        .chat-input-area button:hover {
            background: #1d4ed8;
        }
        .quick-questions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            padding: 16px 20px 0;
            background: #ffffff;
        }
        .quick-questions button {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            padding: 10px 14px;
            border-radius: 999px;
            cursor: pointer;
            font-size: 14px;
        }
        .quick-questions button:hover {
            background: #dbeafe;
        }
        @media (max-width: 900px) {
            .sidebar { width: 210px; }
            .message { max-width: 85%; }
        }
        @media (max-width: 700px) {
            .wrapper { flex-direction: column; }
            .sidebar { width: 100%; }
            .content { padding: 16px; }
            .chat-container { height: 78vh; }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/student-dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/student/profile.jsp">My Profile</a>
        <a href="<%=request.getContextPath()%>/student/ai-chatbot.jsp">AI Chatbot</a>
    </div>

    <div class="content">
        <div class="header-card">
            <h1>AI Hostel Assistant</h1>
            <p>Ask about room status, fee due, complaints, profile, and vacant rooms.</p>
        </div>

        <div class="chat-container">
            <div class="chat-top">Hostel AI Chatbot</div>

            <div class="quick-questions">
                <button onclick="sendQuickMessage('room status')">Room Status</button>
                <button onclick="sendQuickMessage('fee due')">Fee Due</button>
                <button onclick="sendQuickMessage('complaint status')">Complaint Status</button>
                <button onclick="sendQuickMessage('my profile')">My Profile</button>
                <button onclick="sendQuickMessage('vacant rooms')">Vacant Rooms</button>
                <button onclick="sendQuickMessage('help')">Help</button>
            </div>

            <div class="chat-box" id="chatBox">
                <div class="message bot">
                    Hello! I am your hostel assistant. Ask me about your room, fee, complaint, profile, or vacant rooms.
                </div>
            </div>

            <div class="chat-input-area">
                <input type="text" id="messageInput" placeholder="Type your question here..." onkeydown="handleEnter(event)">
                <button onclick="sendMessage()">Send</button>
            </div>
        </div>
    </div>
</div>

<script>
    function appendMessage(text, type) {
        var chatBox = document.getElementById("chatBox");
        var msgDiv = document.createElement("div");
        msgDiv.className = "message " + type;
        msgDiv.textContent = text;
        chatBox.appendChild(msgDiv);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function sendQuickMessage(text) {
        document.getElementById("messageInput").value = text;
        sendMessage();
    }

    function handleEnter(event) {
        if (event.key === "Enter") {
            sendMessage();
        }
    }

    function sendMessage() {
        var input = document.getElementById("messageInput");
        var message = input.value.trim();

        if (message === "") {
            return;
        }

        appendMessage(message, "user");
        input.value = "";

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/chatbot", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var jsonResponse = JSON.parse(xhr.responseText);
                        appendMessage(jsonResponse.reply, "bot");
                    } catch (e) {
                        appendMessage("Sorry, invalid server response.", "bot");
                    }
                } else {
                    appendMessage("Server error. Please try again.", "bot");
                }
            }
        };

        xhr.send("message=" + encodeURIComponent(message));
    }
</script>
</body>
</html>