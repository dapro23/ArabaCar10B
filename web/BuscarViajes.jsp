
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
                    <li><img src="img/viaje.png" style="max-width: 90px; max-height: 90px; border-radius: 20px;"></li>
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
                    <%                        String aviso = (String) request.getAttribute("Aviso");
                        if (aviso == null)
                            aviso = "";
                    %>
                    <label name="Aviso" style="color:#e8491d;"> <%=aviso%> </label>
                </div>
                <div class="formContent">
                    <%
                        Calendar fechaC = new GregorianCalendar();
                        int año = fechaC.get(Calendar.YEAR);
                        int mes = fechaC.get(Calendar.MONTH);
                        int dia = fechaC.get(Calendar.DAY_OF_MONTH);
                        mes++;
                        String fechaActual = año + "-" + mes + "-" + dia;
                        System.err.println(fechaActual);
                        String fechaForm = "<label for='Fecha'> Fecha </label>"
                                + "<input class='datoFecha' type='date' id='fecha' name='fecha'  min='" + fechaActual + "' max='2021-12-31' required>";
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
                                        + "<th>Origen</th>"
                                        + "<th>Destino</th>"
                                        + "<th>Fecha y Hora</th>"
                                        + "<th>Precio</th>";
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
                            //request.setAttribute("avisoReserva", "No hay viajes para mostrar!");

                        } else {//Esta logueado el usuario*****************************                            
                            if (request.getSession().getAttribute("email") != null) {

                                for (Viaje v : viajes) {

                                    String nombre = v.getNombre();
                                    String email = v.getConductor();
                                    String id = v.getId();
                                    String origen = v.getOrigen();
                                    String destino = v.getDestino();
                                    String fecha = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(v.getFecha());
                                    //LocalDateTime fecha = v.getFecha();
                                    //Timestamp fecha = v.getFecha();

                                    double precio = v.getPrecio();
                                    String boton = "<form action='RealizarReserva' onsubmit='{return checkIt(" + id + ");}'>"
                                            + "<Button id = 'botondetalles' name = 'botondetalles' value='" + id + "' action='BuscarViajes'>apuntarse</Button>"
                                            + "</form>";
                    %>
                    <tr>
                        <td><%=nombre%></td>
                        <td><%=email%></td>
                        <td><%=origen%></td>
                        <td><%=destino%></td>
                        <td><%=fecha%></td>                        
                        <td><%=precio%></td>
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
                            String fecha = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").format(v.getFecha());

                            double precio = v.getPrecio();
                            String boton = "<form action='RealizarReserva'>"
                                    + "<Button id = 'botondetalles' name = 'botondetalles' value='" + id + "' action='BuscarViajes'>apuntarse</Button>"
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
