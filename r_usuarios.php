<?php 
    include_once("Include/plantilla_Cabeza.php");
    include("Controllers/r_usuarios.controller.php");

    $usuario = $_SESSION['Usuario'];

	include("Database/conn_backend.php");
	$sql = mysqli_query($conn, 
	"SELECT (u.Rol) as ID_Rol, (r.Rol) as Rol
		FROM t_usuario u 
		INNER JOIN t_rol r
		ON u.Rol = r.ID_Rol WHERE Usuario='$usuario'");

    $idrol = 0;
    
	while($sql_get_user = mysqli_fetch_array($sql)){
		$idrol = $sql_get_user['ID_Rol'];
	}

    if($idrol != 1){
        header("location: Dashboard.php");
    }
	mysqli_close($conn);
?>
<br>
<br>
<head>
    <link rel="stylesheet" href="css/style.css">
</head>
<section id="container">
    <div class="r_user">
	<h1><i class="fa-solid fa-users" style="color: #000;"></i> Lista de usuarios</h1>
    <a class="btn_new" href="c_usuarios.php"><i class="fa-solid fa-user-plus" style="color: #3d3d3d;"></i> Registrar usuarios</a>
    <form method="GET" action="buscar_usuarios.php" class="form_search">
        <input type="text" name="busqueda" id="busqueda" placeholder="Buscar">
        <button type="submit" class="btn_search"><i class="fa-solid fa-magnifying-glass" style="color: #000000;"></i></button>
    </form>
    <div class="containerTableResponsive">
    <table>
        <thead class="table">
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Correo</th>
            <th>Usuario</th>
            <th>Contraseña</th>
            <th>Rol</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <?php while($mostrar = mysqli_fetch_array($result)): ?>
        <tr class="row<?= $mostrar['ID_Usuario']; ?>">
            <td><?= $mostrar['ID_Usuario']; ?></td>
            <td><?= $mostrar['Nombre']; ?></td>
            <td><?= $mostrar['Email']; ?></td>
            <td><?= $mostrar['Usuario']; ?></td>
                <?php
                    $pass = $mostrar['Pass']; 
                    $passEncript = str_repeat("*", strlen($pass));
                ?>
            <td><?php echo $passEncript ?></td>
            <td><?= $mostrar['Rol']; ?></td>
            <td>
                <a class="btn_edit" href="u_usuarios.php?id=<?= $mostrar['ID_Usuario'];?>" data-bs-toggle="modal"><i class="fa-solid fa-pen-to-square"></i></a>
                    <?php if($mostrar['ID_Usuario'] != 1){?>
                <a class="btn_delete del_user" href="#" user="<?= $mostrar['ID_Usuario'];?>"><i class="fa-solid fa-trash"></i></a>
                    <?php } ?>
            </td>
            <?php endwhile;?>
        </tr>
        </tbody>
    </table>
    </div>
    <div class="paginador">
        <ul>
            <?php if($pagina != 1){ ?>
            <li><a href="?pagina=<?php echo 1; ?>"><i class="fa-sharp fa-solid fa-backward-step" style="color: #000000; height: 16px;"></i></a></li>
            <li><a href="?pagina=<?php echo $pagina-1; ?>"><i class="fa-sharp fa-solid fa-caret-left" style="color: #000000; height: 16px;"></i></a></li>
            <?php } for($i=1;$i<=$total_pages;$i++){
                if($i == $pagina){
                    echo '<li class="page_select">'.$i.'</a></li>';
                }else{
                echo '<li><a href="?pagina='.$i.'">'.$i.'</a></li>';
                }
            } if($pagina != $total_pages){ ?>
            <li><a href="?pagina=<?php echo $pagina + 1; ?>"><i class="fa-solid fa-caret-right" style="color: #000000; height: 16px;"></i></a></li>
            <li><a href="?pagina=<?php echo $total_pages?>"><i class="fa-sharp fa-solid fa-forward-step" style="color: #000000; height: 16px;"></i></a></li>
            <?php } ?>
        </ul>
    </div>
    </div>
</section>
<?php include_once("Include/plantilla_pie.php");?>