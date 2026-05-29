package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * RegisterServlet - Kullanıcı Kaydı
 * Yeni kullanıcıların kaydını sağlar
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kayıt sayfasını göster
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Form verilerini al
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Temel Validasyon
        if (fullName == null || fullName.isEmpty() || 
            email == null || email.isEmpty() || 
            password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Ad, email ve şifre gereklidir!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Email benzersizlik kontrolü
        User existingUser = UserDAO.getUserByEmail(email);
        if (existingUser != null) {
            request.setAttribute("errorMessage", "Bu email zaten kayıtlı!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Yeni User nesnesi oluştur
        User newUser = new User(fullName, email, password, phone, address, "customer");
        
        // Kayıt işlemini yap
        boolean success = UserDAO.registerUser(newUser);
        
        if (!success) {
            request.setAttribute("errorMessage", "Kayıt sırasında hata oluştu!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
        
        // Başarılı - Login sayfasına yönlendir
        request.setAttribute("successMessage", "Kayıt başarılı! Lütfen giriş yapın.");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
