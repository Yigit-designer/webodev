package com.ecommerce.model;

import java.time.LocalDateTime;

/**
 * Kategori (Category) Model Sınıfı
 * Veritabanı tablosu: categories
 */
public class Category {
    
    private int id;
    private String name;
    private String description;
    private boolean isActive;
    private LocalDateTime createdAt;
    
    // Boş Constructor
    public Category() {
    }
    
    // Dolu Constructor (Ekleme için - ID olmadan)
    public Category(String name, String description, boolean isActive) {
        this.name = name;
        this.description = description;
        this.isActive = isActive;
    }
    
    // Dolu Constructor (Veritabanından - ID ile)
    public Category(int id, String name, String description, boolean isActive, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }
    
    // Getters
    public int getId() {
        return id;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDescription() {
        return description;
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
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setDescription(String description) {
        this.description = description;
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
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }
}
