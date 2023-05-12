<?php

include("./Database/conn_backend.php");

if(!empty($_POST)){
    $alert = '';
    if(empty($_POST['name']) || empty($_POST['email']) || empty($_POST['apellido']) || empty($_POST['direc'])){
        $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

    }else{

        include("Database\conn_backend.php");

        if(isset($_POST['name'])){
            $id_cliente = $_POST['idcliente'];
            $nombre = $_POST['name'];
            $Apellido = $_POST['apellido'];
            $Telefono = $_POST['tel'];
            $Direccion = $_POST['direc'];
            $Email = $_POST['email'];
            
            //$RNC = md5(mysqli_real_escape_string($conn, $RNC));
            
            $verify_email_rnc = mysqli_query($conn,"SELECT * FROM t_cliente 
                                                                WHERE (Correo='$Email' AND ID_Cliente != $id_cliente)");
            
            $result = mysqli_fetch_array($verify_email_rnc);

            if($result > 0){
                $alert = '<p class="msg_error">Cliente existente.</p>';

            }else{
                
                $query_update = mysqli_query($conn, "UPDATE t_cliente 
                                                        SET Nombre='$nombre', Apellido='$Apellido', Telefono='$Telefono', Direccion='$Direccion', Correo='$Email' 
                                                        WHERE ID_Cliente=$id_cliente
                                                        AND ID_Estado = 1");

                if($query_update){
                    $alert = '<p class="msg_save">Cliente actualizado satisfactoriamente.</p>';

                }else{
                    $alert = '<p class="msg_error">Error al actualizar el cliente.</p>';
                }
            }
    }
}
mysqli_close($conn);
}
?>