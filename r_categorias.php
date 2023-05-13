<?php 
    include_once("Include/plantilla_Cabeza.php");
    include("Controllers/r_categorias.controller.php");

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

    if($idrol != 1 && $idrol != 3){
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
	<h1><i class="fa-solid fa-gear" style="color: #000;"></i> Administrar categorias</h1>
    <div class="containerTableResponsive">
    <table>
        <thead class="table">
        <tr>
            <th>ID</th>
            <th>Nombre Categoria</th>
            <th>Descripcion</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
            <?php while($data = mysqli_fetch_array($query)): ?>
        <tr class="row<?=$data['ID_Categoria'];?>">
            <td><?= $data['ID_Categoria']; ?></td>
            <td class="celName"><?= $data['Nombre_Categoria']; ?></td>
            <td class="celDesc"><?= $data['Descripcion']; ?></td>
            <td>
                <a class="btn_edit edit_cat" category="<?php echo $data['ID_Categoria']; ?>" href="#"><i class="fa-solid fa-pen-to-square"></i></a>
                <?php if($idrol != 4 && $idrol != 3){ ?>
                <a class="btn_delete del_cat" category="<?php echo $data['ID_Categoria'];?>" href="#"><i class="fa-solid fa-trash"></i></a>
                <?php } ?>
            </td>
            <?php endwhile;?>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td>
                <a class="btn_add add_category" href="#"><i class="fa-solid fa-plus" style="color: #fff;"></i> <span>Agregar categoria</span></a>
            </td>
        </tr>
        </tbody>
    </table>
    </div>
    </div>
</section>
<p style="margin-top:-17px;"></p>
<?php include_once("Include/plantilla_pie.php");?>