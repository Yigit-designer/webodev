<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kategoriler - Yönetim Paneli</title>
    
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
        
        .list-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-secondary">📊 Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-sm btn-primary">📂 Kategoriler</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-sm btn-secondary">📦 Ürünler</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-secondary">📋 Siparişler</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-secondary">👥 Kullanıcılar</a>
        </div>

        <!-- Kategoriler Listesi -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>📂 Kategoriler</h1>
            <a href="${pageContext.request.contextPath}/admin/categories?action=add" class="btn btn-success">➕ Yeni Kategori Ekle</a>
        </div>

        <div class="list-container">
            <c:choose>
                <c:when test="${empty categories}">
                    <div class="alert alert-info">Hiçbir kategori bulunmamaktadır.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Adı</th>
                                    <th>Açıklama</th>
                                    <th>Durum</th>
                                    <th>İşlemler</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="category" items="${categories}">
                                    <tr>
                                        <td>${category.id}</td>
                                        <td><strong>${category.name}</strong></td>
                                        <td>${category.description}</td>
                                        <td>
                                            <c:if test="${category.active}">
                                                <span class="badge bg-success">✓ Aktif</span>
                                            </c:if>
                                            <c:if test="${not category.active}">
                                                <span class="badge bg-danger">✗ Pasif</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/categories?action=edit&categoryId=${category.id}" 
                                               class="btn btn-sm btn-primary">✏️ Düzenle</a>
                                            
                                            <form action="${pageContext.request.contextPath}/admin/categories" method="POST" 
                                                  style="display: inline;" 
                                                  onsubmit="return confirm('Silmek istediğinizden emin misiniz?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="categoryId" value="${category.id}">
                                                <button type="submit" class="btn btn-sm btn-danger">🗑️ Sil</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
