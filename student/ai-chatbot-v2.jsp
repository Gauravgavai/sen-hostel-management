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
    <title>AI Chatbot V2</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #eff6ff, #f8fbff, #eef2ff);
            color: #111827;
        }
        .wrapper {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #111827, #1f2937);
            color: white;
            padding: 24px 18px;
        }
        .sidebar h2 {
            margin: 0 0 20px;
            font-size: 22px;
        }
        .sidebar a {
            display: block;
            color: #d1d5db;
            text-decoration: none;
            padding: 12px 14px;
            border-radius: 10px;
            margin-bottom: 8px;
            transition: 0.3s ease;
        }
        .sidebar a:hover {
            background: rgba(255,255,255,0.10);
            color: #fff;
        }
        .content {
            flex: 1;
            padding: 28px;
        }
        .hero-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 26px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.08);
            margin-bottom: 22px;
        }
        .hero-card h1 {
            margin: 0 0 8px;
            color: #1d4ed8;
            font-size: 30px;
        }
        .hero-card p {
            margin: 0;
            color: #6b7280;
            line-height: 1.6;
        }
        .chat-shell {
            background: #ffffff;
            border-radius: 22px;
            box-shadow: 0 18px 40px rgba(0,0,0,0.08);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 78vh;
        }
        .chat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            padding: 18px 22px;
            background: linear-gradient(135deg, #1d4ed8, #2563eb, #4338ca);
            color: white;
        }
        .chat-title {
            font-size: 18px;
            font-weight: bold;
        }
        .header-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .header-btn {
            background: rgba(255,255,255,0.16);
            color: white;
            border: 1px solid rgba(255,255,255,0.18);
            padding: 10px 14px;
            border-radius: 999px;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
        }
        .header-btn:hover {
            background: rgba(255,255,255,0.25);
        }
        .quick-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            padding: 16px 18px;
            border-bottom: 1px solid #e5e7eb;
            background: #ffffff;
        }
        .chip {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            padding: 10px 14px;
            border-radius: 999px;
            font-size: 13px;
            cursor: pointer;
            font-weight: 600;
        }
        .chip:hover {
            background: #dbeafe;
        }
        .chat-box {
            flex: 1;
            overflow-y: auto;
            padding: 22px 18px;
            background:
                radial-gradient(circle at top right, rgba(37,99,235,0.08), transparent 24%),
                linear-gradient(180deg, #f8fbff 0%, #f9fafb 100%);
        }
        .msg-row {
            display: flex;
            margin-bottom: 16px;
        }
        .msg-row.user-row {
            justify-content: flex-end;
        }
        .msg-row.bot-row {
            justify-content: flex-start;
        }
        .msg-bubble {
            max-width: 74%;
            padding: 14px 16px;
            border-radius: 16px;
            line-height: 1.6;
            box-shadow: 0 8px 18px rgba(0,0,0,0.05);
            position: relative;
        }
        .user-bubble {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            border-bottom-right-radius: 6px;
        }
        .bot-bubble {
            background: #ffffff;
            color: #111827;
            border: 1px solid #e5e7eb;
            border-bottom-left-radius: 6px;
        }
        .meta {
            margin-top: 8px;
            font-size: 11px;
            opacity: 0.75;
        }
        .typing {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .typing span {
            width: 8px;
            height: 8px;
            background: #6b7280;
            border-radius: 50%;
            animation: blink 1.2s infinite;
        }
        .typing span:nth-child(2) { animation-delay: 0.2s; }
        .typing span:nth-child(3) { animation-delay: 0.4s; }

        @keyframes blink {
            0%, 80%, 100% { opacity: 0.2; transform: translateY(0); }
            40% { opacity: 1; transform: translateY(-3px); }
        }

        .chat-input-wrap {
            border-top: 1px solid #e5e7eb;
            background: #ffffff;
            padding: 16px;
        }
        .chat-form {
            display: flex;
            gap: 12px;
        }
        .chat-form input {
            flex: 1;
            padding: 15px 16px;
            border-radius: 14px;
            border: 1px solid #cbd5e1;
            outline: none;
            font-size: 15px;
            background: #f8fafc;
        }
        .chat-form input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37,99,235,0.12);
            background: white;
        }
        .send-btn {
            min-width: 110px;
            border: none;
            border-radius: 14px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 10px 20px rgba(37,99,235,0.18);
        }
        .send-btn:hover {
            transform: translateY(-1px);
        }
        .hint {
            margin-top: 10px;
            font-size: 12px;
            color: #6b7280;
        }
        .history-card {
            margin-top: 18px;
            padding: 14px 18px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            color: #475569;
            font-size: 13px;
        }

        @media (max-width: 900px) {
            .sidebar { width: 220px; }
            .msg-bubble { max-width: 85%; }
        }

        @media (max-width: 700px) {
            .wrapper { flex-direction: column; }
            .sidebar { width: 100%; }
            .content { padding: 16px; }
            .chat-shell { height: 82vh; }
            .chat-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .chat-form {
                flex-direction: column;
            }
            .send-btn {
                min-height: 48px;
            }
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/student-dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/student/profile.jsp">My Profile</a>
        <a href="<%=request.getContextPath()%>/student/ai-chatbot-v2.jsp">AI Chatbot V2</a>
    </div>

    <div class="content">
        <div class="hero-card">
            <h1>AI Hostel Assistant V2</h1>
            <p>Ask your hostel assistant about room status, fee due, complaint updates, profile details, vacant rooms, and recent chat history in a polished smart interface.</p>
        </div>

        <div class="chat-shell">
            <div class="chat-header">
                <div class="chat-title">Smart Hostel Chatbot</div>
                <div class="header-actions">
                    <button class="header-btn" onclick="loadHistory()">Show History</button>
                    <button class="header-btn" onclick="clearChatBox()">Clear Chat</button>
                </div>
            </div>

            <div class="quick-bar">
                <button class="chip" onclick="sendQuickMessage('hello')">Hello</button>
                <button class="chip" onclick="sendQuickMessage('room status')">Room Status</button>
                <button class="chip" onclick="sendQuickMessage('fee due')">Fee Due</button>
                <button class="chip" onclick="sendQuickMessage('complaint status')">Complaint Status</button>
                <button class="chip" onclick="sendQuickMessage('my profile')">My Profile</button>
                <button class="chip" onclick="sendQuickMessage('vacant rooms')">Vacant Rooms</button>
                <button class="chip" onclick="sendQuickMessage('help')">Help</button>
            </div>

            <div class="chat-box" id="chatBox">
                <div class="msg-row bot-row">
                    <div class="msg-bubble bot-bubble">
                        Hello! I am your AI hostel assistant. You can ask me about your room, fee, complaint, profile, vacant rooms, or use the Show History button.
                        <div class="meta" id="welcomeTime"></div>
                    </div>
                </div>
            </div>

            <div class="chat-input-wrap">
                <div class="chat-form">
                    <input type="text" id="messageInput" placeholder="Type here... example: fee due" onkeydown="handleEnter(event)">
                    <button class="send-btn" onclick="sendMessage()">Send</button>
                </div>
                <div class="hint">Tip: You can type in Hindi-English style too, like “mera room”, “meri fee”, “khali rooms”.</div>
            </div>
        </div>

        <div class="history-card">
            Recent chat messages are stored in the database and can be loaded using the Show History button.
        </div>
    </div>
</div>

<script>
    function getCurrentTime() {
        var now = new Date();
        return now.toLocaleString();
    }

    document.getElementById("welcomeTime").textContent = getCurrentTime();

    function createMessageBubble(message, type, timeText) {
        var row = document.createElement("div");
        row.className = "msg-row " + (type === "user" ? "user-row" : "bot-row");

        var bubble = document.createElement("div");
        bubble.className = "msg-bubble " + (type === "user" ? "user-bubble" : "bot-bubble");

        var textDiv = document.createElement("div");
        textDiv.textContent = message;

        var metaDiv = document.createElement("div");
        metaDiv.className = "meta";
        metaDiv.textContent = timeText || getCurrentTime();

        bubble.appendChild(textDiv);
        bubble.appendChild(metaDiv);
        row.appendChild(bubble);

        return row;
    }

    function appendMessage(message, type) {
        var chatBox = document.getElementById("chatBox");
        var bubble = createMessageBubble(message, type, getCurrentTime());
        chatBox.appendChild(bubble);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function showTyping() {
        var chatBox = document.getElementById("chatBox");
        var typingRow = document.createElement("div");
        typingRow.className = "msg-row bot-row";
        typingRow.id = "typingRow";

        var bubble = document.createElement("div");
        bubble.className = "msg-bubble bot-bubble";

        var typingDiv = document.createElement("div");
        typingDiv.className = "typing";
        typingDiv.innerHTML = "<span></span><span></span><span></span>";

        var metaDiv = document.createElement("div");
        metaDiv.className = "meta";
        metaDiv.textContent = "Assistant is typing...";

        bubble.appendChild(typingDiv);
        bubble.appendChild(metaDiv);
        typingRow.appendChild(bubble);

        chatBox.appendChild(typingRow);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function hideTyping() {
        var typingRow = document.getElementById("typingRow");
        if (typingRow) {
            typingRow.remove();
        }
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
        showTyping();

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/chatbotV2", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                hideTyping();

                if (xhr.status === 200) {
                    try {
                        var json = JSON.parse(xhr.responseText);
                        appendMessage(json.reply, "bot");
                    } catch (e) {
                        appendMessage("Invalid JSON response from server.", "bot");
                    }
                } else {
                    appendMessage("Server error occurred. Please try again.", "bot");
                }
            }
        };

        xhr.send("message=" + encodeURIComponent(message));
    }

    function clearChatBox() {
        var chatBox = document.getElementById("chatBox");
        chatBox.innerHTML = "";

        var welcomeRow = document.createElement("div");
        welcomeRow.className = "msg-row bot-row";

        var bubble = document.createElement("div");
        bubble.className = "msg-bubble bot-bubble";
        bubble.innerHTML = "Chat cleared. Ask a new question anytime.<div class='meta'>" + getCurrentTime() + "</div>";

        welcomeRow.appendChild(bubble);
        chatBox.appendChild(welcomeRow);
    }

    function loadHistory() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "<%=request.getContextPath()%>/chatHistory", true);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);

                        if (response.status === "success") {
                            clearChatBox();

                            if (response.history.length === 0) {
                                appendMessage("No previous chat history found.", "bot");
                                return;
                            }

                            for (var i = response.history.length - 1; i >= 0; i--) {
                                var item = response.history[i];

                                var userBubble = createMessageBubble(item.userMessage, "user", item.createdAt);
                                document.getElementById("chatBox").appendChild(userBubble);

                                var botBubble = createMessageBubble(item.botReply, "bot", item.createdAt);
                                document.getElementById("chatBox").appendChild(botBubble);
                            }

                            document.getElementById("chatBox").scrollTop = document.getElementById("chatBox").scrollHeight;
                        } else {
                            appendMessage(response.message, "bot");
                        }
                    } catch (e) {
                        appendMessage("Unable to parse chat history.", "bot");
                    }
                } else {
                    appendMessage("Unable to load history right now.", "bot");
                }
            }
        };

        xhr.send();
    }
</script>
</body>
</html>