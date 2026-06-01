<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <style>
        body{
            font-family: Arial, sans-serif;
            background:#0f172a;
            display:flex;
            justify-content:center;
            align-items:center;
            height:100vh;
            margin:0;
        }
        .login-box{
            background:#1e293b;
            padding:30px;
            border-radius:16px;
            width:380px;
            color:white;
            box-shadow:0 8px 20px rgba(0,0,0,0.25);
        }
        h2{
            margin-bottom:20px;
            text-align:center;
        }
        input{
            width:100%;
            padding:12px;
            margin:10px 0;
            border:none;
            border-radius:8px;
            box-sizing:border-box;
        }
        button{
            width:100%;
            padding:12px;
            background:#22d3ee;
            color:#082f49;
            border:none;
            border-radius:8px;
            font-weight:bold;
            cursor:pointer;
        }
        button:hover{
            background:#06b6d4;
        }
        a{
            color:#93c5fd;
            text-decoration:none;
        }
        .error{
            color:#fca5a5;
            margin-top:10px;
            text-align:center;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Admin Login</h2>

        <form action="<%=request.getContextPath()%>/adminLogin" method="post">
            <input type="text" name="username" placeholder="Enter admin username" required>
            <input type="password" name="password" placeholder="Enter password" required>
            <button type="submit">Login</button>
        </form>

        <% String error = request.getParameter("error"); %>
        <% if ("invalid".equals(error)) { %>
            <div class="error">Invalid username or password</div>
        <% } else if ("server".equals(error)) { %>
            <div class="error">Server error, please try again</div>
        <% } %>

        <br>
        <a href="<%=request.getContextPath()%>/index.jsp">Back to Home</a>
    </div>
</body>
</html>