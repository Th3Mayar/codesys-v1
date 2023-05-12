<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/c_clientes.controller.php');

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

    if($idrol == 2 || $idrol == 3){
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
                <h1><i class="fa-solid fa-user-plus" style="color: #525151;"></i> Registro Cliente</h1>
                    <hr>
                    <input type="text" placeholder="RNC" id="rnc" name="rnc">
                    <input type="text" placeholder="Nombre Completo" id="name" name="name">
                    <input type="text" placeholder="Apellido" id="apellido" name="apellido">
                    <input type="text" placeholder="Telefono" id="tel" name="tel">
                    <input type="text" placeholder="Direccion" id="location" name="location">
                    <input type="text" placeholder="Email" id="email" name="email">
                    <button type="submit" class="btn_save"><i class="fa-solid fa-floppy-disk" style="color: #525151;"></i> Registrar Cliente</button>
            </form>
        </div>
</section>
<br>
<br>
<br>
<?php include_once("Include/plantilla_pie.php");?>
