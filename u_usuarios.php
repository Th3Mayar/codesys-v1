<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/u_usuarios.controller.php');?>
<?php 

include("Include/security.usuarios.php");
include("Database/conn_backend.php");

if(empty($_GET['id'])){
    header("location: r_usuarios.php");
}

$id_user = $_GET['id'];

$sql = mysqli_query($conn, 
"SELECT u.ID_Usuario, u.Nombre, u.Email, u.Usuario, u.Pass, (u.Rol) as ID_Rol, (r.Rol) as Rol, (u.ID_Estado) as ID_Estado, (e.Estado) as Estado
    FROM t_usuario u 
    INNER JOIN t_rol r
    INNER JOIN t_estado e
    ON u.Rol = r.ID_Rol AND u.ID_Estado = e.ID_Estado
    WHERE ID_Usuario=$id_user AND e.ID_Estado = 1");

$result = mysqli_num_rows($sql);

if ($result == 0) {
    header("location: r_usuarios.php");
}else{
    $option1 = '';
    $option2 = '';
    while($mostrar = mysqli_fetch_array($sql)){
        $id_user = $mostrar['ID_Usuario'];
        $nombre = $mostrar['Nombre'];
        $email = $mostrar['Email'];
        $usuario = $mostrar['Usuario'];
        $pass = $mostrar['Pass'];
        $idrol = $mostrar['ID_Rol'];
        $rol = $mostrar['Rol'];

        for($i=1;$i<=500;$i++){
            if($idrol == $i ){
                $option1 = '<option value="'.$idrol.'" select>'.$rol.'</option>';
            }
        }
    }
}
?>
<br>
<br>
<head><link rel="stylesheet" href="css/style.css"></head>
<section id="container">
    <div class="form_register">
        <div class="alert"><?php echo $alert ?></div>
            <!-- Formulario de registro Controllers/c_usuarios.controller.php -->
            <form method="POST" action="" class="form-register">
                <h1><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar Usuario</h1>
                    <hr>
                    <input type="hidden" placeholder="ID" id="idusuario" name="idusuario" value="<?php echo $id_user?>" readonly>
                    <input type="text" placeholder="Nombre Completo" id="name" name="name" value="<?php echo $nombre;?>">
                    <input type="text" placeholder="Email" id="email" name="email" value="<?php echo $email;?>">
                    <input type="text" placeholder="Usuario" id="user" name="user" value="<?php echo $usuario;?>">
                    <input type="password" placeholder="Contraseña" id="pass" name="pass">
                    <?php 
                        $getRol = "SELECT ID_Rol, Rol FROM t_rol";
                        $queryRol = mysqli_query($conn, $getRol);
                    ?>
                    <label for="Rol">
                        <p style="font-size: 12px; margin-left: 8px;">Rol</p>
                        <select name="Rol" id="Rol" class="notItemOne" aria-label=".form-select-lg example">
                            <?php
                                echo $option1;
                                if($queryRol > 0){
                                    while($row = mysqli_fetch_array($queryRol)): ?>
                                        <option name="Rol" value="<?= $row['ID_Rol']?>"><?php echo $row['Rol']?></option>
                                <?php endwhile; } ?>
                        </select>
                    </label>
                    <button type="submit" class="btn_save"><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar Usuario</button>
            </form>
        </div>
</section>
<br>
<br>
<br>
<?php include_once("Include/plantilla_pie.php");?>