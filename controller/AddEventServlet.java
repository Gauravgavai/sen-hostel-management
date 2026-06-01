package com.senhostel.controller;

import java.io.IOException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.senhostel.dao.EventDAO;
import com.senhostel.model.Event;

@WebServlet("/addEvent")
public class AddEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        try {
            Event e = new Event();
            e.setEventTitle(request.getParameter("eventTitle"));
            e.setEventDescription(request.getParameter("eventDescription"));
            e.setEventDate(Date.valueOf(request.getParameter("eventDate")));
            e.setEventTime(request.getParameter("eventTime"));
            e.setVenue(request.getParameter("venue"));
            e.setOrganizer(request.getParameter("organizer"));
            e.setStatus(request.getParameter("status"));

            EventDAO dao = new EventDAO();
            boolean status = dao.addEvent(e);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/viewEvents?success=Event added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/viewEvents?error=Unable to add event");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/viewEvents?error=Invalid event data");
        }
    }
}