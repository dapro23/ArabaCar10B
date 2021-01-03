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
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import packUtilidades.BD;

public class BuscarViajes extends HttpServlet {

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

        String origen = request.getParameter("origen");
        String destino = request.getParameter("destino");
        String fecha = request.getParameter("fecha");
        
        if (origen.equals(destino)) {

            request.setAttribute("Aviso", "Origen y destino no pueden ser iguales");

        } else if (fecha.length() == 0) {

            request.setAttribute("AvisoFecha", "Debes elegir una fecha!");

        } else {

            HttpSession s = request.getSession();
            String email = (String) s.getAttribute("email");

            if (email == null) {
            //no hay ningun usuario logueado

                try {

                    Connection conn = BD.getConexion();
                    PreparedStatement pst;
                    ResultSet rs;
                    
                    String query = "SELECT * FROM viaje WHERE origen = ? and destino = ? and fecha > ? ORDER BY fecha";

                    pst = conn.prepareStatement(query);                    

                    pst.setString(1, origen);
                    pst.setString(2, destino);
                    pst.setString(3, fecha);

                    rs = pst.executeQuery();

                    ArrayList<Viaje> viajes = new ArrayList<>();

                    while (rs.next()) {                        
                        viajes.add(
                                new Viaje(
                                        rs.getString("idviaje"),
                                        rs.getString("origen"),
                                        rs.getString("destino"),
                                        rs.getTimestamp("fecha"),
                                        rs.getDouble("precio")
                                )
                        );

                    }

                    //guardar en el atributo "viajes" el arrayList de viajes
                    //que cumplen el filtro
                    request.setAttribute("viajes", viajes);

                } catch (SQLException e) {
                    e.printStackTrace();
                    System.err.println("Error en la consulta!");
                }

            } else {
                //hay un usuario logueado

                try {
                    Connection conn = BD.getConexion();
                    PreparedStatement pst;
                    ResultSet rs;

                    String query = "SELECT * FROM viaje WHERE origen = ? and destino = ? and fecha > ? AND email <> ? AND idviaje NOT IN (SELECT idviaje FROM reservaviaje WHERE email = ?) ORDER BY fecha";

                    pst = conn.prepareStatement(query);                    

                    pst.setString(1, origen);
                    pst.setString(2, destino);
                    pst.setString(3, fecha);
                    pst.setString(4, email);
                    pst.setString(5, email);

                    rs = pst.executeQuery();

                    ArrayList<Viaje> viajes = new ArrayList<>();

                    while (rs.next()) {
                        
                        PreparedStatement pst2;
                        ResultSet rs2;                      
                                                
                        String query2 = "SELECT nombre, movil FROM usuario WHERE email = ?";                                               

                        pst2 = conn.prepareStatement(query2);
                        
                        pst2.setString(1, rs.getString("email"));
                        
                        rs2 = pst2.executeQuery();
                        
                        rs2.next();
                        
                        String nombre = rs2.getString("nombre");
                        String movil = rs2.getString("movil");
                        
                        //public Viaje(String id, String nombre, String conductor, String movil, String origen, String destino, Timestamp fecha, double precio) {
                        viajes.add(
                                new Viaje(
                                        rs.getString("idviaje"),
                                        nombre,
                                        rs.getString("email"),
                                        movil,
                                        rs.getString("origen"),
                                        rs.getString("destino"),
                                        rs.getTimestamp("fecha"),
                                        rs.getDouble("precio")
                                )
                        );

                    }
                    
                    request.setAttribute("viajes", viajes);

                } catch (SQLException e) {
                    e.printStackTrace();
                    System.err.println("Error en la consulta!");
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
