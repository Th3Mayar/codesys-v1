<?php

include("./Database/conn_backend.php");

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_categoria");
$result_registers = mysqli_fetch_array($sql_registers);
$total_registro = $result_registers['total_registers'];
$paginas = 10;

if(empty($_GET['pagina'])){
    $pagina = 1;
}else{
    $pagina = $_GET['pagina'];
}

$from = ($pagina - 1) * $paginas;
$total_pages = ceil($total_registro / $paginas);

$query = mysqli_query($conn, "SELECT * FROM t_categoria
            ORDER BY ID_Categoria ASC
            LIMIT $from,$paginas");

mysqli_close($conn);
?>