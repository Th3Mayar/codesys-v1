<?php 
    include_once("Include/plantilla_Cabeza.php");
    include("Controllers/r_ventas.controller.php");

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
	<h1><i class="far fa-newspaper" style="color: #000;"></i> Lista de ventas</h1>
        <?php if($idrol != 2 && $idrol != 3){ ?>
    <a class="btn_new" href="c_factura.php"><i class="fa-solid fa-file-circle-plus" style="color: #000;"></i> Registrar venta</a>
        <?php } ?>
    <form method="GET" action="buscar_venta.php" class="form_search">
        <input type="text" name="busqueda" id="busqueda" placeholder="No. Factura">
        <button type="submit" class="btn_search"><i class="fa-solid fa-magnifying-glass" style="color: #000000;"></i></button>
    </form>
    <div>
        <h5>Buscar por fecha</h5>
        <form method="GET" action="buscar_venta.php" class="form_search_date">
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
            <td class="textright totalfactura" style="margin-top: 5px;"><span style="font-size:18px; margin-left: 20px;">RD$</span><?= $mostrar['Total_Factura']; ?></td>
            <td>
                <div class="div_acciones">
                    <div>
                        <button type="button" class="btn_view view_factura" cl="<?= $mostrar['Cod_cliente'];?>" f="<?= $mostrar['ID_Factura']; ?>" st="<?php echo $mostrar['Tipo_Factura'];?>"><i class="fas fa-eye"></i></button>
                    </div>
                    <?php if($idrol == 1 || $idrol == 3){ 
                                if($mostrar['ID_Estado'] == 4){?>
                    <div class="div_factura">
                        <button type="button" name="anular" class="btn_null anular_factura" fac="<?= $mostrar['ID_Factura']; ?>"><i class="fas fa-ban"></i></button>
                    </div>
                    <?php }else{ ?>
                            <div class="div_factura">
                                <button type="button" name="inactivo" class="btn_null inactive" fac="<?= $mostrar['ID_Factura']; ?>"><i class="fas fa-ban"></i></button>
                            </div>
                    <?php }} ?>
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