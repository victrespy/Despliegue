<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Verificamos si el usuario está autenticado, si no, al login
    if (request.getRemoteUser() == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    boolean esFull = request.isUserInRole("calc_full");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Calculadora PRO - Panel</title>
    <link rel="stylesheet" href="css/estilo.css">
</head>
<body>
    <div class="contenedor">
        <div class="cabecera-app">
            <h3>Bienvenido, <%= request.getRemoteUser() %></h3>
            <a href="logout.jsp" class="btn-logout">Cerrar Sesión</a>
        </div>

        <h2>Calculadora</h2>
        
        <div class="calculadora-form">
            <input type="number" id="num1" placeholder="Número 1">
            <input type="number" id="num2" placeholder="Número 2">
            
            <div class="grid-operaciones">
                <button onclick="operar('suma')">+</button>
                
                <%-- Operaciones protegidas: el usuario básico verá un candado o mensaje --%>
                <button onclick="operar('resta')" <%= !esFull ? "disabled title='Solo modo FULL'" : "" %>>-</button>
                <button onclick="operar('multi')" <%= !esFull ? "disabled title='Solo modo FULL'" : "" %>>x</button>
                <button onclick="operar('divi')" <%= !esFull ? "disabled title='Solo modo FULL'" : "" %>>/</button>
                <button onclick="operar('potencia')" <%= !esFull ? "disabled title='Solo modo FULL'" : "" %>>^</button>
                <button onclick="operar('raiz')" <%= !esFull ? "disabled title='Solo modo FULL'" : "" %>>√</button>
            </div>
        </div>

        <div id="resultado" class="resultado-box">
            Esperando operación...
        </div>
    </div>

    <script>
        async function operar(op) {
            const n1 = document.getElementById('num1').value;
            const n2 = document.getElementById('num2').value;
            const resDiv = document.getElementById('resultado');

            // Enviamos los datos al Servlet usando POST
            const response = await fetch('calcular', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `num1=${n1}&num2=${n2}&operacion=${op}`
            });

            const data = await response.json();
            
            if(data.ok) {
                resDiv.innerHTML = "<strong>" + data.message + "</strong>";
                resDiv.style.color = "#00d4ff";
            } else {
                resDiv.innerHTML = "❌ " + data.message;
                resDiv.style.color = "#ff4d4d";
            }
        }
    </script>
</body>
</html>