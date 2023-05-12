<?php

include("./Database/conn_backend.php");

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_salida_inventario");
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

$sql = "SELECT si.ID_Detalle_Salida, si.Cod_Fact, prod.Cod_producto, prod.Nombre, DATE_FORMAT(si.Fecha_Salida, '%d/%m/%Y a las %H%:%i% %p') AS Fecha_New, si.Cantidad, si.Precio_total
            FROM t_salida_inventario si
            INNER JOIN t_producto prod
            ON si.Cod_producto = prod.Cod_Producto
            ORDER BY si.ID_Detalle_Salida ASC
            LIMIT $from,$paginas";

$result = mysqli_query($conn, $sql);
mysqli_close($conn);
?>