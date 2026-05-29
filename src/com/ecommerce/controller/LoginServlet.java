package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet - Kullanıcı Giriş
 * Kullanıcıların giriş yapmasını sağlar
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Login sayfasını göster
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Form verilerini al
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validasyon
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Email ve şifre gereklidir!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        
        // UserDAO ile kontrol et
        User user = UserDAO.loginUser(email, password);
        
        if (user == null) {
            request.setAttribute("errorMessage", "Email veya şifre hatalı!");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }
        
        // Başarılı - Session'a kullanıcıyı ekle
        HttpSession session = request.getSession();
        session.setAttribute("loggedInUser", user);
        
        // Kullanıcı rolüne göre yönlendir
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
