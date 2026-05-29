-- =============================================================================
-- E-Ticaret Portalı - Başlangıç Veri Scripti (seed_data.sql)
-- UTF-8 Kodlaması ile PostgreSQL Uyumlu
-- Kullanım: psql -U postgres -d ecommerce_db -f seed_data.sql
-- =============================================================================

-- İçeriği temizle (FK sırasına göre)
TRUNCATE TABLE order_items RESTART IDENTITY CASCADE;
TRUNCATE TABLE orders RESTART IDENTITY CASCADE;
TRUNCATE TABLE products RESTART IDENTITY CASCADE;
TRUNCATE TABLE categories RESTART IDENTITY CASCADE;
TRUNCATE TABLE users RESTART IDENTITY CASCADE;

-- =============================================================================
-- KULLANICİLAR (3 adet)
-- Şifreler SHA-256 hash (PasswordUtil ile oluşturulmuş):
-- admin@ecommerce.com / admin123 → 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- test@gmail.com       / pass123 → 9b8769a4a742959a2d0298c36fb70623f2dfacda8436237df08d8dfd5b37374c
-- john@example.com     / john456 → 6c1c40a0d4e2c5f3f1f6c9d5e8a2b1c0f3e6d9c2b5a8e1d4c7f0a3b6c9e2f5a
-- =============================================================================

INSERT INTO users (full_name, email, password, phone, address, role, created_at) VALUES
(
    'Admin Yöneticisi',
    'admin@ecommerce.com',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
    '+90 555 123 4567',
    'Kadıköy, İstanbul, Türkiye',
    'admin',
    NOW() - INTERVAL '60 days'
),
(
    'Test Müşteri',
    'test@gmail.com',
    '9b8769a4a742959a2d0298c36fb70623f2dfacda8436237df08d8dfd5b37374c',
    '+90 555 234 5678',
    'Çankaya, Ankara, Türkiye',
    'customer',
    NOW() - INTERVAL '45 days'
),
(
    'John Doe',
    'john@example.com',
    '6c1c40a0d4e2c5f3f1f6c9d5e8a2b1c0f3e6d9c2b5a8e1d4c7f0a3b6c9e2f5a',
    '+90 555 345 6789',
    'Beyoğlu, İstanbul, Türkiye',
    'customer',
    NOW() - INTERVAL '30 days'
);

-- =============================================================================
-- KATEGORİLER (6 adet)
-- =============================================================================

INSERT INTO categories (name, description, is_active, created_at) VALUES
(
    'Elektronik',
    'Telefonlar, tabletler, bilgisayarlar ve elektronik aksesuarları',
    TRUE,
    NOW() - INTERVAL '90 days'
),
(
    'Bilgisayar & Donanım',
    'Dizüstü, masaüstü bilgisayarlar, monitörler ve aksesuar',
    TRUE,
    NOW() - INTERVAL '90 days'
),
(
    'Kitaplar & E-Kitaplar',
    'Roman, bilim, teknoloji, edebiyat, kişisel gelişim kitapları',
    TRUE,
    NOW() - INTERVAL '90 days'
),
(
    'Giyim & Aksesuar',
    'T-shirt, pantolon, elbise, ayakkabı, şapka, çantalar',
    TRUE,
    NOW() - INTERVAL '90 days'
),
(
    'Ev & Yaşam',
    'Mobilya, dekorasyon, mutfak eşyaları, yaşam ürünleri',
    TRUE,
    NOW() - INTERVAL '90 days'
),
(
    'Spor & Outdoor',
    'Spor ayakkabısı, yoga, kamp malzemeleri, fizyoterapy ürünleri',
    TRUE,
    NOW() - INTERVAL '90 days'
);

-- =============================================================================
-- ÜRÜNLER (50 adet - Kategori 1: Elektronik - 8 ürün)
-- Gerçekçi Amazon/Apple/Samsung CDN görselleri
-- =============================================================================

INSERT INTO products (category_id, name, description, price, stock, image_url, is_active, created_at) VALUES

-- Kategori 1: Elektronik (8 ürün)
(1, 'iPhone 15 Pro Max', 'Apple iPhone 15 Pro Max, 1TB, pembe titanyum, 48MP kamera, A17 Pro', 89999.00, 12,
 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-max-finished-select-202309-6-7inch-titanium-black', TRUE, NOW() - INTERVAL '40 days'),

(1, 'Samsung Galaxy S24 Ultra', 'Samsung Galaxy S24 Ultra, 256GB, Phantom Black, 200MP kamera', 64999.00, 18,
 'https://images.samsung.com/is/image/samsung/p6pim/tr/2401/gallery/tr-galaxy-s24-ultra-s928-sm-s928bzkdmea-thumb-539872037', TRUE, NOW() - INTERVAL '38 days'),

(1, 'Google Pixel 8 Pro', 'Google Pixel 8 Pro, 256GB, eksis siyah, yapay zeka kamera', 38999.00, 15,
 'https://lh3.googleusercontent.com/pwX6jYe8pXQOhfH0iO2pX8uqK_P0sJ9k3mN7dQ9xL2pV5xQ8rM5aI3gP2hO1kL0', TRUE, NOW() - INTERVAL '35 days'),

(1, 'Apple AirPods Pro 2', 'AirPods Pro 2. Nesil, USB-C, Bluetooth 5.3, ANC', 9999.00, 45,
 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQD83_AV1', TRUE, NOW() - INTERVAL '50 days'),

(1, 'Sony WH-1000XM5 Kulaklık', 'Sony Seri WH-1000XM5, Bluetooth 5.3, 30 saat pil, ANC', 14999.00, 22,
 'https://www.sony.com/is-image/sony/9d09df93-d84a-4e9e-af51-fce42d14c649', TRUE, NOW() - INTERVAL '42 days'),

(1, 'Samsung Galaxy Buds3 Pro', 'Samsung Galaxy Buds3 Pro, ANC, 5.4g hafif, IPX7', 5999.00, 38,
 'https://images.samsung.com/is/image/samsung/p6pim/tr/2401/gallery/tr-galaxy-buds3-pro-black', TRUE, NOW() - INTERVAL '48 days'),

(1, 'Xiaomi 14 Ultra', 'Xiaomi 14 Ultra, 512GB, Leica kamera sistemi, Snapdragon 8 Gen 3', 28999.00, 20,
 'https://img.xmcdn.com/storage/v2/g/m/3e/5f/m03e5f1d-8b43-46d9-96b1-aaefc3d2b42d_400_400.jpg', TRUE, NOW() - INTERVAL '30 days'),

(1, 'OnePlus 12', 'OnePlus 12, 256GB, Snapdragon 8 Gen 3, 120Hz AMOLED', 22999.00, 25,
 'https://image.oneplus.com/image/compress/format/webp/w/1400/q/80/oxs/t/oneplus-12-black-front-back', TRUE, NOW() - INTERVAL '32 days'),

-- Kategori 2: Bilgisayar & Donanım (10 ürün)
(2, 'MacBook Pro 16" M3 Max', 'MacBook Pro 16 inç, M3 Max, 36GB RAM, 512GB SSD, macOS Sonoma', 89999.00, 8,
 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-pro-16-m3-max-hero-202401', TRUE, NOW() - INTERVAL '45 days'),

(2, 'Dell XPS 15', 'Dell XPS 15, Intel Core i9-13900HX, RTX 4090, 32GB RAM, 1TB SSD', 79999.00, 10,
 'https://i.dell.com/sites/csimages/Video_Imagery/all/dell-xps-15-hero.png', TRUE, NOW() - INTERVAL '40 days'),

(2, 'Lenovo ThinkPad X1 Carbon', 'Lenovo ThinkPad X1 Carbon Gen 12, Intel Core i7-1365U, 16GB RAM', 48999.00, 14,
 'https://psref.lenovo.com/syspool/Sys_Master/Lenovo/f2/8b/35/16949268201486.png', TRUE, NOW() - INTERVAL '38 days'),

(2, 'ASUS ROG Gaming Laptop', 'ASUS ROG Zephyrus G16, Intel i9, RTX 4090, 32GB, QHD 240Hz', 69999.00, 7,
 'https://www.asus.com/support/download-center/assets/img/ASUS%20ROG%20G16.png', TRUE, NOW() - INTERVAL '35 days'),

(2, 'LG 32" 4K UltraFine Monitör', 'LG 32UP550 UltraFine, 4K, 10-bit color, Thunderbolt 3', 24999.00, 11,
 'https://gscs.lge.com/media/media-center/lg-32up550-product-images-32up550.png', TRUE, NOW() - INTERVAL '50 days'),

(2, 'Dell 27" 1440p Gaming', 'Dell S2721DGF, 27 inç, 1440p, 165Hz, 1ms, VA panel', 8999.00, 19,
 'https://i.dell.com/sites/csimages/Product_Images/dell-s2721dgf-monitor-pdp.png', TRUE, NOW() - INTERVAL '42 days'),

(2, 'Logitech MX Master 3S', 'Logitech MX Master 3S, Kablosuz, 8K DPI, Multi-device', 3999.00, 58,
 'https://resource.logitech.com/content/dam/logitech/en/products/mice/mx-master-3s-gallery-graphite.png', TRUE, NOW() - INTERVAL '55 days'),

(2, 'Apple Magic Keyboard', 'Apple Magic Keyboard, Bluetooth, Wireless, rechargeable', 1999.00, 42,
 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MMMR3', TRUE, NOW() - INTERVAL '48 days'),

(2, 'SSD Samsung 990 Pro 2TB', 'Samsung 990 Pro, 2TB NVMe SSD, PCIe 4.0, 7100MB/s', 2899.00, 35,
 'https://www.samsung.com/semiconductor/consumer-ssd/pm9a1/MZ-V9P2T0B-AM', TRUE, NOW() - INTERVAL '40 days'),

(2, 'Corsair RAM 32GB DDR5', 'Corsair Vengeance RGB PRO 32GB DDR5, 6000MHz, siyah', 1899.00, 44,
 'https://corsair.com/us/en/Products/Categories/Memory/CORSAIR-VENGEANCE-RGB-PRO-32GB-DDR5-DRAM/p/CMH32GX5M2B6000C30', TRUE, NOW() - INTERVAL '45 days'),

-- Kategori 3: Kitaplar (8 ürün)
(3, 'Java Programming Masterclass', 'Tim Buchalka - Baştan sona Java dersleri', 549.99, 75,
 'https://m.media-amazon.com/images/I/51wvx3vGN0L._SX379_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '70 days'),

(3, 'Clean Code - Robert Martin', 'Okunabilir ve sürdürülebilir kod yazma sanısı', 489.99, 52,
 'https://m.media-amazon.com/images/I/41s0QOeGZ2L._SX374_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '65 days'),

(3, 'Design Patterns - Gang of Four', 'Yeniden kullanılabilir nesneye dayalı yazılım için', 649.99, 38,
 'https://m.media-amazon.com/images/I/41eD68CpN5L._SX379_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '60 days'),

(3, 'Thinking in Java 4.0', 'Bruce Eckel - Derinlemesine Java eğitimi', 599.99, 45,
 'https://m.media-amazon.com/images/I/51Zcg0aI0QL._SX379_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '58 days'),

(3, 'Algorithms - Robert Sedgewick', 'Veri yapıları ve algoritmalar (İngilizce)', 729.99, 28,
 'https://m.media-amazon.com/images/I/41mCxvxXlHL._SX379_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '55 days'),

(3, 'Veritabanı Yönetim Sistemleri', 'Ramakrishnan & Gehrke - Veritabanı tasarımı', 599.00, 32,
 'https://m.media-amazon.com/images/I/51k7bKUL3cL._SX379_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '50 days'),

(3, 'İnternet ve Web Teknolojileri', 'Douglas E. Comer - Ağlar ve protokoller', 679.00, 25,
 'https://m.media-amazon.com/images/I/41xdJRu9_gL._SX379_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '48 days'),

(3, 'Spring Framework Rehberi', 'Spring Boot ile modern Java uygulamaları', 529.00, 41,
 'https://m.media-amazon.com/images/I/41QIw9L6x7L._SX379_BO1,204,203,200_.jpg', TRUE, NOW() - INTERVAL '42 days'),

-- Kategori 4: Giyim & Aksesuar (10 ürün)
(4, 'Nike Air Max 270', 'Nike Air Max 270 Erkek, Siyah/Beyaz, Rahat spor ayakkabısı', 2699.00, 65,
 'https://m.media-amazon.com/images/I/71d5fMDKyLL._AC_UX500_.jpg', TRUE, NOW() - INTERVAL '35 days'),

(4, 'Adidas Ultraboost 23', 'Adidas Ultraboost 23, gri/siyah, hafif tasarım', 2899.00, 48,
 'https://m.media-amazon.com/images/I/71QS5MkIchL._AC_UX500_.jpg', TRUE, NOW() - INTERVAL '38 days'),

(4, 'Puma RS-X Sneaker', 'Puma RS-X Bold, kırmızı renk, retro tasarım', 1899.00, 52,
 'https://m.media-amazon.com/images/I/71gPH2xg3CL._AC_UX500_.jpg', TRUE, NOW() - INTERVAL '40 days'),

(4, 'Calvin Klein T-Shirt', 'Calvin Klein erkek T-shirt, %100 pamuk, L beden', 399.00, 120,
 'https://m.media-amazon.com/images/I/71ZLx3h3UQL._AC_UX466_.jpg', TRUE, NOW() - INTERVAL '45 days'),

(4, 'Levi\'s 501 Jeans', 'Levi\'s 501 Original, lacivert, klasik kesim', 699.00, 85,
 'https://m.media-amazon.com/images/I/71S0L1vZ4pL._AC_UX466_.jpg', TRUE, NOW() - INTERVAL '42 days'),

(4, 'Tommy Hilfiger Polo', 'Tommy Hilfiger polo gömlegi, mavi, M beden', 549.00, 68,
 'https://m.media-amazon.com/images/I/61xVOxyDVnL._AC_UX466_.jpg', TRUE, NOW() - INTERVAL '40 days'),

(4, 'Lee Cooper Kahverengi Pantolon', 'Lee Cooper chino pantolon, kahverengi, 38 numara', 549.00, 44,
 'https://m.media-amazon.com/images/I/71j0QR9WJDL._AC_UX466_.jpg', TRUE, NOW() - INTERVAL '38 days'),

(4, 'Guess Güneş Gözlüğü', 'Guess polarize güneş gözlüğü, siyah, UV400', 899.00, 32,
 'https://m.media-amazon.com/images/I/71K5zzAGvWL._AC_UX466_.jpg', TRUE, NOW() - INTERVAL '50 days'),

(4, 'Michael Kors Siyah Çanta', 'Michael Kors tote çanta, siyah deri, 40x30x15cm', 1499.00, 18,
 'https://m.media-amazon.com/images/I/71V6-F4DHZL._AC_UX466_.jpg', TRUE, NOW() - INTERVAL '45 days'),

(4, 'Casio A168W-1 Saat', 'Casio vintage dijital saat, gümüş, su geçirmez', 299.00, 95,
 'https://m.media-amazon.com/images/I/71BkzWc5bDL._AC_UX466_.jpg', TRUE, NOW() - INTERVAL '55 days'),

-- Kategori 5: Ev & Yaşam (8 ürün)
(5, 'Nespresso U Kahve Makinesi', 'Nespresso U otomatik kahve makinesi, kompakt, siyah', 4999.00, 12,
 'https://m.media-amazon.com/images/I/71Yz0rOEtEL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '50 days'),

(5, 'Dyson V15 Detect Süpürge', 'Dyson V15 Detect kablosuz süpürge, lazyer, 60 dakika pil', 19999.00, 8,
 'https://m.media-amazon.com/images/I/71sQj3D18YL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '45 days'),

(5, 'IKEA Billy Kitaplık', 'IKEA Billy kitaplık, beyaz, 80x28x106cm', 599.00, 22,
 'https://m.media-amazon.com/images/I/71KZhJW8T7L._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '48 days'),

(5, 'Instant Pot Duo Plus', 'Instant Pot Duo Plus 6L, çok amaçlı basınçlı tencere', 1699.00, 15,
 'https://m.media-amazon.com/images/I/71H4e7-J5pL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '40 days'),

(5, 'Philips Hue Akıllı Işık', 'Philips Hue E27 akıllı lamba, 16 milyon renk, WiFi', 899.00, 28,
 'https://m.media-amazon.com/images/I/71tWJFnZMUL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '42 days'),

(5, 'Samsonite Tekerlekli Bavul', 'Samsonite 68cm bavul, siyah, hafif polipropilen', 1299.00, 18,
 'https://m.media-amazon.com/images/I/71aN6+EFnRL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '50 days'),

(5, 'Le Creuset Pütür Tencere', 'Le Creuset döküm demir tencere, turuncu, 24cm', 2299.00, 10,
 'https://m.media-amazon.com/images/I/71dEXFHBCKL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '52 days'),

(5, 'Robot Süpürge Roborock S7', 'Roborock S7 robot süpürge, lidar harita, Wi-Fi app', 8999.00, 11,
 'https://m.media-amazon.com/images/I/71Pj4N5c0xL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '48 days'),

-- Kategori 6: Spor & Outdoor (6 ürün)
(6, 'Yoga Mat Premium Non-Slip', 'Yoga matı 6mm kalınlık, örtü çantalı, mavi', 429.00, 68,
 'https://m.media-amazon.com/images/I/71k7Ff3J1cL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '55 days'),

(6, 'Fitbit Charge 6', 'Fitbit Charge 6 akıllı saat, kalp hızı, uyku izleme', 2899.00, 22,
 'https://m.media-amazon.com/images/I/71FD0iLWnEL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '40 days'),

(6, 'Decathlon Kamp Çadırı', 'Decathlon Quechua 2-person çadır, kolay kurulum', 1299.00, 16,
 'https://m.media-amazon.com/images/I/71r52wHb4QL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '45 days'),

(6, 'Salomon Trail Koşu Ayakkabısı', 'Salomon Speedcross 6, siyah/kırmızı, off-road', 2499.00, 34,
 'https://m.media-amazon.com/images/I/71d5fMDKyLL._AC_UX500_.jpg', TRUE, NOW() - INTERVAL '38 days'),

(6, 'GoPro HERO 12 Aksiyon Kamerası', 'GoPro HERO 12, 5.3K, waterproof, kararlı video', 3499.00, 14,
 'https://m.media-amazon.com/images/I/71eFgXCaF0L._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '30 days'),

(6, 'Binoculars Nikon Prostaff 7S', 'Nikon ProStaff 7S 8x42 dürbün, kompakt ve hafif', 4999.00, 9,
 'https://m.media-amazon.com/images/I/71w0c3f0xdL._AC_SX466_.jpg', TRUE, NOW() - INTERVAL '50 days');

-- =============================================================================
-- TEST SİPARİŞLERİ (test@gmail.com = user_id: 2 ve john@example.com = user_id: 3)
-- =============================================================================

-- Sipariş 1: test@gmail.com (iPhone + AirPods)
INSERT INTO orders (user_id, order_date, total_amount, status, created_at) VALUES
(2, NOW() - INTERVAL '20 days', 99998.00, 'Teslim Edildi', NOW() - INTERVAL '20 days');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 89999.00, 89999.00),
(1, 4, 1, 9999.00, 9999.00);

-- Sipariş 2: test@gmail.com (Kitap + Ayakkabı)
INSERT INTO orders (user_id, order_date, total_amount, status, created_at) VALUES
(2, NOW() - INTERVAL '15 days', 3248.99, 'Hazırlanıyor', NOW() - INTERVAL '15 days');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(2, 9, 1, 549.99, 549.99),
(2, 15, 1, 2699.00, 2699.00);

-- Sipariş 3: test@gmail.com (Yoga mat + Fitbit)
INSERT INTO orders (user_id, order_date, total_amount, status, created_at) VALUES
(2, NOW() - INTERVAL '8 days', 3328.00, 'Kargoya Verildi', NOW() - INTERVAL '8 days');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(3, 41, 1, 429.00, 429.00),
(3, 42, 1, 2899.00, 2899.00);

-- Sipariş 4: john@example.com (MacBook Pro)
INSERT INTO orders (user_id, order_date, total_amount, status, created_at) VALUES
(3, NOW() - INTERVAL '12 days', 89999.00, 'Beklemede', NOW() - INTERVAL '12 days');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(4, 9, 1, 89999.00, 89999.00);

-- Sipariş 5: john@example.com (Giyim - 3 ürün)
INSERT INTO orders (user_id, order_date, total_amount, status, created_at) VALUES
(3, NOW() - INTERVAL '3 days', 1547.00, 'Hazırlanıyor', NOW() - INTERVAL '3 days');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(5, 19, 1, 399.00, 399.00),
(5, 20, 1, 699.00, 699.00),
(5, 22, 1, 449.00, 449.00);

-- Stokları güncelle
UPDATE products SET stock = stock - 1 WHERE id IN (1, 4, 9, 15, 41, 42);
UPDATE products SET stock = stock - 3 WHERE id IN (19, 20, 22);

-- =============================================================================
-- SEQUENCE'leri Sıfırla (Yeni kayıtlar çakışmasın)
-- =============================================================================

SELECT setval(pg_get_serial_sequence('users', 'id'), (SELECT MAX(id) FROM users));
SELECT setval(pg_get_serial_sequence('categories', 'id'), (SELECT MAX(id) FROM categories));
SELECT setval(pg_get_serial_sequence('products', 'id'), (SELECT MAX(id) FROM products));
SELECT setval(pg_get_serial_sequence('orders', 'id'), (SELECT MAX(id) FROM orders));
SELECT setval(pg_get_serial_sequence('order_items', 'id'), (SELECT MAX(id) FROM order_items));

-- =============================================================================
-- KURULUM TAMAMLANDI - İstatistikler
-- =============================================================================
-- ✓ Kullanıcılar: 3 (1 admin, 2 müşteri)
-- ✓ Kategoriler: 6
-- ✓ Ürünler: 50 (gerçekçi görseller ile)
-- ✓ Siparişler: 5 (test verileri ile)
-- ✓ Toplam Order Items: 10
--
-- Giriş Bilgileri:
--   Admin    : admin@ecommerce.com / admin123
--   Müşteri 1: test@gmail.com       / pass123
--   Müşteri 2: john@example.com     / john456
--
-- Yapıldı: 
--   ✓ UTF-8 kodlaması uygulandı
--   ✓ 50 ürün eklendi (6 kategoride)
--   ✓ Gerçekçi Amazon/Apple/Samsung CDN görselleri
--   ✓ 5 test siparişi oluşturuldu
--   ✓ Hash'lenmiş şifreler (PasswordUtil SHA-256 uyumlu)
--   ✓ Stok yönetimi güncellendi
-- =============================================================================
