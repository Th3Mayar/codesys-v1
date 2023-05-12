<?php 
	include("./Database/conn_backend.php");

	$query_config = mysqli_query($conn, "SELECT * FROM t_configuracion");
	$resultado = mysqli_num_rows($query_config);

	$usuario = $_SESSION['Usuario'];

	$sql_get = mysqli_query($conn, 
	"SELECT (u.Rol) as ID_Rol, (r.Rol) as Rol
		FROM t_usuario u 
		INNER JOIN t_rol r
		ON u.Rol = r.ID_Rol WHERE Usuario='$usuario'");
	$idrol = 0;
	while($mostrar_user = mysqli_fetch_array($sql_get)){
		$idrol = $mostrar_user['ID_Rol'];
	}
	mysqli_close($conn);

?>

<nav>
	<ul>
	    <li><a href="./Dashboard.php"><i class="fa-solid fa-house" style="color: #ffffff;"></i> Inicio</a></li>
			<?php if($idrol == 1){ ?>
			<li class="principal" id="users">
				<a href="#"><i class="fa-solid fa-users" style="color: #ffffff;"></i> Usuarios</a>
				<ul>
					<li><a href="./c_usuarios.php"><i class="fa-solid fa-user-plus" style="color: #ffffff;"></i> Nuevo Usuario</a></li>
					<li><a href="./r_usuarios.php"><i class="fa-solid fa-users" style="color: #ffffff;"></i> Lista de Usuarios</a></li>
				</ul>
				</li>
				<?php } ?>
				<li class="principal">
					<a href="#"><i class="fa-solid fa-users-line" style="color: #ffffff;"></i> Clientes</a>
					<ul>
							<?php if($idrol != 2 && $idrol != 3){ ?>
						<li><a href="c_clientes.php"><i class="fa-solid fa-user-plus" style="color: #ffffff;"></i> Nuevo Cliente</a></li>
							<?php } ?>
						<li><a href="r_clientes.php"><i class="fa-solid fa-users-rays" style="color: #ffffff;"></i> Lista de Clientes</a></li>
					</ul>
				</li>
				<?php if($idrol != 4){ ?>
				<li class="principal">
					<a href="#"><i class="fa-solid fa-cart-shopping" style="color: #ffffff;"></i> Compras</a>
					<ul>
							<?php if($idrol != 2){ ?>
						<li><a href="c_proveedor.php"><i class="fa-solid fa-truck-field" style="color: #ffffff;"></i> Nuevo Proveedor</a></li>
							<?php } ?>
						<li><a href="r_proveedores.php"><i class="fa-solid fa-boxes-packing" style="color: #ffffff;"></i> Lista de Proveedores</a></li>
                        <li><a href="r_entradas.php"><i class="fa-solid fa-bag-shopping" style="color: #ffffff;"></i> Lista de Compras</a></li>
					</ul>
				</li>
				<?php } ?>
				<li class="principal">
					<a href="#"><i class="fa-solid fa-cart-flatbed" style="color: #ffffff;"></i> Inventario</a>
					<ul>
							<?php if($idrol != 4 && $idrol != 2){ ?>
						<li><a href="c_productos.php"><i class="fa-solid fa-tag" style="color: #ffffff;"></i> Nuevo Producto</a></li>
						<li><a href="r_categorias.php"><i class="fa-solid fa-calendar" style="color: #ffffff;"></i> Lista de Categorias</a></li>
							<?php } ?>
						<li><a href="r_productos.php"><i class="fa-sharp fa-solid fa-tags" style="color: #ffffff;"></i> Lista de Productos</a></li>
							<?php if($idrol != 4 && $idrol != 2){ ?>
						<li><a href="r_salidas.php"><i class="fa-sharp fa-solid fa-door-open" style="color: #fff;"></i> Lista de Salidas</a></li>
							<?php } ?>
					</ul>
				</li>
				<li class="principal">
					<a href="#"><i class="fa-solid fa-folder-open" style="color: #ffffff;"></i> Ventas</a>
					<ul>
							<?php if($idrol != 2 && $idrol != 3){ ?>
						<li><a href="c_factura.php"><i class="fa-solid fa-file-circle-plus" style="color: #ffffff;"></i> Nueva Venta</a></li>
							<?php } ?>
						<li><a href="r_ventas.php"><i class="far fa-newspaper" style="color: #ffffff;"></i> Lista de Ventas</a></li>
					</ul>
				</li>
	</ul>
</nav>