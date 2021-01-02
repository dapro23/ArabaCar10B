/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package packServlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import packUtilidades.BD;

public class Login extends HttpServlet {

    private Connection conn;

    private int existeUsuario(String email) {

        int num = 0;

        try {

            Statement stmt = conn.createStatement();

            //No deja publicar un viaje si ya existe un viaje ese mismo dia en el rango de la hora determinado
            String query = "select * from usuario where email = '" + email + "';";

            ResultSet rs2 = stmt.executeQuery(query);

            System.out.println(query);
            
            if (rs2.next()) {
                num = 1;
                System.out.println("ENCONTRADO TRUE");
            }

        } catch (SQLException e) {
            num = -1;           
        }
        return num;
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //**********************************
        conn = BD.getConexion();
        Statement st; //<--- sentencia de SQL 
        ResultSet rs; //<--- el resultado de la sentencia

        //**********************************        
        String correo = request.getParameter("email");
        String contra = request.getParameter("password");

        System.out.println("El correo del formulario: " + correo);
        System.out.println("La contraseña del formulario: " + contra);

        if (existeUsuario(correo) == 1) {

            try {
                st = conn.createStatement();
                rs = st.executeQuery("select email, password, coche from usuario");

                while (rs.next()) {

                    String email = rs.getString("email");
                    String password = rs.getString("password");

                    if (correo.equals(email)) {

                        if (contra.equals(password)) {

                            System.out.println("Estas dentro de la BD");

                            HttpSession s = request.getSession();

                            s.setAttribute("email", email);
                            s.setAttribute("password", password);

                            String coche = rs.getString("coche");
                            if (coche != null) {
                                s.setAttribute("coche", coche);
                            }

                            response.sendRedirect("index.jsp");
                            break;
                        } else {

                            //El email no existe
                            request.setAttribute("Aviso", "La clave es incorrecta");
                            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                            rd.include(request, response);
                            break;

                        }

                    }

                }

                rs.close();
                st.close();
            } catch (SQLException ex) {
                System.out.println(ex);
            }

        } else {
            //El email no existe
            request.setAttribute("Aviso", "El email no esta registrado");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.include(request, response);
        }

    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
