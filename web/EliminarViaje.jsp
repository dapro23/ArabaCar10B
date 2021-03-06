
<%@page import="java.util.Base64"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
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
        Connection conn = BD.getConexion();
        try {
            
            PreparedStatement pst1;
            ResultSet rs1;
            String query1 = "SELECT * FROM viaje WHERE email = ? AND fecha > current_date() ORDER BY fecha";
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
        function checkIt(id) {
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
                    <li>
                        <h1> <span class="highlight">ArabaCar</span> Eliminar Viaje</h1>
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
            <b><%=n%>, a continuacion saldran todos los viajes que tienes pendientes de hacer, puedes eliminar el que queiras.</b>
        </section>

        <section id="dataWrapper" >
            <div id="elements">
                <table >
                    <caption>Viajes</caption>
                    <thead>
                        <tr>                            
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Fecha Viaje</th>                             
                            <th>Precio</th>
                            <th>Apuntados</th>

                        </tr>
                    </thead>

                    <tbody id="elementsList"></tbody>
                    <%                        
                        if (false) {
                            System.out.println("No hay viajes para mostrar!");
                        } else {
                            for (Viaje v : viajes) {
                                String id = v.getConductor();
                                String origen = v.getOrigen();
                                String destino = v.getDestino();
                                //LocalDateTime fecha = v.getFecha();
                                String fecha = v.getFecha();
                                
                                
                                double precioP = v.getPrecio();
                                String precio = precioP + " €";
                                    
                                String boton = "<form action='EliminarViaje' onsubmit='{return checkIt(" + id + ");}'>"
                                        + "<Button id = 'botondetalles' name = 'botondetalles' value='" + id + "'>Eliminar</Button>"
                                        + "</form>";
                                
                                String num = "";
                                
                                try{
                                PreparedStatement pst;
                                ResultSet rs;
                                String query3 = "SELECT Count(*) AS num FROM reservaviaje WHERE idviaje = ?";
                                pst = conn.prepareStatement(query3);
                                pst.setString(1, id);
                                rs = pst.executeQuery();
                                rs.next();
                                num = rs.getString("num");
                                
                                }catch (SQLException e) {
                                     e.printStackTrace();
                                    System.err.println("Error en la consulta!");
                                }

                    %>

                    <tr>                       
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fecha%></td>                    
                        <td><%=precio%></td>
                        <td><%=num%></td>
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
