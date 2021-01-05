<%@page import="java.util.Base64"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
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
        HttpSession s = request.getSession();
        String email = (String) s.getAttribute("email");

        ArrayList<Viaje> viajes = new ArrayList<>();

        Connection conn = BD.getConexion();

        try {

            String query1 = "SELECT R.fecha AS fechaReserva, V.idviaje, V.email AS emailConductor, V.origen, V.destino, V.fecha AS fechaViaje, V.precio FROM reservaviaje R, viaje V WHERE R.email = ? AND R.idviaje = V.idviaje AND V.fecha > current_date() order by R.fecha;";

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

                //public Viaje(String id, String nombre, String conductor, String origen, String destino, Timestamp fecha, double precio) {
                viajes.add(
                        new Viaje(
                                rs1.getString("idviaje"),
                                rs3.getString("nombre"),
                                rs3.getString("email"),
                                rs1.getString("origen"),
                                rs1.getString("destino"),
                                rs1.getTimestamp("fechaViaje"),//fecha                               
                                rs1.getDouble("precio")
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

    <script>
        function checkIt(idV) {

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
                    <li>
                    <h1> <span class="highlight">ArabaCar</span> Desapuntarse de un Viaje</h1>
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
            <b><%=n%>, estas son todas las reservas que has realizado, elige la que desees eliminar</b>
        </section>

        <section id="dataWrapper" >
            <div id="elements">
                <table >                    
                    <thead>
                        <tr>
                            <th>Conductor</th>                            
                            <th>Email</th>
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Fecha Viaje</th>                          
                            <th>Precio </th>

                        </tr>
                    </thead>

                    <tbody id="elementsList">   </tbody>
                    <%                        if (false) {
                            System.out.println("No hay viajes para mostrar!");
                        } else {
                            for (Viaje v : viajes) {
                                //public Viaje(String id, String nombre, String conductor, String origen, String destino, Timestamp fecha, double precio) {

                                String idViaje = v.getId();
                                String nombrec = v.getNombre();
                                String emailc = v.getConductor();
                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                //String fecha = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(v.getFecha());
                                //LocalDateTime fecha = v.getFecha();
                                String fecha = v.getFecha();
                                //LocalDateTime fecha2 = v.getFecha2();
                                double precioP = v.getPrecio();
                                String precio = precioP + " €";

                                String boton = "<form action='EliminarReserva' onsubmit='{return checkIt(" + idViaje + ");}'>"
                                        + "<Button id = 'botondetalles' name = 'idviaje' value='" + idViaje + "' action='BuscarViajes'>Eliminar</Button>"
                                        + "</form>";
                    %>

                    <tr>                        
                        <td><%=nombrec%></td>
                        <td><%=emailc%></td>
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
            <label name="Aviso" style="color: white"> <%=aviso%> </label>           

        </section>   

    </body>
</html>
