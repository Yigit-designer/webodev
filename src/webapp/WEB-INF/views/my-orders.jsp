<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Siparişlerim - E-Ticaret Portalı</title>
    
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
        
        .orders-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .badge-pending {
            background-color: #ffc107;
        }
        
        .badge-preparing {
            background-color: #0d6efd;
        }
        
        .badge-shipped {
            background-color: #198754;
        }
        
        .badge-delivered {
            background-color: #28a745;
        }
        
        .badge-cancelled {
            background-color: #dc3545;
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

    <!-- Siparişlerim -->
    <div class="container mt-5">
        <h1 class="mb-4">📋 Siparişlerim</h1>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Kapat"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty orders}">
                <div class="alert alert-info text-center">
                    <h4>📭 Henüz Siparış Yok</h4>
                    <p>Ürünler eklemek için <a href="${pageContext.request.contextPath}/home">alışverişe devam edin</a>.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="orders-container">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Sipariş No</th>
                                    <th>Tarih</th>
                                    <th>Toplam Tutar</th>
                                    <th>Durum</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>
                                            <strong>#${order.id}</strong>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${order.orderDateAsDate}" pattern="dd.MM.yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'Beklemede'}">
                                                    <span class="badge badge-pending">⏳ Beklemede</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Hazırlanıyor'}">
                                                    <span class="badge badge-preparing">📦 Hazırlanıyor</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Kargoya Verildi'}">
                                                    <span class="badge badge-shipped">🚚 Kargoya Verildi</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Teslim Edildi'}">
                                                    <span class="badge badge-delivered">✓ Teslim Edildi</span>
                                                </c:when>
                                                <c:when test="${order.status == 'İptal Edildi'}">
                                                    <span class="badge badge-cancelled">✗ İptal Edildi</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
        
        <!-- Geri Butonu -->
        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                ← Alışverişe Devam Et
            </a>
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
