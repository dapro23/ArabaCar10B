/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package packServlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import packUtilidades.BD;

/**
 *
 * @author dramo
 */
public class RealizarReserva extends HttpServlet {

    private Connection conn;
    private PreparedStatement pst1;
    private PreparedStatement pst2;
    private ResultSet rs;

    @Override
    public void init(ServletConfig config) throws ServletException {

        super.init(config); //To change body of generated methods, choose Tools | Templates.

        conn = BD.getConexion();
    }

    public boolean comprobarNumPasajeros(String idviaje) {
        boolean out = false;

        //hacer la select de los viajes desde esa fecha
        try {

            String query = "SELECT COUNT(*) FROM reservaviaje WHERE idviaje=?;";

            pst2 = conn.prepareStatement(query);

            pst2.setString(1, idviaje);

            rs = pst2.executeQuery();

            rs.next();

            int num = rs.getInt(1);

            System.out.println("Num pasajeros " + num);

            if (num >= 3) {
                System.out.println("El viaje esta lleno");
                out = true;
            }

        } catch (SQLException ex) {
            Logger.getLogger(RegistrarUsuario.class.getName()).log(Level.SEVERE, null, ex);
        }

        return out;

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

        //System.out.println( request, "" + " "));
        HttpSession s = request.getSession();
        String email = (String) s.getAttribute("email");

        String idviaje = request.getParameter("botondetalles"); //falta sacar el id del viaje para realizar la reserva

        System.out.println("idviaje: " + idviaje);

        if (email == null) {

            request.setAttribute("avisoReserva", "Inicia sesion para apunatarte a un viaje");

        } else {

            if (comprobarNumPasajeros(idviaje)) {

                request.setAttribute("avisoReserva", "El viaje seleccionado ya esta lleno");

            } else {

                try {

                    String query = "INSERT INTO reservaviaje (`email`,`idviaje`,`fecha`) VALUES (?, ?, CURRENT_TIMESTAMP());";

                    pst1 = conn.prepareStatement(query);

                    pst1.setString(1, email);

                    pst1.setString(2, idviaje);

                    int num = pst1.executeUpdate();

                    if (num != 0) {
                        request.setAttribute("avisoReserva", "La reserva se ha relizado");
                    } else {
                        request.setAttribute("avisoReserva", "La reserva NO se ha relizado");
                    }

                } catch (SQLException ex) {
                    Logger.getLogger(RegistrarUsuario.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("avisoReserva", "Error al ejecutar la sentencia SQL");
                }
            }
        }
        request.getRequestDispatcher("BuscarViajes.jsp").forward(request, response);

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
