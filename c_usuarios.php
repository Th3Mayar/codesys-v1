<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/c_usuarios.controller.php');?>
<?php 

$usuario = $_SESSION['Usuario'];

	include("Database/conn_backend.php");
	$sql = mysqli_query($conn, 
	"SELECT (u.Rol) as ID_Rol, (r.Rol) as Rol
		FROM t_usuario u 
		INNER JOIN t_rol r
		ON u.Rol = r.ID_Rol WHERE Usuario='$usuario'");

	$idrol = 2;

	while($mostrar = mysqli_fetch_array($sql)){
		$idrol = $mostrar['ID_Rol'];
	}

    if($idrol != 1){
        header("location: Dashboard.php");
    }
	mysqli_close($conn);
?>
<br>
<br>
<head><link rel="stylesheet" href="css/style.css"></head>
<section id="container">
    <div class="form_register">
        <div class="alert"><?php echo $alert ?></div>
            <!-- Formulario de registro Controllers/c_usuarios.controller.php -->
            <form method="POST" action="" class="form-register">
                <h1><i class="fa-solid fa-user-plus" style="color: #525151;"></i> Registro Usuario</h1>
                    <hr>
                    <input type="text" placeholder="Nombre Completo" id="name" name="name">
                    <input type="text" placeholder="Email" id="email" name="email">
                    <input type="text" placeholder="Usuario" id="user" name="user">
                    <input type="password" placeholder="Contraseña" id="pass" name="pass">
                    
                    <label>
                        <p style="font-size: 12px; margin-left: 8px;">Rol</p>
                        <select name="Rol" id="Rol" class="form-select form-select-lg mb-1" aria-label=".form-select-lg example">
                            <?php 
                                include("Database/conn_backend.php");
                                $getRol = "SELECT ID_Rol, Rol FROM t_rol";
                                $queryRol = mysqli_query($conn, $getRol);
                                mysqli_close($conn);

                            while($row = mysqli_fetch_array($queryRol)): ?>
                            <option name="Rol" value="<?= $row['ID_Rol']?>"><?php echo $row['Rol']?>
                            </option>
                            <?php endwhile; ?>
                        </select>
                    </label>
                    <button type="submit" class="btn_save"><i class="fa-solid fa-floppy-disk" style="color: #525151;"></i> Registrar Usuario</button>
            </form>
        </div>
</section>
<br>
<br>
<br>
<?php include_once("Include/plantilla_pie.php");?>
