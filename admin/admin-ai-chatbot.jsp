<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session == null || session.getAttribute("adminUser") == null){
        response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin AI Chatbot</title>
    <style>
        *{box-sizing:border-box;}
        body{margin:0;font-family:Arial,sans-serif;background:#f8fafc;}
        .layout{display:flex;min-height:100vh;}
        .sidebar{width:250px;background:#111827;color:#fff;padding:22px;}
        .sidebar h2{margin-top:0;}
        .sidebar a{display:block;color:#cbd5e1;text-decoration:none;padding:12px;border-radius:10px;margin-bottom:8px;}
        .sidebar a:hover{background:#1f2937;color:#fff;}
        .main{flex:1;padding:28px;}
        .hero,.chat-shell{background:#fff;border-radius:18px;box-shadow:0 10px 24px rgba(0,0,0,.06);}
        .hero{padding:24px;margin-bottom:20px;}
        .chat-shell{overflow:hidden;height:78vh;display:flex;flex-direction:column;}
        .chat-header{background:linear-gradient(135deg,#0f766e,#0ea5e9);color:#fff;padding:18px 22px;font-weight:bold;}
        .chat-box{flex:1;padding:18px;overflow-y:auto;background:#f8fafc;}
        .row{display:flex;margin-bottom:16px;}
        .user-row{justify-content:flex-end;}
        .bot-row{justify-content:flex-start;}
        .bubble{max-width:76%;padding:14px 16px;border-radius:16px;line-height:1.6;}
        .user-bubble{background:#0ea5e9;color:#fff;border-bottom-right-radius:6px;}
        .bot-bubble{background:#fff;border:1px solid #e5e7eb;color:#111827;border-bottom-left-radius:6px;}
        .bottom{padding:16px;border-top:1px solid #e5e7eb;display:flex;gap:12px;}
        .bottom input{flex:1;padding:14px;border:1px solid #cbd5e1;border-radius:12px;}
        .bottom button{min-width:110px;border:none;border-radius:12px;background:#0ea5e9;color:#fff;font-weight:bold;cursor:pointer;}
    </style>
</head>
<body>
<div class="layout">
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/admin-ai-chatbot.jsp">Admin Chatbot</a>
        <a href="<%=request.getContextPath()%>/adminFaq">FAQ Training</a>
        <a href="<%=request.getContextPath()%>/chatAnalytics">Chat Analytics</a>
    </div>
    <div class="main">
        <div class="hero">
            <h1>Admin AI Assistant</h1>
            <p>Ask for hostel summary, admin FAQs, or operational help.</p>
        </div>

        <div class="chat-shell">
            <div class="chat-header">Admin Smart Assistant</div>
            <div class="chat-box" id="chatBox">
                <div class="row bot-row"><div class="bubble bot-bubble">Hello Admin! Ask for dashboard summary or management FAQs.</div></div>
            </div>
            <div class="bottom">
                <input type="text" id="adminMessage" placeholder="Type admin question..." onkeydown="if(event.key==='Enter')sendAdminMessage()">
                <button onclick="sendAdminMessage()">Send</button>
            </div>
        </div>
    </div>
</div>

<script>
    function appendAdminMessage(msg, type){
        const box = document.getElementById("chatBox");
        const row = document.createElement("div");
        row.className = "row " + (type === "user" ? "user-row" : "bot-row");

        const bubble = document.createElement("div");
        bubble.className = "bubble " + (type === "user" ? "user-bubble" : "bot-bubble");
        bubble.textContent = msg;

        row.appendChild(bubble);
        box.appendChild(row);
        box.scrollTop = box.scrollHeight;
    }

    function sendAdminMessage(){
        const input = document.getElementById("adminMessage");
        const message = input.value.trim();
        if(message === "") return;

        appendAdminMessage(message, "user");
        input.value = "";

        const xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/adminChatbot", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function(){
            if(xhr.readyState === 4){
                if(xhr.status === 200){
                    try{
                        const json = JSON.parse(xhr.responseText);
                        appendAdminMessage(json.reply, "bot");
                    }catch(e){
                        appendAdminMessage("Invalid server response.", "bot");
                    }
                } else {
                    appendAdminMessage("Server error.", "bot");
                }
            }
        };

        xhr.send("message=" + encodeURIComponent(message));
    }
</script>
</body>
</html>