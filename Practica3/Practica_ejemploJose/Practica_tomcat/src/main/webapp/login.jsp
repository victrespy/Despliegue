<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  response.setHeader("Cache-Control","no-store");

  if (request.getRemoteUser() != null) {
    response.sendRedirect("index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Login - Calculadora</title>
  <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
  <div class="contenedor">
    <h2>Iniciar sesión</h2>

    <form method="post" action="<%=request.getContextPath()%>/j_security_check" autocomplete="off">
      <label>Usuario</label>
      <input name="j_username" required
       oninput="this.value=this.value.replace(/\s+/g,'')">

      <label>Contraseña</label>
      <input type="password" name="j_password" required
       oninput="this.value=this.value.replace(/\s+/g,'')">

      <button type="submit">Entrar</button>
    </form>

    <div class="nota">
      <p><b>Usuarios de prueba:</b></p>
      <ul>
        <li><b>basic_user</b> / 123</li>
        <li><b>full_user</b> / 321</li>
      </ul>
    </div>
  </div>
</body>
</html>