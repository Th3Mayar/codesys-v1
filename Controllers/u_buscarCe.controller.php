<?php

include("./Database/conn_backend.php");

if(isset($_GET['busqueda'])){
$busqueda = strtolower($_GET['busqueda']);

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_cliente 
                                        WHERE
                                        ( ID_Cliente LIKE '%$busqueda%' OR
                                            Nombre LIKE '%$busqueda%' OR
                                            Apellido LIKE '%$busqueda%' OR
                                            RNC LIKE '%$busqueda%' OR
                                            Telefono LIKE '%$busqueda%' OR
                                            Direccion LIKE '%$busqueda%' OR
                                            Correo LIKE '%$busqueda%'
                                        ) 
                                        AND ID_Estado=1");

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
            WHERE
            ( ce.ID_Cliente LIKE '%$busqueda%' OR
            ce.Nombre LIKE '%$busqueda%' OR
            ce.Apellido LIKE '%$busqueda%' OR
            ce.RNC LIKE '%$busqueda%' OR
            ce.Telefono LIKE '%$busqueda%' OR
            ce.Direccion LIKE '%$busqueda%' OR
            ce.Correo LIKE '%$busqueda%' OR
            e.ID_Estado LIKE '%$busqueda%'
            )
            AND e.ID_Estado = 1
            ORDER BY ce.ID_Cliente ASC
            LIMIT $from,$paginas";

$result = mysqli_query($conn, $sql);

mysqli_close($conn);

}
?>