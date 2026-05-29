<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kayıt Ol - E-Ticaret Portalı</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .register-container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 500px;
        }
        
        .register-title {
            color: #667eea;
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
            font-size: 28px;
        }
        
        .form-control {
            border: 1px solid #ddd;
            padding: 10px 15px;
            margin-bottom: 15px;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: bold;
            width: 100%;
            margin-top: 10px;
        }
        
        .btn-register:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            color: white;
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: bold;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1 class="register-title">📝 Kayıt Ol</h1>
        
        <!-- Hata Mesajı -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Hata!</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Başarı Mesajı -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Başarılı!</strong> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Kayıt Formu -->
        <form action="${pageContext.request.contextPath}/register" method="POST">
            <div class="mb-3">
                <label for="fullName" class="form-label">👤 Adı Soyadı</label>
                <input type="text" class="form-control" id="fullName" name="fullName" required>
            </div>
            
            <div class="mb-3">
                <label for="email" class="form-label">📧 Email Adresi</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            
            <div class="mb-3">
                <label for="password" class="form-label">🔐 Şifre</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            
            <div class="mb-3">
                <label for="phone" class="form-label">📱 Telefon (İsteğe Bağlı)</label>
                <input type="tel" class="form-control" id="phone" name="phone">
            </div>
            
            <div class="mb-3">
                <label for="address" class="form-label">📍 Adres (İsteğe Bağlı)</label>
                <textarea class="form-control" id="address" name="address" rows="3"></textarea>
            </div>
            
            <button type="submit" class="btn btn-register btn-primary">Kayıt Ol</button>
        </form>
        
        <!-- Giriş Linki -->
        <div class="login-link">
            <p>Zaten hesabınız var mı? <a href="${pageContext.request.contextPath}/login">Giriş yapın</a></p>
        </div>
        
        <!-- Ana Sayfa Linki -->
        <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">← Ana Sayfaya Dön</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
