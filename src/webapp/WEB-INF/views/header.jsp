<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Ticaret Portalı</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Özel CSS -->
    <style>
        body {
            padding-top: 60px;
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
                    <!-- Sepet Linki -->
                    <li class="nav-item">
                        <a class="nav-link cart-link" href="${pageContext.request.contextPath}/cart">
                            🛒 Sepet
                            <c:set var="cartSize" value="${sessionScope.cart != null ? sessionScope.cart.size() : 0}" />
                            <c:if test="${cartSize > 0}">
                                <span class="cart-badge">${cartSize}</span>
                            </c:if>
                        </a>
                    </li>
                    
                    <!-- Giriş Yapılmış Kullanıcı -->
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
                    
                    <!-- Giriş Yapmamış Kullanıcı -->
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
</body>
</html>
