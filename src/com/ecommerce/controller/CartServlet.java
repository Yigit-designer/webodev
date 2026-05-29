package com.ecommerce.controller;

import com.ecommerce.model.CartItem;
import com.ecommerce.model.Product;
import com.ecommerce.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * CartServlet - Sepet Yönetimi
 * Sepete ürün ekleme, çıkarma ve güncelleme işlemlerini yönetir
 * Session'da List<CartItem> nesnesini "cart" adıyla tutar
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }
        
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        HttpSession session = request.getSession();
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }
        
        boolean hasError = false;
        switch (action) {
            case "add":
                hasError = !addToCart(request, cart);
                break;
            case "update":
                hasError = !updateCart(request, cart);
                break;
            case "remove":
                removeFromCart(request, cart);
                break;
            default:
                break;
        }
        
        session.setAttribute("cart", cart);
        
        if (hasError) {
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/cart");
    }
    
    /**
     * Sepete ürün ekler veya var olan ürünün miktarını artırır
     * @return true başarılı, false stok/validasyon hatası
     */
    private boolean addToCart(HttpServletRequest request, List<CartItem> cart) {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        
        if (productIdParam == null || quantityParam == null) {
            request.setAttribute("errorMessage", "Geçersiz ürün veya adet bilgisi.");
            return false;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            int quantity = Integer.parseInt(quantityParam);
            
            if (quantity <= 0) {
                request.setAttribute("errorMessage", "Adet 0'dan büyük olmalıdır.");
                return false;
            }
            
            Product product = ProductDAO.getProductById(productId);
            
            if (product == null || !product.isActive()) {
                request.setAttribute("errorMessage", "Ürün bulunamadı veya satışta değil.");
                return false;
            }
            
            int existingQty = 0;
            for (CartItem item : cart) {
                if (item.getProductId() == productId) {
                    existingQty = item.getQuantity();
                    break;
                }
            }
            
            int requestedTotal = existingQty + quantity;
            if (requestedTotal > product.getStock()) {
                request.setAttribute("errorMessage",
                    "Stok yetersiz! \"" + product.getName() + "\" için en fazla " + product.getStock() + " adet ekleyebilirsiniz.");
                return false;
            }
            
            CartItem existingItem = null;
            for (CartItem item : cart) {
                if (item.getProductId() == productId) {
                    existingItem = item;
                    break;
                }
            }
            
            if (existingItem != null) {
                existingItem.setQuantity(requestedTotal);
                existingItem.setProduct(product);
            } else {
                cart.add(new CartItem(product, quantity));
            }
            
            return true;
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Geçersiz sayı formatı.");
            return false;
        }
    }
    
    /**
     * Sepetteki ürünün miktarını günceller
     * @return true başarılı, false stok/validasyon hatası
     */
    private boolean updateCart(HttpServletRequest request, List<CartItem> cart) {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        
        if (productIdParam == null || quantityParam == null) {
            request.setAttribute("errorMessage", "Geçersiz ürün veya adet bilgisi.");
            return false;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            int newQuantity = Integer.parseInt(quantityParam);
            
            if (newQuantity <= 0) {
                removeFromCart(request, cart);
                return true;
            }
            
            Product product = ProductDAO.getProductById(productId);
            if (product == null || !product.isActive()) {
                request.setAttribute("errorMessage", "Ürün bulunamadı veya satışta değil.");
                return false;
            }
            
            if (newQuantity > product.getStock()) {
                request.setAttribute("errorMessage",
                    "Stok yetersiz! \"" + product.getName() + "\" için en fazla " + product.getStock() + " adet seçebilirsiniz.");
                return false;
            }
            
            for (CartItem item : cart) {
                if (item.getProductId() == productId) {
                    item.setQuantity(newQuantity);
                    item.setProduct(product);
                    return true;
                }
            }
            
            request.setAttribute("errorMessage", "Ürün sepette bulunamadı.");
            return false;
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Geçersiz sayı formatı.");
            return false;
        }
    }
    
    /**
     * Sepetten ürünü çıkarır
     */
    private void removeFromCart(HttpServletRequest request, List<CartItem> cart) {
        String productIdParam = request.getParameter("productId");
        
        if (productIdParam == null) {
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            cart.removeIf(item -> item.getProductId() == productId);
        } catch (NumberFormatException e) {
            System.err.println("Sayı dönüştürme hatası: " + e.getMessage());
        }
    }
}
