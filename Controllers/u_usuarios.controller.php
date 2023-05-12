<?php

include("./Database/conn_backend.php");

if(!empty($_POST)){
    $alert = '';
    if(empty($_POST['name']) || empty($_POST['email']) || empty($_POST['user'])){
        $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

    }else{
            $id_usuario = $_POST['idusuario'];
            $nombre = $_POST['name'];
            $Email = $_POST['email'];
            $Usuario = $_POST['user'];
            $Pass = md5($_POST['pass']);
            $Rol = $_POST['Rol'];
            
            //$Pass = md5(mysqli_real_escape_string($conn, $Pass));

            $verify_email_user = mysqli_query($conn,"SELECT * FROM t_usuario 
                                                                WHERE (Email='$Email' AND ID_Usuario != $id_usuario) 
                                                                OR (Usuario='$Usuario' AND ID_Usuario != $id_usuario)");

            $result = mysqli_fetch_array($verify_email_user);

            if($result > 0){
                $alert = '<p class="msg_error">Usuario existente.</p>';

            }else{
                
                if(empty($_POST['pass'])){
                    $query_update = mysqli_query($conn, "UPDATE t_usuario 
                                                            SET Nombre='$nombre', Email='$Email', Usuario='$Usuario', Rol=$Rol
                                                            WHERE ID_Usuario=$id_usuario
                                                            AND ID_Estado = 1");

                }else{
                    $query_update = mysqli_query($conn, "UPDATE t_usuario
                                                            SET Nombre='$nombre', Email='$Email', Usuario='$Usuario', Pass='$Pass', Rol=$Rol
                                                            WHERE ID_Usuario=$id_usuario
                                                            AND ID_Estado = 1");
                }

                if($query_update){
                    $alert = '<p class="msg_save">Usuario actualizado satisfactoriamente.</p>';

                }else{
                    $alert = '<p class="msg_error">Error al actualizar el usuario.</p>';
                }
            }
        mysqli_close($conn);
    }
}
?>