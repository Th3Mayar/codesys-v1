<?php

include("Database\conn_backend.php");

    $usuario = $_SESSION['Usuario'];

	$sql = mysqli_query($conn, 
	"SELECT u.ID_Usuario, u.Nombre, u.Email, u.Usuario
		FROM t_usuario u 
		WHERE Usuario='$usuario'");
        
    
    while($get_user_id = mysqli_fetch_array($sql)){
        $id_usuario = $get_user_id['ID_Usuario'];
    }

    $alert = '';
    if(!empty($_POST)){
        $alert = '';
        if(empty($_POST['name']) || empty($_POST['apellido']) || empty($_POST['rnc']) || empty($_POST['tel']) || empty($_POST['location'])){
            $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

        }else{

            include("Database\conn_backend.php");

            if(isset($_POST['name'])){
                $nombre = $_POST['name'];
                $Apellido = $_POST['apellido'];
                $RNC = $_POST['rnc'];
                $Telefono = $_POST['tel'];
                $Direccion = $_POST['location'];
                $Email = $_POST['email'];
                
                //$RNC = md5(mysqli_real_escape_string($conn, $RNC));
                
                $verify_email_rnc = mysqli_query($conn,"SELECT * FROM t_cliente WHERE Correo='$Email' OR RNC='$RNC'");
                
                $result = mysqli_fetch_array($verify_email_rnc);

                if($result > 0){
                    $alert = '<p class="msg_error">Cliente existente.</p>';

                }else{

                    $query = "INSERT INTO t_cliente(Nombre, Apellido, RNC, Telefono, Direccion, Correo, ID_Estado, Usuario_ID) 
                            VALUES('$nombre','$Apellido','$RNC','$Telefono','$Direccion','$Email', 1, '$id_usuario')
                        ";

                        if(mysqli_query($conn, $query)){
                            $alert = '<p class="msg_save">Cliente registrado satisfactoriamente.</p>';

                        }else{
                            $alert = '<p class="msg_error">Error al registrar el cliente.</p>';
                        }
                }
        }
    }
    mysqli_close($conn);
}
?>