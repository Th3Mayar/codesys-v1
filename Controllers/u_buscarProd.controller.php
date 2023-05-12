<?php

include("./Database/conn_backend.php");

if(!empty($_REQUEST['busqueda'])){
    $busqueda = strtolower($_REQUEST['busqueda']);
    $where = "
    ( 
        prod.Cod_Producto LIKE '%$busqueda%' OR
        prod.Nombre LIKE '%$busqueda%' OR
        prod.Descripcion LIKE '%$busqueda%' OR
        prod.Precio_Unitario LIKE '%$busqueda%' OR
        prod.Cantidad LIKE '%$busqueda%' OR
        prod.Costo LIKE '%$busqueda%' OR
        ca.Nombre_Categoria LIKE '%$busqueda%'
    ) 
    AND prod.ID_Estado=1";
    
    $buscar = 'busqueda='.$busqueda;
}

if(!empty($_REQUEST['proveedor'])){
    $search_proveedor = $_REQUEST['proveedor'];
    $where = "prod.Proveedor LIKE $search_proveedor AND prod.ID_Estado=1";
    $buscar = 'proveedor='.$search_proveedor;
}

//paginador
$sql_registers =  mysqli_query($conn, "SELECT COUNT(*) as total_registers FROM t_producto as prod, t_categoria as ca
                                                                            WHERE $where");
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

$sql = "SELECT prod.Cod_Producto, prod.Nombre, prod.Descripcion, prov.Proveedor, prod.Precio_Unitario, prod.Cantidad, prod.Costo, prod.Imagen, e.Estado, ca.Nombre_Categoria
            FROM t_producto prod
            INNER JOIN t_estado e 
            INNER JOIN t_proveedor prov
            INNER JOIN t_categoria ca 
            ON prod.ID_Estado = e.ID_Estado 
            AND prod.Proveedor = prov.ID_Proveedor
            AND prod.ID_Categoria = ca.ID_Categoria
            WHERE $where
            ORDER BY prod.Cod_Producto ASC
            LIMIT $from,$paginas";

$result = mysqli_query($conn, $sql);

mysqli_close($conn);

?>