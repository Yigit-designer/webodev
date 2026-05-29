<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kullanıcılar - Yönetim Paneli</title>

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

    <div class="container mt-4">
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-secondary">📊 Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-sm btn-secondary">📂 Kategoriler</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-sm btn-secondary">📦 Ürünler</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-secondary">📋 Siparişler</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-primary">👥 Kullanıcılar</a>
        </div>

        <h1 class="mb-4">👥 Kullanıcılar</h1>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <div class="list-container">
            <c:choose>
                <c:when test="${empty users}">
                    <div class="alert alert-info">Kayıtlı kullanıcı bulunmamaktadır.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover table-striped">
                            <thead class="table-light">
                                <tr>
                                    <th>Kullanıcı ID</th>
                                    <th>Ad Soyad</th>
                                    <th>E-posta</th>
                                    <th>Telefon</th>
                                    <th>Rol</th>
                                    <th>Kayıt Tarihi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td><strong>${user.fullName}</strong></td>
                                        <td>${user.email}</td>
                                        <td>${user.phone != null ? user.phone : '-'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.role == 'admin'}">
                                                    <span class="badge bg-danger">Admin</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-primary">Müşteri</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${user.createdAtAsDate}" pattern="dd.MM.yyyy HH:mm" />
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
