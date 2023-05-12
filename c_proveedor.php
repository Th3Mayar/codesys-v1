<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/c_proveedores.controller.php');

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
        $id_usuario = $mostrar['ID_Usuario'];
    }

    if($idrol == 2 || $idrol == 4 ){
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
            <form method="POST" action="" class="form-register">
                <h1><i class="fa-solid fa-truck-field" style="color: #525151;"></i> Registro Proveedor</h1>
                    <hr>
                    <input type="text" placeholder="Proveedor" id="prov" name="prov">
                    <input type="hidden" placeholder="ID_Usuario" id="id_user" name="id_user" value="<?php echo $id_usuario?>">
                    <input type="text" placeholder="Contacto" id="contact" name="contact">
                    <input type="text" placeholder="Telefono" id="tel" name="tel">
                    <input type="text" placeholder="Direccion" id="direcc" name="direcc">
                    <button type="submit" class="btn_save"><i class="fa-solid fa-floppy-disk" style="color: #525151;"></i> Registrar Proveedor</button>
            </form>
        </div>
</section>
<br><br><br><br>
<?php include_once("Include/plantilla_pie.php");?>
