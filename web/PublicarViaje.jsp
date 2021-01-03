
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
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
            <div class="container">
                <div id="branding">
                    <h1> <span class="highlight">ArabaCar</span> Publicar Viaje</h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                    </ul>
                </nav>
            </div>
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

                <div class="formContent">
                    <label for="hora"> Hora </label>
                    <input required class = "datoHora" type="time" name="hora" id="hora">
                </div>            

                <div class="formContent">
                    <label for="precio"> Precio </label>
                    <input  class = "datoPrecio" type="number" id="precio" name="precio" min="0" value="0.00" step="0.50" onchange="(function (el) {
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
