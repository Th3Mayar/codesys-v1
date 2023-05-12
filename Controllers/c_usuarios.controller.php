<?php

include("Database\conn_backend.php");

    $alert = '';

    if(!empty($_POST)){
        $alert = '';
        if(empty($_POST['name']) || empty($_POST['email']) || empty($_POST['user']) || empty($_POST['pass'])){
            $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

        }else{

            include("Database\conn_backend.php");

            if(isset($_POST['name'])){
                $nombre = $_POST['name'];
                $Email = $_POST['email'];
                $Usuario = $_POST['user'];
                $Pass = $_POST['pass'];
                $Rol = $_POST['Rol'];
                
                $Pass = md5(mysqli_real_escape_string($conn, $Pass));

                $verify_email_user = mysqli_query($conn,"SELECT * FROM t_usuario WHERE Email='$Email' OR Usuario='$Usuario'");
                
                $result = mysqli_fetch_array($verify_email_user);

                if($result > 0){
                    $alert = '<p class="msg_error">Usuario existente.</p>';

                }else{

                    $query = "INSERT INTO t_usuario(Nombre, Email, Usuario, Pass, Rol, ID_Estado) 
                            VALUES('$nombre','$Email','$Usuario','$Pass','$Rol', 1)
                        ";

                        if(mysqli_query($conn, $query)){
                            $alert = '<p class="msg_save">Usuario creado satisfactoriamente.</p>';

                        }else{
                            $alert = '<p class="msg_error">Error al crear el usuario.</p>';
                        }
                }
        }
    }
    mysqli_close($conn);
}
?>