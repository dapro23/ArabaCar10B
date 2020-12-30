/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package packServlets;

import java.io.IOException;
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
public class EliminarReserva extends HttpServlet {

    private Connection con;
    private PreparedStatement pst1;

    @Override
    public void init(ServletConfig config) throws ServletException {

        super.init(config); //To change body of generated methods, choose Tools | Templates.

        con = BD.getConexion();
    }
    
    public boolean comprobarNumPasajeros(String idviaje) {
        boolean out = false;

        //hacer la select de los viajes desde esa fecha
        try {
            ResultSet rs;
            
            PreparedStatement pst2;

            String query = "SELECT COUNT(*) FROM reservaviaje WHERE idviaje=?;";

            pst2 = con.prepareStatement(query);

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

        String id = request.getParameter("idviaje");      
                
        HttpSession s = request.getSession();       
        String email = (String) s.getAttribute("email");
        
        System.out.println("Datos del Form: " + id + "Email del Seassion " + email);

        try {

            String query = "DELETE FROM reservaviaje WHERE email = ? AND idviaje = ?;";

            pst1 = con.prepareStatement(query);

            pst1.setString(1, email);
            pst1.setString(2, id);
            

            int i = pst1.executeUpdate();
            if (i != 0) {                
                System.out.println("Reserva Eliminadao");
            }else if(comprobarNumPasajeros(id)){                
                request.setAttribute("Aviso", "El num de plzasa disponibles no ha aumentado");
            }else{
                request.setAttribute("Aviso", "La Reserva a eliminar no existe");
            }

        } catch (SQLException ex) {
            Logger.getLogger(RegistrarUsuario.class.getName()).log(Level.SEVERE, null, ex);
        }

        request.getRequestDispatcher("EliminarReserva.jsp").forward(request, response);

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
