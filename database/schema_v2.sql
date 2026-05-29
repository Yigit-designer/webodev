-- =============================================================================
-- E-Ticaret Portalı - Tam Kurulum Scripti (PostgreSQL)
-- Kullanım: psql -U postgres -d ecommerce_db -f schema_v2.sql
-- veya pgAdmin Query Tool ile çalıştırın
-- =============================================================================

-- Mevcut tabloları sıfırla (FK sırasına göre)
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- =============================================================================
-- TABLOLAR
-- =============================================================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(500),
    role VARCHAR(50) DEFAULT 'customer' CHECK (role IN ('customer', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000),
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    image_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Beklemede'
        CHECK (status IN ('Beklemede', 'Hazırlanıyor', 'Kargoya Verildi', 'Teslim Edildi', 'İptal Edildi')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL
);

-- İndeksler
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- =============================================================================
-- TEST KULLANICILARI (SHA-256 hash - PasswordUtil ile uyumlu)
-- admin@ecommerce.com / admin123
-- test@gmail.com    / pass123
-- =============================================================================

INSERT INTO users (full_name, email, password, phone, address, role) VALUES
(
    'Admin Kullanıcı',
    'admin@ecommerce.com',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
    '5551234567',
    'Kadıköy, İstanbul',
    'admin'
),
(
    'Test Kullanıcı',
    'test@gmail.com',
    '9b8769a4a742959a2d0298c36fb70623f2dfacda8436237df08d8dfd5b37374c',
    '5559876543',
    'Çankaya, Ankara',
    'customer'
);

-- =============================================================================
-- KATEGORİLER (6 adet)
-- =============================================================================

INSERT INTO categories (name, description, is_active) VALUES
('Elektronik', 'Telefon, bilgisayar ve elektronik aksesuarlar', TRUE),
('Bilgisayar', 'Dizüstü, masaüstü ve bilgisayar bileşenleri', TRUE),
('Kitaplar', 'Eğitim, roman ve teknik kitaplar', TRUE),
('Giyim', 'Günlük giyim ve aksesuar ürünleri', TRUE),
('Ev & Yaşam', 'Ev dekorasyonu ve yaşam ürünleri', TRUE),
('Spor & Outdoor', 'Spor ekipmanları ve outdoor ürünler', TRUE);

-- =============================================================================
-- ÜRÜNLER (15 adet - picsum placeholder görseller)
-- =============================================================================

INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES
-- Elektronik (1)
(1, 'iPhone 15 Pro', '256GB, A17 Pro çip, Pro kamera sistemi', 64999.00, 25,
 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-blue-titanium', TRUE),
(1, 'Samsung Galaxy S24', '128GB, AMOLED ekran, 50MP kamera', 42999.00, 30,
 'https://images.samsung.com/is/image/samsung/p6pim/tr/2401/gallery/tr-galaxy-s24-s928-sm-s921bzkdmea-thumb-539872037', TRUE),
(1, 'AirPods Pro 2', 'Aktif gürültü engelleme, MagSafe şarj kutusu', 8999.00, 50,
 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQD83', TRUE),
-- Bilgisayar (2)
(2, 'MacBook Air M3', '13 inç, 8GB RAM, 256GB SSD, macOS', 54999.00, 15,
 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-air-13-m3-hero-202403', TRUE),
(2, 'Lenovo ThinkPad X1', 'Intel Core i7, 16GB RAM, 512GB SSD', 48999.00, 12,
 'https://www.lenovo.com/medias/lenovo-laptop-thinkpad-x1-carbon-gen11-hero.png', TRUE),
(2, 'Logitech MX Master 3S', 'Kablosuz ergonomik mouse, hızlı kaydırma', 3499.00, 80,
 'https://resource.logitech.com/content/dam/logitech/en/products/mice/mx-master-3s/gallery/mx-master-3s-top-view-graphite.png', TRUE),
(2, 'Dell 27\" 4K Monitör', 'IPS panel, 3840x2160 çözünürlük, USB-C', 12999.00, 20,
 'https://i.dell.com/sites/csimages/Video_Imagery/all/dell-monitor-s2721qs.png', TRUE),
-- Kitaplar (3)
(3, 'Java Programlama', 'Başlangıçtan ileri düzeye Java rehberi', 450.00, 100,
 'https://m.media-amazon.com/images/I/41s0QOeGZ2L._SX379_BO1,204,203,200_.jpg', TRUE),
(3, 'Clean Code', 'Robert C. Martin – Okunabilir ve sürdürülebilir kod', 380.00, 60,
 'https://m.media-amazon.com/images/I/41-sN-mzwKL._SX374_BO1,204,203,200_.jpg', TRUE),
(3, 'Veri Yapıları ve Algoritmalar', 'Üniversite düzeyi veri yapıları ve algoritmalar kitabı', 520.00, 45,
 'https://m.media-amazon.com/images/I/51wvx3vGN0L._SX379_BO1,204,203,200_.jpg', TRUE),
-- Giyim (4)
(4, 'Erkek Polo Tişört', '%100 pamuk, regular fit, L beden', 299.00, 120,
 'https://m.media-amazon.com/images/I/71ZLx3h3UQL._AC_UX466_.jpg', TRUE),
(4, 'Kadın Kot Pantolon', 'Slim fit, yüksek bel, mavi', 599.00, 75,
 'https://m.media-amazon.com/images/I/71S0L1vZ4pL._AC_UX466_.jpg', TRUE),
-- Ev & Yaşam (5)
(5, 'Kahve Makinesi', 'Espresso ve filtre kahve modu, paslanmaz çelik', 4500.00, 18,
 'https://m.media-amazon.com/images/I/71Yz0rOEtEL._AC_SX466_.jpg', TRUE),
(5, 'Robot Süpürge', 'Akıllı haritalama, Wi-Fi, mobil uygulama desteği', 8900.00, 22,
 'https://m.media-amazon.com/images/I/71Pj4N5c0xL._AC_SX466_.jpg', TRUE),
-- Spor & Outdoor (6)
(6, 'Koşu Ayakkabısı', 'Hafif taban, nefes alabilen yüzey, 42 numara', 1899.00, 40,
 'https://m.media-amazon.com/images/I/71d5fMDKyLL._AC_UX500_.jpg', TRUE),
(6, 'Yoga Matı', '6mm kalınlık, kaymaz yüzey, mor renk', 349.00, 90,
 'https://m.media-amazon.com/images/I/71k7Ff3J1cL._AC_SX466_.jpg', TRUE);

-- =============================================================================
-- TEST SİPARİŞLERİ (test@gmail.com kullanıcısı = id 2)
-- =============================================================================

-- Sipariş 1: iPhone + AirPods
INSERT INTO orders (user_id, order_date, total_amount, status) VALUES
(2, NOW() - INTERVAL '5 days', 73998.00, 'Teslim Edildi');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 64999.00, 64999.00),
(1, 3, 1, 8999.00, 8999.00);

-- Sipariş 2: Java kitabı + Koşu ayakkabısı
INSERT INTO orders (user_id, order_date, total_amount, status) VALUES
(2, NOW() - INTERVAL '2 days', 2349.00, 'Hazırlanıyor');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 8, 1, 450.00, 450.00),
(2, 14, 1, 1899.00, 1899.00);

-- Stokları siparişlere göre düşür (gerçekçi veri)
UPDATE products SET stock = stock - 1 WHERE id IN (1, 3, 8, 14);

-- =============================================================================
-- SEQUENCE SIFIRLAMA (yeni kayıtlar çakışmasın)
-- =============================================================================

SELECT setval(pg_get_serial_sequence('users', 'id'), (SELECT MAX(id) FROM users));
SELECT setval(pg_get_serial_sequence('categories', 'id'), (SELECT MAX(id) FROM categories));
SELECT setval(pg_get_serial_sequence('products', 'id'), (SELECT MAX(id) FROM products));
SELECT setval(pg_get_serial_sequence('orders', 'id'), (SELECT MAX(id) FROM orders));
SELECT setval(pg_get_serial_sequence('order_items', 'id'), (SELECT MAX(id) FROM order_items));

-- =============================================================================
-- KURULUM TAMAMLANDI
-- =============================================================================
-- Giriş bilgileri:
--   Admin : admin@ecommerce.com / admin123
--   Müşteri: test@gmail.com       / pass123
-- =============================================================================
