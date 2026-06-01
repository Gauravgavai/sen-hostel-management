package com.senhostel.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.QRCheckinV2DAO;
import com.senhostel.model.ScanAnalytics;

@WebServlet("/adminAnalytics")
public class AdminAnalyticsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            out.print("{\"status\":\"error\",\"message\":\"Admin session missing.\"}");
            return;
        }

        QRCheckinV2DAO dao = new QRCheckinV2DAO();
        ScanAnalytics a = dao.getAnalytics();

        String json = "{"
                + "\"status\":\"success\","
                + "\"todayStudentScans\":" + a.getTodayStudentScans() + ","
                + "\"todayVisitorScans\":" + a.getTodayVisitorScans() + ","
                + "\"totalScans\":" + a.getTotalScans() + ","
                + "\"liveAttendanceCount\":" + a.getLiveAttendanceCount()
                + "}";

        out.print(json);
    }
}