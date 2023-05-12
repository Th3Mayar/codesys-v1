<?php 

    $busqueda = '';
    $fecha_de = '';
    $fecha_a = '';

    // Validar para que ninguna venga vacio
    if(isset($_REQUEST['busqueda']) && $_REQUEST['busqueda'] == ''){
        header("location: r_ventas.php");
    }
    if(isset($_REQUEST['fecha_de']) || isset($_REQUEST['fecha_a'])){
        if($_REQUEST['fecha_de'] == '' || $_REQUEST['fecha_a'] == ''){
            header("location: r_ventas.php");
        }
    }

    if(!empty($_REQUEST['busqueda'])){
        if(!is_numeric($_REQUEST['busqueda'])){
            header("location: r_ventas.php");
        }
        $busqueda = strtolower($_REQUEST['busqueda']);
        $where = "ID_Factura = $busqueda";
        $buscar = "busqueda = $busqueda";
    }

    if(!empty($_REQUEST['fecha_de']) && !empty($_REQUEST['fecha_a'])){
        $fecha_de = $_REQUEST['fecha_de'];
        $fecha_a = $_REQUEST['fecha_a'];

        $buscar = '';

        if($fecha_de > $fecha_a){
            header("location: r_ventas.php");
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
    include("Controllers/u_buscarVenta.controller.php");
?>
<br>
<br>
<head>
    <link rel="stylesheet" href="css/style.css">
</head>
<section id="container">
    <div class="r_user">
	<h1><i class="far fa-newspaper" style="color: #000;"></i> Lista de ventas</h1>
        <?php if($idrol != 2 && $idrol != 3){ ?>
    <a class="btn_new" href="c_factura.php"><i class="fa-solid fa-file-circle-plus" style="color: #000;"></i> Registrar venta</a>
        <?php } ?>
    <form method="GET" action="buscar_venta.php" class="form_search">
        <input type="text" name="busqueda" id="busqueda" placeholder="No. Factura" value="<?php echo $busqueda;?>">
        <button type="submit" class="btn_search"><i class="fa-solid fa-magnifying-glass" style="color: #000000;"></i></button>
    </form>
    <div>
        <h5>Buscar por fecha</h5>
        <form method="GET" action="buscar_venta.php" class="form_search_date">
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
            <th>No.</th>
            <th>Fecha / Hora</th>
            <th>Cliente</th>
            <th>Vendedor</th>
            <th>Estado</th>
            <th>Tipo Factura</th>
            <th class="textright">Total Factura</th>
            <th class="textcenter">Acciones</th>
        </tr>
        </thead>
        <tbody>
        <?php while($mostrar = mysqli_fetch_array($query)): 
                if($mostrar['ID_Estado'] == 4){
                    $estado = '<span class="Pagada">Pagada</span>';
                }else if($mostrar['ID_Estado'] == 5){
                    $estado = '<span class="Tramite">Trámite</span>';
                }else{
                    $estado = '<span class="Anulada">Anulada</span>';
            }
            ?>
        <tr>
            <td class="row_<?= $mostrar['ID_Factura']; ?>"><?= $mostrar['ID_Factura']; ?></td>
            <td><?= $mostrar['Fecha']; ?></td>
            <td><?= $mostrar['cliente']; ?></td>
            <td><?= $mostrar['vendedor']; ?></td>
            <td class="estado"><?= $estado; ?></td>
            <td><?= $mostrar['Tipo_Factura']; ?></td>
            <td class="textright totalfactura"><span style="font-size:18px;">RD$</span><?= $mostrar['Total_Factura']; ?></td>
            <td>
                <div class="div_acciones">
                    <div>
                        <button type="button" class="btn_view view_factura" cl="<?= $mostrar['Cod_cliente'];?>" f="<?= $mostrar['ID_Factura']; ?>" st="<?php echo $mostrar['Tipo_Factura'];?>"><i class="fas fa-eye"></i></button>
                    </div>
                    <?php if($idrol == 1 || $idrol == 3){ 
                                if($mostrar['ID_Estado'] == 4 || $mostrar['ID_Estado'] == 5){?>
                    <div class="div_factura">
                        <button type="button" name="anular" class="btn_null anular_factura" fac="<?= $mostrar['ID_Factura']; ?>"><i class="fas fa-ban"></i></button>
                    </div>
                    <?php }else{ ?>
                            <div class="div_factura">
                                <button type="button" name="inactivo" class="btn_null inactive" fac="<?= $mostrar['ID_Factura']; ?>"><i class="fas fa-ban"></i></button>
                            </div>
                    <?php }} ?>
                    <?php if($mostrar['ID_Estado'] == 5){?>
                        <div class="div_factura">
                            <button type="button" class="btn_append_fac" fac="<?= $mostrar['ID_Factura']; ?>"><i class="fa-solid fa-plus"></i></button>
                        </div>
                    <?php } ?>
                </div>
            </td>
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