package packServlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import packUtilidades.BD;

@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class RegistrarUsuario extends HttpServlet {

    private Connection conn;
    private Statement st;
    private PreparedStatement pst;
    private ResultSet rs; //para consultar si existe ese usuario previamente

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config); //To change body of generated methods, choose Tools | Templates.

        conn = BD.getConexion();
    }

    private boolean existeUsuario(String email) {
        boolean enc = false;
        try {
            String query = "select * from usuario where email = '" + email + "'";
            st = conn.createStatement();
            rs = st.executeQuery(query);
           
            if (rs.next()) {
                enc = true;
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
        
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");

        if (existeUsuario(email)) {            
            request.setAttribute("Aviso", "Ya existe un usuario registrado con los mismos datos");
        } else {

            try {

                String query = "INSERT INTO usuario (`email`,`password`,`nombre`,`apellidos`,`dni`,`foto`,`movil`,`edad`,`coche`) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?);";

                pst = conn.prepareStatement(query);

                pst.setString(1, email);

                String password = request.getParameter("password");
                pst.setString(2, password);

                String nombre = request.getParameter("nombre");
                pst.setString(3, nombre);

                String apellidos = request.getParameter("apellidos");
                pst.setString(4, apellidos);

                String dni = request.getParameter("dni");
                pst.setString(5, dni);

                //**************************************************        
                Part filePart = request.getPart("foto");
                InputStream inputStream = filePart.getInputStream();
                pst.setBlob(6, inputStream);
                //**************************************************

                String movil = request.getParameter("movil");
                pst.setString(7, movil);

                String edad = request.getParameter("edad");
                pst.setString(8, edad);

                String coche = request.getParameter("coche");
                pst.setString(9, coche);

                int num = pst.executeUpdate();

                if (num != 0) {
                    request.setAttribute("Aviso", "Usuario agregado correctamente");
                }

            } catch (SQLException ex) {
                request.setAttribute("Aviso", "Error inesperado");
                Logger.getLogger(RegistrarUsuario.class.getName()).log(Level.SEVERE, null, ex);
            }

            //request.setAttribute("Aviso", "Ya existe un usuario con los mismos datos");
        }

        request.getRequestDispatcher("loginRegister.jsp").forward(request, response);
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
