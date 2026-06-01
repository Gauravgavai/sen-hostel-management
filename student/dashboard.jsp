<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.senhostel.model.RoomAllocation" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #0f172a;
            margin: 0;
            padding: 30px;
            color: #e2e8f0;
        }
        .container {
            width: 95%;
            max-width: 1100px;
            margin: auto;
        }
        h1, h2 {
            margin: 0;
        }
        .grid {
            display: grid;
            grid-template-columns: 2fr 1.6fr;
            gap: 20px;
        }
        @media (max-width: 900px) {
            .grid {
                grid-template-columns: 1fr;
            }
        }
        .card {
            background: #111827;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.5);
            margin-bottom: 20px;
        }
        .title {
            font-size: 18px;
            margin-bottom: 10px;
        }
        .allocated {
            background: #0f172a;
            border-left: 5px solid #22c55e;
        }
        .not-allocated {
            background: #0f172a;
            border-left: 5px solid #facc15;
        }
        p {
            margin: 6px 0;
            font-size: 14px;
        }
        a {
            color: #93c5fd;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .btn {
            display: inline-block;
            padding: 10px 16px;
            border-radius: 8px;
            background: #22d3ee;
            color: #0f172a;
            font-weight: bold;
            text-decoration: none;
            margin: 5px 5px 5px 0;
            font-size: 13px;
        }
        .btn.secondary {
            background: #1f2937;
            color: #e5e7eb;
            border: 1px solid #4b5563;
        }
        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 999px;
            font-size: 11px;
        }
        .badge-success {
            background: #064e3b;
            color: #bbf7d0;
        }
        .badge-warning {
            background: #78350f;
            color: #fef3c7;
        }
        .welcome-text {
            margin-bottom: 18px;
            font-size: 14px;
            line-height: 1.5;
        }
        /* Chatbot panel */
        .chat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .chat-box {
            height: 260px;
            background: #020617;
            border-radius: 10px;
            border: 1px solid #1f2937;
            padding: 10px;
            display: flex;
            flex-direction: column;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            font-size: 13px;
        }
        .chat-row {
            margin-bottom: 8px;
        }
        .chat-row.user {
            text-align: right;
        }
        .bubble {
            display: inline-block;
            padding: 7px 10px;
            border-radius: 12px;
            max-width: 80%;
        }
        .bubble.user {
            background: #38bdf8;
            color: #0f172a;
        }
        .bubble.bot {
            background: #111827;
            color: #e5e7eb;
        }
        .chat-meta {
            font-size: 10px;
            color: #9ca3af;
            margin-top: 2px;
        }
        .chat-input-row {
            display: flex;
            gap: 6px;
            margin-top: 8px;
        }
        .chat-input-row input {
            flex: 1;
            padding: 8px;
            border-radius: 999px;
            border: 1px solid #374151;
            background: #020617;
            color: #e5e7eb;
            font-size: 13px;
            outline: none;
        }
        .chat-input-row button {
            border-radius: 999px;
            border: none;
            padding: 8px 14px;
            background: #22c55e;
            color: #022c22;
            font-weight: bold;
            font-size: 12px;
            cursor: pointer;
        }
        .chat-input-row button:hover {
            background: #16a34a;
        }
        .small-text {
            font-size: 12px;
            color: #9ca3af;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Student Dashboard</h1>

    <div class="welcome-text">
        <strong>Namaste! Welcome to the Elite Student Housing Portal.</strong><br>
        We’re glad that you’ve chosen our hostel to support your academic journey. 
        From room allocation to complaints and smart QR access, manage everything from this portal.
    </div>

    <div class="grid">
        <!-- LEFT: Room allocation + quick links -->
        <div>
            <%
                RoomAllocation currentAllocation = (RoomAllocation) request.getAttribute("currentAllocation");
            %>

            <div class="card <%= (currentAllocation != null ? "allocated" : "not-allocated") %>">
                <div class="title">Room Allocation Status</div>

                <% if (currentAllocation != null) { %>
                    <p>
                        <span class="badge badge-success">Allocated</span>
                    </p>
                    <p><strong>Room Number:</strong> <%= currentAllocation.getRoomNumber() %></p>
                    <p><strong>Block:</strong> <%= currentAllocation.getBlock() %></p>
                    <p><strong>Allocation Date:</strong> <%= currentAllocation.getAllocationDate() %></p>
                    <p><strong>Status:</strong> <%= currentAllocation.getStatus() %></p>
                    <p><strong>Occupancy:</strong> <%= currentAllocation.getOccupied() %>/<%= currentAllocation.getCapacity() %></p>
                    <p><strong>Vacancy Left:</strong> <%= currentAllocation.getVacancy() %></p>
                <% } else { %>
                    <p>
                        <span class="badge badge-warning">Not Allocated</span>
                    </p>
                    <p>No active room has been allocated to you yet.</p>
                    <p>Please contact the warden or hostel office for allocation status.</p>
                <% } %>
            </div>

            <!-- Quick navigation cards -->
            <div class="card">
                <div class="title">Quick Actions</div>
                <p>
                    <a href="<%=request.getContextPath()%>/student/add-complaint.jsp" class="btn">Submit Complaint</a>
                    <a href="<%=request.getContextPath()%>/student/my-complaints.jsp" class="btn secondary">My Complaints</a>
                </p>
                <p>
                    <a href="<%=request.getContextPath()%>/student/add-visitor.jsp" class="btn">Add Visitor</a>
                    <a href="<%=request.getContextPath()%>/student/my-visitors.jsp" class="btn secondary">My Visitors</a>
                </p>
                <p>
                    <a href="<%=request.getContextPath()%>/student/mess-menu.jsp" class="btn secondary">Mess Menu</a>
                    <a href="<%=request.getContextPath()%>/student/my-mess-attendance.jsp" class="btn secondary">Mess Attendance</a>
                </p>
                <p>
                    <a href="<%=request.getContextPath()%>/student/events.jsp" class="btn secondary">Events Calendar</a>
                    <a href="<%=request.getContextPath()%>/student/student-qr-pass-v2.jsp" class="btn">QR Pass V2 Ultra</a>
                </p>
            </div>
        </div>

        <!-- RIGHT: Fee summary + AI Chatbot V3 -->
        <div>
            <!-- Fee summary (placeholder; future integration with DB) -->
            <div class="card">
                <div class="title">Fee Status (Summary)</div>
                <p><strong>Total Due:</strong> <%= (request.getAttribute("feeAmountText") != null ? request.getAttribute("feeAmountText") : "-") %></p>
                <p><strong>Status:</strong> <%= (request.getAttribute("feeStatusText") != null ? request.getAttribute("feeStatusText") : "Not Generated") %></p>
                <p class="small-text">
                    For detailed bill and payment history, please check the fees section (once enabled) or contact the hostel office.
                </p>
            </div>

            <!-- AI Chatbot V3 panel -->
            <div class="card">
                <div class="chat-header">
                    <div>
                        <div class="title">AI Assistant (Chatbot V3)</div>
                        <div class="small-text">
                            Ask about room status, hostel rules, mess, visitors, or general FAQs.
                        </div>
                    </div>
                    <button type="button" onclick="loadChatHistoryV3()" style="background:#1f2937;color:#e5e7eb;border:1px solid #4b5563;border-radius:6px;padding:6px 10px;font-size:11px;cursor:pointer;">
                        History
                    </button>
                </div>

                <div class="chat-box">
                    <div id="chatMessages" class="chat-messages">
                        <div class="chat-row bot">
                            <div class="bubble bot">
                                Hi, I’m your hostel AI assistant. How can I help you today?
                                <div class="chat-meta">Now • Assistant</div>
                            </div>
                        </div>
                    </div>

                    <div id="typingRow" class="small-text" style="display:none;">
                        Assistant is typing…
                    </div>

                    <div class="chat-input-row">
                        <input type="text" id="chatInput" placeholder="Type your question and press Enter..."
                               onkeydown="if(event.key==='Enter'){ sendChatV3(); }">
                        <button type="button" onclick="sendChatV3()">Send</button>
                    </div>
                </div>
                <div class="small-text" style="margin-top:6px;">
                    Tip: Try asking “What is my room allocation process?”, “How to submit a complaint?”, or “What are hostel gate timings?”.
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function appendChat(text, type, meta) {
        var box = document.getElementById("chatMessages");
        var row = document.createElement("div");
        row.className = "chat-row " + (type === "user" ? "user" : "bot");

        var bubble = document.createElement("div");
        bubble.className = "bubble " + (type === "user" ? "user" : "bot");
        bubble.textContent = text;

        var metaDiv = document.createElement("div");
        metaDiv.className = "chat-meta";
        metaDiv.textContent = meta || new Date().toLocaleTimeString();

        bubble.appendChild(metaDiv);
        row.appendChild(bubble);
        box.appendChild(row);
        box.scrollTop = box.scrollHeight;
    }

    function setTyping(show) {
        document.getElementById("typingRow").style.display = show ? "block" : "none";
    }

    function sendChatV3() {
        var input = document.getElementById("chatInput");
        var msg = input.value.trim();
        if (!msg) return;

        appendChat(msg, "user", "You • " + new Date().toLocaleTimeString());
        input.value = "";
        setTyping(true);

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "<%=request.getContextPath()%>/chatbotV3", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                setTyping(false);
                if (xhr.status === 200) {
                    try {
                        var raw = xhr.responseText ? xhr.responseText.trim() : "";
                        var json = JSON.parse(raw);
                        var reply = json.reply || "I couldn't understand the response.";
                        appendChat(reply, "bot", "Assistant • " + new Date().toLocaleTimeString());
                    } catch (e) {
                        appendChat("Sorry, there was an error reading the server response.", "bot");
                    }
                } else {
                    appendChat("Server error (" + xhr.status + "). Please try again later.", "bot");
                }
            }
        };

        xhr.send("message=" + encodeURIComponent(msg));
    }

    function loadChatHistoryV3() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "<%=request.getContextPath()%>/chatHistoryV3", true);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                var box = document.getElementById("chatMessages");
                box.innerHTML = "";

                if (xhr.status === 200) {
                    try {
                        var raw = xhr.responseText ? xhr.responseText.trim() : "";
                        var json = JSON.parse(raw);

                        if (!json.history || json.history.length === 0) {
                            appendChat("No previous chat history found.", "bot");
                            return;
                        }

                        json.history.forEach(function(item) {
                            appendChat(item.userMessage, "user", item.createdAt || "You");
                            appendChat(item.botReply, "bot", item.createdAt || "Assistant");
                        });
                    } catch (e) {
                        appendChat("Unable to load chat history.", "bot");
                    }
                } else {
                    appendChat("Failed to load history (" + xhr.status + ").", "bot");
                }
            }
        };

        xhr.send();
    }
</script>
</body>
</html>