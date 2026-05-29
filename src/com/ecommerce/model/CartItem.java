package com.ecommerce.model;

import java.math.BigDecimal;

/**
 * Sepet Öğesi (CartItem) Model Sınıfı
 * Session'da tutulur, veritabanında tablosu yoktur
 * Product nesnesi ve miktar bilgisini tutar
 */
public class CartItem {
    
    private Product product;
    private int quantity;
    
    // Boş Constructor
    public CartItem() {
    }
    
    // Dolu Constructor
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }
    
    // Getters
    public Product getProduct() {
        return product;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    // Setters
    public void setProduct(Product product) {
        this.product = product;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    // İş Mantığı Metodları
    
    /**
     * Sepet öğesinin toplam fiyatını hesaplar
     */
    public BigDecimal getSubtotal() {
        if (product != null && product.getPrice() != null) {
            return product.getPrice().multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Sepet öğesinin ürün ID'sini döndürür
     */
    public int getProductId() {
        return product != null ? product.getId() : -1;
    }
    
    /**
     * Sepet öğesinin ürün adını döndürür
     */
    public String getProductName() {
        return product != null ? product.getName() : "";
    }
    
    /**
     * Sepet öğesinin ürün fiyatını döndürür
     */
    public BigDecimal getProductPrice() {
        return product != null ? product.getPrice() : BigDecimal.ZERO;
    }
    
    /**
     * Ürün stokunda yeterli miktar olup olmadığını kontrol eder
     */
    public boolean isValidQuantity() {
        return product != null && product.getStock() >= quantity;
    }
    
    /**
     * toString() Metodu
     */
    @Override
    public String toString() {
        return "CartItem{" +
                "product=" + (product != null ? product.getName() : "null") +
                ", quantity=" + quantity +
                ", subtotal=" + getSubtotal() +
                '}';
    }
}
