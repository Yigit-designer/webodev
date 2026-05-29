package com.ecommerce.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LogoutServlet - Çıkış İşlemi
 * Kullanıcı oturumunu kapatır
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Mevcut session'ı al ve sonlandır
        HttpSession session = request.getSession();
        session.invalidate();
        
        // Ana sayfaya yönlendir
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
