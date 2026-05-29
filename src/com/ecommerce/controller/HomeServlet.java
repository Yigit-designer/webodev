package com.ecommerce.controller;

import com.ecommerce.model.Category;
import com.ecommerce.model.Product;
import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * HomeServlet - Ana Sayfa
 * Kategorileri ve ürünleri listeler, kategori filtreleme yapar
 */
@WebServlet({"", "/", "/home"})
public class HomeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdParam = request.getParameter("categoryId");
        String searchParam = request.getParameter("search");
        
        List<Category> categories = CategoryDAO.getActiveCategories();
        request.setAttribute("categories", categories);
        
        List<Product> products;
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            products = ProductDAO.searchProducts(searchParam.trim());
            request.setAttribute("searchKeyword", searchParam.trim());
        } else if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdParam);
                products = ProductDAO.getProductsByCategory(categoryId);
            } catch (NumberFormatException e) {
                products = ProductDAO.getAllActiveProducts();
            }
        } else {
            products = ProductDAO.getAllActiveProducts();
        }
        
        request.setAttribute("products", products);
        
        // JSP sayfasına yönlendir
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}
