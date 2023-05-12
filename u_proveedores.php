<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/u_proveedores.controller.php');?>
<?php 

include("Include/security_prov.php");
include("Database/conn_backend.php");

if(empty($_GET['id'])){
    header("location: r_proveedores.php");
}else{

$id_proveedor = $_GET['id'];

$sql = mysqli_query($conn, "SELECT prov.ID_Proveedor, prov.Proveedor, u.Nombre, prov.Fecha_Registro, prov.Contacto, prov.Telefono, prov.Direccion, e.Estado
            FROM t_proveedor prov
            INNER JOIN t_usuario u 
            INNER JOIN t_estado e 
            ON prov.ID_Estado = e.ID_Estado 
            AND prov.Cod_Usuario = u.ID_Usuario
            WHERE ID_Proveedor = $id_proveedor AND e.ID_Estado = 1");

$result = mysqli_num_rows($sql);

if ($result == 0) {
    header("location: r_proveedores.php");
    
}else{
    while($mostrar = mysqli_fetch_array($sql)){
        $id_prov = $mostrar['ID_Proveedor'];
        $proveedor = $mostrar['Proveedor'];
        $contacto = $mostrar['Contacto'];
        $tel = $mostrar['Telefono'];
        $direcc = $mostrar['Direccion'];
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
            <h1><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar Proveedor</h1>
                    <hr>
                    <input type="hidden" placeholder="ID" id="id_prov" name="id_prov" value="<?php echo $id_prov;?>">
                    <input type="text" placeholder="Proveedor" id="prov" name="prov" value="<?php echo $proveedor;?>">
                    <input type="text" placeholder="Contacto" id="contact" name="contact" value="<?php echo $contacto;?>">
                    <input type="text" placeholder="Telefono" id="tel" name="tel" value="<?php echo $tel;?>">
                    <input type="text" placeholder="Direccion" id="direcc" name="direcc" value="<?php echo $direcc;?>">
                    <button type="submit" class="btn_save"><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar Proveedor</button>
            </form>
        </div>
</section>
<br><br><br>
<br><br><br><br>
<?php include_once("Include/plantilla_pie.php");?>