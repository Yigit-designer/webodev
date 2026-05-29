package com.ecommerce.model;

import java.math.BigDecimal;

/**
 * Sipariş Öğesi (OrderItem) Model Sınıfı
 * Veritabanı tablosu: order_items
 */
public class OrderItem {
    
    private int id;
    private int orderId;
    private int productId;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal subtotal;
    
    // Boş Constructor
    public OrderItem() {
    }
    
    // Dolu Constructor (Ekleme için - ID olmadan)
    public OrderItem(int orderId, int productId, int quantity, BigDecimal unitPrice, BigDecimal subtotal) {
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }
    
    // Dolu Constructor (Veritabanından - ID ile)
    public OrderItem(int id, int orderId, int productId, int quantity, BigDecimal unitPrice, BigDecimal subtotal) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }
    
    // Getters
    public int getId() {
        return id;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public BigDecimal getSubtotal() {
        return subtotal;
    }
    
    // Setters
    public void setId(int id) {
        this.id = id;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
    
    // toString() Metodu
    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", productId=" + productId +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", subtotal=" + subtotal +
                '}';
    }
    
    /**
     * Alt toplam tutarını hesaplar ve günceller
     */
    public void calculateSubtotal() {
        if (this.unitPrice != null) {
            this.subtotal = this.unitPrice.multiply(BigDecimal.valueOf(this.quantity));
        }
    }
}
