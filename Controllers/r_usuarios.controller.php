<?php

include("./Database/conn_backend.php");

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_usuario WHERE ID_Estado=1");
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

$sql = "SELECT u.ID_Usuario, u.Nombre, u.Email, u.Usuario, u.Pass, r.Rol, e.Estado 
            FROM t_usuario u 
            INNER JOIN t_rol r 
            INNER JOIN t_estado e 
            ON u.Rol = r.ID_Rol 
            AND u.ID_Estado = e.ID_Estado
            WHERE e.ID_Estado = 1
            ORDER BY u.ID_Usuario ASC
            LIMIT $from,$paginas";

$result = mysqli_query($conn, $sql);
mysqli_close($conn);
?>