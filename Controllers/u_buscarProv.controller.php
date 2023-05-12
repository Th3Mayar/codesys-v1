<?php

include("./Database/conn_backend.php");

if(isset($_GET['busqueda'])){

$busqueda = strtolower($_GET['busqueda']);

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_proveedor 
                                        WHERE
                                        ( ID_Proveedor LIKE '%$busqueda%' OR
                                            Proveedor LIKE '%$busqueda%' OR
                                            Fecha_Registro LIKE '%$busqueda%' OR
                                            Contacto LIKE '%$busqueda%' OR
                                            Telefono LIKE '%$busqueda%' OR
                                            Direccion LIKE '%$busqueda%'
                                        ) 
                                        AND ID_Estado=1");

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

$sql = "SELECT prov.ID_Proveedor, prov.Proveedor, u.Nombre, prov.Fecha_Registro, prov.Contacto, prov.Telefono, prov.Direccion, e.Estado
            FROM t_proveedor prov
            INNER JOIN t_usuario u 
            INNER JOIN t_estado e 
            ON prov.ID_Estado = e.ID_Estado 
            AND prov.Cod_Usuario = u.ID_Usuario
            WHERE
            (
                prov.ID_Proveedor LIKE '%$busqueda%' OR
                prov.Proveedor LIKE '%$busqueda%' OR
                u.Nombre LIKE '%$busqueda%' OR
                prov.Fecha_Registro LIKE '%$busqueda%' OR
                prov.Contacto LIKE '%$busqueda%' OR
                prov.Telefono LIKE '%$busqueda%' OR
                prov.Direccion LIKE '%$busqueda%'
            )
            AND e.ID_Estado = 1
            ORDER BY prov.ID_Proveedor ASC
            LIMIT $from,$paginas";

$result = mysqli_query($conn, $sql);

mysqli_close($conn);

}
?>