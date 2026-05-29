-- PostgreSQL E-Ticaret Portalı Veritabanı Şeması
-- Veritabanı Adı: ecommerce_db

-- Veritabanı oluşturma (Eğer var değilse)
CREATE DATABASE IF NOT EXISTS ecommerce_db;

-- Kullanıcılar Tablosu
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(500),
    role VARCHAR(50) DEFAULT 'customer' CHECK (role IN ('customer', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kategoriler Tablosu
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ürünler Tablosu
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

-- Siparişler Tablosu
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Beklemede' CHECK (status IN ('Beklemede', 'Hazırlanıyor', 'Kargoya Verildi', 'Teslim Edildi', 'İptal Edildi')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- Sipariş Öğeleri Tablosu
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

-- İndeksler (Performans İçin)
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Test Verileri (İsteğe Bağlı)
-- Şifreler SHA-256 ile hashlenmiştir (admin123 / pass123)
INSERT INTO users (full_name, email, password, phone, address, role) 
VALUES 
    ('Admin User', 'admin@ecommerce.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '5551234567', 'Istanbul', 'admin'),
    ('Ahmet Yılmaz', 'ahmet@example.com', '9b8769a4a742959a2d0298c36fb70623f2dfacda8436237df08d8dfd5b37374c', '5559876543', 'Ankara, Türkiye', 'customer');

INSERT INTO categories (name, description, is_active) 
VALUES 
    ('Elektronik', 'Elektronik ürünler ve cihazlar', TRUE),
    ('Giyim', 'Kiyafet ve aksesuarlar', TRUE),
    ('Kitaplar', 'Eğitim ve teknoloji kitapları', TRUE);

INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) 
VALUES 
    (1, 'Laptop HP', 'Intel Core i7, 16GB RAM', 15000.00, 10, '/images/laptop.jpg', TRUE),
    (1, 'Kablosuz Mouse', 'USB Dongle ile 2.4GHz', 150.00, 50, '/images/mouse.jpg', TRUE),
    (2, 'Mavi T-Shirt', '100% Pamuk, M beden', 89.99, 30, '/images/tshirt.jpg', TRUE),
    (3, 'Java Programlama', 'Başlangıçtan İleri Düzeye', 120.00, 15, '/images/java_book.jpg', TRUE);

-- İlişkileri doğrulama (Örnek: Bir siparişin detayları)
-- SELECT o.id, u.full_name, o.total_amount, o.status 
-- FROM orders o 
-- JOIN users u ON o.user_id = u.id;
