<?php

include("./Database/conn_backend.php");

if(!empty($_POST)){
    $alert = '';
    if(empty($_POST['name']) || empty($_POST['desc']) || empty($_POST['ID_Proveedor']) || empty($_POST['precio_u']) || empty($_POST['costo']) || empty($_POST['ID_Categoria'])){
        $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

    }else{
        
            $cod_producto = $_POST['cod_prod'];
            $nombre = $_POST['name'];
            $descripcion = $_POST['desc'];
            $proveedor = $_POST['ID_Proveedor'];
            $precio_u = $_POST['precio_u'];
            $costo = $_POST['costo'];
            $id_categoria = $_POST['ID_Categoria'];

            // Trabajando con la foto
            $foto = $_FILES['foto'];
            $nombre_foto = $foto['name'];
            $type = $foto['type'];
            $url_temp = $foto['tmp_name'];
            
            if($nombre_foto != ''){
                $destino = 'assets/images/Uploads/';
                $img_nombre = 'img_'.md5(date('d-m-y H:m:s'));
                $img_producto = $img_nombre.'.jpg';
                $src = $destino.$img_producto;
            }

            $verify_name_img = mysqli_query($conn,"SELECT * FROM t_producto 
                                                            WHERE (Nombre='$nombre' AND Cod_Producto != $cod_producto)");

            $result = mysqli_fetch_array($verify_name_img);

            if($result > 0){
                $alert = '<p class="msg_error">Producto existente.</p>';

            }else{
                
                if($nombre_foto == ''){
                    $query_update = mysqli_query($conn, "UPDATE t_producto 
                                                            SET Nombre='$nombre', Descripcion='$descripcion', Proveedor=$proveedor, Precio_Unitario='$precio_u', Costo='$costo', ID_Categoria=$id_categoria
                                                            WHERE Cod_Producto=$cod_producto
                                                            AND ID_Estado = 1");

                }else{
                    $query_update = mysqli_query($conn, "UPDATE t_producto 
                                                            SET Nombre='$nombre', Descripcion='$descripcion', Proveedor=$proveedor, Precio_Unitario='$precio_u', Costo='$costo', Imagen='$img_producto', ID_Categoria=$id_categoria
                                                            WHERE Cod_Producto=$cod_producto
                                                            AND ID_Estado = 1");

                }

                if($query_update){
                    if($nombre_foto != ''){
                        move_uploaded_file($url_temp,$src);
                    }
                    $alert = '<p class="msg_save">Producto actualizado satisfactoriamente.</p>';

                }else{
                    $alert = '<p class="msg_error">Error al actualizar el producto.</p>';
                }
            }
    }
    mysqli_close($conn);
}
?>