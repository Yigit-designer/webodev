package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * AdminOrderServlet - Sipariş Yönetimi
 * Admin panelinde siparişleri listeleyip durumlarını güncelleyebilir
 */
@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (!isAdmin(request)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("detail".equals(action)) {
                showOrderDetail(request, response);
            } else {
                listOrders(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Bir hata oluştu: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (!isAdmin(request)) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("updateStatus".equals(action)) {
                updateOrderStatus(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Bir hata oluştu: " + e.getMessage());
            listOrders(request, response);
        }
    }
    
    /**
     * Tüm siparişleri listeler
     */
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Order> orders = OrderDAO.getAllOrders();
            
            if (orders == null) {
                orders = new java.util.ArrayList<>();
                System.err.println("⚠ OrderDAO.getAllOrders() null döndü");
            }
            
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("❌ Siparişleri Listeleme Hatası: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Siparişler listelenirken hata oluştu: " + e.getMessage());
            request.setAttribute("orders", new java.util.ArrayList<>());
            request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
        }
    }
    
    /**
     * Sipariş detayını gösterir
     */
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam.trim());
            Order order = OrderDAO.getOrderById(orderId);
            
            if (order == null) {
                System.err.println("⚠ Sipariş bulunamadı: Order ID = " + orderId);
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            
            List<OrderItem> orderItems = OrderDAO.getOrderItems(orderId);
            
            if (orderItems == null) {
                orderItems = new java.util.ArrayList<>();
                System.err.println("⚠ OrderDAO.getOrderItems() null döndü");
            }
            
            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.getRequestDispatcher("/WEB-INF/views/admin/order-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("❌ Geçersiz Order ID: " + orderIdParam);
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } catch (Exception e) {
            System.err.println("❌ Sipariş Detayı Hatası: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
    
    /**
     * Sipariş durumunu günceller
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdParam = request.getParameter("orderId");
        String status = request.getParameter("status");
        
        if (orderIdParam == null || status == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        
        // Durum validasyonu
        if (!isValidStatus(status)) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        
        try {
            int orderId = Integer.parseInt(orderIdParam);
            
            if (OrderDAO.updateOrderStatus(orderId, status)) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&orderId=" + orderId);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
    
    /**
     * Sipariş durumunun geçerli olup olmadığını kontrol eder
     */
    private boolean isValidStatus(String status) {
        return status.equals("Beklemede") || 
               status.equals("Hazırlanıyor") || 
               status.equals("Kargoya Verildi") || 
               status.equals("Teslim Edildi") || 
               status.equals("İptal Edildi");
    }
    
    /**
     * Kullanıcının admin olup olmadığını kontrol eder
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        return loggedInUser != null && loggedInUser.isAdmin();
    }
}
