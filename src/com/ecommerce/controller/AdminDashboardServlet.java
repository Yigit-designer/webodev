package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AdminDashboardServlet - Yönetim Paneli
 * İstatistikleri ve özet bilgileri gösterir
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        // Admin kontrolü
        if (loggedInUser == null || !loggedInUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // İstatistikleri hesapla
        int totalProducts = ProductDAO.getAllActiveProducts().size();
        int totalCategories = CategoryDAO.getAllCategories().size();
        int totalOrders = OrderDAO.getAllOrders().size();
        
        // Request attribute olarak ekle
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("totalOrders", totalOrders);
        
        // Dashboard sayfasına yönlendir
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
