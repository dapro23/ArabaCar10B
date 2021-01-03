/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package packServlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import packUtilidades.BD;

/**
 *
 * @author dramo
 */
public class EliminarViaje extends HttpServlet {

    private Connection con;
    private PreparedStatement pst1;

    @Override
    public void init(ServletConfig config) throws ServletException {

        super.init(config); //To change body of generated methods, choose Tools | Templates.

        con = BD.getConexion();
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
        
        response.setContentType("text/html;charset=UTF-8");

        String id = request.getParameter("botondetalles");

        System.out.println("Datos del Form: " + id);

        try {

            String query = "DELETE FROM viaje WHERE idviaje = ?;";

            pst1 = con.prepareStatement(query);

            pst1.setString(1, id);

            int i = pst1.executeUpdate();
            if (i == 1) {
                request.setAttribute("Aviso", "Viaje Eliminado");
            } else if (i != 0) {                
                request.setAttribute("Aviso", "El viaje con id: (" + id + ") no fue eliminado");
            }

        } catch (SQLException ex) {
            Logger.getLogger(RegistrarUsuario.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("Aviso", "Error al eliminar el viaje");
        }

        request.getRequestDispatcher("EliminarViaje.jsp").forward(request, response);

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
