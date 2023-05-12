<?php

include("./Database/conn_backend.php");

if(!empty($_POST)){
    $alert = '';
    if(empty($_POST['cantidad']) || empty($_POST['precio_u'])){
        $alert = '<p class="msg_error">Ningún campo puede estar vacío.</p>';

    }else{

        include("Database\conn_backend.php");

        if(isset($_POST['cantidad'])){
            $id_entrada = $_POST['id_entrada'];
            $Cod_Producto = $_POST['Cod_Producto'];
            $cant = $_POST['cantidad'];
            $precio_unitario = $_POST['precio_u'];
            
            //ESTO ESTA CORRECTO
            $query_update = mysqli_query($conn, "UPDATE t_entrada_inventario 
                                                    SET Cod_Producto=$Cod_Producto, Cantidad=$cant, Precio_Unitario='$precio_unitario'
                                                    WHERE ID_Entrada=$id_entrada");
            //ESTO AUN NO LO HE PROBAO.
            if($query_update){

                $inventario_cant = 0;
                $cant_producto = 0;

                $get_cant_product = mysqli_query($conn, "SELECT Cantidad, Precio_Unitario FROM t_producto WHERE Cod_Producto=$Cod_Producto");
                $get_cant_inventary = mysqli_query($conn, "SELECT Cantidad, Precio_Unitario FROM t_entrada_inventario WHERE ID_Entrada=$id_entrada");
                    
                while($cant_prod = mysqli_fetch_array($get_cant_product)){
                        $cant_producto = $cant_prod['Cantidad'];
                        //$antiguo_precio = $get_cant['Precio_Unitario'];
                }

                while($cant_inv = mysqli_fetch_array($get_cant_inventary)){
                    $inventario_cant = $cant_inv['Cantidad'];
                    //$antiguo_precio = $get_cant['Precio_Unitario'];
                }

                    $rf = 0;
                    $resultado = 0;
                    $resta = $inventario_cant - $cant;

                    $rf = 103 - $inventario_cant;
                    $resultado = $rf + $cant - $resta;

                    //$get_anterior_precio = $antiguo_precio - $precio_unitario;

                    $query_update_producto = mysqli_query($conn, "UPDATE t_producto 
                                                    SET Cantidad=$resultado
                                                    WHERE Cod_Producto=$Cod_Producto");
                    
                    if($query_update_producto){
                        $alert = '<p class="msg_save">Entrada actualizada satisfactoriamente.</p>';
                        echo "Cantidad ingresada update ".$cant."<br>";
                        echo "Cantidad antes de hacer el ingreso ".$rf."<br>";
                        echo "Resultado a actualizar ".$resultado."<br>";

                    }else{
                        $alert = '<p class="msg_error">Error al actualizar la entrada.</p>';
                    }
                }
        }
    }
    mysqli_close($conn);
}

?>