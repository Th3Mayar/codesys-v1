
<?php
    $host = "localhost";
    $user = "root";
    $pass = "";
    $dbname = "dbventa_inventario_compra";
    $conn = new mysqli($host , $user, $pass, $dbname);
    mysqli_query($conn , "SET character_set_result=utf8");
    //mysqli_close($conn);
    if($conn->connect_error){
        die("Error al conectarse : " . $conn->connect_error);
    }
?>