<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.senhostel.model.ChatFAQ" %>
<%
    if(session == null || session.getAttribute("adminUser") == null){
        response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
        return;
    }
    List<ChatFAQ> faqList = (List<ChatFAQ>) request.getAttribute("faqList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FAQ Training</title>
    <style>
        *{box-sizing:border-box;}
        body{margin:0;font-family:Arial,sans-serif;background:#f8fafc;}
        .wrap{padding:28px;}
        .card{background:#fff;border-radius:18px;box-shadow:0 10px 24px rgba(0,0,0,.06);padding:24px;margin-bottom:20px;}
        .grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;}
        input,textarea,select{width:100%;padding:12px;border:1px solid #cbd5e1;border-radius:12px;}
        textarea{min-height:100px;resize:vertical;}
        button{padding:12px 18px;border:none;border-radius:12px;background:#2563eb;color:#fff;font-weight:bold;cursor:pointer;}
        table{width:100%;border-collapse:collapse;margin-top:12px;}
        th,td{padding:12px;border-bottom:1px solid #e5e7eb;text-align:left;}
        th{background:#eff6ff;color:#1d4ed8;}
        @media(max-width:768px){.grid{grid-template-columns:1fr;}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <h1>FAQ Training Module</h1>
        <p>Add chatbot training questions and answers for student or admin role.</p>
    </div>

    <div class="card">
        <form method="post" action="<%=request.getContextPath()%>/adminFaq">
            <div class="grid">
                <div>
                    <label>Question</label>
                    <input type="text" name="question" required>
                </div>
                <div>
                    <label>Intent Name</label>
                    <input type="text" name="intentName" required>
                </div>
                <div>
                    <label>Role Type</label>
                    <select name="roleType">
                        <option value="student">Student</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div></div>
            </div>
            <div style="margin-top:14px;">
                <label>Answer</label>
                <textarea name="answer" required></textarea>
            </div>
            <div style="margin-top:16px;">
                <button type="submit">Add FAQ</button>
            </div>
        </form>
    </div>

    <div class="card">
        <h2>Existing FAQ Entries</h2>
        <table>
            <tr>
                <th>ID</th>
                <th>Question</th>
                <th>Answer</th>
                <th>Intent</th>
                <th>Role</th>
            </tr>
            <%
                if(faqList != null && !faqList.isEmpty()){
                    for(ChatFAQ faq : faqList){
            %>
            <tr>
                <td><%= faq.getFaqId() %></td>
                <td><%= faq.getQuestion() %></td>
                <td><%= faq.getAnswer() %></td>
                <td><%= faq.getIntentName() %></td>
                <td><%= faq.getRoleType() %></td>
            </tr>
            <% }} else { %>
            <tr><td colspan="5">No FAQ training data found.</td></tr>
            <% } %>
        </table>
    </div>
</div>
</body>
</html>