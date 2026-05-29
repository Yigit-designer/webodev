<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yönetim Paneli - E-Ticaret Portalı</title>
    
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
        
        .nav-link:hover {
            color: white !important;
        }
        
        .admin-nav {
            background-color: white;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .admin-nav a {
            margin-right: 10px;
            display: inline-block;
        }
        
        .dashboard-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            margin-bottom: 20px;
        }
        
        .dashboard-card h6 {
            font-size: 14px;
            margin-bottom: 10px;
            opacity: 0.9;
        }
        
        .dashboard-number {
            font-size: 32px;
            font-weight: bold;
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

    <!-- Admin Menu -->
    <div class="container mt-4">
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-primary">📊 Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-sm btn-secondary">📂 Kategoriler</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-sm btn-secondary">📦 Ürünler</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-secondary">📋 Siparişler</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-secondary">👥 Kullanıcılar</a>
        </div>

        <!-- Dashboard İstatistikleri -->
        <h1 class="mb-4">📊 Yönetim Paneli</h1>
        
        <div class="row">
            <div class="col-md-3">
                <div class="dashboard-card">
                    <h6>Toplam Ürün</h6>
                    <div class="dashboard-number">${totalProducts}</div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="dashboard-card">
                    <h6>Toplam Kategori</h6>
                    <div class="dashboard-number">${totalCategories}</div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="dashboard-card">
                    <h6>Toplam Sipariş</h6>
                    <div class="dashboard-number">${totalOrders}</div>
                </div>
            </div>
            
            <div class="col-md-3">
                <div class="dashboard-card">
                    <h6>İstatistikler</h6>
                    <div class="dashboard-number">✓</div>
                </div>
            </div>
        </div>

        <!-- Hızlı Erişim Butonları -->
        <div class="row mt-4">
            <div class="col-md-12">
                <h5>Hızlı İşlemler</h5>
                <a href="${pageContext.request.contextPath}/admin/categories?action=add" class="btn btn-success me-2">➕ Yeni Kategori Ekle</a>
                <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn btn-success me-2">➕ Yeni Ürün Ekle</a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-info">📋 Siparişleri Yönet</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
