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
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
    
    @Override
    public void init(ServletConfig config) throws ServletException {

        super.init(config); //To change body of generated methods, choose Tools | Templates.

        conn = BD.getConexion();
    }

    private int existeViaje(String email, String origen, String destino, LocalDateTime fecha) {

        int num = 0;

        try {

            Statement stmt = conn.createStatement();            

            String fecha2 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH").format(fecha);
            
            //No deja publicar un viaje si ya existe un viaje ese mismo dia en el rango de la hora determinado
            String query = "SELECT * FROM viaje WHERE email = '"+  email +"' AND origen = '"+origen+"' AND destino = '"+destino+"' "
                    + "AND fecha LIKE '"+fecha2+":%'";

            ResultSet rs2 = stmt.executeQuery(query);
                      
            System.out.println(query);
            
            if (rs2.next()) {
                num = 1;
                System.out.println("ENCONTRADO TRUE");
            }

        } catch (SQLException e) {
            num = -1;
            e.printStackTrace();
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

        HttpSession s = request.getSession();
        String email = (String) s.getAttribute("email");

        String origen = request.getParameter("origen");
        String destino = request.getParameter("destino");

        String fecha = request.getParameter("fecha");
        String hora = request.getParameter("hora");
       
        fecha = fecha + " " + hora;
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime dateTime = LocalDateTime.parse(fecha, formatter);

        String precio = request.getParameter("precio");

        System.out.println("Datos del Form: " + email + " " + fecha + " " + precio + " " + origen + " " + destino);

        int a = existeViaje(email, origen, destino, dateTime);

        if (a == 1) {

            System.out.println("YA EXISTE!!! el viaje");
            request.setAttribute("Aviso", "No puedes publicar ese viaje");
            request.getRequestDispatcher("PublicarViaje.jsp").forward(request, response);

        } else if (a == -1) {
           
            request.setAttribute("Aviso", "Error en la comprobacion de duplicidad");
            request.getRequestDispatcher("PublicarViaje.jsp").forward(request, response);

        } else if (a == 0) {

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
            request.setAttribute("Aviso", "Viaje publicado correctamente");
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
