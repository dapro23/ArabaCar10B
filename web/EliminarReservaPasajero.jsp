<%-- 
    Document   : eliminarReservaPasajero
    Created on : 23-dic-2020, 17:12:12
    Author     : dramo
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="packUtilidades.BD"%>
<%@page import="java.util.ArrayList"%>
<%@page import="packServlets.Viaje"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        //https://stackoverflow.com/questions/15784069/getdatetime-from-resultset-java/21860779

        HttpSession s = request.getSession();
        String email = (String) s.getAttribute("email");

        ArrayList<Viaje> viajes = new ArrayList<>();

        Connection conn = BD.getConexion();
        PreparedStatement pst1;
        ResultSet rs1;

        PreparedStatement pst2;
        ResultSet rs2;

        try {

            String query1 = "SELECT * FROM viaje WHERE email = ? AND fecha > current_date()";

            pst1 = conn.prepareStatement(query1);

            pst1.setString(1, email);

            rs1 = pst1.executeQuery();

            while (rs1.next()) {

                //crear un arraylist de viajes
                viajes.add(
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
            System.err.println("Error en la consulta!");
        }


    %>
    <script>
        function checkIt(id) {

            //var id = document.getElementById('idviaje').value;
            //var email = document.getElementById('email').value;

            if (confirm("Eliminar reserva con id: " + id)) {
                return true;
            } else {
                return false;
            }
        }
    </script> 

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <meta name="author" content="David Ramos">
        <title>ArabaCar | Eliminar Reserva de Pasajero</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <h1> <span class="highlight">ArabaCar</span> Eliminar Reserva</h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <section id="form-box">
            <b>A continuacion saldran todos los viajes que tienes pendientes de hacer y las personas que se han apuntado a esos viajes</b>
        </section>



        <%                    if (false) {
                System.out.println("No hay viajes para mostrar!");
            } else {
                for (Viaje v : viajes) {

                    String idviaje = v.getConductor();
                    String origen = v.getOrigen();
                    String destino = v.getDestino();
                    LocalDateTime fechaC = v.getFecha();
                    double precio = v.getPrecio();
        %>
        <section id="dataWrapper" >
            <div id="elements">
                <table >                   

                    <tbody id="elementsList"></tbody>

                    <tr>
                        <th>ID Viaje</th>
                        <th>Origen</th>
                        <th>Destino</th>
                        <th>Fecha </th>                          
                        <th>Precio </th>

                    </tr>
                    <tr>
                        <td><%=idviaje%></td>
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fechaC%></td>                    
                        <td><%=precio%></td>
                    </tr>
                    <tr>

                        <th>Email Pasajero</th>
                        <th>Fecha Reserva</th>                      
                    </tr>

                    <%
                        ArrayList<Viaje> reservas = new ArrayList<>();
                        try {

                            String query2 = "SELECT * FROM reservaviaje WHERE idviaje = ?;";

                            pst2 = conn.prepareStatement(query2);

                            pst2.setString(1, idviaje);

                            rs2 = pst2.executeQuery();

                            //System.out.println("1: " + rs2.getString("email") + " 2: " + rs2.getTimestamp("fecha"));
                            while (rs2.next()) {

                                reservas.add(
                                        new Viaje(
                                                rs2.getString("email"),
                                                rs2.getTimestamp("fecha")
                                        )
                                );

                            }

                        } catch (SQLException e) {
                            e.printStackTrace();
                            System.err.println("Error en la consulta!");
                        }

                        for (Viaje r : reservas) {

                            String emailP = r.getId();
                            //LocalDateTime fechaR = r.getFecha();
                            String fechaR = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(v.getFecha());
                            
                            String boton = "<form action='EliminarReservaPasajero' onsubmit='{return checkIt("+idviaje+");}'>"
                                    + "<Button id = 'botondetalles' name = 'botondetalles'>Eliminar</Button>"
                                    + "<input id='idviaje' name='idviaje' type='hidden' value='" + idviaje + "'></input>"
                                    + "<input id='email' name='email' type='hidden' value='" + emailP + "'></input>"
                                    + "</form>";

                    %>              
                    <tr>

                        <td><%=emailP%></td>
                        <td><%=fechaR%></td>
                        <td><%=boton%></td> 

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




        <section id="form-box">             

            <%                String aviso = (String) request.getAttribute("Aviso");

                if (aviso == null)
                    aviso = "";
            %>
            <label name="Aviso" style="color: red"> <%=aviso%> </label>

        </section>
    </body>
</html>
