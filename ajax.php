<?php 
    include("Database/conn_backend.php");

    session_start();

    $usuario = $_SESSION['Usuario'];

	$sql = mysqli_query($conn, 
	"SELECT u.ID_Usuario, u.Nombre, u.Email, u.Usuario
		FROM t_usuario u 
		WHERE Usuario='$usuario'");
    
    
    while($get_user_id = mysqli_fetch_array($sql)){
        $usuario = $get_user_id['Usuario'];
        $id_usuario = $get_user_id['ID_Usuario'];
    }
    
    if(!empty($_POST)){
        
        // Extraer datos del producto
        if($_POST['action'] == 'infoProducto'){
            $id_producto = $_POST['producto'];

            $query = mysqli_query($conn, "SELECT Cod_Producto, Nombre, Descripcion, Precio_Unitario, Cantidad FROM t_producto
                                            WHERE Cod_Producto = '$id_producto'
                                            AND ID_Estado = 1");
            mysqli_close($conn);

            $result = mysqli_num_rows($query);

            if ($result > 0) {
                $data = mysqli_fetch_assoc($query);
                echo json_encode($data,JSON_UNESCAPED_UNICODE);

            }else{
                echo "error";
            }
            
            exit;
        }
        
        // Añadiendo productos
        if($_POST['action'] == 'addProduct'){

            include("Database/conn_backend.php");

            //Agregar productos a entrada
            if(!empty($_POST['cantidad']) || !empty($_POST['precio']) || !empty($_POST['id_producto'])){
                $cantidad = $_POST['cantidad'];
                $precio = $_POST['precio'];
                $id_producto = $_POST['id_producto'];

                $query_insert =  mysqli_query($conn, "INSERT INTO t_entrada_inventario(Cod_Producto, Cantidad, Precio_Unitario, ID_Usuario)
                                                        VALUES($id_producto, $cantidad, $precio, $id_usuario)");

                if($query_insert){
                    //Ejecutar procedimiento almacenado
                    $query_upd = mysqli_query($conn, "CALL actualizar_precio_producto($cantidad, $precio, $id_producto)");
                    $result_prod = mysqli_num_rows($query_upd);

                    if ($result_prod > 0) {
                        $data = mysqli_fetch_assoc($query_upd);
                        $data['id_producto'] = $id_producto;
                        echo json_encode($data,JSON_UNESCAPED_UNICODE);

                    }else{
                        echo "error";
                    }
                }
            }
            mysqli_close($conn);
            exit;
        }
        
        // Extraer datos del usuario
        if($_POST['action'] == 'infoUser'){

            include("Database/conn_backend.php");

            $id_usuario = $_POST['user'];

            $query = mysqli_query($conn, "SELECT u.ID_Usuario, u.Nombre, r.Rol
                                            FROM t_usuario u
                                            INNER JOIN t_rol r
                                            ON u.Rol = r.ID_Rol
                                            WHERE u.ID_Usuario = $id_usuario
                                            AND u.ID_Estado = 1");
            mysqli_close($conn);

            $result = mysqli_num_rows($query);

            if ($result > 0) {
                $data = mysqli_fetch_assoc($query);
                echo json_encode($data,JSON_UNESCAPED_UNICODE);

            }else{
                echo "error";
            }
            
            exit;
        }

        // Extraer datos del cliente
        if($_POST['action'] == 'infoClient'){

            include("Database/conn_backend.php");

            $id_cliente = $_POST['client'];

            $query = mysqli_query($conn, "SELECT ID_Cliente, Nombre, Apellido, RNC FROM t_cliente
                                            WHERE ID_Cliente = $id_cliente
                                            AND ID_Estado = 1");
            mysqli_close($conn);

            $result = mysqli_num_rows($query);

            if ($result > 0) {
                $data = mysqli_fetch_assoc($query);
                echo json_encode($data,JSON_UNESCAPED_UNICODE);

            }else{
                echo "error";
            }
            
            exit;
        }

        // Extraer datos del proveedor
        if($_POST['action'] == 'infoSupp'){

            include("Database/conn_backend.php");

            $id_proveedor = $_POST['client'];

            $query = mysqli_query($conn, "SELECT ID_Proveedor, Proveedor, Contacto FROM t_proveedor
                                            WHERE ID_Proveedor = $id_proveedor
                                            AND ID_Estado = 1");
            mysqli_close($conn);

            $result = mysqli_num_rows($query);

            if ($result > 0) {
                $data = mysqli_fetch_assoc($query);
                echo json_encode($data,JSON_UNESCAPED_UNICODE);

            }else{
                echo "error";
            }
            
            exit;
        }

        // Eliminar producto
        if($_POST['action'] == 'delProduct'){

            if(empty($_POST['id_producto']) || !is_numeric($_POST['id_producto'])){
                echo "error";

            }else{

            include("Database/conn_backend.php");

            $id_producto = $_POST['id_producto'];
            $query_delete = mysqli_query($conn, "UPDATE t_producto SET ID_Estado = 2 WHERE Cod_Producto = $id_producto");
            
            if($query_delete){
                echo "ok";
            }else{
                echo "error";
            }
            mysqli_close($conn);
            exit;
        }
        echo "error";
        }

        // Eliminar usuario
        if($_POST['action'] == 'delUser'){

            if(empty($_POST['id_usuario']) || !is_numeric($_POST['id_usuario'])){
                echo "error";

            }else{
            
            include("Database/conn_backend.php");
            $id_usuario = $_POST['id_usuario'];
            $query_delete = mysqli_query($conn, "UPDATE t_usuario SET ID_Estado = 2 WHERE ID_Usuario = $id_usuario");

            if($query_delete){
                echo "ok";
            }else{
                echo "error";
            }
            mysqli_close($conn);
            exit;
        }
        echo "error";
        }

        // Eliminar cliente
        if($_POST['action'] == 'delClient'){

            if(empty($_POST['id_cliente']) || !is_numeric($_POST['id_cliente'])){
                echo "error";

            }else{
            
            include("Database/conn_backend.php");
            $id_cliente = $_POST['id_cliente'];
            $query_delete = mysqli_query($conn, "UPDATE t_cliente SET ID_Estado = 2 WHERE ID_Cliente = $id_cliente");

            if($query_delete){
                echo "ok";
            }else{
                echo "error";
            }
            mysqli_close($conn);
            exit;
        }
        echo "error";
        }

        // Eliminar proveedor
        if($_POST['action'] == 'delSupp'){

            if(empty($_POST['id_proveedor']) || !is_numeric($_POST['id_proveedor'])){
                echo "error";

            }else{
            
            include("Database/conn_backend.php");
            $id_proveedor = $_POST['id_proveedor'];
            $query_delete = mysqli_query($conn, "UPDATE t_proveedor SET ID_Estado = 2 WHERE ID_Proveedor = $id_proveedor");

            if($query_delete){
                echo "ok";
            }else{
                echo "error";
            }
            mysqli_close($conn);
            exit;
        }
        echo "error";
        }

        // Eliminar categoria
        if($_POST['action'] == 'delCat'){

            if(empty($_POST['id_categoria']) || !is_numeric($_POST['id_categoria'])){
                echo "error";

            }else{
            
            include("Database/conn_backend.php");
            $id_categoria = $_POST['id_categoria'];
            $query_delete = mysqli_query($conn, "UPDATE t_categoria SET ID_Estado = 2 WHERE ID_Categoria  = $id_categoria");

            if($query_delete){
                echo "ok";
            }else{
                echo "error";
            }
            mysqli_close($conn);
            exit;
        }
        echo "error";
        }

        // Buscar cliente por ventas
        if($_POST['action'] == 'searchCliente'){
            include("Database/conn_backend.php");
            if(!empty($_POST['cliente'])){
                $rnc = $_POST['cliente'];

                $query = mysqli_query($conn, "SELECT * FROM t_cliente WHERE RNC LIKE '$rnc' AND ID_Estado = 1");
                $result = mysqli_num_rows($query);
                $data = '';

                if($result > 0){
                    $data = mysqli_fetch_assoc($query);
                    
                }else{
                    $data = 0;
                
            }
            echo json_encode($data,JSON_UNESCAPED_UNICODE);
        }
        mysqli_close($conn);
        exit;
        }

        // Registrar clientes por ventas
        if($_POST['action'] == 'addCliente'){
            include("Database/conn_backend.php");
            $rnc = $_POST['rnc'];
            $name = $_POST['name'];
            $apellido = $_POST['apellido'];
            $tel = $_POST['tel'];
            $location = $_POST['location'];
            $email = $_POST['email'];
            $id_user = $id_usuario;

            $query_insert = mysqli_query($conn, "INSERT INTO t_cliente(Nombre, Apellido, RNC, Telefono, Direccion, Correo, ID_Estado, Usuario_ID) 
                            VALUES('$name','$apellido','$rnc','$tel','$location','$email', 1, $id_user)
                        ");
            
            if($query_insert){
                $cod_cliente = mysqli_insert_id($conn);
                $msg = $cod_cliente;
                
            }else{
                $msg = "Error al registrar el cliente";
            }
            echo $msg;
            mysqli_close($conn);
            exit;
        }
        
        // Agregar productos a la t_detalle
        if($_POST['action'] == 'addProductoDetalle'){
            include("Database/conn_backend.php");

            if(empty($_POST['producto']) || empty($_POST['cantidad'])){
                echo "error";

            }else{
                $codproducto = $_POST['producto'];
                $cantidad = $_POST['cantidad'];
                $token_user = md5($id_usuario);

                $query_ITBIS = mysqli_query($conn, "SELECT ITBIS FROM t_configuracion");
                $result_ITBIS = mysqli_num_rows($query_ITBIS);

                $query_detalle_fact = mysqli_query($conn, "CALL add_detalle_fact($codproducto,$cantidad,'$token_user')");
                $result = mysqli_num_rows($query_detalle_fact);

                $detalle_tabla = '';
                $sub_total = 0;
                $itbis = 0;
                $total = 0;
                //$precio_total = 0;
                $arrayData = array();

                if($result > 0){
                    if($result_ITBIS > 0){
                        $info_itbis = mysqli_fetch_assoc($query_ITBIS);
                        $itbis = $info_itbis['ITBIS'];
                    }

                    while($data = mysqli_fetch_assoc($query_detalle_fact)){
                        $precio_total = round($data['Cantidad'] * $data['Precio_Venta'], 2);
                        $sub_total = round($sub_total + $precio_total, 2);
                        $total = round($total + $precio_total, 2);
                        
                        $detalle_tabla .= '<tr>
                                            <td>'.$data['Cod_producto'].'</td>
                                            <td colspan="2">'.$data['Descripcion'].'</td>
                                            <td class="textcenter">'.$data['Cantidad'].'</td>
                                            <td class="textright">'.$data['Precio_Venta'].'</td>
                                            <td class="textright">'.$precio_total.'</td>
                                            <td class="">
                                                <a href="#" class="link_delete" onclick="event.preventDefault(); 
                                                del_product_detalle('.$data['ID_Fact_Detalle'].');" style="color:rgb(218, 56, 56);"><i class="far fa-trash-alt" style="color:rgb(218, 56, 56);"></i> Remover</a>
                                            </td>
                                        </tr>';
                    }

                    $impuesto = round($sub_total * ($itbis / 100), 2);
                    $tl_sitbis = round($sub_total - $impuesto, 2);
                    $total = round($tl_sitbis + $impuesto, 2);

                    $detalle_totales = '<tr>
                                            <td colspan="5" class="textright">SUBTOTAL RD$</td>
                                            <td class="textright">RD$'.$tl_sitbis.'</td>
                                        </tr>
                                        <tr>
                                            <td colspan="5" class="textright">ITBIS ('.$itbis.'%)</td>
                                            <td class="textright">RD$'.$impuesto.'</td>
                                        </tr>
                                        <tr>
                                            <td colspan="5" class="textright">TOTAL RD$</td>
                                            <td class="textright">RD$'.$total.'</td>
                                        </tr>';

                    $arrayData['detalle'] = $detalle_tabla;
                    $arrayData['totales'] = $detalle_totales;

                    echo json_encode($arrayData,JSON_UNESCAPED_UNICODE);
                }else{
                    echo "error";
                }
            }
            exit;
        }

        // Extraer datos de la tabla detalle fact detalle
        if($_POST['action'] == 'serchForDetalle'){
            include("Database/conn_backend.php");

            if(empty($_POST['user'])){
                echo "error";

            }else{
                $token_user = md5($id_usuario);

                $query = mysqli_query($conn, "SELECT tfd.ID_Fact_Detalle, tfd.Cod_producto,prod.Descripcion,tfd.Cantidad,tfd.Precio_Venta FROM t_fact_detalle tfd
                                                INNER JOIN t_producto prod
                                                ON tfd.Cod_producto = prod.Cod_Producto
                                                WHERE tfd.Token_User = '$token_user'");
                $result = mysqli_num_rows($query);

                $query_ITBIS = mysqli_query($conn, "SELECT ITBIS FROM t_configuracion");
                $result_ITBIS = mysqli_num_rows($query_ITBIS);

                $detalle_tabla = '';
                $sub_total = 0;
                $itbis = 0;
                $total = 0;
                //$precio_total = 0;
                $arrayData = array();

                if($result > 0){
                    if($result_ITBIS > 0){
                        $info_itbis = mysqli_fetch_assoc($query_ITBIS);
                        $itbis = $info_itbis['ITBIS'];
                    }

                    while($data = mysqli_fetch_assoc($query)){
                        $precio_total = round($data['Cantidad'] * $data['Precio_Venta'], 2);
                        $sub_total = round($sub_total + $precio_total, 2);
                        $total = round($total + $precio_total, 2);
                        
                        $detalle_tabla .= '<tr>
                                            <td>'.$data['Cod_producto'].'</td>
                                            <td colspan="2">'.$data['Descripcion'].'</td>
                                            <td class="textcenter">'.$data['Cantidad'].'</td>
                                            <td class="textright">'.$data['Precio_Venta'].'</td>
                                            <td class="textright">'.$precio_total.'</td>
                                            <td class="">
                                                <a href="#" class="link_delete" onclick="event.preventDefault(); 
                                                del_product_detalle('.$data['ID_Fact_Detalle'].');" style="color:rgb(218, 56, 56);"><i class="far fa-trash-alt" style="color:rgb(218, 56, 56);"></i> Remover</a>
                                            </td>
                                        </tr>';
                    }

                    $impuesto = round($sub_total * ($itbis / 100), 2);
                    $tl_sitbis = round($sub_total - $impuesto, 2);
                    $total = round($tl_sitbis + $impuesto, 2);

                    $detalle_totales = '<tr>
                                            <td colspan="5" class="textright">SUBTOTAL RD$</td>
                                            <td class="textright">RD$'.$tl_sitbis.'</td>
                                        </tr>
                                        <tr>
                                            <td colspan="5" class="textright">ITBIS ('.$itbis.'%)</td>
                                            <td class="textright">RD$'.$impuesto.'</td>
                                        </tr>
                                        <tr>
                                            <td colspan="5" class="textright">TOTAL RD$</td>
                                            <td class="textright">RD$'.$total.'</td>
                                        </tr>';

                    $arrayData['detalle'] = $detalle_tabla;
                    $arrayData['totales'] = $detalle_totales;
                    
                    echo json_encode($arrayData,JSON_UNESCAPED_UNICODE);
                }else{
                    echo "error";
                }
            }
            
            exit;
        }

        // Eliminar producto de la factura
        if($_POST['action'] == 'del_product_detalle'){
            include("Database/conn_backend.php");
            if(empty($_POST['id_detalle'])){
                echo "error";

            }else{
                $id_detalle = $_POST['id_detalle'];
                $token_user = md5($id_usuario);

                $query_ITBIS = mysqli_query($conn, "SELECT ITBIS FROM t_configuracion");
                $result_ITBIS = mysqli_num_rows($query_ITBIS);

                $query_detalle_fact = mysqli_query($conn, "CALL del_detalle_fact($id_detalle,'$token_user')");
                $result = mysqli_num_rows($query_detalle_fact);

                $detalle_tabla = '';
                $sub_total = 0;
                $itbis = 0;
                $total = 0;
                //$precio_total = 0;
                $arrayData = array();

                if($result > 0){
                    if($result_ITBIS > 0){
                        $info_itbis = mysqli_fetch_assoc($query_ITBIS);
                        $itbis = $info_itbis['ITBIS'];
                    }

                    while($data = mysqli_fetch_assoc($query_detalle_fact)){
                        $precio_total = round($data['Cantidad'] * $data['Precio_Venta'], 2);
                        $sub_total = round($sub_total + $precio_total, 2);
                        $total = round($total + $precio_total, 2);

                        $detalle_tabla .= '<tr>
                                            <td>'.$data['Cod_producto'].'</td>
                                            <td colspan="2">'.$data['Descripcion'].'</td>
                                            <td class="textcenter">'.$data['Cantidad'].'</td>
                                            <td class="textright">'.$data['Precio_Venta'].'</td>
                                            <td class="textright">'.$precio_total.'</td>
                                            <td class="">
                                                <a href="#" class="link_delete" onclick="event.preventDefault(); 
                                                del_product_detalle('.$data['ID_Fact_Detalle'].');" style="color:rgb(218, 56, 56);"><i class="far fa-trash-alt" style="color:rgb(218, 56, 56);"></i> Remover</a>
                                            </td>
                                        </tr>';
                    }

                    $impuesto = round($sub_total * ($itbis / 100), 2);
                    $tl_sitbis = round($sub_total - $impuesto, 2);
                    $total = round($tl_sitbis + $impuesto, 2);

                    $detalle_totales = '<tr>
                                            <td colspan="5" class="textright">SUBTOTAL RD$</td>
                                            <td class="textright">RD$'.$tl_sitbis.'</td>
                                        </tr>
                                        <tr>
                                            <td colspan="5" class="textright">ITBIS ('.$itbis.'%)</td>
                                            <td class="textright">RD$'.$impuesto.'</td>
                                        </tr>
                                        <tr>
                                            <td colspan="5" class="textright">TOTAL RD$</td>
                                            <td class="textright">RD$'.$total.'</td>
                                        </tr>';

                    $arrayData['detalle'] = $detalle_tabla;
                    $arrayData['totales'] = $detalle_totales;

                    echo json_encode($arrayData,JSON_UNESCAPED_UNICODE);
                }else{
                    echo "error";
                }
            }
            mysqli_close($conn);
            exit;
        }

        // Anular venta
        if($_POST['action'] == 'anularVenta'){
            include("Database/conn_backend.php");
			$token_user = md5($id_usuario);

            $query_del = mysqli_query($conn, "DELETE FROM t_fact_detalle WHERE Token_User = '$token_user'");

            if($query_del){
                echo "ok";

            }else{
                echo "error";
            }
            mysqli_close($conn);
            exit;
        }
        
        // Procesar venta
        if($_POST['action'] == 'procesarVenta'){
            include("Database/conn_backend.php");

            if(empty($_POST['codcliente'])){
                $codcliente = 1;

            }else{
                $codcliente = $_POST['codcliente'];
            }

            $token_user = md5($id_usuario);
            $cod_user = $id_usuario;

            $query = mysqli_query($conn,"SELECT * FROM t_fact_detalle WHERE Token_User = '$token_user'");
            $result = mysqli_num_rows($query);

            if($result > 0){
                $query_procesar = mysqli_query($conn,"CALL procesar_venta($cod_user,$codcliente,'$token_user')");
                $result_detalle = mysqli_num_rows($query_procesar);

                if($result_detalle > 0){
                    $data = mysqli_fetch_assoc($query_procesar);
                    //$query_insert_credit = mysqli_query($conn, "CALL registrar_credito($codcliente)");
                    echo json_encode($data,JSON_UNESCAPED_UNICODE);
                    
                }else{
                    echo "error";
                }
            }else{
                echo "error";
            }
            mysqli_close($conn);
            exit;
        }

        // Extrayendo info. Empresa
        if($_POST['action'] == 'infoCompany'){
            include("Database/conn_backend.php");

            $id = $_POST['id'];
            $query = mysqli_query($conn, "SELECT ID_Config, Nombre, Razon_Social, Telefono, Email, Direccion, ITBIS FROM t_configuracion
                                            WHERE ID_Config = $id");
            mysqli_close($conn);

            $result = mysqli_num_rows($query);

            if ($result > 0) {
                $data = mysqli_fetch_assoc($query);
                echo json_encode($data,JSON_UNESCAPED_UNICODE);
                
            }else{
                echo "error";
            }
            exit;
        }

        // Añadiendo categorias
        if($_POST['action'] == 'addCat'){

            //Agregar productos a entrada
            if(empty($_POST['txtNombre']) || empty($_POST['txtdesc'])){
                echo "error";

            }else{
                include("Database/conn_backend.php");

                $Nombre = $_POST['txtNombre'];
                $Descripcion = $_POST['txtdesc'];
                
                $query_insert =  mysqli_query($conn, "INSERT INTO t_categoria(Nombre_Categoria, Descripcion)
                                                        VALUES('$Nombre', '$Descripcion')");
                $id = mysqli_insert_id($conn);

                $query_select = mysqli_query($conn, "SELECT * FROM t_categoria WHERE ID_Categoria = $id");
                $result = mysqli_num_rows($query_select);

                if($result > 0){
                    $data = mysqli_fetch_assoc($query_select);
                    echo json_encode($data,JSON_UNESCAPED_UNICODE);
                }
                else{
                    $data = mysqli_fetch_assoc($query_select);
                    echo json_encode($data,JSON_UNESCAPED_UNICODE);
                }
            }
            mysqli_close($conn);
            exit;
        }

        // Extrayendo info. de categoria
        if($_POST['action'] == 'infoCategory'){
            include("Database/conn_backend.php");

            $id = $_POST['id'];
            $query = mysqli_query($conn, "SELECT * FROM t_categoria
                                            WHERE ID_Categoria = $id");
            mysqli_close($conn);

            $result = mysqli_num_rows($query);

            if ($result > 0) {
                $data = mysqli_fetch_assoc($query);
                echo json_encode($data,JSON_UNESCAPED_UNICODE);
                
            }else{
                echo "error";
            }
            exit;
        }

        // Editando info. categoria
        if($_POST['action'] == 'EditCat'){

            if(empty($_POST['txtNombre']) || empty($_POST['txtdesc'])){
                echo "error";

            }else{
                include("Database/conn_backend.php");
                // Agregar informacion a empresa
                $nombre = $_POST['txtNombre'];
                $desc = $_POST['txtdesc'];
                $id = $_POST['id_cat'];

                $query_update = mysqli_query($conn, "UPDATE t_categoria 
                                                        SET Nombre_Categoria='$nombre', Descripcion='$desc'
                                                        WHERE ID_Categoria = $id");

                if ($query_update) {
                    $query = mysqli_query($conn, "SELECT * FROM t_categoria
                                            WHERE ID_Categoria = $id");
                    
                    $data = mysqli_fetch_assoc($query);
                    echo json_encode($data,JSON_UNESCAPED_UNICODE);

                }else{
                    echo "error";
                }

                mysqli_close($conn);
                exit;

            }
        }

        // Obteniendo datos de la factura
        if($_POST['action'] == 'infoFactura'){
            if(!empty(($_POST['nofactura']))){
                include("Database/conn_backend.php");
                $nofactura = $_POST['nofactura'];
                $query = mysqli_query($conn, "SELECT * FROM t_factura WHERE ID_Factura = '$nofactura'");
                mysqli_close($conn);
                $result = mysqli_num_rows($query);
                if($result > 0){
                    $data = mysqli_fetch_assoc($query);
                    if($data['ID_Estado'] == 4){
                        echo json_encode($data,JSON_UNESCAPED_UNICODE);
                    }
                    else if($data['ID_Estado'] == 5){
                        echo json_encode($data,JSON_UNESCAPED_UNICODE);
                    }else{
                        exit;
                    }
                    exit;
                }
        }
        echo "error";
        exit;
        }

        // Anulando factura mediante el id
        if($_POST['action'] == 'anularFactura'){
            if(!empty(($_POST['nofactura']))){
                include("Database/conn_backend.php");
                $nofactura = $_POST['nofactura'];
                $queryAnular = mysqli_query($conn, "CALL anular_factura($nofactura)");
                mysqli_close($conn);
                $result = mysqli_num_rows($queryAnular);
                if($result > 0){
                    $data = mysqli_fetch_assoc($queryAnular);
                    echo json_encode($data,JSON_UNESCAPED_UNICODE);
                    exit;
                }
            }
            echo "error";
            exit;
        }

        // Cambiando password mediante ajax
        if($_POST['action'] == 'changePassword'){
            
            if(!empty($_POST['passActual']) && !empty($_POST['passNew'])){
                include("Database/conn_backend.php");
                $passwordActual = md5($_POST['passActual']);
                $newPass = md5($_POST['passNew']);
                $idUser = $id_usuario;

                $code = '';
                $msg = '';
                $arrayData = array();
                
                $query_login = mysqli_query($conn, "SELECT * FROM t_usuario WHERE Pass = '$passwordActual' AND ID_Usuario = $idUser");
                $result = mysqli_num_rows($query_login);

                if($result > 0){
                    $query_update = mysqli_query($conn, "UPDATE t_usuario SET Pass='$newPass' WHERE ID_Usuario = $idUser");
                    mysqli_close($conn);

                    if($query_update){
                        $code = '00';
                        $msg = 'Contraseña actualiaza exitosamente';
                    }else{
                        $code = '2';
                        $msg = 'No fue posible cambiar su contraseña';
                    }
                }else{
                    $code = '1';
                    $msg = 'La contraseña actual es incorrecta';
                }
                
                $arrayData = array('cod' => $code, 'msg' => $msg);
                echo json_encode($arrayData,JSON_UNESCAPED_UNICODE);

            }else{
                echo "error";
            }
            exit;
        }

        // Actualizar datos de la empresa
        if($_POST['action'] == 'updateDataEmpresa'){
            
            if(empty($_POST['txtCif']) || empty($_POST['txtNombre']) || empty($_POST['txtTel']) || empty($_POST['txtEmail']) || empty($_POST['txtDireccion']) || empty($_POST['txtItbis'])){
                $code = '1';
                $msg = 'Todos los campos son obligatorios';

            }else{
                include("Database/conn_backend.php");

                $code = '';
                $msg = '';
                $arrayData = array();

                $intCif = $_POST['txtCif'];
                $strNombre = $_POST['txtNombre'];
                $strRazon = $_POST['txtRazon'];
                $strTel = $_POST['txtTel'];
                $strEmail = $_POST['txtEmail'];
                $strDirecc = $_POST['txtDireccion'];
                $intItbis = $_POST['txtItbis'];

                $queryUpd = mysqli_query($conn, "UPDATE t_configuracion SET CIF = '$intCif',
                                                                            Nombre = '$strNombre',
                                                                            Razon_Social = '$strRazon',
                                                                            Telefono = '$strTel',
                                                                            Email = '$strEmail',
                                                                            Direccion = '$strDirecc',
                                                                            ITBIS = '$intItbis'
                                                                            WHERE ID_Config = 1");
                mysqli_close($conn);
                if($queryUpd){
                    $code = '00';
                    $msg = 'Datos actualizados correctamente';
                }else{
                    $code = '2';
                    $msg = 'Error al actualizar los datos';
                }
            }
            $arrayData = array('cod' => $code, 'msg' => $msg);
            echo json_encode($arrayData,JSON_UNESCAPED_UNICODE);
            exit;
        }
        
    mysqli_close($conn);
}
?>