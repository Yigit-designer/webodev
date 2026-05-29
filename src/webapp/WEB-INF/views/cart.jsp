<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sepet - E-Ticaret Portalı</title>
    
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
        
        .cart-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .cart-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .total-amount {
            color: #667eea;
            font-weight: bold;
            font-size: 24px;
        }
        
        .btn-checkout {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            font-weight: bold;
        }
        
        .btn-checkout:hover {
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

    <!-- Sepet İçeriği -->
    <div class="container mt-5">
        <h1 class="mb-4">🛒 Sepetim</h1>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Kapat"></button>
            </div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty cart}">
                <div class="alert alert-info text-center">
                    <h4>📭 Sepetiniz Boş</h4>
                    <p>Ürünler eklemek için <a href="${pageContext.request.contextPath}/home">ana sayfaya</a> dönün.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cart-container">
                    <!-- Sepet Tablosu -->
                    <div class="table-responsive mb-4">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Ürün Adı</th>
                                    <th>Birim Fiyat</th>
                                    <th>Adet</th>
                                    <th>Toplam</th>
                                    <th>İşlem</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="grandTotal" value="0" />
                                <c:forEach var="item" items="${cart}">
                                    <tr>
                                        <td><strong>${item.productName}</strong></td>
                                        <td>
                                            <fmt:formatNumber value="${item.productPrice}" type="currency" currencySymbol="₺" />
                                        </td>
                                        <td>
                                            <!-- Adet Güncelleme Formu -->
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" 
                                                  class="d-flex gap-2" style="width: 120px;">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <input type="number" name="quantity" value="${item.quantity}" 
                                                       min="1" max="${item.product.stock}" class="form-control form-control-sm">
                                                <button type="submit" class="btn btn-sm btn-info">✓</button>
                                            </form>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₺" />
                                        </td>
                                        <td>
                                            <!-- Silme Formu -->
                                            <form action="${pageContext.request.contextPath}/cart" method="POST" style="display: inline;">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="productId" value="${item.productId}">
                                                <button type="submit" class="btn btn-danger btn-sm">🗑️ Sil</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <c:set var="grandTotal" value="${grandTotal + item.subtotal}" />
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Özet -->
                    <div class="cart-summary mb-4">
                        <div class="row">
                            <div class="col-md-8"></div>
                            <div class="col-md-4">
                                <div class="d-flex justify-content-between mb-3">
                                    <strong>Genel Toplam:</strong>
                                    <span class="total-amount">
                                        <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₺" />
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- İşlem Butonları -->
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                            ← Alışverişe Devam Et
                        </a>
                        
                        <c:if test="${sessionScope.loggedInUser != null}">
                            <form action="${pageContext.request.contextPath}/order" method="POST" style="margin-left: auto;">
                                <button type="submit" class="btn btn-checkout btn-lg">
                                    ✓ Siparişi Tamamla
                                </button>
                            </form>
                        </c:if>
                        
                        <c:if test="${sessionScope.loggedInUser == null}">
                            <div style="margin-left: auto;">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-checkout btn-lg">
                                    Giriş Yap & Siparişi Tamamla
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
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
