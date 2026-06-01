package com.senhostel.controller;

import java.io.IOException;

import com.senhostel.dao.FeeStructureDAO;
import com.senhostel.model.FeeStructure;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addFeeStructure")
public class AddFeeStructureServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        try {
            FeeStructure fs = new FeeStructure();
            fs.setRoomType(request.getParameter("roomType"));
            fs.setMonthlyFee(Double.parseDouble(request.getParameter("monthlyFee")));
            fs.setLateFee(Double.parseDouble(request.getParameter("lateFee")));
            fs.setRemarks(request.getParameter("remarks"));

            FeeStructureDAO dao = new FeeStructureDAO();
            boolean status = dao.addFeeStructure(fs);

            if(status) {
                response.sendRedirect(request.getContextPath() + "/listFeeStructures?success=Fee structure added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/add-fee-structure.jsp?error=Unable to add fee structure");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/add-fee-structure.jsp?error=Invalid data");
        }
    }
}