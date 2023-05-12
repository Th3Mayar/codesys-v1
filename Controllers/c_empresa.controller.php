<?php

include("Database\conn_backend.php");

    $alert = '';
    if(!empty($_POST)){
        $alert = '';
        if(empty($_POST['cif']) || empty($_POST['name']) || empty($_POST['tel']) || empty($_POST['location']) || empty($_POST['itbis'])){
            $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

        }else{

            include("Database\conn_backend.php");

            if(isset($_POST['name'])){
                $CIF = $_POST['cif'];
                $nombre = $_POST['name'];
                $razon = $_POST['razon_s'];
                $Telefono = $_POST['tel'];
                $Direccion = $_POST['location'];
                $Email = $_POST['email'];
                $itbis = $_POST['itbis'];
                
                //$RNC = md5(mysqli_real_escape_string($conn, $RNC));
                
                $verify_name = mysqli_query($conn,"SELECT * FROM t_configuracion WHERE Nombre='$nombre'");
                
                $result = mysqli_fetch_array($verify_name);

                if($result > 0){
                    $alert = '<p class="msg_error">Empresa existente.</p>';

                }else{

                    $query = "INSERT INTO t_configuracion(CIF, Nombre, Razon_Social, Telefono, Email, Direccion, ITBIS) 
                            VALUES('$CIF','$nombre','$razon','$Telefono','$Email','$Direccion','$itbis')
                        ";

                        if(mysqli_query($conn, $query)){
                            $alert = '<p class="msg_save">Empresa registrada satisfactoriamente.</p>';

                        }else{
                            $alert = '<p class="msg_error">Error al registrar la empresa.</p>';
                        }
                }
        }
    }
    mysqli_close($conn);
}
?>