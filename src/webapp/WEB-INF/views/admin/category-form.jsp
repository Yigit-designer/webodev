<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kategori Form - Yönetim Paneli</title>
    
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
        
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            max-width: 500px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">⚙️ YÖNETİM PANELİ</a>
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
        <div class="form-container mx-auto">
            <h1 class="mb-4">
                <c:if test="${empty category}">➕ Yeni Kategori Ekle</c:if>
                <c:if test="${not empty category}">✏️ Kategoriyi Düzenle</c:if>
            </h1>

            <!-- Hata Mesajı -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/admin/categories" method="POST">
                <input type="hidden" name="action" value="${empty category ? 'add' : 'update'}">
                <c:if test="${not empty category}">
                    <input type="hidden" name="categoryId" value="${category.id}">
                </c:if>

                <div class="mb-3">
                    <label for="name" class="form-label">📝 Kategori Adı <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="${category.name}" required>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">📄 Açıklama</label>
                    <textarea class="form-control" id="description" name="description" rows="3">${category.description}</textarea>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <c:if test="${empty category}">✓ Ekle</c:if>
                        <c:if test="${not empty category}">✓ Güncelle</c:if>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary">← Geri Dön</a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
