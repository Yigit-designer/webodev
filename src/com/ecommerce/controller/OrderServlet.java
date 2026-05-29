package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.model.Order;
import com.ecommerce.model.CartItem;
import com.ecommerce.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderServlet - Sipariş Yönetimi
 * Sipariş oluşturma ve siparişleri listeleme işlemlerini yönetir
 */
@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            
            if (loggedInUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            String flashMessage = (String) session.getAttribute("orderSuccessMessage");
            if (flashMessage != null) {
                request.setAttribute("successMessage", flashMessage);
                session.removeAttribute("orderSuccessMessage");
            }
            
            List<Order> orders = OrderDAO.getOrdersByUserId(loggedInUser.getId());
            
            if (orders == null) {
                orders = new ArrayList<>();
                System.err.println("⚠ OrderDAO.getOrdersByUserId() null döndü");
            }
            
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/my-orders.jsp").forward(request, response);
            
        } catch (NullPointerException e) {
            System.err.println("❌ NullPointerException - OrderServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Veri işleme hatası: Eksik veya boş veri");
            request.setAttribute("orders", new ArrayList<>());
            try {
                request.getRequestDispatcher("/WEB-INF/views/my-orders.jsp").forward(request, response);
            } catch (Exception forwardEx) {
                System.err.println("Forward hatası: " + forwardEx.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, forwardEx.getMessage());
            }
        } catch (Exception e) {
            System.err.println("❌ Genel Hata - OrderServlet.doGet: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Bir hata oluştu: " + e.getMessage());
            request.setAttribute("orders", new ArrayList<>());
            try {
                request.getRequestDispatcher("/WEB-INF/views/my-orders.jsp").forward(request, response);
            } catch (Exception forwardEx) {
                System.err.println("Forward hatası: " + forwardEx.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, forwardEx.getMessage());
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            if (loggedInUser == null || loggedInUser.getId() <= 0) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                request.setAttribute("errorMessage", "Sepetiniz boş. Sipariş oluşturulamaz.");
                request.setAttribute("cart", new ArrayList<>());
                request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
                return;
            }
            
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (CartItem item : cart) {
                if (item.getSubtotal() != null) {
                    totalAmount = totalAmount.add(item.getSubtotal());
                }
            }
            
            if (totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("errorMessage", "Sipariş tutarı geçersiz. Lütfen sepetinizi kontrol edin.");
                request.setAttribute("cart", cart);
                request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
                return;
            }
            
            Order order = new Order(loggedInUser.getId(), totalAmount, "Beklemede");
            order.setOrderDate(LocalDateTime.now());
            
            int orderId = OrderDAO.createOrder(order, cart);
            
            if (orderId == -1) {
                System.err.println("❌ Sipariş oluşturma başarısız - OrderServlet");
                request.setAttribute("errorMessage", "Sipariş oluşturulamadı! Lütfen tekrar deneyin.");
                request.setAttribute("cart", cart);
                request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
                return;
            }
            
            session.removeAttribute("cart");
            session.setAttribute("orderSuccessMessage",
                "Siparişiniz başarıyla oluşturuldu! Sipariş numaranız: #" + orderId);
            response.sendRedirect(request.getContextPath() + "/order");
            
        } catch (NumberFormatException e) {
            System.err.println("❌ NumberFormatException - OrderServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Geçersiz sayısal değer: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        } catch (NullPointerException e) {
            System.err.println("❌ NullPointerException - OrderServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Veri işleme hatası: Eksik veya boş veri");
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("❌ Genel Hata - OrderServlet.doPost: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Sipariş oluşturulurken hata oluştu: " + e.getMessage());
            try {
                request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
            } catch (Exception forwardEx) {
                System.err.println("Forward hatası: " + forwardEx.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, forwardEx.getMessage());
            }
        }
    }
}
