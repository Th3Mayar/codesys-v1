<?php

include("./Database/conn_backend.php");

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_factura WHERE ID_Estado != 7 AND $where");
$result_registers = mysqli_fetch_array($sql_registers);
$total_registro = $result_registers['total_registers'];
$paginas = 100;

if(empty($_GET['pagina'])){
    $pagina = 1;
}else{
    $pagina = $_GET['pagina'];
}

$from = ($pagina - 1) * $paginas;
$total_pages = ceil($total_registro / $paginas);

$query = mysqli_query($conn, "SELECT f.ID_Factura, f.Fecha, u.Nombre as vendedor, f.Cod_cliente, ce.Nombre as cliente, f.Total_Factura, f.Tipo_Factura, f.ID_Estado, e.Estado as estado
            FROM t_factura f
            INNER JOIN t_estado e 
            ON f.ID_Estado = e.ID_Estado 
            INNER JOIN t_cliente ce
            ON f.Cod_cliente = ce.ID_Cliente 
            INNER JOIN t_usuario u
            ON f.Usuario = u.ID_Usuario
            WHERE e.ID_Estado != 7 AND $where
            ORDER BY f.ID_Factura ASC
            LIMIT $from,$paginas");

mysqli_close($conn);
?>