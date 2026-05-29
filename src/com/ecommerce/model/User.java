package com.ecommerce.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 * Kullanıcı (User) Model Sınıfı
 * Veritabanı tablosu: users
 */
public class User {
    
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String role; // "customer" veya "admin"
    private LocalDateTime createdAt;
    
    // Boş Constructor
    public User() {
    }
    
    // Dolu Constructor (Kayıt için - ID olmadan)
    public User(String fullName, String email, String password, String phone, String address, String role) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.address = address;
        this.role = role;
    }
    
    // Dolu Constructor (Veritabanından - ID ile)
    public User(int id, String fullName, String email, String password, String phone, String address, String role, LocalDateTime createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.address = address;
        this.role = role;
        this.createdAt = createdAt;
    }
    
    // Getters
    public int getId() {
        return id;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public String getRole() {
        return role;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public Date getCreatedAtAsDate() {
        if (createdAt == null) {
            return null;
        }
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }
    
    // Setters
    public void setId(int id) {
        this.id = id;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    // toString() Metodu
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", password='***'" +
                ", phone='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", role='" + role + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
    
    /**
     * Kullanıcının admin olup olmadığını kontrol eder
     */
    public boolean isAdmin() {
        return "admin".equals(this.role);
    }
}
