<?php

include("./Database/conn_backend.php");

if(!empty($_POST)){
    $alert = '';
    if(empty($_POST['prov']) || empty($_POST['contact']) || empty($_POST['tel']) || empty($_POST['direcc'])){
        $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

    }else{

        include("Database\conn_backend.php");

        if(isset($_POST['prov'])){
            $id_prov = $_POST['id_prov'];
            $prov = $_POST['prov'];
            $contact = $_POST['contact'];
            $tel = $_POST['tel'];
            $direcc = $_POST['direcc'];
            
            $verify_nombre = mysqli_query($conn,"SELECT * FROM t_proveedor 
                                                            WHERE (Proveedor ='$prov' AND ID_Proveedor != $id_prov)");
            
            $result = mysqli_fetch_array($verify_nombre);

            if($result > 0){
                $alert = '<p class="msg_error">Proveedor existente.</p>';

            }else{
                
                $query_update = mysqli_query($conn, "UPDATE t_proveedor 
                                                        SET Proveedor='$prov', Contacto='$contact', Telefono='$tel', Direccion='$direcc' 
                                                        WHERE ID_Proveedor=$id_prov
                                                        AND ID_Estado = 1");

                if($query_update){
                    $alert = '<p class="msg_save">Proveedor actualizado satisfactoriamente.</p>';

                }else{
                    $alert = '<p class="msg_error">Error al actualizar el proveedor.</p>';
                }
            }
    }
}
mysqli_close($conn);
}
?>