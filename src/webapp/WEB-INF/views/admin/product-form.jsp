<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ürün Form - Yönetim Paneli</title>
    
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
            max-width: 600px;
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
                <c:if test="${empty product}">➕ Yeni Ürün Ekle</c:if>
                <c:if test="${not empty product}">✏️ Ürünü Düzenle</c:if>
            </h1>

            <!-- Hata Mesajı -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/admin/products" method="POST">
                <input type="hidden" name="action" value="${empty product ? 'add' : 'update'}">
                <c:if test="${not empty product}">
                    <input type="hidden" name="productId" value="${product.id}">
                </c:if>

                <div class="mb-3">
                    <label for="categoryId" class="form-label">📂 Kategori <span class="text-danger">*</span></label>
                    <select class="form-control" id="categoryId" name="categoryId" required>
                        <option value="">-- Kategori Seç --</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}" <c:if test="${not empty product && product.categoryId == category.id}">selected</c:if>>
                                ${category.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="name" class="form-label">📝 Ürün Adı <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="${product.name}" required>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">📄 Açıklama</label>
                    <textarea class="form-control" id="description" name="description" rows="3">${product.description}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="price" class="form-label">💰 Fiyat <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="price" name="price" 
                               value="${not empty product ? product.price : ''}" 
                               min="0" step="0.01" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="stock" class="form-label">📦 Stok <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="stock" name="stock" 
                               value="${not empty product ? product.stock : '0'}" 
                               min="0" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="imageUrl" class="form-label">🖼️ Görsel URL</label>
                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                           value="${product.imageUrl}">
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <c:if test="${empty product}">✓ Ekle</c:if>
                        <c:if test="${not empty product}">✓ Güncelle</c:if>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">← Geri Dön</a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
