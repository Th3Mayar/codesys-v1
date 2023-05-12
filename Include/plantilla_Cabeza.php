<?php

	include("./Database/conn_backend.php");
	include("scripts.php");

    session_start();
    
    if (empty($_SESSION['Usuario'])){
        echo '<script>
                //alert("Debes iniciar sesion");
                window.location = "./index.php";
            </script>';
		
        session_destroy();
        
        die();
    }

	$usuario = $_SESSION['Usuario'];
	$sql = "SELECT * FROM t_usuario WHERE Usuario='$usuario'";
	$result = mysqli_query($conn, $sql);

?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>CODESYS</title>
	<link rel="shortcut icon" href="./assets/images/CODESYSLOGO.ico" type="image/x-icon">
</head>
<body>
	<header>
		<div class="header">
			<a href="#" class="btn_menu"><i class="fas fa-bars"></i></a>
			<h1><img class="imgHeader" src="assets\images\CODESYSLOGO.svg" alt="Logo de CODESYS" width="130px" height="100px" style="margin-top:2px; margin-left:-5px;"></h1>
			<div class="optionsBar">
				<p id="hora">República Dominicana, <?php echo fechaActual();?></p>
				<span>|</span>
				<?php while($mostrar = mysqli_fetch_array($result)){?>
				<span class="user"><?php echo $mostrar['Nombre'].' - '.$mostrar['Rol']?></span>
				<?php } ?>
				<img class="photouser" src="assets\images\user-line.svg" alt="Usuario">
				<a href="Include\Close_session.php"><img class="close" src="assets\images\shut-down-line.svg" alt="Salir del sistema" title="Salir"></a>
			</div>
		</div>
		<?php include("Include/navbar.php");?>
	</header>
	<div class="modal">
		<div class="bodyModal">
		</div>
	</div>