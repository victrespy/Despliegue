<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  response.setHeader("Cache-Control","no-store");

  if (request.getRemoteUser() == null) { response.sendRedirect("login.jsp"); return; }

  boolean basica = request.isUserInRole("calc_basic");
  boolean full   = request.isUserInRole("calc_full");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Calculadora JSP</title>
  <link rel="stylesheet" href="css/estilo.css">
</head>
<body>

<div class="contenedor">
  <div class="cabecera">
    <h2>Calculadora JSP</h2>
    <form method="post" action="<%=request.getContextPath()%>/logout.jsp">
      <button type="submit">Cerrar sesión</button>
    </form>
  </div>

  <form id="formCalc" autocomplete="off">
    <label>Número 1</label>
    <input type="number" name="num1" step="any" required>

    <label>Número 2</label>
    <input type="number" name="num2" step="any" required>

    <label>Operación</label>
    <select name="operacion" required>
      <option value="suma">Suma</option>
      <% if (full) { %>
        <option value="resta">Resta</option>
      <% } %>
    </select>

    <button type="submit">Calcular</button>
  </form>

  <div id="salida" class="resultado" style="display:none;"></div>
</div>

<script>
  const form = document.getElementById("formCalc");
  const salida = document.getElementById("salida");

  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const resp = await fetch("<%=request.getContextPath()%>/calcular", {  // <-- SERVLET
      method: "POST",
      body: new URLSearchParams(new FormData(form)),
      credentials: "same-origin"
    });

    if (!resp.ok) { console.error("Error HTTP:", resp.status); }

    const { message } = await resp.json();
    salida.style.display = "block";
    salida.textContent = message;
  });
</script>

</body>
</html>
