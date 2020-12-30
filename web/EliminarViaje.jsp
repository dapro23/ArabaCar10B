<%-- 
    Document   : eliminarViaje
    Created on : 23-dic-2020, 17:11:01
    Author     : dramo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Connection"%>
<%@page import="packUtilidades.BD"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="packServlets.Viaje"%>
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
            //var id = document.getElementById('botondetalles').value;
            if (confirm('Eliminar Viaje con Id: ' + id)) {
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
        <title>ArabaCar | Eliminar Viaje</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <h1> <span class="highlight">ArabaCar</span> Eliminar Viaje</h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <section id="form-box">
            <b>A continuacion saldran todos los viajes que tienes pendientes de hacer</b>
        </section>

        <section id="dataWrapper" >
            <div id="elements">
                <table >
                    <caption>Viajes</caption>
                    <thead>
                        <tr>                            
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Fecha </th>                          
                            <th>Precio </th>

                        </tr>
                    </thead>

                    <tbody id="elementsList"></tbody>
                    <%                        if (false) {
                            System.out.println("No hay viajes para mostrar!");
                        } else {
                            for (Viaje v : viajes) {
                                String id = v.getConductor();
                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                Timestamp fecha = v.getFecha();
                                double precio = v.getPrecio();
                                String boton = "<form action='EliminarViaje' onsubmit='{return checkIt(" + id + ");}'>"
                                        + "<Button id = 'botondetalles' name = 'botondetalles' value='" + id + "'>Eliminar</Button>"
                                        + "<label for='botondetalles'> id: " + id + "</label> "
                                        + "</form>";
                    %>

                    <tr>                       
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
        </section>


        <section id="form-box">
            <%
                String boton = (String) request.getAttribute("boton");
                if (boton == null)
                    boton = "";
            %>

            <%=boton%>      
        </section>

    </body>
</html>
