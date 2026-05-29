package com.ecommerce.controller;

import com.ecommerce.model.Product;
import com.ecommerce.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * ProductServlet - Ürün Detay Sayfası
 * Ürün detaylarını gösterir
 */
@WebServlet("/product")
public class ProductServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // URL'den id parametresini al
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            // ID yoksa ana sayfaya yönlendir
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        try {
            int productId = Integer.parseInt(idParam);
            Product product = ProductDAO.getProductById(productId);
            
            if (product == null || !product.isActive()) {
                // Ürün bulunamazsa ana sayfaya yönlendir
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            // Ürünü request attribute olarak ekle
            request.setAttribute("product", product);
            
            // Ürün detay sayfasına yönlendir
            request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            // Hata durumunda ana sayfaya yönlendir
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
