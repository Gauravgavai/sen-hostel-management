package com.senhostel.controller;

import java.io.IOException;
import java.sql.Date;

import com.senhostel.dao.FeePaymentDAO;
import com.senhostel.model.FeePayment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addFeePayment")
public class AddFeePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }

        try {
            FeePayment payment = new FeePayment();
            payment.setBillId(Integer.parseInt(request.getParameter("billId")));
            payment.setStudentId(Integer.parseInt(request.getParameter("studentId")));
            payment.setAmountPaid(Double.parseDouble(request.getParameter("amountPaid")));
            payment.setPaymentDate(Date.valueOf(request.getParameter("paymentDate")));
            payment.setPaymentMode(request.getParameter("paymentMode"));
            payment.setRemarks(request.getParameter("remarks"));

            FeePaymentDAO dao = new FeePaymentDAO();
            boolean status = dao.addPayment(payment);

            if (status) {
                response.sendRedirect(request.getContextPath() + "/listFeeBills?success=Payment added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/add-fee-payment.jsp?error=Unable to add payment");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/add-fee-payment.jsp?error=Invalid input");
        }
    }
}