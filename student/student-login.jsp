<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Login</title>
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
            font-size:14px;
        }
        .success{
            color:#86efac;
            margin-top:10px;
            text-align:center;
            font-size:14px;
            font-weight:bold;
        }
        .bottom-links{
            margin-top:16px;
            text-align:center;
            font-size:13px;
        }
        .bottom-links a{
            display:inline-block;
            margin:4px 0;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>Student Login</h2>

        <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");
        %>

        <% if ("registered".equals(success)) { %>
            <div class="success">
                Registration successful! Please login with your email and password.
            </div>
        <% } %>

        <% if ("invalid".equals(error)) { %>
            <div class="error">Invalid email or password</div>
        <% } else if ("server".equals(error)) { %>
            <div class="error">Server error, please try again</div>
        <% } %>

        <form action="<%=request.getContextPath()%>/studentLogin" method="post">
            <input type="text" name="email" placeholder="Enter email" required>
            <input type="password" name="password" placeholder="Enter password" required>
            <button type="submit">Login</button>
        </form>

        <div class="bottom-links">
            <div>
                New student? 
                <a href="<%=request.getContextPath()%>/student/student-register.jsp">
                    Create a new account
                </a>
            </div>
            <div>
                <a href="<%=request.getContextPath()%>/index.jsp">Back to Home</a>
            </div>
        </div>
    </div>
</body>
</html>