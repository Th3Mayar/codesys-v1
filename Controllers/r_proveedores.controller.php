<?php

include("./Database/conn_backend.php");

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_proveedor WHERE ID_Estado=1");
$result_registers = mysqli_fetch_array($sql_registers);
$total_registro = $result_registers['total_registers'];
$paginas = 5;

if(empty($_GET['pagina'])){
    $pagina = 1;
}else{
    $pagina = $_GET['pagina'];
}

$from = ($pagina - 1) * $paginas;
$total_pages = ceil($total_registro / $paginas);

$sql = "SELECT prov.ID_Proveedor, prov.Proveedor, u.Nombre, DATE_FORMAT(prov.Fecha_Registro, '%d/%m/%Y a las %H%:%i% %p') AS Fecha_New, prov.Contacto, prov.Telefono, prov.Direccion, e.Estado
            FROM t_proveedor prov
            INNER JOIN t_usuario u 
            INNER JOIN t_estado e 
            ON prov.ID_Estado = e.ID_Estado 
            AND prov.Cod_Usuario = u.ID_Usuario
            WHERE e.ID_Estado = 1
            ORDER BY prov.ID_Proveedor ASC
            LIMIT $from,$paginas";

$result = mysqli_query($conn, $sql);
mysqli_close($conn);
?>