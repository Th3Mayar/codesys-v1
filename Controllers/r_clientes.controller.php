<?php

include("./Database/conn_backend.php");

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_cliente WHERE ID_Estado=1");
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

$sql = "SELECT ce.ID_Cliente, ce.Nombre, ce.Apellido, ce.RNC, ce.Telefono, ce.Direccion, ce.Correo, e.Estado
            FROM t_cliente ce
            INNER JOIN t_estado e 
            ON ce.ID_Estado = e.ID_Estado 
            WHERE e.ID_Estado = 1
            ORDER BY ce.ID_Cliente ASC
            LIMIT $from,$paginas";

$result = mysqli_query($conn, $sql);
mysqli_close($conn);
?>