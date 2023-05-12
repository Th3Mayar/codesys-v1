<?php 
	include_once("Include/plantilla_Cabeza.php"); 
	include("Database/conn_backend.php");

	$query_dash = mysqli_query($conn, "CALL dataDashboard()");
	$result_dash = mysqli_num_rows($query_dash);
	if($result_dash > 0){
		$data_dash = mysqli_fetch_assoc($query_dash);
		mysqli_close($conn);
	}

	$usuario = $_SESSION['Usuario'];

	include("Database/conn_backend.php");

	// Datos de la empresa
	$cif = '';
	$nombreEmpresa = '';
	$razon_social = '';
	$telefono = '';
	$emailEmpresa = '';
	$direccion = '';
	$itbis = '';

	$query_empresa = mysqli_query($conn, "SELECT * FROM t_configuracion WHERE CIF = '67389826'");
	$row_empresa = mysqli_num_rows($query_empresa);

	if($row_empresa > 0){
		while($dataEmpresa = mysqli_fetch_array($query_empresa)){
			$cif = $dataEmpresa['CIF'];
			$nombreEmpresa = $dataEmpresa['Nombre'];
			$razon_social = $dataEmpresa['Razon_Social'];
			$telefono = $dataEmpresa['Telefono'];
			$emailEmpresa = $dataEmpresa['Email'];
			$direccion = $dataEmpresa['Direccion'];
			$itbis = $dataEmpresa['ITBIS'];
		}
	}

	$sql = mysqli_query($conn, 
	"SELECT u.ID_Usuario, u.Nombre, u.Email, u.Usuario, (u.Rol) as ID_Rol, (r.Rol) as Rol
		FROM t_usuario u 
		INNER JOIN t_rol r
		ON u.Rol = r.ID_Rol WHERE Usuario='$usuario'");

	while($mostrar = mysqli_fetch_array($sql)){
		$id = $mostrar['ID_Usuario'];
		$nombre = $mostrar['Nombre'];
		$email = $mostrar['Email'];
		$usuario = $mostrar['Usuario'];
		$rol = $mostrar['Rol'];
		$idrol = $mostrar['ID_Rol'];
	}

	// Extraer venta hecha por los usuarios, y c/u
	$sql_ventas = mysqli_query($conn, "SELECT Total_Factura FROM t_factura WHERE Fecha > CURDATE() AND ID_Estado = 4");
	$sql_ventas_usuario = mysqli_query($conn, "SELECT Total_Factura FROM t_factura WHERE Fecha > CURDATE() AND Usuario = $id AND ID_Estado = 4");
	
	mysqli_close($conn);

	if($idrol == 4){
		$total = 0;
		while($row = mysqli_fetch_array($sql_ventas_usuario)) {
			$total += $row['Total_Factura'];
		}
		
	}elseif($idrol == 1){
		$total_vendido = 0;
		while($row = mysqli_fetch_array($sql_ventas)) {
			$total_vendido += $row['Total_Factura'];
		}
	}
?>
<br>
<br>
<head><link rel="stylesheet" href="css/style.css"></head>
<section id="container">
	<div class="divContainer">
		<div>
			<h1 class="titlePanelControll">Panel de control</h1>
		</div>
		<div class="dashboard">
			<?php if($idrol == 1 || $idrol == 3){ ?>
				<a href="r_usuarios.php">
					<i class="fas fa-user"></i>
					<p>
						<strong>Usuarios</strong><br>
						<span><?= $data_dash['usuarios']; ?></span>
					</p>
				</a>
			<?php } ?>
			<a href="r_clientes.php" class="borde">
				<i class="fas fa-user"></i>
				<p>
					<strong>Clientes</strong><br>
					<span><?= $data_dash['clientes']; ?></span>
				</p>
			</a>
			<?php if($idrol == 1 || $idrol == 3){ ?>
				<a href="r_proveedores.php" class="borde">
					<i class="fa-solid fa-truck-field"></i>
					<p>
						<strong>Proveedores</strong><br>
						<span><?= $data_dash['proveedores']; ?></span>
					</p>
				</a>
			<?php } ?>
			<a href="r_productos.php" class="borde">
				<i class="fa-solid fa-tag"></i>
				<p>
					<strong>Productos</strong><br>
					<span><?= $data_dash['productos']; ?></span>
				</p>
			</a>
			<a href="r_ventas.php" class="borde">
				<i class="far fa-newspaper"></i>
				<p>
					<strong>Ventas</strong><br>
					<span><?= $data_dash['ventas']; ?></span>
				</p>
			</a>
			<a href="#" class="borde" onclick="event.preventDefault();">
				<i class="fa-solid fa-clipboard"></i>
				<p>
					<?php if($idrol == 4){ ?>
						<strong>Total Vendido</strong><br>
						<span><?php echo "RD$".$total; ?></span>
					<?php }else if($idrol == 1){ ?>
						<strong>Total Vendido</strong><br>
						<span><?php echo "RD$".$total_vendido; ?></span>
					<?php } ?>
				</p>
			</a>
		</div>
	</div>
	<div class="infoSystem">
		<div>
			<h1 class="titlePanelControll">Configuración</h1>
		</div>
		<div class="containerPerfil">
			<div class="containerDataUser">
				<div class="logoUser">
					<img src="assets/images/logoUser.png" alt="">
				</div>
				<div class="divDataUser">
					<h4>Información personal</h4>
						<div>
							<label>Nombre: <span><?= $nombre;?></span></label>
						</div>
						<div>
							<label>Correo: <span><?= $email;?></span></label>
						</div>

						<h4>Datos de usuario</h4>
						<div>
							<label>Rol: <span><?= $rol;?></span></label>
						</div>
						<div>
							<label>Usuario: <span><?= $usuario;?></span></label>
						</div>

						<h4>Cambiar contraseña</h4>
						<form action="" method="POST" name="frmChangePass" id="frmChangePass">
							<div>
								<input type="password" name="txtPassUser" id="txtPassUser" placeholder="Contraseña actual" required>
							</div>
							<div>
								<input type="password" class="newPass" name="txtNewPassUser" id="txtNewPassUser" placeholder="Nueva contraseña" required>
							</div>
							<div>
								<input type="password" class="newPass" name="txtPassConfirm" id="txtPassConfirm" placeholder="Confirmar contraseña" required>
							</div>
							<div class="alertChangePass" style="display:none;"></div>
							<button type="submit" class="btn_save btnChangePass"> <i class="fas fa-key"></i> Cambiar contraseña</button>
						</form>
				</div>
			</div>
				<?php if($idrol == 1){ ?>
			<div class="containerDataEmpresa">
				<div class="logoCompany">
					<img src="assets/images/logoEmpresa.png" alt="">
				</div>
				<h4>Datos de la empresa</h4>
				<form method="POST" action="" name="frmEmpresa" id="frmEmpresa" class="form-register">
                	<input type="hidden" name="action" value="updateDataEmpresa">
                    <div>
						<label>CIF: </label><input type="text" placeholder="CIF Empresa" id="txtCif" name="txtCif" value="<?= $cif;?>" required>
					</div>
                    <div>
						<label>Nombre: </label><input type="text" placeholder="Nombre empresa" id="txtNombre" name="txtNombre" value="<?= $nombreEmpresa;?>" required>
					</div>
                    <div>
						<label>Razon Social: </label><input type="text" placeholder="Razon Social" id="txtRazon" name="txtRazon" value="<?= $razon_social;?>">
					</div>
                    <div>
						<label>Telefono: </label><input type="text" placeholder="Número de teléfono" id="txtTel" name="txtTel" value="<?= $telefono;?>" required>
					</div>
                    <div>
						<label>Correo electrónico: </label><input type="email" placeholder="Correo electrónico" id="txtEmail" value="<?= $emailEmpresa;?>" name="txtEmail" required>
					</div>
					<div>
						<label>Direccion: </label><input type="text" placeholder="Direccion de la empresa" id="txtDireccion" value="<?= $direccion;?>" name="txtDireccion" required>
					</div>
                    <div>
						<label>ITBIS (%): </label><input type="text" placeholder="Impuesto al valor agregado" id="txtItbis" value="<?= $itbis;?>" name="txtItbis" required>
					</div>
					<div class="alertFormEmpresa" style="display:none;"></div>
                    <div>
						<button type="submit" class="btn_save"><i class="fa-solid fa-floppy-disk" style="color: #525151;"></i> Guardar datos</button>
					</div>
            </form>
			</div>
				<?php } ?>
		</div>
	</div>
</section>

<?php include_once("Include/plantilla_pie.php");?>