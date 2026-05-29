package com.ecommerce.dao;

import com.ecommerce.model.Product;
import com.ecommerce.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductDAO - Ürün işlemleri
 * Ürünlerin CRUD operasyonlarını ve stok yönetimini sağlar
 */
public class ProductDAO {
    
    /**
     * Tüm aktif ürünleri getirir
     * 
     * @return Aktif ürün listesi
     */
    public static List<Product> getAllActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, name, description, price, stock, image_url, is_active, created_at FROM products WHERE is_active = true ORDER BY name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Aktif ürünler getirme hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * Kategori ID'ye göre aktif ürünleri getirir
     * 
     * @param categoryId Kategori ID'si
     * @return Kategori içindeki ürün listesi
     */
    public static List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, category_id, name, description, price, stock, image_url, is_active, created_at FROM products WHERE category_id = ? AND is_active = true ORDER BY name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Kategoriye göre ürünler getirme hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * ID'ye göre ürün bulur
     * 
     * @param productId Ürün ID'si
     * @return Product nesnesi (başarılı) veya null (başarısız)
     */
    public static Product getProductById(int productId) {
        String sql = "SELECT id, category_id, name, description, price, stock, image_url, is_active, created_at FROM products WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Ürün ID ile arama hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Yeni ürün ekler
     * 
     * @param product Eklenecek ürün nesnesi
     * @return true başarılı, false başarısız
     */
    public static boolean addProduct(Product product) {
        String sql = "INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, product.getCategoryId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getDescription());
            pstmt.setBigDecimal(4, product.getPrice());
            pstmt.setInt(5, product.getStock());
            pstmt.setString(6, product.getImageUrl());
            pstmt.setBoolean(7, product.isActive());
            
            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            System.err.println("Ürün ekleme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Ürün bilgisini günceller
     * 
     * @param product Güncellenecek ürün nesnesi
     * @return true başarılı, false başarısız
     */
    public static boolean updateProduct(Product product) {
        String sql = "UPDATE products SET category_id = ?, name = ?, description = ?, price = ?, stock = ?, image_url = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, product.getCategoryId());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getDescription());
            pstmt.setBigDecimal(4, product.getPrice());
            pstmt.setInt(5, product.getStock());
            pstmt.setString(6, product.getImageUrl());
            pstmt.setBoolean(7, product.isActive());
            pstmt.setInt(8, product.getId());
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Ürün güncelleme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Ürünü siler (gerçekten silmez, is_active = false yapar)
     * 
     * @param productId Silinecek ürün ID'si
     * @return true başarılı, false başarısız
     */
    public static boolean deleteProduct(int productId) {
        String sql = "UPDATE products SET is_active = false WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Ürün silme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Ürün stokunu günceller
     * Sipariş oluşturulduğunda çağrılır
     * 
     * @param productId Ürün ID'si
     * @param quantity Düşülecek stok miktarı
     * @return true başarılı, false başarısız
     */
    public static boolean updateStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Stok güncelleme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Anahtar kelimeye göre aktif ürünleri arar (PostgreSQL ILIKE)
     */
    public static List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllActiveProducts();
        }
        
        String sql = "SELECT id, category_id, name, description, price, stock, image_url, is_active, created_at "
                   + "FROM products WHERE is_active = true AND (name ILIKE ? OR description ILIKE ?) "
                   + "ORDER BY name ASC";
        String searchPattern = "%" + keyword.trim() + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Ürün arama hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return products;
    }
    
    /**
     * ResultSet'i Product nesnesine dönüştürür
     */
    private static Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        return new Product(
            rs.getInt("id"),
            rs.getInt("category_id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getBigDecimal("price"),
            rs.getInt("stock"),
            rs.getString("image_url"),
            rs.getBoolean("is_active"),
            rs.getTimestamp("created_at").toLocalDateTime()
        );
    }
}
