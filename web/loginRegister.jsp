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
            <form id="myform" action="RegistrarUsuario" method = "post" enctype="multipart/form-data">

                <div class="formContent">
                    <label for="Nombre"> Nombre </label> 
                    <input type="text" placeholder= "nombre" id="nombre" name="nombre" pattern="[a-zA-Z]{3,}" required>
                </div>

                <div class="formContent">
                    <label for="Apellidos"> Apellidos </label> 
                    <input type="text" placeholder= "apellidos" id="apellidos" name="apellidos" required>
                </div>

                <div class="formContent">
                    <label for="Email"> Email </label>
                    <input type="email" placeholder= "emal" id="email" name = "email" pattern="(?!.*\.\.)(^[^\.][^@\s]+@[^@\s]+\.[^@\s\.]+$)" required>
                </div>
                <p id='resultemail' style="color: red">  </p>

                <div class="formContent">
                    <label for="Password"> Password </label>
                    <input type="password" placeholder= "password" id="password" name = "password" pattern="[a-zA-Z0-9_.+-]{4,}" required>
                </div>
                <p id='resultpassword' style="color: red">  </p>

                <div class="formContent">
                    <label for="Dni"> DNI </label>
                    <input type="text" placeholder= "ej: 12345678A" id="dni" name = "dni" pattern="[2-9]{1}[0-9]{7}[a-zA-Z]{1}" required>
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
                    <input type="text" placeholder= "Marca y Modelo de Coche" id="coche" name = "coche" >
                </div>

                <div class="formContent">
                    <button id='boton' type="submit" class="button">Registrar</button><br>
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
            <label name="AvisoFecha" style="color:#e8491d"> <%=usuario%> </label>
        </section>

    </body>
</html>
