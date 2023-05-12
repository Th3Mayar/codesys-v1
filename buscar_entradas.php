<?php 

    $busqueda = '';
    $fecha_de = '';
    $fecha_a = '';
    
    // Validar para que ninguna venga vacio
    if(isset($_REQUEST['busqueda']) && $_REQUEST['busqueda'] == ''){
        header("location: r_entradas.php");
    }
    if(isset($_REQUEST['fecha_de']) || isset($_REQUEST['fecha_a'])){
        if($_REQUEST['fecha_de'] == '' || $_REQUEST['fecha_a'] == ''){
            header("location: r_entradas.php");
        }
    }

    if(!empty($_REQUEST['fecha_de']) && !empty($_REQUEST['fecha_a'])){
        $fecha_de = $_REQUEST['fecha_de'];
        $fecha_a = $_REQUEST['fecha_a'];

        $buscar = '';

        if($fecha_de > $fecha_a){
            header("location: r_entradas.php");
        }else if($fecha_de == $fecha_a){
            $where = "Fecha LIKE '$fecha_de%'";
            $buscar = "fecha_de=$fecha_de&fecha_a=$fecha_a";
        }else{
            $f_de = $fecha_de.' 00:00:00';
            $f_a = $fecha_a.' 23:59:59';
            $where = "Fecha BETWEEN '$f_de' AND '$f_a'";
            $buscar = "fecha_de=$fecha_de&fecha_a=$fecha_a";
        }
    }

    include_once("Include/plantilla_Cabeza.php");
    include("Controllers/u_buscarEntrada.controller.php");
?>
<br>
<br>
<head>
    <link rel="stylesheet" href="css/style.css">
</head>
<section id="container">
    <div class="r_user">
	<h1>📝 Lista de compras</h1>
    <div>
        <br>
        <h5>Buscar por fecha</h5>
        <form method="GET" action="buscar_entradas.php" class="form_search_date">
            <label>De: </label>
            <input type="date" name="fecha_de" id="fecha_de" value="<?php echo $fecha_de;?>" required>
            <label> A </label>
            <input type="date" name="fecha_a" id="fecha_a" value="<?php echo $fecha_a;?>" required>
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
        <?php while($mostrar = mysqli_fetch_array($query)): ?>
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
            <li><a href="?pagina=<?php echo 1; ?>&<?php echo $buscar; ?>"><i class="fa-sharp fa-solid fa-backward-step" style="color: #000000; height: 16px;"></i></a></li>
            <li><a href="?pagina=<?php echo $pagina-1; ?>&<?php echo $buscar; ?>"><i class="fa-sharp fa-solid fa-caret-left" style="color: #000000; height: 16px;"></i></a></li>
            <?php } for($i=1;$i<=$total_pages;$i++){
                if($i == $pagina){
                    echo '<li class="page_select">'.$i.'</a></li>';
                }else{
                echo '<li><a href="?pagina='.$i.'&'.$buscar.'">'.$i.'</a></li>';
                }
            } if($pagina != $total_pages){ ?>
            <li><a href="?pagina=<?php echo $pagina + 1; ?>&<?php echo $buscar; ?>"><i class="fa-solid fa-caret-right" style="color: #000000; height: 16px;"></i></a></li>
            <li><a href="?pagina=<?php echo $total_pages?>&<?php echo $buscar; ?>"><i class="fa-sharp fa-solid fa-forward-step" style="color: #000000; height: 16px;"></i></a></li>
            <?php } ?>
        </ul>
    </div>
    </div>
</section>
<?php include_once("Include/plantilla_pie.php");?>