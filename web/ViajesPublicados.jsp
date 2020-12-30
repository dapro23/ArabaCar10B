<%-- 
    Document   : publishedTrips
    Created on : 5 dic. 2020, 20:39:35
    Author     : dramo
--%>

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

        String mensaje = "La fecha actual es: " + LocalDate.now();

        try {
            Connection conn = BD.getConexion();
            PreparedStatement pst1;
            PreparedStatement pst2;
            ResultSet rs1;
            ResultSet rs2;

            String query1 = "SELECT * FROM viaje WHERE email = ? AND fecha < current_date()";

            pst1 = conn.prepareStatement(query1);

            pst1.setString(1, email);

            rs1 = pst1.executeQuery();

            while (rs1.next()) {

                //crear un arraylist de viajes
                viajesPasados.add(
                        new Viaje(
                                rs1.getString("origen"),
                                rs1.getString("destino"),
                                rs1.getTimestamp("fecha"),
                                rs1.getDouble("precio")
                        )
                );

                System.out.println(rs1.getString("fecha"));

            }

            String query2 = "SELECT * FROM viaje WHERE email = ? AND fecha > current_date()";

            pst2 = conn.prepareStatement(query2);

            pst2.setString(1, email);

            rs2 = pst2.executeQuery();

            while (rs2.next()) {

                //crear un arraylist de viajes
                viajesFuturos.add(
                        new Viaje(
                                rs2.getString("origen"),
                                rs2.getString("destino"),
                                rs2.getTimestamp("fecha"),
                                rs2.getDouble("precio")
                        )
                );

                System.out.println(rs2.getString("fecha"));

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
                    <h1> <span class="highlight">ArabaCar</span> Mis Viajes Publicados</h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <section id="form-box">
            <b>A continuacion saldran todos los viajes publicados que tienes</b>
        </section>

        <section id="dataWrapper" >
            <div id="elements">
                <table >
                    <caption>Viajes Pasados</caption>
                    <thead>
                        <tr>
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Fecha </th>                          
                            <th>Precio </th>

                        </tr>
                    </thead>

                    <tbody id="elementsList">   </tbody>
                    <%                        if (false) {
                            System.out.println("No hay viajes para mostrar!");
                        } else {
                            for (Viaje v : viajesPasados) {

                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                LocalDateTime fecha = v.getFecha();
                                double precio = v.getPrecio();
                    %>

                    <tr>
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fecha%></td>                    
                        <td><%=precio%></td>
                    </tr>

                    <%
                            }
                        }
                    %>

                    </tbody>
                </table>
            </div>
        </section>

        <section id="dataWrapper" >
            <caption><%=mensaje%></caption>
        </section>            

        <section id="dataWrapper" >
            <div id="elements">
                <table >
                    <caption>Viajes Futuros</caption>
                    <thead>
                        <tr>
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Fecha </th>                          
                            <th>Precio </th>

                        </tr>
                    </thead>

                    <tbody id="elementsList">   </tbody>
                    <%
                        if (false) {
                            System.out.println("No hay viajes para mostrar!");
                        } else {
                            for (Viaje v : viajesFuturos) {

                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                LocalDateTime fecha = v.getFecha();
                                //SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
                                //String strFecha = formatter.format(fecha);
                                double precio = v.getPrecio();
                    %>

                    <tr>
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fecha%></td>                    
                        <td><%=precio%></td>
                    </tr>

                    <%
                            }
                        }
                    %>

                    </tbody>
                </table>
            </div>
        </section>


    </body>
</html>
