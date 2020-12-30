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
public class PublicarViaje extends HttpServlet {

    private Connection conn;   
    private PreparedStatement pst;
    private PreparedStatement pst2;
    private ResultSet rs;
    private ResultSet rs2;
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        
        super.init(config); //To change body of generated methods, choose Tools | Templates.

        conn = BD.getConexion();
    }
    
    private boolean existeViaje(String email, String origen, String destino, String fecha) {
        
        boolean enc = false;
        
        try {
            
            String query = "SELECT * FROM viaje WHERE email = ? AND origen = ? AND destino = ? AND fecha = ?;";
          
          
            pst2 = conn.prepareStatement(query);

            pst2.setString(1, email);

            pst2.setString(2, origen);

            pst2.setString(3, destino);

            pst2.setString(4, fecha);                     
           
            rs2 = pst2.executeQuery(query);

            //if ( rs.getRow() == 1 )
            if (rs2.next()) {
                enc = true;
                System.out.println("ENCONTRADO TRUE");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return enc;
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
        
        HttpSession s = request.getSession();       
        String email = (String) s.getAttribute("email");
        
        String origen = request.getParameter("origen");
        String destino = request.getParameter("destino");
        
        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");        
        
        fecha = fecha + " " + hora + ":00";
        
        String precio = request.getParameter("precio");
        
        System.out.println("Datos del Form: " + email + " "+ fecha + " " + precio + " " + origen + " " + destino);       
        
        
        if (false /*existeViaje(email, origen, destino, fecha)*/) {

            System.out.println("YA EXISTE!!! el viaje");

        } else {

            try {
                
                String query = "INSERT INTO viaje (`email`,`origen`,`destino`,`fecha`,`precio`) VALUES (?, ?, ?, ?, ?);";

                pst = conn.prepareStatement(query);

                pst.setString(1, email);
                
                pst.setString(2, origen);
               
                pst.setString(3, destino);
                               
                pst.setString(4, fecha);                         
                                           
                pst.setString(5, precio);                       
                                
                pst.executeUpdate();                
                                                   
            } catch (SQLException ex) {
                Logger.getLogger(RegistrarUsuario.class.getName()).log(Level.SEVERE, null, ex);
            }

            request.getRequestDispatcher("PublicarViaje.jsp").forward(request, response);
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
