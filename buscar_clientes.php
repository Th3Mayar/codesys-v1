<?php 
    
    $busqueda = strtolower($_REQUEST['busqueda']);
        if(empty($busqueda)){
            header("location: r_clientes.php");
            
        }else{
            include_once("Include/plantilla_Cabeza.php");
            include("Controllers/u_buscarCe.controller.php");
            $usuario = $_SESSION['Usuario'];

            include("Database/conn_backend.php");
            $sql_get = mysqli_query($conn, 
            "SELECT (u.Rol) as ID_Rol, (r.Rol) as Rol
                FROM t_usuario u 
                INNER JOIN t_rol r
                ON u.Rol = r.ID_Rol WHERE Usuario='$usuario'");

            $idrol = 0;

            while($query_get = mysqli_fetch_array($sql_get)){
                $idrol = $query_get['ID_Rol'];
            }
        }
    
?>
<br>
<br>
<head>
    <link rel="stylesheet" href="css/style.css">
</head>
<section id="container">
    <div class="r_user">
	<h1><i class="fa-solid fa-users" style="color: #000;"></i> Lista de clientes</h1>
        <?php if($idrol != 2 && $idrol != 3){ ?>
    <a class="btn_new" href="c_clientes.php"><i class="fa-solid fa-user-plus" style="color: #3d3d3d;"></i> Registrar cliente</a>
        <?php } ?>
    <form method="GET" action="" class="form_search">
        <input type="text" name="busqueda" id="busqueda" placeholder="Buscar" value="<?php echo $busqueda;?>">
        <button type="submit" class="btn_search"><i class="fa-solid fa-magnifying-glass" style="color: #000000;"></i></button>
    </form>
    <div class="containerTableResponsive">
    <table>
        <thead class="table">
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>RNC</th>
            <th>Telefono</th>
            <th>Direccion</th>
            <th>Email</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <?php while($mostrar = mysqli_fetch_array($result)): ?>
        <tr>
            <td><?= $mostrar['ID_Cliente']; ?></td>
            <td><?= $mostrar['Nombre']; ?></td>
            <td><?= $mostrar['Apellido']; ?></td>
            <td><?= $mostrar['RNC']; ?></td>
            <td><?= $mostrar['Telefono']; ?></td>
            <td><?= $mostrar['Direccion']; ?></td>
            <td><?= $mostrar['Correo']; ?></td>
            <td>
                <?php if($idrol != 2){ ?>
                <a class="btn_edit" id="abrir_caja" href="u_clientes.php?id=<?php echo $mostrar['ID_Cliente'];?>" data-bs-toggle="modal" data-bs-target="#btn_editar" ><i class="fa-solid fa-pen-to-square"></i></a>
                    <?php if($idrol != 4 && $idrol != 3){ ?>
                <a class="btn_delete del_client" href="#" client="<?php echo $mostrar['ID_Cliente'];?>"><i class="fa-solid fa-trash"></i></a>
                    <?php }} ?>
            </td>
            <?php endwhile;?>
        </tr>
        </tbody>
    </table>
    </div>
    <?php if($total_registro != 0){?>
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
    <?php } ?>
    </div>
</section>
<?php include_once("Include/plantilla_pie.php");?>