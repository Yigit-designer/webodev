<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sipariş Detayı - Yönetim Paneli</title>
    
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
            font-size: 20px;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255,255,255,0.9) !important;
            margin-left: 10px;
            font-size: 14px;
        }
        
        .detail-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .info-card {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">⚙️ YÖNETİM PANELİ</a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="nav-link">👤 ${sessionScope.loggedInUser.fullName}</span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">🏠 Siteye Dön</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">🚪 Çıkış Yap</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <!-- Geri Butonu -->
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-secondary mb-3">← Siparişlere Dön</a>

        <div class="detail-container">
            <h1 class="mb-4">📋 Sipariş #${order.id} Detayı</h1>

            <!-- Sipariş Bilgileri -->
            <div class="info-card">
                <div class="row">
                    <div class="col-md-6">
                        <strong>Sipariş No:</strong> #${order.id}<br>
                        <strong>Müşteri ID:</strong> ${order.userId}<br>
                        <strong>Sipariş Tarihi:</strong> <fmt:formatDate value="${order.orderDateAsDate}" pattern="dd.MM.yyyy HH:mm" />
                    </div>
                    <div class="col-md-6">
                        <strong>Toplam Tutar:</strong> 
                        <span style="color: #667eea; font-weight: bold; font-size: 18px;">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" />
                        </span><br>
                        <strong>Durum:</strong>
                        <c:choose>
                            <c:when test="${order.status == 'Beklemede'}">
                                <span class="badge bg-warning">⏳ Beklemede</span>
                            </c:when>
                            <c:when test="${order.status == 'Hazırlanıyor'}">
                                <span class="badge bg-info">📦 Hazırlanıyor</span>
                            </c:when>
                            <c:when test="${order.status == 'Kargoya Verildi'}">
                                <span class="badge bg-primary">🚚 Kargoya Verildi</span>
                            </c:when>
                            <c:when test="${order.status == 'Teslim Edildi'}">
                                <span class="badge bg-success">✓ Teslim Edildi</span>
                            </c:when>
                            <c:when test="${order.status == 'İptal Edildi'}">
                                <span class="badge bg-danger">✗ İptal Edildi</span>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Sipariş Ürünleri -->
            <h5 class="mb-3">📦 Sipariş Ürünleri</h5>
            
            <c:choose>
                <c:when test="${empty orderItems}">
                    <div class="alert alert-info">Hiçbir ürün bulunmamaktadır.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive mb-4">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Ürün ID</th>
                                    <th>Adet</th>
                                    <th>Birim Fiyat</th>
                                    <th>Toplam</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${orderItems}">
                                    <tr>
                                        <td>${item.productId}</td>
                                        <td>${item.quantity}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₺" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₺" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Durum Güncelleme Formu -->
            <h5 class="mb-3">🔄 Sipariş Durumunu Güncelle</h5>
            
            <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="mb-3">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="orderId" value="${order.id}">
                
                <div class="row">
                    <div class="col-md-6">
                        <label for="status" class="form-label">Yeni Durum</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="Beklemede" <c:if test="${order.status == 'Beklemede'}">selected</c:if>>⏳ Beklemede</option>
                            <option value="Hazırlanıyor" <c:if test="${order.status == 'Hazırlanıyor'}">selected</c:if>>📦 Hazırlanıyor</option>
                            <option value="Kargoya Verildi" <c:if test="${order.status == 'Kargoya Verildi'}">selected</c:if>>🚚 Kargoya Verildi</option>
                            <option value="Teslim Edildi" <c:if test="${order.status == 'Teslim Edildi'}">selected</c:if>>✓ Teslim Edildi</option>
                            <option value="İptal Edildi" <c:if test="${order.status == 'İptal Edildi'}">selected</c:if>>✗ İptal Edildi</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-success w-100">✓ Durumu Güncelle</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
