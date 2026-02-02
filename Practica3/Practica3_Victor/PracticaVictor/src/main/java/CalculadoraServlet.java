package calculadora;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/calcular")
public class CalculadoraServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter(); 
        
        String user = request.getRemoteUser();
        if (user == null) {
            out.print("{\"ok\":false,\"message\":\"Sesión expirada.\"}");
            return;
        }

        String n1 = request.getParameter("num1");
        String n2 = request.getParameter("num2"); // Nota: n2 no se usa en raíz cuadrada
        String op = request.getParameter("operacion");

        if (n1 == null || op == null) {
            out.print("{\"ok\":false,\"message\":\"Faltan datos.\"}");
            return;
        }

        double a, b = 0;
        try {
            a = Double.parseDouble(n1);
            if (n2 != null && !n2.isEmpty()) {
                b = Double.parseDouble(n2);
            }
        } catch (Exception e) {
            out.print("{\"ok\":false,\"message\":\"Números no válidos.\"}");
            return;
        }

        boolean basica = request.isUserInRole("calc_basic");
        boolean full   = request.isUserInRole("calc_full");

        // Seguridad: Solo el rol 'full' sale de la suma
        if (!(full || (basica && "suma".equals(op)))) {
            out.print("{\"ok\":false,\"message\":\"Acceso denegado. Necesitas rol FULL.\"}");
            return;
        }

        double r;
        switch (op) {
            case "suma": r = a + b; break;
            case "resta": r = a - b; break;
            case "multi": r = a * b; break;
            case "divi": 
                if (b == 0) {
                    out.print("{\"ok\":false,\"message\":\"Error: División por cero.\"}");
                    return;
                }
                r = a / b; 
                break;
            case "potencia": r = Math.pow(a, b); break;
            case "raiz": 
                if (a < 0) {
                    out.print("{\"ok\":false,\"message\":\"Error: Raíz negativa.\"}");
                    return;
                }
                r = Math.sqrt(a); 
                break;
            default:
                out.print("{\"ok\":false,\"message\":\"Operación no válida.\"}");
                return;
        }

        out.print("{\"ok\":true,\"message\":\"Resultado: " + r + "\"}");
    }
}