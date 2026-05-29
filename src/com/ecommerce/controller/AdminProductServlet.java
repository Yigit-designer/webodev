package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.model.Product;
import com.ecommerce.model.Category;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * AdminProductServlet - Ürün Yönetimi
 * Ürünlerin CRUD operasyonlarını yönetir
 */
@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Admin kontrolü
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            editProductForm(request, response);
        } else if ("add".equals(action)) {
            showProductForm(request, response, null);
        } else {
            listProducts(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Admin kontrolü
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    /**
     * Tüm ürünleri listeler
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Product> products = ProductDAO.getAllActiveProducts();
        List<Category> categories = CategoryDAO.getAllCategories();
        
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }
    
    /**
     * Ürün ekleme/düzenleme formunu gösterir
     */
    private void showProductForm(HttpServletRequest request, HttpServletResponse response, Product product)
            throws ServletException, IOException {
        List<Category> categories = CategoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        if (product != null) {
            request.setAttribute("product", product);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(request, response);
    }
    
    /**
     * Ürünü düzenleme formunu gösterir
     */
    private void editProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productIdParam = request.getParameter("productId");
        
        if (productIdParam == null || productIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            Product product = ProductDAO.getProductById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }
            showProductForm(request, response, product);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    /**
     * Yeni ürün ekler (Sunucu tarafı validasyonu ile)
     */
    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdParam = request.getParameter("categoryId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceParam = request.getParameter("price");
        String stockParam = request.getParameter("stock");
        String imageUrl = request.getParameter("imageUrl");
        
        // Validasyon
        String errorMessage = validateProduct(categoryIdParam, name, priceParam, stockParam);
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            listProducts(request, response);
            return;
        }
        
        try {
            int categoryId = Integer.parseInt(categoryIdParam);
            BigDecimal price = new BigDecimal(priceParam);
            int stock = Integer.parseInt(stockParam);
            
            Product product = new Product(categoryId, name, description, price, stock, imageUrl, true);
            
            if (ProductDAO.addProduct(product)) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                request.setAttribute("errorMessage", "Ürün eklenemedi!");
                listProducts(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Geçersiz format!");
            listProducts(request, response);
        }
    }
    
    /**
     * Ürünü günceller (Sunucu tarafı validasyonu ile)
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productIdParam = request.getParameter("productId");
        String categoryIdParam = request.getParameter("categoryId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceParam = request.getParameter("price");
        String stockParam = request.getParameter("stock");
        String imageUrl = request.getParameter("imageUrl");
        
        // Validasyon
        String errorMessage = validateProduct(categoryIdParam, name, priceParam, stockParam);
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            listProducts(request, response);
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            int categoryId = Integer.parseInt(categoryIdParam);
            BigDecimal price = new BigDecimal(priceParam);
            int stock = Integer.parseInt(stockParam);
            
            Product product = new Product(productId, categoryId, name, description, price, stock, imageUrl, true, null);
            
            if (ProductDAO.updateProduct(product)) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else {
                request.setAttribute("errorMessage", "Ürün güncellenemedi!");
                listProducts(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Geçersiz format!");
            listProducts(request, response);
        }
    }
    
    /**
     * Ürünü siler (is_active = false yapar)
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String productIdParam = request.getParameter("productId");
        
        if (productIdParam == null || productIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            ProductDAO.deleteProduct(productId);
            response.sendRedirect(request.getContextPath() + "/admin/products");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    /**
     * Ürün verilerini valide eder (Sunucu tarafı validasyonu)
     */
    private String validateProduct(String categoryIdParam, String name, String priceParam, String stockParam) {
        
        if (categoryIdParam == null || categoryIdParam.isEmpty()) {
            return "Kategori seçimi gereklidir!";
        }
        
        if (name == null || name.trim().isEmpty()) {
            return "Ürün adı boş olamaz!";
        }
        
        if (priceParam == null || priceParam.isEmpty()) {
            return "Fiyat gereklidir!";
        }
        
        if (stockParam == null || stockParam.isEmpty()) {
            return "Stok bilgisi gereklidir!";
        }
        
        try {
            BigDecimal price = new BigDecimal(priceParam);
            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                return "Fiyat 0'dan büyük olmalıdır!";
            }
            
            int stock = Integer.parseInt(stockParam);
            if (stock < 0) {
                return "Stok negatif olamaz!";
            }
            
        } catch (NumberFormatException e) {
            return "Geçersiz sayı formatı!";
        }
        
        return null; // Validasyon başarılı
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
