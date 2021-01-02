
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <meta name="author" content="David Ramos">
        <title>ArabaCar | Login</title>
        <link  rel="icon"   href="img/favicon.png" type="image/png" />
        <link rel="stylesheet" href="css/style.css">

    </head>

    <body>
        <header>
            <div class="container">
                <div id="branding">
                    <h1> <span class="highlight">ArabaCar</span> Login</h1>
                </div>
                <nav>
                    <ul>
                        <li><a href="index.jsp">Inicio</a></li>
                        <li class="current"><a href="login.jsp">Iniciar sesion</a></li>
                    </ul>
                </nav>
            </div>
        </header>
        <section id="form-box">
            <b>Introduce tu informacion de login</b>            
            <form action="Login" id="formulariologin">
                <div class="formContent">
                    <label for="email"> Email </label> 
                    <input type="email" placeholder= "email" id="correo" name="email" required>
                </div>
                <div class="formContent">
                    <label for="password"> Password </label> 
                    <input type="password" placeholder= "password" id ="contraseña" name="password" required>
                </div>
                <div class="formContent">
                    <button class="button" id="boton" >Entrar</button>
                </div>
                <a href="loginRegister.jsp">No tienes una cuenta?</a><br>
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
