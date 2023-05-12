<?php include_once("Include/plantilla_Cabeza.php");?>
<?php $alert = ''; include('Controllers/u_productos.controller.php');?>
<?php 

include("Include/security.productos.php");
include("Database/conn_backend.php");

if(empty($_GET['id'])){
    header("location: r_productos.php");
}

$cod_producto = $_GET['id'];

$sql = mysqli_query($conn,"SELECT prod.Cod_Producto, prod.Nombre, prod.Descripcion, prov.Proveedor, prov.ID_Proveedor, prod.Precio_Unitario, prod.Cantidad, prod.Costo, prod.Imagen, e.Estado, e.ID_Estado, ca.Nombre_Categoria, ca.ID_Categoria
            FROM t_producto prod
            INNER JOIN t_estado e 
            INNER JOIN t_proveedor prov
            INNER JOIN t_categoria ca 
            ON prod.ID_Estado = e.ID_Estado 
            AND prod.Proveedor = prov.ID_Proveedor
            AND prod.ID_Categoria = ca.ID_Categoria
            WHERE Cod_Producto = $cod_producto AND e.ID_Estado = 1");

$result = mysqli_num_rows($sql);

if ($result == 0) {
    header("location: r_productos.php");

}else{
    $option1 = '';
    $option2 = '';
    $option3 = '';
    while($mostrar = mysqli_fetch_array($sql)){
        $cod_producto = $mostrar['Cod_Producto'];
        $nombre = $mostrar['Nombre'];
        $descripcion = $mostrar['Descripcion'];
        $proveedor = $mostrar['Proveedor'];
        $idproveedor = $mostrar['ID_Proveedor'];
        $precio_u = $mostrar['Precio_Unitario'];
        $costo = $mostrar['Costo'];
        $img = $mostrar['Imagen'];
        $idcategoria = $mostrar['ID_Categoria'];
        $nombre_categoria = $mostrar['Nombre_Categoria'];

        for($i=1;$i<=500;$i++){
            if($idproveedor == $i){
                $option1 = '<option value="'.$idproveedor.'" select>'.$proveedor.'</option>';
            }
            if($idcategoria == $i){
                $option3 = '<option value="'.$idcategoria.'" select>'.$nombre_categoria.'</option>';
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
            <form method="POST" action="" class="form-register" enctype="multipart/form-data">
                <h1><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar producto</h1>
                    <hr>
                    <input type="hidden" placeholder="Codigo" id="cod_prod" name="cod_prod" value="<?= $cod_producto;?>" readonly>
                    <input type="text" placeholder="Nombre" id="name" name="name" value="<?= $nombre;?>">
                    <input type="text" placeholder="Descripcion" id="desc" name="desc" value="<?= $descripcion;?>">
                    <label>
                        <p style="font-size: 12px; margin-left: 8px;">Proveedor</p>
                        <select name="ID_Proveedor" id="ID_Proveedor" class="notItemOne" aria-label=".form-select-lg example">
                            <?php
                                include("Database/conn_backend.php");
                                $getProveedor = "SELECT ID_Proveedor, Proveedor FROM t_proveedor";
                                $queryProveedor = mysqli_query($conn, $getProveedor);
                                mysqli_close($conn);
                        echo $option1;
                        if($queryProveedor > 0){
                            while($row = mysqli_fetch_array($queryProveedor)): ?>
                            <option name="ID_Proveedor" value="<?= $row['ID_Proveedor']?>"><?php echo $row['Proveedor']?>
                            </option>
                            <?php endwhile; } ?>
                        </select>
                    </label>
                    <p style="font-size: 12px; margin-left: 8px; margin-top:10px;">Precio</p>
                    <input type="text" placeholder="Precio Unitario" id="precio_u" name="precio_u" value="<?= $precio_u;?>">
                    <p style="font-size: 12px; margin-left: 8px; margin-top:10px;">Costo</p>
                    <input type="text" placeholder="Costo" id="costo" name="costo" value="<?= $costo;?>">
                    </label>
                    <label>
                        <p style="font-size: 12px; margin-left: 8px;">Categoria</p>
                        <select name="ID_Categoria" id="ID_Categoria" class="notItemOne" aria-label=".form-select-lg example">
                            <?php
                                include("Database/conn_backend.php");
                                $getCategoria = "SELECT ID_Categoria, Nombre_Categoria FROM t_categoria";
                                $queryCategoria = mysqli_query($conn, $getCategoria);
                                mysqli_close($conn);
                        echo $option3;
                        if($queryCategoria > 0){
                            while($row = mysqli_fetch_array($queryCategoria)): ?>
                            <option name="ID_Categoria" value="<?= $row['ID_Categoria']?>"><?php echo $row['Nombre_Categoria']?>
                            </option>
                            <?php endwhile; } ?>
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
                    <button type="submit" class="btn_save"><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Actualizar Producto</button>
            </form>
        </div>
</section>
<br>
<br>
<br>
<?php include_once("Include/plantilla_pie.php");?>