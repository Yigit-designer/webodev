package com.ecommerce.controller;

import com.ecommerce.model.User;
import com.ecommerce.model.Category;
import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * AdminCategoryServlet - Kategori Yönetimi
 * Kategorilerin CRUD operasyonlarını yönetir
 */
@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    
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
            editCategoryForm(request, response);
        } else if ("add".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(request, response);
        } else {
            listCategories(request, response);
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
                addCategory(request, response);
                break;
            case "update":
                updateCategory(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
    
    /**
     * Tüm kategorileri listeler
     */
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Category> categories = CategoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
    }
    
    /**
     * Kategoriyi düzenleme formunu gösterir
     */
    private void editCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdParam = request.getParameter("categoryId");
        
        if (categoryIdParam == null || categoryIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        try {
            int categoryId = Integer.parseInt(categoryIdParam);
            Category category = CategoryDAO.getCategoryById(categoryId);
            
            request.setAttribute("category", category);
            request.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
    
    /**
     * Yeni kategori ekler
     */
    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        // Validasyon
        if (name == null || name.isEmpty()) {
            request.setAttribute("errorMessage", "Kategori adı gereklidir!");
            listCategories(request, response);
            return;
        }
        
        Category category = new Category(name, description, true);
        
        if (CategoryDAO.addCategory(category)) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        } else {
            request.setAttribute("errorMessage", "Kategori eklenemedi!");
            listCategories(request, response);
        }
    }
    
    /**
     * Kategoriyi günceller
     */
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdParam = request.getParameter("categoryId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        // Validasyon
        if (categoryIdParam == null || name == null || name.isEmpty()) {
            request.setAttribute("errorMessage", "Kategori adı gereklidir!");
            listCategories(request, response);
            return;
        }
        
        try {
            int categoryId = Integer.parseInt(categoryIdParam);
            Category category = new Category(categoryId, name, description, true, null);
            
            if (CategoryDAO.updateCategory(category)) {
                response.sendRedirect(request.getContextPath() + "/admin/categories");
            } else {
                request.setAttribute("errorMessage", "Kategori güncellenemedi!");
                listCategories(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
    
    /**
     * Kategoriyi siler (is_active = false yapar)
     */
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryIdParam = request.getParameter("categoryId");
        
        if (categoryIdParam == null || categoryIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        try {
            int categoryId = Integer.parseInt(categoryIdParam);
            CategoryDAO.deleteCategory(categoryId);
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
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
