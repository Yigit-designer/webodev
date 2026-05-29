package com.ecommerce.dao;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.CartItem;
import com.ecommerce.util.DBConnection;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderDAO - Sipariş işlemleri
 * Sipariş oluşturma, listeleme ve durum güncelleme işlemlerini yönetir
 * ÖNEMLI: Transaction yönetimi ile veri bütünlüğünü sağlar
 */
public class OrderDAO {
    
    /**
     * Yeni sipariş oluşturur (Transaction ile güvenli)
     * ÖNEMLI: Bu metot transaction yönetimi içerir:
     * 1. Order tablosuna veri ekler
     * 2. OrderItems tablosuna kayıtlar ekler
     * 3. Ürün stokları düşürür
     * 4. Hata durumunda ROLLBACK yapar
     * 
     * @param order Oluşturulacak sipariş
     * @param cartItems Sepet öğeleri
     * @return Oluşturulan sipariş ID'si (başarılı) veya -1 (başarısız)
     */
    public static int createOrder(Order order, List<CartItem> cartItems) {
        String insertOrderSQL = "INSERT INTO orders (user_id, order_date, total_amount, status) VALUES (?, ?, ?, ?) RETURNING id";
        String insertOrderItemSQL = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
        String updateStockSQL = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
        
        Connection conn = null;
        int orderId = -1;
        boolean committed = false;
        
        try {
            conn = DBConnection.getConnection();
            
            // AUTO_COMMIT'i kapat - Transaction başlat
            conn.setAutoCommit(false);
            
            // 1. Order tablosuna sipariş ekle
            try (PreparedStatement pstmt = conn.prepareStatement(insertOrderSQL)) {
                pstmt.setInt(1, order.getUserId());
                pstmt.setTimestamp(2, Timestamp.valueOf(order.getOrderDate()));
                pstmt.setBigDecimal(3, order.getTotalAmount());
                pstmt.setString(4, order.getStatus());
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        orderId = rs.getInt("id");
                    }
                }
            }
            
            if (orderId == -1) {
                conn.rollback();
                System.err.println("Sipariş ID getirilemedi!");
                return -1;
            }
            
            // 2. OrderItems tablosuna detayları ekle
            try (PreparedStatement pstmt = conn.prepareStatement(insertOrderItemSQL)) {
                for (CartItem cartItem : cartItems) {
                    pstmt.setInt(1, orderId);
                    pstmt.setInt(2, cartItem.getProductId());
                    pstmt.setInt(3, cartItem.getQuantity());
                    pstmt.setBigDecimal(4, cartItem.getProductPrice());
                    pstmt.setBigDecimal(5, cartItem.getSubtotal());
                    
                    pstmt.addBatch();
                }
                pstmt.executeBatch();
            }
            
            // 3. Ürün stoklarını AYNI transaction içinde düş
            try (PreparedStatement stockStmt = conn.prepareStatement(updateStockSQL)) {
                for (CartItem cartItem : cartItems) {
                    stockStmt.setInt(1, cartItem.getQuantity());
                    stockStmt.setInt(2, cartItem.getProductId());
                    stockStmt.setInt(3, cartItem.getQuantity());

                    int rowsUpdated = stockStmt.executeUpdate();
                    if (rowsUpdated == 0) {
                        throw new SQLException("Ürün stoku yetersiz veya ürün bulunamadı: Product ID " + cartItem.getProductId());
                    }
                }
            }
            
            // Tüm işlemler başarılı - COMMIT
            conn.commit();
            committed = true;
            System.out.println("✓ Sipariş başarıyla oluşturuldu. Sipariş ID: " + orderId);
            return orderId;
            
        } catch (SQLException e) {
            // Hata durumunda ROLLBACK
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("✗ Transaction rollback yapıldı!");
                } catch (SQLException rollbackException) {
                    System.err.println("Rollback hatası: " + rollbackException.getMessage());
                }
            }
            System.err.println("Sipariş oluşturma hatası: " + e.getMessage());
            e.printStackTrace();
            return -1;
            
        } finally {
            if (conn != null) {
                try {
                    if (!committed) {
                        conn.rollback();
                    }
                    // AUTO_COMMIT'i yeniden aç
                    conn.setAutoCommit(true);
                    DBConnection.closeConnection(conn);
                } catch (SQLException e) {
                    System.err.println("Bağlantı kapatma hatası: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * Belirli bir kullanıcının tüm siparişlerini getirir
     * 
     * @param userId Kullanıcı ID'si
     * @return Siparişlerin listesi (null yerine boş liste)
     */
    public static List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT id, user_id, order_date, total_amount, status, created_at FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            if (conn == null) {
                System.err.println("❌ getOrdersByUserId: Veritabanı bağlantısı null");
                return orders;
            }
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    if (order != null) {
                        orders.add(order);
                    }
                }
            }
            System.out.println("✓ " + orders.size() + " sipariş getirildi (User ID: " + userId + ")");
            
        } catch (SQLException e) {
            System.err.println("❌ Kullanıcı siparişleri getirme hatası (User ID: " + userId + "): " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Tüm siparişleri getirir (Admin için)
     * 
     * @return Tüm siparişlerin listesi (null yerine boş liste)
     */
    public static List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT id, user_id, order_date, total_amount, status, created_at FROM orders ORDER BY order_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (conn == null) {
                System.err.println("❌ getAllOrders: Veritabanı bağlantısı null");
                return orders;
            }
            
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                if (order != null) {
                    orders.add(order);
                }
            }
            System.out.println("✓ Toplam " + orders.size() + " sipariş getirildi");
            
        } catch (SQLException e) {
            System.err.println("❌ Tüm siparişleri getirme hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Belirli bir siparişin detaylarını getirir
     * 
     * @param orderId Sipariş ID'si
     * @return Order nesnesi (başarılı) veya null (başarısız)
     */
    public static Order getOrderById(int orderId) {
        String sql = "SELECT id, user_id, order_date, total_amount, status, created_at FROM orders WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Sipariş ID ile arama hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Sipariş durumunu günceller
     * 
     * @param orderId Sipariş ID'si
     * @param status Yeni durum
     * @return true başarılı, false başarısız
     */
    public static boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, orderId);
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Sipariş durumu güncelleme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Belirli bir siparışın tüm öğelerini getirir
     * 
     * @param orderId Sipariş ID'si
     * @return Sipariş öğelerinin listesi
     */
    public static List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT id, order_id, product_id, quantity, unit_price, subtotal FROM order_items WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, orderId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    orderItems.add(mapResultSetToOrderItem(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Sipariş öğeleri getirme hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return orderItems;
    }
    
    /**
     * ResultSet'i Order nesnesine dönüştürür
     */
    private static Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Timestamp orderTs = rs.getTimestamp("order_date");
        Timestamp createdTs = rs.getTimestamp("created_at");
        return new Order(
            rs.getInt("id"),
            rs.getInt("user_id"),
            orderTs != null ? orderTs.toLocalDateTime() : null,
            rs.getBigDecimal("total_amount"),
            rs.getString("status"),
            createdTs != null ? createdTs.toLocalDateTime() : null
        );
    }
    
    /**
     * ResultSet'i OrderItem nesnesine dönüştürür
     */
    private static OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        return new OrderItem(
            rs.getInt("id"),
            rs.getInt("order_id"),
            rs.getInt("product_id"),
            rs.getInt("quantity"),
            rs.getBigDecimal("unit_price"),
            rs.getBigDecimal("subtotal")
        );
    }
}
