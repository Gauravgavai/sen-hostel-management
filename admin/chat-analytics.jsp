<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.senhostel.model.ChatAnalytics" %>
<%
    if(session == null || session.getAttribute("adminUser") == null){
        response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
        return;
    }
    ChatAnalytics analytics = (ChatAnalytics) request.getAttribute("analytics");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat Analytics</title>
    <style>
        *{box-sizing:border-box;}
        body{margin:0;font-family:Arial,sans-serif;background:#f8fafc;}
        .wrap{padding:28px;}
        .hero,.card{background:#fff;border-radius:18px;box-shadow:0 10px 24px rgba(0,0,0,.06);padding:24px;margin-bottom:20px;}
        .stats{display:grid;grid-template-columns:repeat(5,1fr);gap:16px;}
        .stat{background:linear-gradient(135deg,#eff6ff,#f8fafc);padding:20px;border-radius:16px;border:1px solid #dbeafe;}
        .stat h4{margin:0 0 10px;color:#64748b;font-size:14px;}
        .stat p{margin:0;font-size:28px;font-weight:bold;color:#1d4ed8;}
        @media(max-width:1000px){.stats{grid-template-columns:repeat(2,1fr);}}
        @media(max-width:650px){.stats{grid-template-columns:1fr;}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="hero">
        <h1>Chat Analytics Dashboard</h1>
        <p>Monitor total chats, FAQ hits, AI fallback usage, and user feedback trends.</p>
    </div>

    <div class="stats">
        <div class="stat">
            <h4>Total Chats</h4>
            <p><%= analytics != null ? analytics.getTotalChats() : 0 %></p>
        </div>
        <div class="stat">
            <h4>FAQ Hits</h4>
            <p><%= analytics != null ? analytics.getTotalFaqHits() : 0 %></p>
        </div>
        <div class="stat">
            <h4>AI Fallbacks</h4>
            <p><%= analytics != null ? analytics.getTotalAiFallbacks() : 0 %></p>
        </div>
        <div class="stat">
            <h4>Helpful</h4>
            <p><%= analytics != null ? analytics.getHelpfulCount() : 0 %></p>
        </div>
        <div class="stat">
            <h4>Not Helpful</h4>
            <p><%= analytics != null ? analytics.getNotHelpfulCount() : 0 %></p>
        </div>
    </div>
</div>
</body>
</html>