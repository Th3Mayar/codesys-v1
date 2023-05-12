<?php

    include("Database\conn_backend.php");
    
    $alert = '';
    if(!empty($_POST)){
        $alert = '';
        if(empty($_POST['name']) || empty($_POST['desc']) || empty($_POST['ID_Proveedor']) || empty($_POST['precio_u']) || empty($_POST['cantidad']) || empty($_POST['costo' ]) || empty($_POST['ID_Categoria'])){
            $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

        }else{

            include("Database\conn_backend.php");

            if(isset($_POST['name'])){
                $codigo_producto = rand(1000, 9999);
                $Nombre = $_POST['name'];
                $Descripcion = $_POST['desc'];
                $ID_Proveedor = $_POST['ID_Proveedor'];
                $Precio_u = $_POST['precio_u'];
                $Cantidad = $_POST['cantidad'];
                $Costo = $_POST['costo'];
                $id_usuario = $_POST['id_user'];
                $ID_Categoria = $_POST['ID_Categoria'];

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

                $verify_NAME_ID = mysqli_query($conn,"SELECT * FROM t_producto WHERE Nombre='$Nombre' OR Cod_Producto='$codigo_producto'");
                
                $result = mysqli_fetch_array($verify_NAME_ID);

                if($result > 0){
                    $alert = '<p class="msg_error">Producto existente.</p>';

                }else{

                    if($nombre_foto == ''){

                        $query = "INSERT INTO t_producto(Cod_Producto, Nombre, Descripcion, Proveedor, Precio_Unitario, Cantidad, Costo, Imagen, ID_Usuario, ID_Estado, ID_Categoria) 
                                VALUES('$codigo_producto','$Nombre','$Descripcion','$ID_Proveedor','$Precio_u','$Cantidad','$Costo','exampleproduct.png','$id_usuario',1,'$ID_Categoria')
                            ";

                    }else{
                        $query = "INSERT INTO t_producto(Cod_Producto, Nombre, Descripcion, Proveedor, Precio_Unitario, Cantidad, Costo, Imagen, ID_Usuario, ID_Estado, ID_Categoria) 
                                VALUES('$codigo_producto','$Nombre','$Descripcion','$ID_Proveedor','$Precio_u','$Cantidad','$Costo','$img_producto','$id_usuario',1,'$ID_Categoria')
                            ";
                    }

                        if(mysqli_query($conn, $query)){
                            if($nombre_foto != ''){
                                move_uploaded_file($url_temp,$src);
                            }
                            $alert = '<p class="msg_save">Producto registrado satisfactoriamente.</p>';

                        }else{
                            $alert = '<p class="msg_error">Error al registrar el producto.</p>';
                        }
                }
        }
    }
    mysqli_close($conn);
}
?>