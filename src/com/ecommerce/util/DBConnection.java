package com.ecommerce.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Veritabanı Bağlantı Sınıfı
 * PostgreSQL ile bağlantı yönetimi sağlar.
 */
public class DBConnection {
    
    // PostgreSQL JDBC Sürücüsü
    private static final String DRIVER = "org.postgresql.Driver";
    
    // Veritabanı Bağlantı Bilgileri (UTF-8 karakter seti ile)
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/ecommerce_db?charSet=UTF8";
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "101909";
    
    static {
        try {
            // PostgreSQL sürücüsünü yükle
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Sürücüsü bulunamadı!");
            e.printStackTrace();
        }
    }
    
    /**
     * Veritabanı bağlantısı oluşturur
     * 
     * @return Veritabanı bağlantısı
     * @throws SQLException Bağlantı hatası durumunda
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Veritabanı bağlantısı başarılı!");
            return connection;
        } catch (SQLException e) {
            System.err.println("Veritabanı bağlantı hatası: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Veritabanı bağlantısını kapatır
     * 
     * @param connection Kapatılacak bağlantı
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Veritabanı bağlantısı kapatıldı.");
            } catch (SQLException e) {
                System.err.println("Bağlantı kapatma hatası: " + e.getMessage());
            }
        }
    }
    
    /**
     * Bağlantı testini gerçekleştirir (Debug amaçlı)
     */
    public static void testConnection() {
        Connection connection = null;
        try {
            connection = getConnection();
            if (connection != null && !connection.isClosed()) {
                System.out.println("✓ Veritabanı bağlantısı başarılı!");
            }
        } catch (SQLException e) {
            System.err.println("✗ Bağlantı hatası: " + e.getMessage());
        } finally {
            closeConnection(connection);
        }
    }
}
