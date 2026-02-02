<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  //Evita que el navegador guarde la página en caché.
  response.setHeader("Cache-Control","no-store");

  //Comprobamos si hay un usuario autenticado.
  if (request.getRemoteUser() == null) { response.sendRedirect("login.jsp"); return; }

  //Comprobamos los roles del usuario
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
  <!-- Cabecera con el título y el botón de cerrar sesión -->
  <div class="cabecera">
    <h2>Calculadora JSP</h2>  
    <!--Formulario para cerrar sesión.Se envía por POST a logout.jsp-->
    <form method="post" action="<%=request.getContextPath()%>/logout.jsp">
      <button type="submit">Cerrar sesión</button>
    </form>
  </div>
  <!--Formulario principal de la calculadora.-->
  <form id="formCalc" autocomplete="off">
    <label>Número 1</label>
    <input type="number" name="num1" step="any" required>

    <label>Número 2</label>
    <input type="number" name="num2" step="any" required>

    <label>Operación</label>
    <select name="operacion" required>
      <option value="suma">Suma</option>
      <!--Solo mostramos la opción "resta" si el usuario tiene el rol calc_full-->
      <% if (full) { %>
        <option value="resta">Resta</option>
      <% } %>
    </select>

    <button type="submit">Calcular</button>
  </form>
  <!--resultado devuelto por el servlet-->
  <div id="salida" class="resultado" style="display:none;"></div>
</div>

<script>
  //referencias al formulario y al div del resultado
  const form = document.getElementById("formCalc");
  const salida = document.getElementById("salida");

  /*
    Cuando el usuario pulsa "Calcular":
    - Evitamos el envío normal del formulario
    - Enviamos los datos por fetch (AJAX)
  */
  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    /*
      Enviamos los datos al servlet /calcular usando POST.
      request.getContextPath() añade automáticamente el nombre del proyecto.
    */
    const resp = await fetch("<%=request.getContextPath()%>/calcular", {  // <-- SERVLET
      method: "POST",
      body: new URLSearchParams(new FormData(form)),
      credentials: "same-origin"
    });
    if (!resp.ok) { console.error("Error HTTP:", resp.status); }

    //Leemos la respuesta JSON del servlet y mostramos el resultado por pantalla
    const { message } = await resp.json();
    salida.style.display = "block";
    salida.textContent = message;
  });
</script>

</body>
</html>
