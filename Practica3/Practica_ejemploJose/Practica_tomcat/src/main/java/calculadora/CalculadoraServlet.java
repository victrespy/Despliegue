package calculadora;

/*
  Importamos las clases necesarias de la API de Jakarta Servlet:
  - WebServlet: para mapear la URL del servlet
  - HttpServlet, HttpServletRequest, HttpServletResponse: para manejar peticiones HTTP
*/
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/*
  @WebServlet("/calcular")
  Indica que este servlet responderá a la URL:

      /calcular

  Es decir, cuando el navegador o el JavaScript haga una petición a
  http://localhost:8080/calculadora/calcular
  se ejecutará esta clase.
*/
@WebServlet("/calcular")
public class CalculadoraServlet extends HttpServlet {
    
    /*
      Este método se ejecuta cuando llega una petición HTTP POST.

      POST se usa porque:
      - Se envían datos (num1, num2, operacion)
      - No queremos que la operación vaya en la URL
    */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // La respuesta será JSON y en UTF-8 importante para que el navegador interprete bien el texto.
        response.setContentType("application/json;charset=UTF-8");
        // Obtenemos el "escritor" para enviar texto al cliente
        PrintWriter out = response.getWriter(); 
        
        /*
          Comprobación de sesión:
          getRemoteUser() devuelve el usuario autenticado.
          Si es null, significa que NO hay sesión activa.
        */
        String user = request.getRemoteUser();
        if (user == null) {
            out.print("{\"ok\":false,\"message\":\"Sesión expirada.\"}");
            return;
        }

        // Leemos los parámetros enviados desde el formulario
        String n1 = request.getParameter("num1");
        String n2 = request.getParameter("num2");
        String op = request.getParameter("operacion");
        if (n1 == null || n2 == null || op == null) {
            out.print("{\"ok\":false,\"message\":\"Faltan datos.\"}");
            return;
        }

        // Convertimos los valores de texto a números (double).
        double a, b;
        try {
            a = Double.parseDouble(n1);
            b = Double.parseDouble(n2);
        } catch (Exception e) {
            out.print("{\"ok\":false,\"message\":\"Números no válidos.\"}");
            return;
        }

        //Comprobamos los roles del usuario:
        boolean basica = request.isUserInRole("calc_basic");
        boolean full   = request.isUserInRole("calc_full");

        /*
          Reglas de autorización:
          - Los usuarios "full" pueden hacer cualquier operación
          - Los usuarios "basic" SOLO pueden hacer "suma"
        */
        if (!(full || (basica && "suma".equals(op)))) {
            out.print("{\"ok\":false,\"message\":\"Acceso denegado.\"}");
            return;
        }

        //Realizamos la operación solicitada.
        double r;
        switch (op) {
            case "suma": r = a + b; break;
            case "resta": r = a - b; break;
            default:
                out.print("{\"ok\":false,\"message\":\"Operación no válida.\"}");
                return;
        }

        /*Devolvemos el resultado en formato JSON.
        El frontend (JavaScript) leerá este mensaje y lo mostrará en pantalla.*/
        out.print("{\"ok\":true,\"message\":\"Resultado: " + r + "\"}");
    }
}
