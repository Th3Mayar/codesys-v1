<?php

    include('Database/conn_backend.php');

    session_start();

    if (isset($_SESSION['Usuario'])){
        header("location: Dashboard.php");
    }
    
    $alert = '';

    if(isset($_GET['alerta'])){
        $alert = $_GET['alerta'];
    }
    
    mysqli_close($conn);
?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <title>CODESYS</title>
        <link rel="shortcut icon" href="./assets/images/CODESYSLOGO.ico" type="image/x-icon">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <link href="assets/css/style.css" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,500;1,700;1,900&display=swap" rel="stylesheet">
    </head>
    <body>
                <div class="login-register">
                    <!-- Formulario de login-->
                    <form method="POST" action="PHP/Login.php" class="form-login">
                        <h2>Iniciar Sesion</h2>
                        <img src="assets/images/User_Control.png" alt="Inicio de sesion" height="120px" width="120px">
                        <input type="text" placeholder="Usuario" id="email_user" name="email_user" required>
                        <input type="password" placeholder="Contraseña" id="pass" name="pass" required>
                        <p id="alert" style="font-size:14px; text-align:center; margin-top:16px; color:red;"><?php echo $alert;?></p>
                        <button type="submit">Ingresar</button>
                    </form>
                </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe" crossorigin="anonymous"></script>
        <script src="./assets/js/script.js"></script>
    </body>
</html>