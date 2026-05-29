package com.ecommerce.dao;

import com.ecommerce.model.User;
import com.ecommerce.util.DBConnection;
import com.ecommerce.util.PasswordUtil;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO - Kullanıcı işlemleri
 * CRUD operasyonları ve kimlik doğrulama işlemlerini yönetir
 */
public class UserDAO {
    
    /**
     * Yeni kullanıcı kaydı oluşturur
     * 
     * @param user Kaydedilecek kullanıcı nesnesi
     * @return true başarılı, false başarısız
     */
    public static boolean registerUser(User user) {
        if (user == null) {
            System.err.println("❌ registerUser hatası: User nesnesi null");
            return false;
        }
        
        String sql = "INSERT INTO users (full_name, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("❌ registerUser hatası: Veritabanı bağlantısı null");
                return false;
            }
            
            conn.setAutoCommit(false); // Transaction başlat

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, PasswordUtil.hashPassword(user.getPassword()));
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole() != null ? user.getRole() : "customer");

            int rowsInserted = pstmt.executeUpdate();
            
            if (rowsInserted > 0) {
                conn.commit(); // Başarılı ise commit
                System.out.println("✓ Kullanıcı başarıyla kaydedildi: " + user.getEmail());
                return true;
            } else {
                conn.rollback();
                System.err.println("❌ Kullanıcı kaydı başarısız - hiçbir satır eklenmedi");
                return false;
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("✓ Rollback başarılı");
                } catch (SQLException ex) {
                    System.err.println("❌ Rollback hatası: " + ex.getMessage());
                }
            }
            System.err.println("❌ Kayıt işlemi hatası: " + e.getMessage());
            if (e.getMessage() != null && e.getMessage().contains("unique constraint")) {
                System.err.println("   Sebep: Bu e-posta adresi zaten kayıtlı");
            }
            e.printStackTrace();
            return false;

        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException ignored) {}
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                    System.out.println("✓ Bağlantı kapatıldı");
                } catch (SQLException ignored) {}
            }
        }
    }
    
    /**
     * Kullanıcı giriş yapar
     * Email ve şifre ile kullanıcıyı doğrular
     * 
     * @param email Kullanıcı e-posta
     * @param password Kullanıcı şifre
     * @return User nesnesi (başarılı) veya null (başarısız)
     */
    public static User loginUser(String email, String password) {
        String sql = "SELECT id, full_name, email, password, phone, address, role, created_at FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    if (!PasswordUtil.verifyPassword(password, storedHash)) {
                        return null;
                    }
                    Timestamp createdAtTs = rs.getTimestamp("created_at");
                    return new User(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        storedHash,
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("role"),
                        createdAtTs != null ? createdAtTs.toLocalDateTime() : null
                    );
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Giriş işlemi hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Tüm kullanıcıları getirir (admin paneli listeleme)
     */
    public static List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, full_name, email, phone, role, created_at FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Timestamp createdAtTs = rs.getTimestamp("created_at");
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    null,
                    rs.getString("phone"),
                    null,
                    rs.getString("role"),
                    createdAtTs != null ? createdAtTs.toLocalDateTime() : null
                );
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Kullanıcı listesi getirme hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Email adresine göre kullanıcı bulur
     * 
     * @param email Kullanıcı e-posta
     * @return User nesnesi (başarılı) veya null (başarısız)
     */
    public static User getUserByEmail(String email) {
        String sql = "SELECT id, full_name, email, password, phone, address, role, created_at FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Timestamp createdAtTs = rs.getTimestamp("created_at");
                    return new User(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("role"),
                        createdAtTs != null ? createdAtTs.toLocalDateTime() : null
                    );
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Email ile arama hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * ID'ye göre kullanıcı bulur
     * 
     * @param userId Kullanıcı ID'si
     * @return User nesnesi (başarılı) veya null (başarısız)
     */
    public static User getUserById(int userId) {
        String sql = "SELECT id, full_name, email, password, phone, address, role, created_at FROM users WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Timestamp createdAtTs = rs.getTimestamp("created_at");
                    return new User(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("role"),
                        createdAtTs != null ? createdAtTs.toLocalDateTime() : null
                    );
                }
            }
            
        } catch (SQLException e) {
            System.err.println("ID ile arama hatası: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Kullanıcı bilgisini günceller
     * 
     * @param user Güncellenecek kullanıcı nesnesi
     * @return true başarılı, false başarısız
     */
    public static boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, address = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getAddress());
            pstmt.setInt(5, user.getId());
            
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("Güncelleme hatası: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
