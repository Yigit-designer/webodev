package com.ecommerce.dao;

import com.ecommerce.model.Category;
import com.ecommerce.util.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * CategoryDAO - Kategori işlemleri
 * Kategorilerin CRUD operasyonlarını yönetir
 */
public class CategoryDAO {
    
    /**
     * Tüm kategorileri getirir (aktif ve pasif)
     * 
     * @return Kategori listesi
     */
    public static List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, description, is_active, created_at FROM categories ORDER BY name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Tüm kategoriler getirme hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    /**
     * Sadece aktif kategorileri getirir
     * 
     * @return Aktif kategori listesi
     */
    public static List<Category> getActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, description, is_active, created_at FROM categories WHERE is_active = true ORDER BY name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Aktif kategoriler getirme hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    /**
     * ID'ye göre kategori bulur
     * 
     * @param categoryId Kategori ID'si
     * @return Category nesnesi (başarılı) veya null (başarısız)
     */
    public static Category getCategoryById(int categoryId) {
        String sql = "SELECT id, name, description, is_active, created_at FROM categories WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Kategori ID ile arama hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Yeni kategori ekler
     * 
     * @param category Eklenecek kategori nesnesi
     * @return true başarılı, false başarısız
     */
    public static boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (name, description, is_active) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setBoolean(3, category.isActive());
            
            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            System.err.println("Kategori ekleme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kategori bilgisini günceller
     * 
     * @param category Güncellenecek kategori nesnesi
     * @return true başarılı, false başarısız
     */
    public static boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET name = ?, description = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setBoolean(3, category.isActive());
            pstmt.setInt(4, category.getId());
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Kategori güncelleme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kategoriyi siler (gerçekten silmez, is_active = false yapar)
     * Bağlı ürünü olan kategoriler silinmez, sadece pasif duruma çekilir
     * 
     * @param categoryId Silinecek kategori ID'si
     * @return true başarılı, false başarısız
     */
    public static boolean deleteCategory(int categoryId) {
        String sql = "UPDATE categories SET is_active = false WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, categoryId);
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Kategori silme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * ResultSet'i Category nesnesine dönüştürür
     */
    private static Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        return new Category(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getBoolean("is_active"),
            rs.getTimestamp("created_at").toLocalDateTime()
        );
    }
}
