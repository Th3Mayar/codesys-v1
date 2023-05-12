<?php 
    include("Include/plantilla_Cabeza.php");
    include("Controllers/r_proveedores.controller.php");
?>
<br>
<br>
<head>
    <link rel="stylesheet" href="css/style.css">
</head>
<section id="container">
    <div class="r_user">
	<h1><i class="fa-solid fa-boxes-packing" style="color: #000;"></i> Lista de proveedores</h1>
        <?php if($idrol != 2 && $idrol != 3){ ?>
    <a class="btn_new" href="c_proveedor.php"><i class="fa-solid fa-truck-field" style="color: #525151;"></i> Registrar proveedores</a>
        <?php } ?>
    <form method="GET" action="buscar_proveedores.php" class="form_search">
        <input type="text" name="busqueda" id="busqueda" placeholder="Buscar">
        <button type="submit" class="btn_search"><i class="fa-solid fa-magnifying-glass" style="color: #000000;"></i></button>
    </form>
    <div class="containerTableResponsive">
    <table>
        <thead class="table">
        <tr>
            <th>ID</th>
            <th>Proveedor</th>
            <th>Usuario</th>
            <th>Fecha de registro</th>
            <th>Contacto</th>
            <th>Telefono</th>
            <th>Direccion</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <?php while($mostrar = mysqli_fetch_array($result)): ?>
        <tr class="row<?= $mostrar['ID_Proveedor'];?>">
            <td><?= $mostrar['ID_Proveedor']; ?></td>
            <td><?= $mostrar['Proveedor']; ?></td>
            <td><?= $mostrar['Nombre']; ?></td>
            <td><?= $mostrar['Fecha_New']; ?></td>
            <td><?= $mostrar['Contacto']; ?></td>
            <td><?= $mostrar['Telefono']; ?></td>
            <td><?= $mostrar['Direccion']; ?></td>
            <td>
                <?php if($idrol != 2){ ?>
                <a class="btn_edit" id="abrir_caja" href="u_proveedores.php?id=<?php echo $mostrar['ID_Proveedor'];?>" data-bs-toggle="modal" data-bs-target="#btn_editar" ><i class="fa-solid fa-pen-to-square"></i></a>
                    <?php if($idrol != 4 && $idrol != 3){ ?>
                <a class="btn_delete del_supplier" href="#" client="<?php echo $mostrar['ID_Proveedor'];?>"><i class="fa-solid fa-trash"></i></a>
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