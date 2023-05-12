<?php 
    include_once("Include/plantilla_Cabeza.php");
    include("Controllers/r_productos.controller.php");

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

?>
<br>
<br>
<head>
    <link rel="stylesheet" href="css/style.css">
</head>
<section id="container">
    <div class="r_user">
	<h1><i class="fa-solid fa-tag" style="color: #000;"></i> Lista de productos</h1>
        <?php if($idrol != 4 && $idrol != 2 && $idrol != 3){ ?>
    <a class="btn_new" href="c_productos.php"><i class="fa-solid fa-plus" style="color: #3d3d3d;"></i> Registrar productos</a>
        <?php } ?>
    <form method="GET" action="buscar_productos.php" class="form_search">
        <input type="text" name="busqueda" id="busqueda" placeholder="Buscar">
        <button type="submit" class="btn_search" value="buscar"><i class="fa-solid fa-magnifying-glass" style="color: #000;"></i></button>
    </form>
    <div class="containerTableResponsive">
    <table>
        <thead class="table">
        <tr>
            <th>COD</th>
            <th>Nombre</th>
            <th>Descripcion</th>
            <th>
                <select name="proveedor" id="search_proveedor" class="form-select form-select-lg mb-1" aria-label=".form-select-lg example">
                <option value="" selected>Proveedor</option>
                    <?php 
                        include("Database/conn_backend.php");
                        $getProveedor = "SELECT ID_Proveedor, Proveedor FROM t_proveedor";
                        $queryProveedor = mysqli_query($conn, $getProveedor);
                        mysqli_close($conn);

                        while($row = mysqli_fetch_array($queryProveedor)): ?>
                        <option name="ID_Proveedor" value="<?= $row['ID_Proveedor']?>"><?php echo $row['Proveedor']?>
                        </option>
                    <?php endwhile; ?>
                </select>
            </th>
            <th>Precio</th>
            <th>Cantidad</th>
            <th>Imagen</th>
            <th>Categoria</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <?php while($mostrar = mysqli_fetch_array($result)): ?>
        <tr class="row<?= $mostrar['Cod_Producto']; ?>">
            <td><?= $mostrar['Cod_Producto']; ?></td>
            <td><?= $mostrar['Nombre']; ?></td>
            <td><?= $mostrar['Descripcion']; ?></td>
            <td><?= $mostrar['Proveedor']; ?></td>
            <td class="celPrecio"><?= $mostrar['Precio_Unitario']; ?></td>
            <td class="celCantidad"><?= $mostrar['Cantidad']; ?></td>
            <td><img src="<?php echo 'assets/images/Uploads/'.$mostrar['Imagen'];?>" alt="Producto" height="80px" width="60px"></td>
            <td><?= $mostrar['Nombre_Categoria']; ?></td>
            <td>
                    <?php if($idrol != 4 && $idrol != 2){ ?>
                <a class="btn_append add_product" product="<?php echo $mostrar['Cod_Producto'];?>" href="#"><i class="fa-solid fa-plus" style="color: #fff;"></i></a>
                <a class="btn_edit" id="abrir_caja" href="u_productos.php?id=<?php echo $mostrar['Cod_Producto'];?>" data-bs-toggle="modal" data-bs-target="#btn_editar" ><i class="fa-solid fa-pen-to-square"></i></a>
                    <?php if($idrol != 3){ ?>
                <a class="btn_delete del_product" href="#" product="<?php echo $mostrar['Cod_Producto'];?>"><i class="fa-solid fa-trash"></i></a>
                    <?php }} ?>
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