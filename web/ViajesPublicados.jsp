
<%@page import="java.util.Base64"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="packUtilidades.BD"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="packServlets.Viaje"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        //https://stackoverflow.com/questions/15784069/getdatetime-from-resultset-java/21860779

        HttpSession s = request.getSession();
        String email = (String) s.getAttribute("email");

        ArrayList<Viaje> viajesPasados = new ArrayList<>();
        ArrayList<Viaje> viajesFuturos = new ArrayList<>();

        String mensaje = "Fecha actual: " + DateTimeFormatter.ofPattern("dd/MM/yyyy").format(LocalDate.now());

        Connection conn = BD.getConexion();

        try {

            PreparedStatement pst1;
            ResultSet rs1;

            String query1 = "SELECT * FROM viaje WHERE email = ? AND fecha < current_date() ORDER BY fecha";

            pst1 = conn.prepareStatement(query1);

            pst1.setString(1, email);

            rs1 = pst1.executeQuery();

            while (rs1.next()) {

                viajesPasados.add(
                        new Viaje(
                                rs1.getString("idviaje"),
                                rs1.getString("origen"),
                                rs1.getString("destino"),
                                rs1.getTimestamp("fecha"),
                                rs1.getDouble("precio")
                        )
                );

            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error en la consulta 1 !");
        }

        try {

            PreparedStatement pst2;
            ResultSet rs2;

            String query2 = "SELECT * FROM viaje WHERE email = ? AND fecha > current_date() ORDER BY fecha";

            pst2 = conn.prepareStatement(query2);

            pst2.setString(1, email);

            rs2 = pst2.executeQuery();

            while (rs2.next()) {

                viajesFuturos.add(
                        new Viaje(
                                rs2.getString("idviaje"),
                                rs2.getString("origen"),
                                rs2.getString("destino"),
                                rs2.getTimestamp("fecha"),
                                rs2.getDouble("precio")
                        )
                );

            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error en la consulta! 212");
        }


    %>   

    <%        String n = "";
        String imgDataBase64 = "";
        try {

            Statement stName;
            ResultSet rsName;

            System.out.println("Iniciando el JSP");
            conn = BD.getConexion();

            String e = (String) s.getAttribute("email");

            if (s.getAttribute("email") != null) {

                stName = conn.createStatement();
                rsName = stName.executeQuery("select * from usuario where email = '" + e + "'");
                rsName.next();

                n = rsName.getString("nombre");
                n = n;
                //System.out.println("Bienvenido/a " + n);
                //el nombre se mostrará en el label que viene despues
                //objeto Blob recuperado de la BD
                Blob image = rsName.getBlob("foto");
                byte[] imgData = null;
                imgData = image.getBytes(1, (int) image.length());
                imgDataBase64 = new String(Base64.getEncoder().encode(imgData));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error en la consulta!");
        }


    %>

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <meta name="author" content="David Ramos">
        <title>ArabaCar | Viajes Publicados</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">



    </head>
    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <li>
                        <h1> <span class="highlight">ArabaCar</span> Mis Viajes Publicados</h1>
                    <li><h1 id = "usuario" style="padding: 10px"> <%=n%> </h1></li> 
                    <img src="data:image/png;base64,<%= imgDataBase64%>" class ="imgProfile" id="foto">
                    </li>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <section id="form-box">
            <b><%=n%>, a continuacion saldran todos los viajes publicados que tienes</b>
        </section>

        <%            if (false) {
                System.out.println("No hay viajes para mostrar!");
            } else {
                for (Viaje v : viajesPasados) {

                    String idviajeP = v.getConductor();
                    String origen = v.getOrigen();
                    String destino = v.getDestino();
                    String fechaC = v.getFecha();
                    //LocalDateTime fechaC = v.getFecha();

                    double precioP = v.getPrecio();
                    String precio = precioP + " €";
        %>
        <section id="dataWrapper" >            
            <div id="elements">
                <table >                   

                    <tbody id="elementsList"></tbody>

                    <tr>                        
                        <th>Origen</th>
                        <th>Destino</th>
                        <th>Fecha Viaje</th>                          
                        <th>Precio </th>
                    </tr>
                    <tr>                       
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fechaC%></td>                    
                        <td><%=precio%></td>
                    </tr>                    
                    <tr>
                        <th>Nombre</th>
                        <th>Email Pasajero</th>
                        <th>Fecha Reserva</th>                      
                    </tr>                    

                    <%
                        ArrayList<Viaje> reservas = new ArrayList<>();
                        PreparedStatement pst3;
                        ResultSet rs3;

                        try {

                            String query3 = "SELECT * FROM reservaviaje WHERE idviaje = ? ORDER BY fecha";

                            pst3 = conn.prepareStatement(query3);

                            pst3.setString(1, idviajeP);

                            rs3 = pst3.executeQuery();
                            while (rs3.next()) {

                                reservas.add(
                                        new Viaje(
                                                rs3.getString("email"),
                                                rs3.getTimestamp("fecha")
                                        )
                                );

                            }

                        } catch (SQLException e) {
                            e.printStackTrace();
                            System.err.println("Error en la consulta!");
                        }

                        for (Viaje r : reservas) {

                            String emailP = r.getId();

                            PreparedStatement pst;
                            ResultSet rs;
                            String query3 = "SELECT nombre FROM usuario WHERE email = ?";
                            pst = conn.prepareStatement(query3);
                            pst.setString(1, emailP);
                            rs = pst.executeQuery();
                            rs.next();

                            String nombre = rs.getString("nombre");
                            String fechaR = v.getFecha();

                    %>              
                    <tr>
                        <td><%=nombre%></td>
                        <td><%=emailP%></td>
                        <td><%=fechaR%></td>                  

                    </tr>

                    <%

                        }


                    %>

                    </tbody>
                </table>
            </div>
        </section>

        <%                            }
            }
        %>


        <section id="dataWrapper" >
            <caption><%=mensaje%></caption>
        </section>            

        <%
            if (false) {
                System.out.println("No hay viajes para mostrar!");
            } else {
                for (Viaje v : viajesFuturos) {

                    String idviajeF = v.getConductor();
                    String origen = v.getOrigen();
                    String destino = v.getDestino();
                    String fechaC = v.getFecha();

                    double precioP = v.getPrecio();
                    String precio = precioP + " €";
        %>

        <section id="dataWrapper" >            
            <div id="elements">
                <table >                   

                    <tbody id="elementsList"></tbody>

                    <tr>                        
                        <th>Origen</th>
                        <th>Destino</th>
                        <th>Fecha Viaje</th>                          
                        <th>Precio </th>
                    </tr>
                    <tr>                       
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fechaC%></td>                    
                        <td><%=precio%></td>
                    </tr>

                    <tr>
                        <th>Nombre</th>
                        <th>Email Pasajero</th>
                        <th>Fecha Reserva</th>                      
                    </tr>

                    <%
                        ArrayList<Viaje> reservas = new ArrayList<>();
                        PreparedStatement pst4;
                        ResultSet rs4;
                        try {

                            String query4 = "SELECT * FROM reservaviaje WHERE idviaje = ? ORDER BY fecha";

                            pst4 = conn.prepareStatement(query4);

                            pst4.setString(1, idviajeF);

                            rs4 = pst4.executeQuery();

                            while (rs4.next()) {

                                reservas.add(
                                        new Viaje(
                                                rs4.getString("email"),
                                                rs4.getTimestamp("fecha")
                                        )
                                );

                            }

                        } catch (SQLException e) {
                            e.printStackTrace();
                            System.err.println("Error en la consulta de viajes futuros!");
                        }

                        for (Viaje r : reservas) {

                            String emailP = r.getId();

                            PreparedStatement pst;
                            ResultSet rs;
                            String query3 = "SELECT nombre FROM usuario WHERE email = ?";
                            pst = conn.prepareStatement(query3);
                            pst.setString(1, emailP);
                            rs = pst.executeQuery();
                            rs.next();

                            String nombre = rs.getString("nombre");
                            String fechaR = v.getFecha();

                    %>              
                    <tr>
                        <td><%=nombre%></td>
                        <td><%=emailP%></td>
                        <td><%=fechaR%></td>                       

                    </tr>

                    <%

                        }


                    %>

                    </tbody>
                </table>
            </div>
        </section>

        <%                            }
            }
        %>



    </body>
</html>
