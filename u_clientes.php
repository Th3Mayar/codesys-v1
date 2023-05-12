<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/u_clientes.controller.php');?>
<?php 

include("Include/security.rol.php");
include("Database/conn_backend.php");

if(empty($_GET['id'])){
    header("location: r_clientes.php");
}else{

$id_cliente = $_GET['id'];

$sql = mysqli_query($conn, 
"SELECT ce.ID_Cliente, ce.Nombre, ce.Apellido, ce.Telefono, ce.Direccion, ce.Correo, e.Estado
    FROM t_cliente ce
    INNER JOIN t_estado e 
    ON ce.ID_Estado = e.ID_Estado 
    WHERE ID_Cliente=$id_cliente AND e.ID_Estado = 1");

$result = mysqli_num_rows($sql);

if ($result == 0) {
    header("location: r_clientes.php");
    
}else{
    $option1 = '';
    while($mostrar = mysqli_fetch_array($sql)){
        $id_cliente = $mostrar['ID_Cliente'];
        $nombre = $mostrar['Nombre'];
        $Apellido = $mostrar['Apellido'];
        $Telefono = $mostrar['Telefono'];
        $Direccion = $mostrar['Direccion'];
        $Email = $mostrar['Correo'];
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
            <form method="POST" action="" class="form-register">
            <h1><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar Cliente</h1>
                    <hr>
                    <input type="hidden" placeholder="ID" id="idcliente" name="idcliente" value="<?php echo $id_cliente?>" readonly>
                    <input type="text" placeholder="Nombre Completo" id="name" name="name" value="<?php echo $nombre;?>">
                    <input type="text" placeholder="Apellido" id="apellido" name="apellido" value="<?php echo $Apellido;?>">
                    <input type="text" placeholder="Telefono" id="tel" name="tel" value="<?php echo $Telefono;?>">
                    <input type="text" placeholder="Direccion" id="direc" name="direc" value="<?php echo $Direccion;?>">
                    <input type="text" placeholder="Email" id="email" name="email" value="<?php echo $Email;?>">
                    <button type="submit" class="btn_save"><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar Cliente</button>
            </form>
        </div>
</section>
<br><br>
<br><br><br>
<?php include_once("Include/plantilla_pie.php");?>