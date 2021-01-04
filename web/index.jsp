
<%@page import="java.sql.SQLException"%>
<%@page import="java.nio.file.FileSystems"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.io.File"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="packUtilidades.BD"%>
<%@page import="packUtilidades.Fechas"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <%

        if (request.getSession().getAttribute("email") == null) {

            out.println("<script>");
            out.println("window.onload = function (){    limpiar();};function limpiar() {    $('div').remove('#0');    $('div').remove('#5');    $('div').remove('#6');}");
            out.println("</script>");

        } else if (request.getSession().getAttribute("coche") == null) {

            out.println("<script>");
            out.println("window.onload = function (){    limpiar();    };function limpiar() {          $('a').remove('#1_1');    $('a').remove('#1_2');   $('a').remove('#1_3');    $('a').remove('#4');          $('div').remove('#5');          $('h1').remove('#7');}");
            out.println("</script>");

        } else if (request.getSession().getAttribute("email") != null) {

            out.println("<script>");
            out.println("window.onload = function (){    limpiar();    };function limpiar() {    $('a').remove('#4');    $('h1').remove('#7');}");
            out.println("</script>");

        }
    %>

    <script>
        function checkIt() {

            if (confirm('¿Deseas Cerrar Sesion?')) {
                return true;
            } else {
                return false;
            }
        }
    </script>  

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
                n = "Hola " + n;
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
        <title>ArabaCar | Bienvenido</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />

        <link rel="stylesheet" type="text/css" href="css/style.css">    
        <script src="https://code.jquery.com/jquery-3.5.0.js"></script>
        <script src="js/dropdown.js" type="text/javascript"></script>
    </head>
    <body>    

        <header>
            <div id="branding">
                <div class="container">
                    <li>
                    <li><h1 >ArabaCar</h1></li>
                    <li><h1 id = "usuario"> <%=n%> </h1></li> 
                    <img src="data:image/png;base64,<%= imgDataBase64%>" class ="imgProfile" id="foto">
                    
                    </li>
                </div>
            </div>
            <nav>
                <li>
                    <div class="dropdown" id ="0">
                        <button onclick="myFunction()" class="dropbtn">Mi Perfil</button>
                        <div id="myDropdown" class="dropdown-content">

                            <a id="1_1" href="ViajesPublicados.jsp">Ver Mis Viajes Publicados</a>                
                            <a id="1_2" href="EliminarViaje.jsp">Eliminar un viaje</a>
                            <a id="1_3" href="EliminarReservaPasajero.jsp">Eliminar a un pasajero de mi viaje</a>                                                            
                            <a id="1_4" href="Reservas.jsp">Ver Mis Reservas</a>
                            <a id="1_5" href="EliminarReserva.jsp">Desapuntarme de un viajes</a>   

                        </div>
                    </div>
                <li class="current"><a href="index.jsp">Inicio</a></li>
                <li><a id="4" href="login.jsp" >Iniciar sesion</a></li>
                </li>
            </nav>
        </header>
        <section id="main-showcase">
            <div id="logo">
                <img src="./img/logo.png">
            </div>
            <h1 id="7" >Bienvenido/a a ArabaCar!</h1>
            <p>Arabacar es un servicio de vehiculo compartido que hace posible que las personas que quieren desplazarse al mismo lugar en el mismo momento puedan organizarse para viajar justos.</p>
        </section>

        <section id="main-showcase">
            <section id="form-box">
                <b>Busca viajes</b><br>
                <c>Si quieres buscar un viaje, pulsa este boton</c>
                <form id="myform" action="BuscarViajes.jsp" >
                    <div class="formContent">
                        <button class="button">Buscar</button>
                    </div>
                </form>
            </section>
            <div id="5">
                <section id="form-box">
                    <b>Publicar un viaje</b> <br>
                    <c>¿Tienes planificado un viaje y quieres compartir tu coche con otras personas? Publica un viaje de forma sencilla y comparte los gastos.</c>
                    <form id="myform" action="PublicarViaje.jsp">
                        <div class="formContent">
                            <button class="button">Publicar</button>
                        </div>
                    </form>
                </section>
            </div>
        </section>
        <div id="6">
            <section id="form-box">
                <div class="container">
                    <form action="LoginOut" onsubmit='{
                                return checkIt();
                            }'>
                        <button class="button" id="logoutButton">Cerrar sesion</button>
                    </form>
                </div>
            </section>
        </div>

    </body>
</html>
