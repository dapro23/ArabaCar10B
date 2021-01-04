
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="packUtilidades.BD"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.util.Base64"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

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

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <meta name="author" content="David Ramos">
        <title>ArabaCar | Publicar Viaje</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">

    </head>
    <body>
        <header>
            <div id="branding">
                <div class="container">
                    <li>
                    <li><h1> <span class="highlight">ArabaCar</span> Publicar Viaje</h1></li>
                    <li><h1 id = "usuario"><%=n%> </h1></li> 
                    <img src="data:image/png;base64,<%= imgDataBase64%>" class ="imgProfile" id="foto">                      

                    </li>
                </div>
            </div>
            <nav>
                <ul>
                    <li><a href="index.jsp">Inicio</a></li>
                </ul>
            </nav>

        </header>
        <section id="form-box">
            <b>Introduce la informacion del viaje</b>

            <form id="myform" action="PublicarViaje">
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

                <div class="formContent">
                    <%
                        Calendar fechaC = new GregorianCalendar();
                        int año = fechaC.get(Calendar.YEAR);
                        int mesA = fechaC.get(Calendar.MONTH);
                        int diaA = fechaC.get(Calendar.DAY_OF_MONTH);
                        mesA++;
                        String mes = "" + mesA;
                        String dia = "" + diaA;
                        if (mesA < 10) {
                            mes = "0" + mes;
                        }

                        if (diaA < 10) {
                            dia = "0" + dia;
                        }

                        String fechaActual = año + "-" + mes + "-" + dia;

                        int añoB = año + 1;
                        String fechaMax = añoB + "-" + mes + "-" + dia;

                        System.out.println("fecha actual del sistema: " + fechaMax);

                        String fechaForm = "<label for='Fecha'> Fecha </label>"
                                + "<input class='datoFecha' type='date' id='fecha' name='fecha'  min='" + fechaActual + "' max='" + fechaMax + "' >";
                    %>
                    <%=fechaForm%>       
                </div>  

                <div class="formContent">
                    <label for="hora"> Hora </label>
                    <input required class = "datoHora" type="time" name="hora" id="hora">
                </div>            

                <div class="formContent">
                    <label for="precio"> Precio </label>
                    <input  class = "datoPrecio" type="number" id="precio" name="precio" min="1" max="500" value="0.00" step="0.50" onchange="(function (el) {
                                el.value = parseFloat(el.value).toFixed(2);
                            })(this)">
                </div>

                <div class="formContent">
                    <button class="button" type='submit' id="boton">Publicar</button>
                </div>
            </form>
        </section>

        <section id="form-box">
            <%
                String usuario = (String) request.getAttribute("Aviso");
                if (usuario == null) {
                    usuario = "";
                }

            %>
            <label name="AvisoFecha" style="color: white"> <%=usuario%> </label>
        </section>

    </body>
</html>
