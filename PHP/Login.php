<?php

    session_start();

    include('../Database/conn_backend.php');
    
    $EmailUser = $_POST['email_user'];
    $Pass = $_POST['pass'];
    
    $EmailUser = mysqli_real_escape_string($conn, $EmailUser);
    $Pass = md5(mysqli_real_escape_string($conn, $Pass));

    $valuate = mysqli_query($conn, "SELECT * FROM t_usuario WHERE Email='$EmailUser' OR Usuario='$EmailUser' AND Pass='$Pass'");

    if (mysqli_num_rows($valuate) > 0){
        $data = mysqli_fetch_array($valuate);
        $_SESSION['active'] = true;
        $_SESSION['ID_Usuario'] = $data['ID_Usuario'];
        $_SESSION['Nombre'] = $data['Nombre'];
        $_SESSION['Usuario'] = $data['Usuario'];
        $_SESSION['Email'] = $data['Email'];
        $_SESSION['Rol'] = $data['Rol'];
        header("location: ../Dashboard.php");

    }else{
        $alerta = "Usuario y/o contraseña incorrecta";
        header("Location: ../index.php?alerta=" . urlencode($alerta));
        }

    exit();

?>