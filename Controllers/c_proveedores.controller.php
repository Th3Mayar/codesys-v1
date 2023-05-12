<?php

include("Database\conn_backend.php");

    $alert = '';
    if(!empty($_POST)){
        $alert = '';
        if(empty($_POST['prov']) || empty($_POST['contact']) || empty($_POST['tel']) || empty($_POST['direcc'])){
            $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

        }else{

            include("Database\conn_backend.php");

            if(isset($_POST['prov'])){
                $prov = $_POST['prov'];
                $cod_empleado = $_POST['id_user'];
                $contact = $_POST['contact'];
                $tel = $_POST['tel'];
                $direcc = $_POST['direcc'];
                
                $verify_name = mysqli_query($conn,"SELECT * FROM t_proveedor WHERE Proveedor='$prov'");
                
                $result = mysqli_fetch_array($verify_name);

                if($result > 0){
                    $alert = '<p class="msg_error">Proveedor existente.</p>';

                }else{

                    $query = "INSERT INTO t_proveedor(Proveedor, Cod_Usuario, Contacto, Telefono, Direccion, ID_Estado) 
                            VALUES('$prov','$cod_empleado','$contact','$tel','$direcc', 1)
                        ";

                        if(mysqli_query($conn, $query)){
                            $alert = '<p class="msg_save">Proveedor registrado satisfactoriamente.</p>';

                        }else{
                            $alert = '<p class="msg_error">Error al registrar el proveedor.</p>';
                        }
                }
        }
    }
    mysqli_close($conn);
}
?>