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
    <title>AI Chatbot V3</title>
    <style>
        *{box-sizing:border-box;}
        body{
            margin:0;
            font-family:Arial,sans-serif;
            background:linear-gradient(135deg,#eef2ff,#eff6ff,#f8fafc);
            color:#111827;
        }
        .layout{display:flex;min-height:100vh;}
        .sidebar{
            width:250px;background:linear-gradient(180deg,#0f172a,#1e293b);color:#fff;padding:22px;
        }
        .sidebar h2{margin:0 0 20px;}
        .sidebar a{
            display:block;color:#cbd5e1;text-decoration:none;padding:12px 14px;border-radius:10px;margin-bottom:8px;
        }
        .sidebar a:hover{background:rgba(255,255,255,0.08);color:#fff;}
        .main{flex:1;padding:28px;}
        .hero{
            background:#fff;border-radius:20px;padding:24px;box-shadow:0 12px 30px rgba(0,0,0,0.07);margin-bottom:22px;
        }
        .hero h1{margin:0 0 8px;color:#1d4ed8;}
        .hero p{margin:0;color:#64748b;line-height:1.6;}
        .chat-shell{
            background:#fff;border-radius:24px;box-shadow:0 18px 40px rgba(0,0,0,0.08);overflow:hidden;
            display:flex;flex-direction:column;height:78vh;
        }
        .chat-header{
            display:flex;justify-content:space-between;align-items:center;gap:12px;
            background:linear-gradient(135deg,#1d4ed8,#2563eb,#4f46e5);color:#fff;padding:18px 22px;
        }
        .chat-header h3{margin:0;}
        .action-group{display:flex;gap:10px;flex-wrap:wrap;}
        .top-btn{
            border:none;background:rgba(255,255,255,0.15);color:#fff;padding:10px 14px;border-radius:999px;cursor:pointer;font-weight:bold;
        }
        .top-btn:hover{background:rgba(255,255,255,0.25);}
        .quick-bar{
            display:flex;flex-wrap:wrap;gap:10px;padding:16px;background:#fff;border-bottom:1px solid #e5e7eb;
        }
        .chip{
            border:1px solid #bfdbfe;background:#eff6ff;color:#1d4ed8;padding:10px 14px;border-radius:999px;cursor:pointer;font-weight:600;
        }
        .chat-box{
            flex:1;overflow-y:auto;padding:18px;background:linear-gradient(180deg,#f8fbff,#f9fafb);
        }
        .row{display:flex;margin-bottom:16px;}
        .user-row{justify-content:flex-end;}
        .bot-row{justify-content:flex-start;}
        .bubble{
            max-width:76%;padding:14px 16px;border-radius:18px;line-height:1.6;box-shadow:0 8px 18px rgba(0,0,0,0.05);
        }
        .user-bubble{
            background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#fff;border-bottom-right-radius:6px;
        }
        .bot-bubble{
            background:#fff;border:1px solid #e5e7eb;color:#111827;border-bottom-left-radius:6px;
        }
        .meta{margin-top:8px;font-size:11px;opacity:0.75;}
        .feedback{
            display:flex;gap:8px;margin-top:10px;flex-wrap:wrap;
        }
        .feedback button{
            border:1px solid #d1d5db;background:#f8fafc;padding:7px 10px;border-radius:999px;cursor:pointer;font-size:12px;
        }
        .feedback button:hover{background:#eef2ff;}
        .typing span{
            display:inline-block;width:8px;height:8px;background:#64748b;border-radius:50%;margin-right:4px;animation:blink 1.2s infinite;
        }
        .typing span:nth-child(2){animation-delay:.2s;}
        .typing span:nth-child(3){animation-delay:.4s;}
        @keyframes blink{
            0%,80%,100%{opacity:.2;transform:translateY(0);}
            40%{opacity:1;transform:translateY(-3px);}
        }
        .bottom{
            padding:16px;border-top:1px solid #e5e7eb;background:#fff;
        }
        .input-wrap{display:flex;gap:12px;}
        .input-wrap input{
            flex:1;padding:15px;border:1px solid #cbd5e1;border-radius:14px;font-size:15px;outline:none;background:#f8fafc;
        }
        .input-wrap input:focus{
            border-color:#2563eb;box-shadow:0 0 0 4px rgba(37,99,235,.12);background:#fff;
        }
        .send-btn{
            min-width:110px;border:none;border-radius:14px;background:linear-gradient(135deg,#2563eb,#1d4ed8);color:#fff;font-weight:bold;cursor:pointer;
        }
        .note{margin-top:10px;color:#64748b;font-size:12px;}
        @media(max-width:768px){
            .layout{flex-direction:column;}
            .sidebar{width:100%;}
            .main{padding:16px;}
            .chat-header{flex-direction:column;align-items:flex-start;}
            .input-wrap{flex-direction:column;}
            .send-btn{min-height:48px;}
            .bubble{max-width:88%;}
        }
    </style>
</head>
<body>
<div class="layout">
    <div class="sidebar">
        <h2>Student Panel</h2>
        <a href="<%=request.getContextPath()%>/student/student-dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/student/ai-chatbot-v3.jsp">AI Chatbot V3</a>
    </div>

    <div class="main">
        <div class="hero">
            <h1>AI Hostel Assistant V3</h1>
            <p>Voice-enabled premium chatbot with smart fallback, FAQ matching, speech output, feedback, and advanced hostel support.</p>
        </div>

        <div class="chat-shell">
            <div class="chat-header">
                <h3>Smart Student Assistant</h3>
                <div class="action-group">
                    <button class="top-btn" onclick="startVoiceInput()">🎤 Voice</button>
                    <button class="top-btn" onclick="toggleSpeech()">🔊 Speech</button>
                    <button class="top-btn" onclick="loadHistory()">🕘 History</button>
                    <button class="top-btn" onclick="clearChat()">🧹 Clear</button>
                </div>
            </div>

            <div class="quick-bar">
                <button class="chip" onclick="quickAsk('hello')">Hello</button>
                <button class="chip" onclick="quickAsk('room status')">Room Status</button>
                <button class="chip" onclick="quickAsk('fee due')">Fee Due</button>
                <button class="chip" onclick="quickAsk('complaint status')">Complaint Status</button>
                <button class="chip" onclick="quickAsk('my profile')">My Profile</button>
                <button class="chip" onclick="quickAsk('vacant rooms')">Vacant Rooms</button>
            </div>

            <div class="chat-box" id="chatBox">
                <div class="row bot-row">
                    <div class="bubble bot-bubble">
                        Hello! I am your V3 hostel assistant. You can type or use voice search.
                        <div class="meta" id="welcomeTime"></div>
                    </div>
                </div>
            </div>

            <div class="bottom">
                <div class="input-wrap">
                    <input type="text" id="messageInput" placeholder="Ask anything... ex. meri fee, room status, hostel rules" onkeydown="handleEnter(event)">
                    <button class="send-btn" onclick="sendMessage()">Send</button>
                </div>
                <div class="note">Voice uses browser speech recognition support. Speech output uses browser text-to-speech. These browser capabilities vary by platform and support level. [web:374][web:356][web:373]</div>
            </div>
        </div>
    </div>
</div>

<script>
    let speechEnabled = true;
    document.getElementById("welcomeTime").textContent = new Date().toLocaleString();

    function handleEnter(event){
        if(event.key === "Enter"){
            sendMessage();
        }
    }

    function quickAsk(text){
        document.getElementById("messageInput").value = text;
        sendMessage();
    }

    function createBubble(message, type, timeText, chatId){
        const row = document.createElement("div");
        row.className = "row " + (type === "user" ? "user-row" : "bot-row");

        const bubble = document.createElement("div");
        bubble.className = "bubble " + (type === "user" ? "user-bubble" : "bot-bubble");

        const msg = document.createElement("div");
        msg.textContent = message;

        const meta = document.createElement("div");
        meta.className = "meta";
        meta.textContent = timeText || new Date().toLocaleString();

        bubble.appendChild(msg);
        bubble.appendChild(meta);

        if(type === "bot" && chatId){
            const feedback = document.createElement("div");
            feedback.className = "feedback";
            feedback.innerHTML =
                '<button onclick="sendFeedback(' + chatId + ', \'helpful\')">👍 Helpful</button>' +
                '<button onclick="sendFeedback(' + chatId + ', \'not_helpful\')">👎 Not Helpful</button>' +
                '<button onclick="speakText(this.parentElement.parentElement.firstChild.textContent)">🔊 Speak</button>';
            bubble.appendChild(feedback);
        }

        row.appendChild(bubble);
        return row;
    }

    function appendMessage(message, type, chatId){
        const chatBox = document.getElementById("chatBox");
        const bubble = createBubble(message, type, new Date().toLocaleString(), chatId);
        chatBox.appendChild(bubble);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function showTyping(){
        const chatBox = document.getElementById("chatBox");
        const row = document.createElement("div");
        row.className = "row bot-row";
        row.id = "typingRow";

        const bubble = document.createElement("div");
        bubble.className = "bubble bot-bubble";
        bubble.innerHTML = '<div class="typing"><span></span><span></span><span></span></div><div class="meta">Assistant is typing...</div>';

        row.appendChild(bubble);
        chatBox.appendChild(row);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function hideTyping(){
        const row = document.getElementById("typingRow");
        if(row) row.remove();
    }

    function clearChat(){
        document.getElementById("chatBox").innerHTML = "";
        appendMessage("Chat cleared. Ask a fresh question anytime.", "bot", null);
    }

    function toggleSpeech(){
        speechEnabled = !speechEnabled;
        appendMessage("Speech output is now " + (speechEnabled ? "enabled." : "disabled."), "bot", null);
    }

    function speakText(text){
        if(!speechEnabled) return;
        if(!('speechSynthesis' in window)) return;

        window.speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = "en-IN";
        utterance.rate = 1;
        utterance.pitch = 1;
        window.speechSynthesis.speak(utterance);
    }

    function startVoiceInput(){
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if(!SpeechRecognition){
            appendMessage("Voice recognition is not supported in this browser.", "bot", null);
            return;
        }

        const recognition = new SpeechRecognition();
        recognition.lang = "en-IN";
        recognition.interimResults = false;
        recognition.maxAlternatives = 1;

        recognition.onstart = function(){
            appendMessage("Listening... बोलो अपना question.", "bot", null);
        };

        recognition.onresult = function(event){
            const transcript = event.results[0][0].transcript;
            document.getElementById("messageInput").value = transcript;
            sendMessage();
        };

        recognition.onerror = function(){
            appendMessage("Voice recognition failed. Please try again.", "bot", null);
        };

        recognition.start();
    }

    function sendMessage(){
        const input = document.getElementById("messageInput");
        const message = input.value.trim();

        if(message === "") return;

        appendMessage(message, "user", null);
        input.value = "";
        showTyping();

        const xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/chatbotV3", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4){
                hideTyping();
                if(xhr.status === 200){
                    try{
                        const json = JSON.parse(xhr.responseText);
                        appendMessage(json.reply, "bot", json.chatId);
                        if(speechEnabled){
                            speakText(json.reply);
                        }
                    }catch(e){
                        appendMessage("Invalid response from server.", "bot", null);
                    }
                }else{
                    appendMessage("Server error. Please try again.", "bot", null);
                }
            }
        };

        xhr.send("message=" + encodeURIComponent(message));
    }

    function sendFeedback(chatId, feedbackType){
        const xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/chatFeedback", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4 && xhr.status === 200){
                appendMessage("Feedback saved: " + feedbackType, "bot", null);
            }
        };
        xhr.send("chatId=" + encodeURIComponent(chatId) + "&feedbackType=" + encodeURIComponent(feedbackType));
    }

    function loadHistory(){
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "<%=request.getContextPath()%>/chatHistoryV3", true);

        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4){
                if(xhr.status === 200){
                    try{
                        const response = JSON.parse(xhr.responseText);
                        if(response.status === "success"){
                            clearChat();
                            if(response.history.length === 0){
                                appendMessage("No chat history found.", "bot", null);
                                return;
                            }

                            for(let i = response.history.length - 1; i >= 0; i--){
                                const item = response.history[i];
                                const userRow = createBubble(item.userMessage, "user", item.createdAt, null);
                                const botRow = createBubble(item.botReply, "bot", item.createdAt, item.chatId);
                                document.getElementById("chatBox").appendChild(userRow);
                                document.getElementById("chatBox").appendChild(botRow);
                            }
                        } else {
                            appendMessage(response.message, "bot", null);
                        }
                    }catch(e){
                        appendMessage("Unable to parse history.", "bot", null);
                    }
                } else {
                    appendMessage("Unable to load history.", "bot", null);
                }
            }
        };

        xhr.send();
    }
</script>
</body>
</html>