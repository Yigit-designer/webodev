<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ana Sayfa - E-Ticaret Portalı</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            padding-top: 60px;
            background-color: #f8f9fa;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .navbar-brand {
            font-weight: bold;
            font-size: 24px;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255,255,255,0.9) !important;
            margin-left: 10px;
            transition: color 0.3s;
        }
        
        .nav-link:hover {
            color: white !important;
        }
        
        .cart-badge {
            position: absolute;
            top: 10px;
            right: -10px;
            background-color: #ff6b6b;
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }
        
        .cart-link {
            position: relative;
        }
        
        .category-btn {
            display: block;
            width: 100%;
            text-align: left;
            margin-bottom: 10px;
            transition: all 0.3s;
        }
        
        .category-btn:hover {
            transform: translateX(5px);
            background-color: #f0f0f0;
        }
        
        .product-card {
            transition: transform 0.3s, box-shadow 0.3s;
            height: 100%;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        
        .product-image {
            height: 200px;
            object-fit: cover;
            background-color: #e9ecef;
        }
        
        .price-tag {
            color: #667eea;
            font-weight: bold;
            font-size: 18px;
        }
        
        .sidebar {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .sidebar h5 {
            color: #667eea;
            margin-bottom: 20px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">🛍️ E-Ticaret</a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link cart-link" href="${pageContext.request.contextPath}/cart">
                            🛒 Sepet
                            <c:set var="cartSize" value="${sessionScope.cart != null ? sessionScope.cart.size() : 0}" />
                            <c:if test="${cartSize > 0}">
                                <span class="cart-badge">${cartSize}</span>
                            </c:if>
                        </a>
                    </li>
                    
                    <c:if test="${sessionScope.loggedInUser != null}">
                        <li class="nav-item">
                            <span class="nav-link">👤 ${sessionScope.loggedInUser.fullName}</span>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/order">📋 Siparişlerim</a>
                        </li>
                        <c:if test="${sessionScope.loggedInUser.admin}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">⚙️ Yönetim Paneli</a>
                            </li>
                        </c:if>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">🚪 Çıkış Yap</a>
                        </li>
                    </c:if>
                    
                    <c:if test="${sessionScope.loggedInUser == null}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login">🔑 Giriş Yap</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/register">📝 Kayıt Ol</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Ana İçerik -->
    <div class="container-fluid mt-5">
        <div class="row">
            <!-- Kategori Sidebar -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5>📂 Kategoriler</h5>
                    
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary category-btn">
                        Tümü
                    </a>
                    
                    <c:forEach var="category" items="${categories}">
                        <a href="${pageContext.request.contextPath}/home?categoryId=${category.id}" 
                           class="btn btn-outline-secondary category-btn">
                            ${category.name}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <!-- Ürün Listesi -->
            <div class="col-md-9">
                <!-- Ürün Arama -->
                <div class="card mb-4 shadow-sm">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/home" method="GET" class="row g-2 align-items-center">
                            <div class="col-md-9">
                                <input type="text" name="search" class="form-control"
                                       placeholder="Ürün adı veya açıklama ile ara..."
                                       value="${searchKeyword != null ? searchKeyword : ''}">
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-primary w-100">🔍 Ara</button>
                            </div>
                        </form>
                        <c:if test="${not empty searchKeyword}">
                            <p class="text-muted small mt-2 mb-0">
                                "<strong>${searchKeyword}</strong>" için arama sonuçları
                                — <a href="${pageContext.request.contextPath}/home">tümünü göster</a>
                            </p>
                        </c:if>
                    </div>
                </div>

                <div class="row">
                    <c:choose>
                        <c:when test="${empty products}">
                            <div class="col-12">
                                <div class="alert alert-info text-center mt-5">
                                    <h4>📭 Ürün Bulunamadı</h4>
                                    <p>Şu anda hiçbir ürün mevcut değil. Daha sonra tekrar deneyin.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="product" items="${products}">
                                <div class="col-md-4 mb-4">
                                    <div class="card product-card">
                                        <!-- Ürün Görseli -->
                                        <img src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/300x200?text=' += product.name}" 
                                             alt="${product.name}" class="card-img-top product-image">
                                        
                                        <div class="card-body">
                                            <!-- Ürün Adı -->
                                            <h6 class="card-title">${product.name}</h6>
                                            
                                            <!-- Ürün Açıklaması -->
                                            <p class="card-text text-muted small">
                                                <c:choose>
                                                    <c:when test="${not empty product.description and fn:length(product.description) > 50}">
                                                        ${fn:substring(product.description, 0, 50)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${product.description}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                            
                                            <!-- Fiyat -->
                                            <div class="mb-2">
                                                <span class="price-tag">
                                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" />
                                                </span>
                                            </div>
                                            
                                            <!-- Stok Durumu -->
                                            <div class="mb-3">
                                                <c:choose>
                                                    <c:when test="${product.stock > 0}">
                                                        <small class="text-success">✓ Stokta (${product.stock})</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <small class="text-danger">✗ Stokta Yok</small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <!-- Detay Butonu -->
                                            <a href="${pageContext.request.contextPath}/product?id=${product.id}" 
                                               class="btn btn-primary btn-sm w-100">
                                                👁️ Detaylar
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5>🛍️ E-Ticaret Portalı</h5>
                    <p>Kaliteli ürünler, uygun fiyatlar, hızlı teslimat.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Hızlı Linkler</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-white-50">Ana Sayfa</a></li>
                        <li><a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-white-50">Sepet</a></li>
                        <li><a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-white-50">Giriş Yap</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>İletişim</h5>
                    <p class="text-white-50">
                        📧 info@ecommerce.com<br>
                        📱 (212) 555-1234<br>
                        📍 Istanbul, Türkiye
                    </p>
                </div>
            </div>
            <hr>
            <div class="text-center text-white-50">
                <p>&copy; 2026 E-Ticaret Portalı. Tüm hakları saklıdır.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
