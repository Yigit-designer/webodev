package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.AdminAuthFilter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * AdminUserServlet - Kullanıcı listeleme (yalnızca görüntüleme)
 * Admin yetki kontrolü yapılır
 */
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Admin yetki kontrolü
            if (!isAdmin(request)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            List<User> users = UserDAO.getAllUsers();
            
            if (users == null) {
                users = new java.util.ArrayList<>();
                System.err.println("⚠ UserDAO.getAllUsers() null döndü");
            }
            
            request.setAttribute("users", users);
            request.setAttribute("successMessage", request.getParameter("successMessage"));
            
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
            
        } catch (NullPointerException e) {
            System.err.println("❌ NullPointerException - AdminUserServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Veri işleme hatası: Eksik veya boş veri");
            request.setAttribute("users", new java.util.ArrayList<>());
            try {
                request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
            } catch (Exception forwardEx) {
                System.err.println("Forward hatası: " + forwardEx.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, forwardEx.getMessage());
            }
        } catch (Exception e) {
            System.err.println("❌ Genel Hata - AdminUserServlet: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Bir hata oluştu: " + e.getMessage());
            request.setAttribute("users", new java.util.ArrayList<>());
            try {
                request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
            } catch (Exception forwardEx) {
                System.err.println("Forward hatası: " + forwardEx.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, forwardEx.getMessage());
            }
        }
    }
    
    /**
     * Kullanıcının admin olup olmadığını kontrol eder
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        return loggedInUser != null && "admin".equalsIgnoreCase(loggedInUser.getRole());
    }
}
