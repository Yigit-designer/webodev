package com.ecommerce.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Ürün (Product) Model Sınıfı
 * Veritabanı tablosu: products
 */
public class Product {
    
    private int id;
    private int categoryId;
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private String imageUrl;
    private boolean isActive;
    private LocalDateTime createdAt;
    
    // Boş Constructor
    public Product() {
    }
    
    // Dolu Constructor (Ekleme için - ID olmadan)
    public Product(int categoryId, String name, String description, BigDecimal price, int stock, String imageUrl, boolean isActive) {
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
    }
    
    // Dolu Constructor (Veritabanından - ID ile)
    public Product(int id, int categoryId, String name, String description, BigDecimal price, int stock, String imageUrl, boolean isActive, LocalDateTime createdAt) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }
    
    // Getters
    public int getId() {
        return id;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public int getStock() {
        return stock;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    // Setters
    public void setId(int id) {
        this.id = id;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    // toString() Metodu
    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", categoryId=" + categoryId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", imageUrl='" + imageUrl + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
    
    /**
     * Ürünün stokta olup olmadığını kontrol eder
     */
    public boolean isInStock() {
        return this.stock > 0;
    }
}
