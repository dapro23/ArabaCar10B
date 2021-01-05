
<%@page import="java.util.Base64"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Blob"%>
<%@page import="packUtilidades.BD"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="packServlets.Viaje"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

    <%        
        if (request.getSession().getAttribute("email") != null) {
            out.println("<script>");
            out.println("window.onload = function (){    limpiar();};function limpiar() {    $('a').remove('#4'); }");
            out.println("</script>");
        }
    %>  

    <script>
        function checkIt(id) {
            if (confirm("¿Deseas apuntarte al viaje?" + " con id: " + id)) {
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
        <title>ArabaCar | Login</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">
        <script src="https://code.jquery.com/jquery-3.5.0.js"></script>
    </head>
    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <li>
                    <li><h1> <span class="highlight">ArabaCar</span> Viajes</h1></li>
                    <%
                        Connection conn;
                        String n = "";
                        String imgDataBase64 = "";
                        try {
                            
                            Statement stName;
                            ResultSet rsName;

                            System.out.println("Iniciando el JSP");
                            conn = BD.getConexion();

                            HttpSession s = request.getSession();
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
                    <li><h1 id = "usuario"> <%=n%> </h1></li> 
                    <img src="data:image/png;base64,<%= imgDataBase64%>" class ="imgProfile" id="foto">
                    
                    </li>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                        <li><a id="4" href="login.jsp">Iniciar sesión</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <section id="form-box">           
            <b>Introduce los detalles del viaje que deseas</b><br>
            <c>Se mostraran los viajes con fecha posterior a la indicada</c>
            <form id="myform" action="BuscarViajes" method = "GET">
                <div class="formContent">
                    <label for="Origen"> Origen </label>
                    <select id="origen" name="origen">
                        <option value="Bilbao">Bilbao</option>
                        <option value="Donostia">Donostia</option>
                        <option value="Vitoria">Vitoria - Gasteiz</option>
                    </select>
                </div>
                <div class="formContent">
                    <label for="Destino"> Destino </label>
                    <select id="destino" name="destino">
                        <option value="Bilbao">Bilbao</option>
                        <option value="Donostia">Donostia</option>
                        <option value="Vitoria">Vitoria - Gasteiz</option>
                    </select>
                </div>
                <div class ="Aviso">
                    <%                        
                        String aviso = (String) request.getAttribute("AvisoOD");
                        if (aviso == null)
                            aviso = "";
                    %>
                    <label name="Aviso" style="color:#e8491d;"> <%=aviso%> </label>
                </div>
                <div class="formContent">
                    <%
                        Calendar fechaC = new GregorianCalendar();
                        int año = fechaC.get(Calendar.YEAR);
                        int mesA = fechaC.get(Calendar.MONTH);
                        int diaA = fechaC.get(Calendar.DAY_OF_MONTH);
                        mesA++;
                        String mes = ""+mesA;
                        String dia = ""+diaA;
                        if(mesA < 10){
                             mes = "0"+mes;
                        }
                        
                        if(diaA < 10){
                            dia = "0"+dia;                                                
                        }
                        
                        String fechaActual = año + "-" + mes + "-" + dia;
                        
                        
                        int añoB = año + 1; 
                        String fechaMax = añoB + "-" + mes + "-" + dia;
                        
                        System.out.println("fecha actual del sistema: " + fechaMax);    

                        String fechaForm = "<label for='Fecha'> Fecha </label>"
                                + "<input class='datoFecha' type='date' id='fecha' name='fecha'  min='" + fechaActual + "' max='"+fechaMax+"' >";
                    %>
                    <%=fechaForm%>       
                </div>

                <div class ="AvisoFecha">
                    <%
                        String avisoFecha = (String) request.getAttribute("AvisoFecha");
                        if (avisoFecha == null) {
                            avisoFecha = "";
                        }

                    %>
                    <label name="AvisoFecha" style="color:#e8491d"> <%=avisoFecha%> </label>
                </div>
                <button class="button" type='submit' id='enviar' >Buscar</button>
            </form>
        </section>
        <section id="dataWrapper" >
            <div id="elements">
                <table >
                    <caption>Viajes Seleccionados</caption>
                    <thead>
                        <%
                            String cabecera;

                            if (request.getSession().getAttribute("email") != null) {
                                cabecera = "<th>Nombre</th>"
                                        + "<th>Email</th>"
                                        + "<th>Movil</th>"
                                        + "<th>Origen</th>"
                                        + "<th>Destino</th>"
                                        + "<th>Fecha y Hora</th>"
                                        + "<th>Precio</th>"
                                        + "<th>Coche</th>";
                            } else {
                                cabecera = "<th>Origen</th>"
                                        + "<th>Destino</th>"
                                        + "<th>Fecha y Hora</th>"
                                        + "<th>Precio</th>";
                            }


                        %>                     
                        <tr><%=cabecera%></tr>
                    </thead>
                    <tbody id="elementsList">   </tbody>
                    <%
                        ArrayList<Viaje> viajes = (ArrayList<Viaje>) request.getAttribute("viajes");
                        if (viajes == null) {
                            //request.setAttribute("avisoReserva", "Esperando..");

                        } else {//Esta logueado el usuario*****************************                            
                            if (request.getSession().getAttribute("email") != null) {

                                for (Viaje v : viajes) {

                                    String nombre = v.getNombre();
                                    String email = v.getConductor();
                                    String id = v.getId();
                                    String origen = v.getOrigen();
                                    String destino = v.getDestino();
                                    String fecha = v.getFecha();
                                    //LocalDateTime fecha = v.getFecha();
                                    //Timestamp fecha = v.getFecha();
                                    String movil = v.getMovil();
                                    String coche = v.getCoche();
                                    
                                    double precioP = v.getPrecio();
                                    String precio = precioP + " €";
                                    String boton = "<form action='RealizarReserva' onsubmit='{return checkIt(" + id + ");}'>"
                                            + "<Button id = 'botondetalles' name = 'botondetalles' value='" + id + "' action='BuscarViajes'>apuntarse</Button>"
                                            + "</form>";
                    %>
                    <tr>
                        <td><%=nombre%></td>
                        <td><%=email%></td>
                        <td><%=movil%></td>                        
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fecha%></td>                        
                        <td><%=precio%></td>
                        <td><%=coche%></td>
                        <td><%=boton%></td>                
                    </tr>     
                    <%
                        }
                    } else {//NO esta en el sistema
                        for (Viaje v : viajes) {

                            String id = v.getConductor();
                            String origen = v.getOrigen();
                            String destino = v.getDestino();
                            //LocalDateTime fecha = v.getFecha();
                            //Timestamp fecha = v.getFecha();

                            //System.out.println(DateTimeFormatter.ofPattern("dd/MM/yyyy").format(v.getFecha()) + " holaa");
                            String fecha = v.getFecha();

                            double precioP = v.getPrecio();
                            String precio = precioP + " €";
                            String boton = "<form action='RealizarReserva'>"
                                    + "<Button id = 'botondetalles' name = 'botondetalles' value='" + id + "' action='BuscarViajes'>apuntarse</Button>"                                    
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
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </section>

        <section id="form-box">   
            <%
                String avisoReserva;
                avisoReserva = (String) request.getAttribute("avisoReserva");
                if (avisoReserva == null)
                    avisoReserva = "";
            %>
            <label name="avisoReserva" style="color:#e8491d;"> <%=avisoReserva%> </label>
        </section>   

    </body>
</html>
