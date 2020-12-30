<%-- 
    Document   : Desapuntarse
    Created on : 23-dic-2020, 17:20:04
    Author     : dramo
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="packUtilidades.BD"%>
<%@page import="packUtilidades.BD"%>
<%@page import="java.sql.SQLException"%>
<%@page import="packServlets.Viaje"%>
<%@page import="java.sql.Timestamp"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        //https://stackoverflow.com/questions/15784069/getdatetime-from-resultset-java/21860779

        HttpSession s = request.getSession();
        String email = (String) s.getAttribute("email");

        ArrayList<Viaje> viajes = new ArrayList<>();

        //String mensaje = "La fecha actual es: " + LocalDate.now();
        try {
            Connection conn = BD.getConexion();
            PreparedStatement pst1;
            ResultSet rs1;

            String query1 = "SELECT * FROM viaje WHERE idviaje IN (SELECT idviaje FROM reservaviaje WHERE email = ?) ORDER BY fecha";

            pst1 = conn.prepareStatement(query1);

            pst1.setString(1, email);

            rs1 = pst1.executeQuery();

            while (rs1.next()) {

                //crear un arraylist de viajes
                viajes.add(
                        new Viaje(
                                rs1.getString("idviaje"),
                                rs1.getString("email"),
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
        function checkIt(idV) {

            //var idV = document.getElementById('botondetalles').value;

            if (confirm('Eliminar Viaje con Id: ' + idV)) {
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
        <title>ArabaCar | Desapuntarse de un Viaje</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <h1> <span class="highlight">ArabaCar</span> Desapuntarse de un Viaje</h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <section id="form-box">
            <b>A continuacion saldran todas las reservas que has realizado</b>
        </section>

        <section id="dataWrapper" >
            <div id="elements">
                <table >
                    <caption>Viajes Pasados</caption>
                    <thead>
                        <tr>                            
                            <th>Conductor</th>
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
                            for (Viaje v : viajes) {

                                String idViaje = v.getId();
                                String conductor = v.getConductor();
                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                Timestamp fecha = v.getFecha();
                                double precio = v.getPrecio();
                                String boton = "<form action='EliminarReserva' onsubmit='{return checkIt("+ idViaje +");}'>"
                                        + "<Button id = 'botondetalles' name = 'idviaje' value='" + idViaje + "' action='BuscarViajes'>Eliminar</Button>"                                        
                                        + "</form>";
                    %>

                    <tr>                        
                        <td><%=conductor%></td>
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fecha%></td>                    
                        <td><%=precio%></td>
                        <td><%=boton%></td> 
                    </tr>

                    <%
                            }
                        }
                    %>

                    </tbody>
                </table>
            </div>
        </section>

        <section id="form-box">   
                       
                <%
                    String aviso = (String) request.getAttribute("Aviso");

                    if (aviso == null)
                        aviso = "";
                %>
                <label name="Aviso" style="color: red"> <%=aviso%> </label>

                
            </form>
        </section>   
    </body>
</html>
