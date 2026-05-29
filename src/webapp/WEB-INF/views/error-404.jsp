<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sayfa Bulunamadı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100">
    <div class="text-center">
        <h1 class="display-4">404</h1>
        <p class="lead">Aradığınız sayfa bulunamadı.</p>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Ana Sayfaya Dön</a>
    </div>
</body>
</html>
