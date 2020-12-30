/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package packServlets;

import java.io.IOException;
import java.io.PrintWriter;
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
        Connection conn = BD.getConexion();
        Statement st; //<--- sentencia de SQL 
        ResultSet rs; //<--- el resultado de la sentencia

        //**********************************        
        String correo = request.getParameter("email");
        String contra = request.getParameter("password");

        System.out.println("El correo del formulario: " + correo);
        System.out.println("La contraseña del formulario: " + contra);

        try {
            st = conn.createStatement();
            rs = st.executeQuery("select email,password,coche from usuario");

            boolean existe = true;

            while (rs.next()) {

                String email = rs.getString("email");
                String contraa = rs.getString("password");

                if (correo.equals(email) && contra.equals(contraa)) {

                    existe = false;

                    System.out.println("Estas dentro de la BD");

                    HttpSession s = request.getSession();

                    s.setAttribute("email", email);
                    s.setAttribute("password", contra);

                    String coche = rs.getString("coche"); //<-- recupera de la BD el campo coche
                    if (coche != null) {
                        s.setAttribute("coche", coche);
                    }

                    //se ven los datos en la direccion
                    //request.getRequestDispatcher("indexlogueado.html").forward(request, response);
                    response.sendRedirect("index.jsp");
                }
            }
            if (existe == true) {
                
                request.setAttribute("Aviso", "Informacion de Login Incorrecta");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.include(request, response);
                
            }

            rs.close();
            st.close();
        } catch (SQLException ex) {
            System.out.println(ex);
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
