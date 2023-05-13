<?php 
    include_once("Include/plantilla_Cabeza.php");
    include("Controllers/r_entradas.controller.php");

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

	mysqli_close($conn);

    if($idrol != 1 && $idrol != 3){
        header("location: Dashboard.php");
    }
?>
<br>
<br>
<head>
    <link rel="stylesheet" href="css/style.css">
</head>
<section id="container">
    <div class="r_user">
	<h1><i class="fa-solid fa-cart-shopping" style="color: #000;"></i> Lista de compras</h1>
    <div>
        <br>
        <h5>Buscar por fecha</h5>
        <form method="GET" action="buscar_entradas.php" class="form_search_date">
            <label>De: </label>
            <input type="date" name="fecha_de" id="fecha_de" required>
            <label> A </label>
            <input type="date" name="fecha_a" id="fecha_a" required>
            <button type="submit" class="btn_view"><i class="fa-solid fa-magnifying-glass" style="color: #000000;"></i></button>
        </form>
    </div>
    <div class="containerTableResponsive">
    <table>
        <thead class="table">
        <tr>
            <th>ID</th>
            <th>Nombre producto</th>
            <th>Codigo Producto</th>
            <th>Fecha</th>
            <th>Cantidad</th>
            <th>Precio Unitario</th>
            <th>Usuario</th>
        </tr>
        </thead>
        <tbody>
        <?php while($mostrar = mysqli_fetch_array($result)): ?>
        <tr>
            <td><?= $mostrar['ID_Entrada']; ?></td>
            <td><?= $mostrar['Nombre_Prod']; ?></td>
            <td><?= $mostrar['Cod_Producto']; ?></td>
            <td><?= $mostrar['Fecha_New']; ?></td>
            <td><?= $mostrar['Cantidad']; ?></td>
            <td><?= $mostrar['Precio_Unitario']; ?></td>
            <td><?= $mostrar['Nombre']; ?></td>
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