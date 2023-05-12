<?php

include("./Database/conn_backend.php");

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_entrada_inventario WHERE $where");
$result_registers = mysqli_fetch_array($sql_registers);
$total_registro = $result_registers['total_registers'];
$paginas = 50;

if(empty($_GET['pagina'])){
    $pagina = 1;
}else{
    $pagina = $_GET['pagina'];
}

$from = ($pagina - 1) * $paginas;
$total_pages = ceil($total_registro / $paginas);

$query = mysqli_query($conn, "SELECT ent.ID_Entrada, prod.Cod_Producto, prod.Nombre as Nombre_Prod, DATE_FORMAT(ent.Fecha, '%d/%m/%Y a las %H%:%i% %p') AS Fecha_New, ent.Cantidad, ent.Precio_Unitario, u.Usuario, u.Nombre
                                FROM t_entrada_inventario ent
                                INNER JOIN t_producto prod
                                INNER JOIN t_usuario u
                                ON ent.Cod_Producto = prod.Cod_Producto
                                AND ent.ID_Usuario = u.ID_Usuario
                                WHERE $where
                                ORDER BY ent.ID_Entrada ASC
                                LIMIT $from,$paginas");

mysqli_close($conn);

?>