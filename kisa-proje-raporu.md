# Kisa Proje Raporu

## Projenin Amaci
Java tabanli, standart MVC mimarisi ile temel duzeyde calisan, kullanici ve admin yetkilerine sahip bir e-ticaret sisteminin gelistirilmesi hedeflenmistir. Projede kullanicilarin urunleri listeleyebilmesi, sepete ekleyebilmesi ve siparis olusturabilmesi; yonetici tarafinda ise kategori, urun ve siparis yonetimi yapilabilmesi amaclanmistir.

## Kullanilan Teknolojiler
Projede modern frameworkler (Spring, Hibernate vb.) kullanilmamistir. Uygulama su teknolojilerle gelistirilmistir:
- Java (Servlet tabanli mimari)
- JSP ve JSTL (gorsel katman ve dinamik veri gosterimi)
- PostgreSQL (veritabani)
- JDBC (veritabani baglantisi ve sorgular)
- Apache Tomcat (uygulama sunucusu)
- Bootstrap 5 (arayuz tasarimi)
- SHA-256 (PasswordUtil uzerinden sifre hashleme)

## Veritabani Tasarimi
Veritabani bes ana tablodan olusmaktadir:
- users: Kullanici bilgileri. Primary Key: id
- categories: Kategori bilgileri. Primary Key: id
- products: Urun bilgileri. Primary Key: id, Foreign Key: category_id -> categories(id)
- orders: Siparis bilgileri. Primary Key: id, Foreign Key: user_id -> users(id)
- order_items: Siparis kalemleri. Primary Key: id, Foreign Key: order_id -> orders(id), product_id -> products(id)

Bu tasarim ile urunler kategorilere baglanmis, siparisler kullanicilara baglanmis ve siparis kalemleri ile urun/siparis iliskileri normalize edilmistir.

## MVC Mimarisi Aciklamasi
Proje klasik MVC mantigina uygun olarak katmanlara ayrilmistir:
- Model: User, Product, Category, Order, OrderItem ve CartItem siniflari is kurallarini ve veri yapilarini temsil eder.
- DAO: UserDAO, ProductDAO, CategoryDAO ve OrderDAO siniflari JDBC araciligi ile veritabani islemlerini yurutur.
- Controller: Servlet siniflari (HomeServlet, ProductServlet, CartServlet, OrderServlet, LoginServlet, RegisterServlet, admin servletleri) is akisini yonetir ve ilgili veri setlerini view katmanina aktarir.
- View: JSP sayfalari JSTL etiketleri ile dinamik veri gosterimi yapar; UI katmani yalnizca gorsel sunumdan sorumludur.

Bu ayrim sayesinde is mantigi, veri erisimi ve arayuz sorumluluklari net olarak ayrilmis, surdurulebilir bir mimari elde edilmistir.

## Ekran Goruntuleri
- [Ana Sayfa Ekran Goruntusu Eklenecek]
- [Admin Paneli Goruntusu Eklenecek]

## Karsilasilan Problemler
1. UTF-8 (Turkce karakter) encoding sorunlari: Formlardan gelen verilerde ve veritabani kayitlarinda karakter bozulmalari goruldu. Bu sorun EncodingFilter ile cozulerek tum isteklerde request/response UTF-8 olarak ayarlandi.
2. NullPointerException kaynakli 500 hatalari: Ozellikle ResultSet okumalarinda ve OrderDAO icindeki transaction sureclerinde ortaya cikan hatalar try-catch bloklari ile yakalanip guvenli hale getirildi; servislerin hata durumunda kontrollu cevap donmesi saglandi.
3. Urun gorsel URL uzunluklari: Disaridan cekilen gorsel URL'leri veritabani alan sinirlarini asma riski tasidi. Bu problem URL uzunlugu icin uygun alan boyutu belirlenerek giderildi.

## Sonuc
Proje basariyla tamamlanmis, MVC mantigi ve JSTL kullanimi etkin bir sekilde uygulanmistir. Kullanici ve admin rolleri arasindaki yetkilendirme, veritabani islemleri ve arayuz katmani arasindaki baglar akademik gereksinimlere uygun sekilde kurgulanmistir. Uygulama, klasik Java Servlet ve JSP yapisi ile gelistirilmis olmasina ragmen temiz bir mimari ve surdurulebilir kod yapisi ile teslim edilebilir durumdadir.
