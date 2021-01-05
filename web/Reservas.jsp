<%@page import="java.util.Base64"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="packUtilidades.BD"%>
<%@page import="packUtilidades.BD"%>
<%@page import="java.util.ArrayList"%>
<%@page import="packServlets.Viaje"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        HttpSession s = request.getSession();
        String email = (String) s.getAttribute("email");

        ArrayList<Viaje> viajesPasados = new ArrayList<>();
        ArrayList<Viaje> viajesFuturos = new ArrayList<>();

        String mensaje = "Fecha actual: " + DateTimeFormatter.ofPattern("dd/MM/yyyy").format(LocalDate.now());
        Connection conn = BD.getConexion();
        try {

            String query1 = "SELECT R.fecha AS fechaReserva, V.idviaje, V.email AS emailConductor, V.origen, V.destino, V.fecha AS fechaViaje, V.precio FROM reservaviaje R, viaje V WHERE R.email = ? AND R.idviaje = V.idviaje AND V.fecha < current_date() order by R.fecha;";

            PreparedStatement pst1 = conn.prepareStatement(query1);

            pst1.setString(1, email);

            ResultSet rs1 = pst1.executeQuery();

            while (rs1.next()) {

                PreparedStatement pst3;
                ResultSet rs3;

                String query3 = "SELECT email, nombre, movil FROM usuario WHERE email = ?";

                pst3 = conn.prepareStatement(query3);

                pst3.setString(1, rs1.getString("emailConductor"));

                rs3 = pst3.executeQuery();

                rs3.next();

                //crear un arraylist de viajes
                viajesPasados.add(
                        new Viaje(
                                rs3.getString("nombre"),
                                rs3.getString("email"),
                                rs3.getString("movil"),
                                rs1.getString("origen"),
                                rs1.getString("destino"),
                                rs1.getTimestamp("fechaViaje"),//fecha
                                rs1.getTimestamp("fechaReserva"),//fecha2
                                rs1.getDouble("precio")
                        )
                );

            }

            String query2 = "SELECT R.fecha AS fechaReserva, V.idviaje, V.email AS emailConductor, V.origen, V.destino, V.fecha AS fechaViaje, V.precio FROM reservaviaje R, viaje V WHERE R.email = ? AND R.idviaje = V.idviaje AND V.fecha > current_date() order by R.fecha;";

            PreparedStatement pst2 = conn.prepareStatement(query2);

            pst2.setString(1, email);

            ResultSet rs2 = pst2.executeQuery();

            while (rs2.next()) {

                PreparedStatement pst4;
                ResultSet rs4;

                String query4 = "SELECT email, nombre, movil FROM usuario WHERE email = ?";

                pst4 = conn.prepareStatement(query4);

                pst4.setString(1, rs2.getString("emailConductor"));

                rs4 = pst4.executeQuery();

                rs4.next();

                //crear un arraylist de viajes
                viajesFuturos.add(
                        new Viaje(
                                rs4.getString("nombre"),
                                rs4.getString("email"),
                                rs4.getString("movil"),
                                rs2.getString("origen"),
                                rs2.getString("destino"),
                                rs2.getTimestamp("fechaViaje"),//fecha
                                rs2.getTimestamp("fechaReserva"),//fecha2
                                rs2.getDouble("precio")
                        )
                );

            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error en la consulta!");
        }


    %>

    <%        
        String n = "";
        String imgDataBase64 = "";
        try {

            Statement stName;
            ResultSet rsName;

            System.out.println("Iniciando el JSP");
            conn = BD.getConexion();

            String e = (String) s.getAttribute("email");

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

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error en la consulta!");
        }


    %>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <meta name="author" content="David Ramos">
        <title>ArabaCar | Mi Reservas</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <li>
                    <h1> <span class="highlight">ArabaCar</span> Mi Reservas</h1>
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
            <b><%=n%>, estas son todas las reservas que has realizado</b>
        </section>

        <section id="dataWrapper" >
            <div id="elements">
                <table >
                    <caption>Viajes Pasados</caption>
                    <thead>
                        <tr>
                            <th>Fecha Reserva</th>
                            <th>Conductor</th>
                            <th>Email</th>                            
                            <th>Telefono</th>
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Fecha viaje</th>                          
                            <th>Precio </th>

                        </tr>
                    </thead>

                    <tbody id="elementsList">   </tbody>
                    <%                        if (false) {
                            System.out.println("No hay viajes para mostrar!");
                        } else {
                            for (Viaje v : viajesPasados) {

                                String nombrec = v.getId();
                                String emailc = v.getNombre();
                                String telefonoc = v.getConductor();
                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                String fecha = v.getFecha();
                                //LocalDateTime fecha = v.getFecha();
                                String fecha2 = v.getFecha2();
                                //LocalDateTime fecha2 = v.getFecha2();
                                double precioP = v.getPrecio();
                                String precio = precioP + " €";
                    %>

                    <tr>
                        <td><%=fecha2%></td>      
                        <td><%=nombrec%></td>
                        <td><%=emailc%></td>
                        <td><%=telefonoc%></td>
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
                            <th>Fecha de la Reserva</th>
                            <th>Conductor</th>
                            <th>Email</th>                            
                            <th>Telefono</th>
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Fecha viaje</th>                          
                            <th>Precio </th>

                        </tr>
                    </thead>

                    <tbody id="elementsList">   </tbody>
                    <%
                        if (false) {
                            System.out.println("No hay viajes para mostrar!");
                        } else {
                            for (Viaje v : viajesFuturos) {

                                String nombrec = v.getId();
                                String emailc = v.getNombre();
                                String telefonoc = v.getConductor();
                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                //LocalDateTime fecha = v.getFecha();
                                //LocalDateTime fecha2 = v.getFecha2();

                                String fecha = v.getFecha();
                                String fecha2 = v.getFecha2();

                                double precioP = v.getPrecio();
                                String precio = precioP + " €";
                    %>

                    <tr>
                        <td><%=fecha2%></td>      
                        <td><%=nombrec%></td>
                        <td><%=emailc%></td>
                        <td><%=telefonoc%></td>
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
