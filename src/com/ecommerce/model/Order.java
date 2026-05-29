package com.ecommerce.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 * Sipariş (Order) Model Sınıfı
 * Veritabanı tablosu: orders
 */
public class Order {
    
    private int id;
    private int userId;
    private LocalDateTime orderDate;
    private BigDecimal totalAmount;
    private String status; // "Beklemede", "Hazırlanıyor", "Kargoya Verildi", "Teslim Edildi", "İptal Edildi"
    private LocalDateTime createdAt;
    
    // Boş Constructor
    public Order() {
    }
    
    // Dolu Constructor (Ekleme için - ID olmadan)
    public Order(int userId, BigDecimal totalAmount, String status) {
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.status = status != null ? status : "Beklemede";
        this.orderDate = LocalDateTime.now();
    }
    
    // Dolu Constructor (Veritabanından - ID ile)
    public Order(int id, int userId, LocalDateTime orderDate, BigDecimal totalAmount, String status, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    // Getters
    public int getId() {
        return id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public LocalDateTime getOrderDate() {
        return orderDate;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public Date getOrderDateAsDate() {
        if (orderDate == null) {
            return null;
        }
        return Date.from(orderDate.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    // Setters
    public void setId(int id) {
        this.id = id;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    // toString() Metodu
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", orderDate=" + orderDate +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
    
    /**
     * Sipariş durumunun geçerli olup olmadığını kontrol eder
     */
    public boolean isValidStatus() {
        return status != null && 
               (status.equals("Beklemede") || 
                status.equals("Hazırlanıyor") || 
                status.equals("Kargoya Verildi") || 
                status.equals("Teslim Edildi") || 
                status.equals("İptal Edildi"));
    }
}
