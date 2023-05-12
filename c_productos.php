<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/c_productos.controller.php');

    $usuario = $_SESSION['Usuario'];

    include("Database/conn_backend.php");
    $sql = mysqli_query($conn, 
    "SELECT (u.Rol) as ID_Rol, (r.Rol) as Rol, (u.ID_Usuario) as ID_Usuario
        FROM t_usuario u 
        INNER JOIN t_rol r
        ON u.Rol = r.ID_Rol WHERE Usuario='$usuario'");

    $idrol = 0;

    while($mostrar = mysqli_fetch_array($sql)){
        $idrol = $mostrar['ID_Rol'];
        $id_user = $mostrar['ID_Usuario'];
    }

    if($idrol != 1 && $idrol != 4){
        header("location: Dashboard.php");
    }
    mysqli_close($conn);
?>
<br>
<br>
<head><link rel="stylesheet" href="css/style.css"></head>
<section id="container">
    <div class="form_register">
        <div class="alert"><?php echo $alert ?></div>
            <!-- Formulario de registro Controllers/c_usuarios.controller.php -->
            <form method="POST" action="" class="form-register" enctype="multipart/form-data">
                <h1><i class="fa-solid fa-tag" style="color: #525151;"></i> Registro producto</h1>
                    <hr>
                    <input type="text" placeholder="Nombre" id="name" name="name">
                    <input type="text" placeholder="Descripcion" id="desc" name="desc">
                    <label>
                        <p style="font-size: 12px; margin-left: 8px;">Proveedor</p>
                        <select name="ID_Proveedor" id="ID_Proveedor" class="form-select form-select-lg mb-1" aria-label=".form-select-lg example">
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
                    </label>
                    <input type="hidden" placeholder="ID_Usuario" id="id_user" name="id_user" value="<?php echo $id_user; ?>">
                    <input type="number" placeholder="Precio Unitario" id="precio_u" name="precio_u">
                    <input type="number" placeholder="Cantidad" id="cantidad" name="cantidad">
                    <input type="number" placeholder="Costo" id="costo" name="costo">
                    </label>
                    <label>
                        <p style="font-size: 12px; margin-left: 8px;">Categoria</p>
                        <select name="ID_Categoria" id="ID_Categoria" class="form-select form-select-lg mb-1" aria-label=".form-select-lg example">
                            <?php 
                                include("Database/conn_backend.php");
                                $getCategoria = "SELECT ID_Categoria, Nombre_Categoria FROM t_categoria";
                                $queryCategoria = mysqli_query($conn, $getCategoria);
                                mysqli_close($conn);

                            while($row = mysqli_fetch_array($queryCategoria)): ?>
                            <option name="ID_Categoria" value="<?= $row['ID_Categoria']?>"><?php echo $row['Nombre_Categoria']?>
                            </option>
                            <?php endwhile; ?>
                        </select>
                    </label>
                    <div class="photo">
                        <label for="foto"><p style="font-size: 12px; margin-left: 8px;">Imagen</p></label>
                            <div class="prevPhoto">
                            <span class="delPhoto notBlock">X</span>
                            <label for="foto"></label>
                        </div>
                            <div class="upimg">
                            <input type="file" name="foto" id="foto">
                        </div>
                        <div id="form_alert"></div>
                    </div>
                    <button type="submit" class="btn_save"><i class="fa-solid fa-floppy-disk" style="color: #525151;"></i> Registrar Producto</button>
            </form>
        </div>
</section>
<br>
<br>
<br>
<?php include_once("Include/plantilla_pie.php");?>
