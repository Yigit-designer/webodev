<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - E-Ticaret Portalı</title>
    
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
        
        .product-detail {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .product-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            background-color: #e9ecef;
        }
        
        .price-tag {
            color: #667eea;
            font-weight: bold;
            font-size: 32px;
        }
        
        .btn-add-to-cart {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            font-weight: bold;
        }
        
        .btn-add-to-cart:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
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

    <!-- Ürün Detayı -->
    <div class="container mt-5">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary mb-3">← Geri Dön</a>
        
        <div class="product-detail">
            <div class="row">
                <!-- Ürün Görseli -->
                <div class="col-md-5">
                    <img src="${product.imageUrl != null ? product.imageUrl : 'https://via.placeholder.com/500x500?text=' += product.name}" 
                         alt="${product.name}" class="product-image">
                </div>
                
                <!-- Ürün Bilgileri -->
                <div class="col-md-7">
                    <h1>${product.name}</h1>
                    
                    <hr>
                    
                    <!-- Fiyat -->
                    <div class="mb-3">
                        <label class="text-muted">Fiyat</label><br>
                        <span class="price-tag">
                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" />
                        </span>
                    </div>
                    
                    <!-- Açıklama -->
                    <div class="mb-3">
                        <label class="text-muted">Açıklama</label><br>
                        <p>${product.description}</p>
                    </div>
                    
                    <!-- Stok Durumu -->
                    <div class="mb-3">
                        <label class="text-muted">Stok Durumu</label><br>
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span class="badge bg-success">✓ Stokta (${product.stock} adet)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">✗ Stokta Yok</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Sepete Ekle Formu -->
                    <c:if test="${product.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="POST" class="mb-3">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.id}">
                            
                            <div class="input-group mb-3" style="max-width: 300px;">
                                <label class="input-group-text">Adet</label>
                                <input type="number" name="quantity" value="1" min="1" max="${product.stock}" 
                                       class="form-control" required>
                            </div>
                            
                            <button type="submit" class="btn btn-add-to-cart btn-lg">
                                🛒 Sepete Ekle
                            </button>
                        </form>
                    </c:if>
                    
                    <c:if test="${product.stock == 0}">
                        <button class="btn btn-secondary btn-lg" disabled>
                            ✗ Stokta Yok
                        </button>
                    </c:if>
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
