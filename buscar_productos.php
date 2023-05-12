<?php 

    $busqueda = '';
    $search_proveedor = '';

        if(empty($_REQUEST['busqueda']) && empty($_REQUEST['proveedor'])){
            header("location: r_productos.php");
        }

        if(!empty($_REQUEST['busqueda'])){
            $busqueda = strtolower($_REQUEST['busqueda']);
        }

        if(!empty($_REQUEST['proveedor'])){
            $search_proveedor = $_REQUEST['proveedor'];
        }

        include_once("Include/plantilla_Cabeza.php");
        include("Controllers/u_buscarProd.controller.php");
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
    <form method="GET" action="" class="form_search">
        <input type="text" name="busqueda" id="busqueda" placeholder="Buscar" value="<?php echo $busqueda;?>">
        <button type="submit" class="btn_search"><i class="fa-solid fa-magnifying-glass" style="color: #000000;"></i></button>
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

                        $pro = 0;

                        if(!empty($_REQUEST['proveedor'])){
                            $pro = $_REQUEST['proveedor'];
                        }

                        include("Database/conn_backend.php");
                        $getProveedor = "SELECT ID_Proveedor, Proveedor FROM t_proveedor";
                        $queryProveedor = mysqli_query($conn, $getProveedor);
                        $resultado = mysqli_num_rows($queryProveedor);
                        mysqli_close($conn);

                        if($resultado > 0){
                            while($row = mysqli_fetch_array($queryProveedor)){
                                if($pro == $row['ID_Proveedor']){ ?>
                                    <option name="ID_Proveedor" value="<?= $row['ID_Proveedor']?>" selected><?php echo $row['Proveedor']?></option>
                                <?php }else{ ?>
                                    <option name="ID_Proveedor" value="<?= $row['ID_Proveedor']?>"><?php echo $row['Proveedor']?></option>
                                <?php }
                            }}?>
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
    <?php if($total_pages != 0){?>
    <div class="paginador">
        <ul>
            <?php if($pagina != 1){ ?>
            <li><a href="?pagina=<?php echo 1; ?>&<?php echo $buscar;?>"><i class="fa-sharp fa-solid fa-backward-step" style="color: #000000; height: 16px;"></i></a></li>
            <li><a href="?pagina=<?php echo $pagina-1; ?>&<?php echo $buscar;?>"><i class="fa-sharp fa-solid fa-caret-left" style="color: #000000; height: 16px;"></i></a></li>
            <?php } for($i=1;$i<=$total_pages;$i++){
                if($i == $pagina){
                    echo '<li class="page_select">'.$i.'</a></li>';
                }else{
                echo '<li><a href="?pagina='.$i.'&'.$buscar.'">'.$i.'</a></li>';
                }
            } if($pagina != $total_pages){ ?>
            <li><a href="?pagina=<?php echo $pagina + 1; ?>&<?php echo $buscar;?>"><i class="fa-solid fa-caret-right" style="color: #000000; height: 16px;"></i></a></li>
            <li><a href="?pagina=<?php echo $total_pages?>&<?php echo $buscar;?>"><i class="fa-sharp fa-solid fa-forward-step" style="color: #000000; height: 16px;"></i></a></li>
            <?php } ?>
        </ul>
    </div>
    <?php } ?>
    </div>
</section>
<?php include_once("Include/plantilla_pie.php");?>