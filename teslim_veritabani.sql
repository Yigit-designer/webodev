
\restrict kCXy2CxbYqHMIqZOmB6l18mTUBhO4PEFNVEqaNGxCfkQ5cth5l4sE7TEDUfMGqQ



ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_order_id_fkey;
DROP INDEX IF EXISTS public.idx_users_email;
DROP INDEX IF EXISTS public.idx_products_is_active;
DROP INDEX IF EXISTS public.idx_products_category_id;
DROP INDEX IF EXISTS public.idx_orders_user_id;
DROP INDEX IF EXISTS public.idx_order_items_order_id;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_pkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_name_key;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.products ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.orders ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.order_items ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.categories ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.products_id_seq;
DROP TABLE IF EXISTS public.products;
DROP SEQUENCE IF EXISTS public.orders_id_seq;
DROP TABLE IF EXISTS public.orders;
DROP SEQUENCE IF EXISTS public.order_items_id_seq;
DROP TABLE IF EXISTS public.order_items;
DROP SEQUENCE IF EXISTS public.categories_id_seq;
DROP TABLE IF EXISTS public.categories;



CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(500),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);



CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;



CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);



CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;



CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(12,2) NOT NULL,
    status character varying(50) DEFAULT 'Beklemede'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['Beklemede'::character varying, 'HazÃ„Â±rlanÃ„Â±yor'::character varying, 'Kargoya Verildi'::character varying, 'Teslim Edildi'::character varying, 'Ã„Â°ptal Edildi'::character varying])::text[])))
);



CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;



CREATE TABLE public.products (
    id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(1000),
    price numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    image_url character varying(500),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT products_price_check CHECK ((price > (0)::numeric)),
    CONSTRAINT products_stock_check CHECK ((stock >= 0))
);



CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;



CREATE TABLE public.users (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(20),
    address character varying(500),
    role character varying(50) DEFAULT 'customer'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['customer'::character varying, 'admin'::character varying])::text[])))
);



CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;



ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);



ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);



ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);



ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);



ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);



INSERT INTO public.categories (id, name, description, is_active, created_at) VALUES (5, 'Ev EÅŸyalarÄ±', 'Mobilya, dekorasyon, mutfak eÅŸyalarÄ±', true, '2026-05-29 14:01:39.302521');
INSERT INTO public.categories (id, name, description, is_active, created_at) VALUES (1, 'Elektronik', 'Telefonlar, tabletler, elektronik aksesuarlar', true, '2026-05-29 14:01:39.302521');
INSERT INTO public.categories (id, name, description, is_active, created_at) VALUES (4, 'Giyim', 'T-shirt, pantolon, elbise, ayakkabÄ±', true, '2026-05-29 14:01:39.302521');
INSERT INTO public.categories (id, name, description, is_active, created_at) VALUES (3, 'Kitaplar', 'Roman, bilim, teknoloji, edebiyat kitaplar, online dersler', true, '2026-05-29 14:01:39.302521');
INSERT INTO public.categories (id, name, description, is_active, created_at) VALUES (6, 'Spor Outdoor', 'Spor ayakkabÄ±sÄ±, yoga, kamp malzemeleri', true, '2026-05-29 14:01:39.302521');
INSERT INTO public.categories (id, name, description, is_active, created_at) VALUES (2, 'Bilgisayar', 'DizÃ¼stÃ¼, masaÃ¼stÃ¼ bilgisayarlar, monitÃ¶rleri', true, '2026-05-29 14:01:39.302521');



INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (1, 1, 1, 1, 89999.00, 89999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (2, 1, 4, 1, 9999.00, 9999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (3, 2, 2, 1, 64999.00, 64999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (4, 2, 12, 1, 549.99, 549.99);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (5, 3, 7, 1, 79999.00, 79999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (6, 4, 15, 1, 729.99, 729.99);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (7, 5, 12, 1, 489.99, 489.99);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (8, 6, 1, 1, 89999.00, 89999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (9, 7, 2, 1, 64999.00, 64999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (10, 8, 15, 1, 729.99, 729.99);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (11, 9, 4, 1, 9999.00, 9999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (12, 9, 7, 1, 79999.00, 79999.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (13, 10, 17, 12, 2899.00, 34788.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (14, 11, 7, 3, 79999.00, 239997.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (15, 12, 21, 3, 19999.00, 59997.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (16, 12, 17, 1, 2899.00, 2899.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (17, 13, 7, 3, 79999.00, 239997.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (18, 14, 17, 2, 2899.00, 5798.00);
INSERT INTO public.order_items (id, order_id, product_id, quantity, unit_price, subtotal) VALUES (19, 14, 22, 1, 599.00, 599.00);



INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (1, 2, '2026-05-09 14:01:39.308313', 99998.00, 'Teslim Edildi', '2026-05-29 14:01:39.308313');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (3, 1, '2026-05-29 14:55:49.127135', 79999.00, 'Beklemede', '2026-05-29 14:55:49.166251');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (2, 2, '2026-05-19 14:01:39.308313', 4598.99, 'Kargoya Verildi', '2026-05-29 14:01:39.308313');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (4, 1, '2026-05-29 14:55:58.889065', 729.99, 'Teslim Edildi', '2026-05-29 14:55:58.917133');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (6, 1, '2026-05-29 15:00:49.541765', 89999.00, 'Kargoya Verildi', '2026-05-29 15:00:49.569864');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (5, 1, '2026-05-29 14:56:10.623611', 489.99, 'Teslim Edildi', '2026-05-29 14:56:10.654268');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (7, 1, '2026-05-29 15:01:02.804405', 64999.00, 'Kargoya Verildi', '2026-05-29 15:01:02.83549');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (8, 1, '2026-05-29 15:28:34.735916', 729.99, 'Beklemede', '2026-05-29 15:28:34.764766');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (10, 1, '2026-05-29 15:47:37.503926', 34788.00, 'Beklemede', '2026-05-29 15:47:37.533323');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (11, 4, '2026-05-29 21:17:51.970971', 239997.00, 'Beklemede', '2026-05-29 21:17:52.00689');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (12, 5, '2026-05-29 21:25:32.251536', 62896.00, 'Beklemede', '2026-05-29 21:25:32.2823');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (13, 6, '2026-05-29 21:26:57.551737', 239997.00, 'Beklemede', '2026-05-29 21:26:57.583267');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (14, 7, '2026-05-29 21:29:36.895751', 6397.00, 'Beklemede', '2026-05-29 21:29:36.92455');
INSERT INTO public.orders (id, user_id, order_date, total_amount, status, created_at) VALUES (9, 1, '2026-05-29 15:29:14.311462', 89998.00, 'Kargoya Verildi', '2026-05-29 15:29:14.340936');



INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (2, 1, 'Samsung Galaxy S24 Ultra', 'Samsung Galaxy S24 Ultra, 256GB, Phantom Black', 64999.00, 17, 'https://ffo3gv1cf3ir.merlincdn.net/SiteAssets/pasaj/crop/cg/00KYMU/00KYMU-2.png', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (13, 3, 'Design Patterns', 'Gang of Four - TasarÄ±m desenleri', 649.99, 60, 'https://media.licdn.com/dms/image/v2/C5603AQEVXmE17WUYcw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1644222882070?e=2147483647&v=beta&t=-7mt4qUemJL_fTYYSfYdh-g4Z5w_H7HnnrP4FmIyj4s', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (4, 1, 'Apple AirPods Pro 2', 'AirPods Pro 2. Nesil, USB-C, Bluetooth 5.3, ANC', 12000.00, 50, 'https://www.beko.com.tr/media/resize/9227371600_LO1_20231123_083954.png/1000Wx1000H/image.png', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (15, 3, 'Algorithms', 'Robert Sedgewick - Veri yapÄ±larÄ±', 729.99, 50, 'https://m.media-amazon.com/images/I/51bz8TupENL._AC_UF894,1000_QL80_.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (12, 3, 'Clean Code', 'Robert Martin - Okunabilir kod yazma', 489.99, 51, 'https://m.media-amazon.com/images/I/81Rnac2Fq+L._AC_UF894,1000_QL80_.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (11, 3, 'Java Programming Masterclass', 'Tim Buchalka - BaÅŸtan sona Java dersleri', 549.99, 75, 'https://m.media-amazon.com/images/I/71isYqIo6yL.jpg_BO30,255,255,255_UF750,750_SR1910,1000,0,C_QL100_.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (14, 3, 'Operating System Concepts', 'Abraham Silberschatz - Operating System Concepts', 599.99, 45, 'https://m.media-amazon.com/images/I/91xvtzqH5xL._UF1000,1000_QL80_.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (7, 2, 'Dell XPS 15', 'Dell XPS 15, Intel Core i9-13900HX, RTX 4090', 79999.00, 14, 'https://www.notebookcheck-tr.com/uploads/tx_nbc2/DellXPS15-9510__1__03.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (3, 1, 'Google Pixel 8 Pro', 'Google Pixel 8 Pro, 256GB, siyah, yapay zeka kamera', 38999.00, 15, 'https://ares.shiftdelete.net/2023/09/google-pixel-8-samsunga-meydan-okuyor1.webp', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (8, 2, 'Lenovo ThinkPad X1 Carbon', 'Lenovo ThinkPad X1 Carbon Gen 12, Intel i7', 48999.00, 14, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRLGAeVo1hjJsBGhpM3Fwp88EsYyS-SQof5g&s', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (9, 2, 'Logitech MX Master 3S', 'Logitech MX Master 3S, Kablosuz, 8K DPI', 3999.00, 58, 'https://assets.mmsrg.com/isr/166325/c1/-/ASSET_MMS_98640940?x=536&y=402&format=jpg&quality=80&sp=yes&strip=yes&trim&ex=536&ey=402&align=center&resizesource&unsharp=1.5x1+0.7+0.02&cox=0&coy=0&cdx=536&cdy=402', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (6, 2, 'MacBook Pro 16 M3 Max', 'MacBook Pro 16 inÃ§, M3 Max, 36GB RAM, 512GB SSD', 89999.00, 8, 'https://macfinder.co.uk/wp-content/smush-webp/2023/12/img-MacBook-Pro-Retina-16-Inch-28687-scaled-scaled-1250x1250.jpg.webp', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (10, 2, 'Samsung SSD 990 Pro 2TB', 'Samsung 990 Pro, 2TB NVMe SSD, PCIe 4.0', 2899.00, 35, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg_yehP4NUvOX3cvG-fLtB8XHVf_gR9DCqOQ&s', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (5, 1, 'Sony WH-1000XM5 KulaklÄ±k', 'Sony WH-1000XM5, Bluetooth 5.3, 30 saat pil', 14999.00, 22, 'https://productimages.hepsiburada.net/s/240/375-375/110000223938781.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (1, 1, 'iPhone 15 Pro Max', 'Apple iPhone 15 Pro Max, 1TB, pembe titanyum', 89999.00, 11, 'https://assets.getmobil.com/uploads/56790/getmobil-iphone-15-pro-max-natural-titanium-1webp.webp', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (18, 4, 'Calvin Klein T-Shirt', 'Calvin Klein erkek T-shirt, pamuk, L beden', 399.00, 120, 'https://st-calvinkleinecom.mncdn.com/mnresize/800/1200/Content/media/ProductImg/original/lvgmf5k101100-erkek-t-shirt-638986492006664158.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (25, 6, 'Fitbit Charge 6', 'Fitbit Charge 6 akÄ±llÄ± saat', 2899.00, 22, 'https://productimages.hepsiburada.net/s/777/375-375/110001075839876.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (26, 6, 'GoPro HERO 12', 'GoPro HERO 12, 5.3K, waterproof', 3499.00, 14, 'https://static.gopro.com/assets/blta2b8522e5372af40/blt86b2d5c67d4f1ed5/64d0e286369276296caf7a71/02-pdp-h12b-gallery-1920.png', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (23, 5, 'Instant Pot Duo Plus', 'Instant Pot Duo Plus 6L, basÄ±nÃ§lÄ± tencere', 1699.00, 15, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwCDVsGhYD9SB5bDjRG2rNCCRlKBN9bGYLjg&s', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (19, 4, 'Levis 501 Jeans', 'Levis 501 Original, lacivert, klasik kesim', 699.00, 85, 'https://static.ticimax.cloud/49255/uploads/urunresimleri/buyuk/levis-501-original-erkek-lacivert-jean-591dc6.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (20, 5, 'Nespresso Kahve Makinesi', 'Nespresso U otomatik kahve makinesi', 4999.00, 12, 'https://www.alwaysfashion.com/images/thumbs/0012107_u_c50_mat_kirmizi_kahve_maknes_645.jpeg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (16, 4, 'Nike Air Max 270', 'Nike Air Max 270 Erkek, Siyah/Beyaz', 2699.00, 65, 'https://cdn.akakce.com/nike/nike-air-max-270-react-siyah-beyaz-erkek-spor-ayakkabi-z.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (24, 6, 'Yoga Mat Premium', 'Yoga matÄ± 6mm kalÄ±nlÄ±k, mavi', 429.00, 68, 'https://productimages.hepsiburada.net/s/55/375-375/11209823060018.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (21, 5, 'Dyson V15 Detect SÃ¼pÃ¼rge', 'Dyson V15 Detect kablosuz sÃ¼pÃ¼rge', 19999.00, 5, 'https://cdn.akakce.com/z/dyson/dyson-v15-detect-absolute-kablosuz-supurge.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (22, 5, 'IKEA Billy KitaplÄ±k', 'IKEA Billy kitaplÄ±k, beyaz', 599.00, 21, 'https://image-ikea.mncdn.com/urunler/500_500/PE875187.jpg', true, '2026-05-29 14:01:39.304456');
INSERT INTO public.products (id, category_id, name, description, price, stock, image_url, is_active, created_at) VALUES (17, 4, 'Adidas Ultraboost 23', 'Adidas Ultraboost 23, gri/siyah', 2899.00, 56, 'https://assets.adidas.com/images/w_600,f_auto,q_auto/316297fac2c54c689ec192e376e79540_9366/UltraBOOST_23_Ayakkabi_Gri_IE1763_01_standard.jpg', true, '2026-05-29 14:01:39.304456');



INSERT INTO public.users (id, full_name, email, password, phone, address, role, created_at) VALUES (3, 'John Doe', 'john@example.com', '6c1c40a0d4e2c5f3f1f6c9d5e8a2b1c0f3e6d9c2b5a8e1d4c7f0a3b6c9e2f5a', '+90 555 3456789', 'Istanbul', 'customer', '2026-05-29 14:01:39.299619');
INSERT INTO public.users (id, full_name, email, password, phone, address, role, created_at) VALUES (1, 'Admin YÃ¶neticisi', 'admin@ecommerce.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '+90 555 1234567', 'Istanbul', 'admin', '2026-05-29 14:01:39.299619');
INSERT INTO public.users (id, full_name, email, password, phone, address, role, created_at) VALUES (2, 'YiÄŸit Efe AltuntaÅŸ', 'test@gmail.com', '9b8769a4a742959a2d0298c36fb70623f2dfacda8436237df08d8dfd5b37374c', '+90 555 2345678', 'Ankara', 'customer', '2026-05-29 14:01:39.299619');
INSERT INTO public.users (id, full_name, email, password, phone, address, role, created_at) VALUES (4, 'yiÄŸit efe ', 'yigit@gmail.com', '8d80ed939ab547c55ce1b1edc4df13f8fa31082da6cc8568fcd65cbf25a1750e', '5445423432', 'samsun yenimahalle', 'customer', '2026-05-29 21:17:07.31195');
INSERT INTO public.users (id, full_name, email, password, phone, address, role, created_at) VALUES (5, 'efe', 'efe@gmail.com', '8d80ed939ab547c55ce1b1edc4df13f8fa31082da6cc8568fcd65cbf25a1750e', '541231233432', 'asdadasfadads', 'customer', '2026-05-29 21:24:44.949351');
INSERT INTO public.users (id, full_name, email, password, phone, address, role, created_at) VALUES (6, 'YiÄŸit efe altuntaÅŸ', 'ygt@gmail.com', '8d80ed939ab547c55ce1b1edc4df13f8fa31082da6cc8568fcd65cbf25a1750e', '05445772666', 'yenimahalle mah. 3076. sokak bina no4 daire no8', 'customer', '2026-05-29 21:26:28.052723');
INSERT INTO public.users (id, full_name, email, password, phone, address, role, created_at) VALUES (7, 'yiÄŸit', 'yegete@gmail.com', '8d80ed939ab547c55ce1b1edc4df13f8fa31082da6cc8568fcd65cbf25a1750e', '05445772666', 'yenimahalle mah. 3076. sokak bina no4 daire no8', 'customer', '2026-05-29 21:29:01.523052');



SELECT pg_catalog.setval('public.categories_id_seq', 6, true);



SELECT pg_catalog.setval('public.order_items_id_seq', 19, true);



SELECT pg_catalog.setval('public.orders_id_seq', 14, true);



SELECT pg_catalog.setval('public.products_id_seq', 26, true);



SELECT pg_catalog.setval('public.users_id_seq', 7, true);



ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);



ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);



CREATE INDEX idx_orders_user_id ON public.orders USING btree (user_id);



CREATE INDEX idx_products_category_id ON public.products USING btree (category_id);



CREATE INDEX idx_products_is_active ON public.products USING btree (is_active);



CREATE INDEX idx_users_email ON public.users USING btree (email);



ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;



ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;



ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;



\unrestrict kCXy2CxbYqHMIqZOmB6l18mTUBhO4PEFNVEqaNGxCfkQ5cth5l4sE7TEDUfMGqQ

