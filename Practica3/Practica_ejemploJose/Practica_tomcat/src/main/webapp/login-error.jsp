<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Error de login</title>
  <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
  <div class="contenedor">
    <h2>Error de autenticación</h2>
    <div class="error">Usuario o contraseña incorrectos.</div>
    <p><a class="btn-sec" href="<%=request.getContextPath()%>/login.jsp">Volver</a></p>
  </div>
</body>
</html>
