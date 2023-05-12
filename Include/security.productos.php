<?php 

    $usuario = $_SESSION['Usuario'];

	include("Database/conn_backend.php");
	$sql = mysqli_query($conn, 
	"SELECT (u.Rol) as ID_Rol, (r.Rol) as Rol
		FROM t_usuario u 
		INNER JOIN t_rol r
		ON u.Rol = r.ID_Rol WHERE Usuario='$usuario'");

	$idrol = 0;

	while($mostrar = mysqli_fetch_array($sql)){
		$idrol = $mostrar['ID_Rol'];
	}

    if($idrol != 1 && $idrol != 3){
        header("location: Dashboard.php");
    }
	mysqli_close($conn);

?>