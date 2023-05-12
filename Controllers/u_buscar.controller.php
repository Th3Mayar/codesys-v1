<?php

include("./Database/conn_backend.php");

if(isset($_GET['busqueda'])){
    $busqueda = strtolower($_GET['busqueda']);
    /*$getRol = "SELECT ID_Rol, Rol FROM t_rol";
    $queryRol = mysqli_query($conn, $getRol);
    while($row = mysqli_fetch_array($queryRol)){$nombre_rol = $row['Rol'];}
    for($i=1;$i<=500;$i++){
        if($busqueda == "$nombre_rol"){
            $rol = "'%$i%'";
            break;
        }else{
            $rol = "'%%'";
        }
        }*/

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_usuario 
                                        WHERE
                                        ( ID_Usuario LIKE '%$busqueda%' OR
                                            Nombre LIKE '%$busqueda%' OR
                                            Email LIKE '%$busqueda%' OR
                                            Usuario LIKE '%$busqueda%' OR
                                            Pass LIKE '%$busqueda%' OR
                                            Rol LIKE '%$busqueda%'
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

$sql = "SELECT u.ID_Usuario, u.Nombre, u.Email, u.Usuario, u.Pass, r.Rol, e.Estado 
            FROM t_usuario u 
            INNER JOIN t_rol r 
            INNER JOIN t_estado e 
            ON u.Rol = r.ID_Rol 
            AND u.ID_Estado = e.ID_Estado
            WHERE
            (
                u.ID_Usuario LIKE '%$busqueda%' OR
                u.Nombre LIKE '%$busqueda%' OR
                u.Email LIKE '%$busqueda%' OR
                u.Usuario LIKE '%$busqueda%' OR
                u.Pass LIKE '%$busqueda%' OR
                r.Rol LIKE '%$busqueda%' OR
                e.ID_Estado LIKE '%$busqueda%'
            )
            AND e.ID_Estado = 1
            ORDER BY u.ID_Usuario ASC
            LIMIT $from, $paginas";

$result = mysqli_query($conn, $sql);

mysqli_close($conn);

}
?>