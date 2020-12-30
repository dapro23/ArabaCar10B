<%-- 
    Document   : loginRegister
    Created on : 5 dic. 2020, 18:32:33
    Author     : dramo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/style.css">
        <title>ArabaCar | Registro</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />

    </head>
    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <h1> <span class="highlight">ArabaCar</span> Registro</h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <section id="form-box">
            <b>Introduce tu Informacion personal</b>
            <div class ="Aviso">
                <%
                    String avisoFecha = (String) request.getAttribute("AvisoFecha");
                    if (avisoFecha == null) {
                        avisoFecha = "";
                    }

                %>
                <label name="AvisoFecha" style="color:#e8491d"> <%=avisoFecha%> </label>
            </div>
            <form id="myform" action="RegistrarUsuario" method = "post" enctype="multipart/form-data">

                <div class="formContent">
                    <label for="Nombre"> Nombre </label> 
                    <input type="text" placeholder= "nombre" id="nombre" name="nombre" required>
                </div>

                <div class="formContent">
                    <label for="Apellidos"> Apellidos </label> 
                    <input type="text" placeholder= "apellidos" id="apellidos" name="apellidos" required>
                </div>

                <div class="formContent">
                    <label for="Email"> Email </label>
                    <input type="email" placeholder= "emal" id="email" name = "email" required>
                </div>
                <p id='resultemail' style="color: red">  </p>

                <div class="formContent">
                    <label for="Password"> Password </label>
                    <input type="password" placeholder= "password" id="password" name = "password" required>
                </div>
                <p id='resultpassword' style="color: red">  </p>

                <div class="formContent">
                    <label for="Dni"> DNI </label>
                    <input type="text" placeholder= "DNI" id="dni" name = "dni" required>
                </div>
                <p id='resultdni' style="color: red">  </p>

                <div class = "formContent">

                    <label for="foto">
                        <section id="cajadatos" class="formContentFoto" > </section>
                        Foto
                        <input required type="file" id="foto" name = "foto" required>
                    </label>

                </div>

                <div class="formContent">
                    <label for="movil"> Telefono </label> 
                    <input type="tel" placeholder= "telefono" id="movil" name="movil"  pattern="[5-9]{1}[0-9]{8}" required>
                </div>

                <div class="formContent">
                    <label for="Edad"> Edad </label>
                    <!--<input required type="text" name = "edad" id="edad"/>-->
                    <input type="number" placeholder= "Age" min="18" max="100" required id="edad" name="edad" required>                    
                </div>

                <div class="formContent">
                    <label for="coche"> Coche </label>
                    <input type="text" placeholder= "Marca/Modelo de Coche" id="coche" name = "coche" >
                </div>

                <div class="formContent">
                    <button id='boton' type="submit" class="button">Registrar</button><br>
                </div>
            </form>
        </section>
    </body>
</html>
