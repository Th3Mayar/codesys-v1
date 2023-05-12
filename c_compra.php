<?php include("Include/plantilla_Cabeza.php");
    include("Database/conn_backend.php");
    $usuario = $_SESSION['Usuario'];
    $sqlvendedor = mysqli_query($conn, "SELECT * FROM t_usuario WHERE Usuario='$usuario'");
    
    while($row = mysqli_fetch_array($sqlvendedor)){
        $nombre = $row['Nombre'];
        $id_usuario = $row['ID_Usuario'];
    }
?>
<head><link rel="stylesheet" href="css/style.css"></head>
    <br><br><br><br><br><br>
    <section class="container">
        <div class="title_page">
            <br><h1><i class="fa-sharp fa-solid fa-cart-plus" style="color: #000;"></i> Nueva Compra</h1><hr>
        </div>
        <div class="datos_venta">
            <h4>Datos de compra</h4>
            <div class="datos">
                <div class="wd50">
                    <label style="font-size:14px;">Usuario</label>
                    <p><?php echo $nombre;?></p><br>
                    <label style="font-size:14px;">Proveedor</label>
                    <select name="ID_Proveedor" id="ID_Proveedor" class="form-select form-select-lg mb-1" aria-label=".form-select-lg example">
                            <?php 
                                include("Database/conn_backend.php");
                                $getProveedor = "SELECT ID_Proveedor, Proveedor FROM t_proveedor";
                                $queryProveedor = mysqli_query($conn, $getProveedor);
                                mysqli_close($conn);

                            while($row = mysqli_fetch_array($queryProveedor)): ?>
                            <option name="ID_Proveedor" value="<?= $row['ID_Proveedor']?>"><?php echo $row['Proveedor']?>
                            </option>
                            <?php endwhile; ?>
                        </select>
                </div>
                <div class="wd50">
                    <label style="margin-left:140px; font-size:14px;">Acciones</label>
                    <div class="acciones_venta">
                        <a href="#" class="btn_new textcenter" id="btn_anular_compra" onclick="event.preventDefault();" style="background-color:rgb(218, 56, 56); color:#fff;"><i class="fa-solid fa-ban" style="color: #fff;"></i> Anular</a>
                        <a href="#" class="btn_new textcenter" id="btn_facturar_compra" onclick="event.preventDefault();" style="background-color:rgb(63, 122, 56); color:#fff; display:none;"><i class="fa-solid fa-clipboard-check" style="color: #fff;"></i> Procesar</a>
                    </div>
                </div>
            </div>
        </div>
        <table class="tbl_venta">
            <thead>
                <tr>
                    <th width="100px">Código</th>
                    <th>Descripción</th>
                    <th>Existencia</th>
                    <th width="100px">Cantidad</th>
                    <th class="textright">Costo</th>
                    <th class="textright">Costo Total</th>
                    <th> Acción</th>
                </tr>
                <tr>
                    <td><input type="text" name="cod_producto" id="cod_producto"></td>
                    <td id="descripcion">-</td>
                    <td id="existencia">-</td>
                    <td><input type="text" name="txt_cant_producto" id="cant_producto" value="0" min="1" disabled></td>
                    <td id="costo" class="textright">RD$0.00</td>
                    <td id="costo_total" class="textright">$RD0.00</td>
                    <td><a href="#" id="add_product_compra" class="link_add" style="color:rgb(53, 175, 42);"><i class="fas fa-plus" style="color: rgb(53, 175, 42);"></i> Agregar</a></td>
                </tr>
                <tr>
                    <th width="100px">Código</th>
                    <th colspan="2">Descripción</th>
                    <th width="100px">Cantidad</th>
                    <th class="textright">Costo</th>
                    <th class="textright">Costo Total</th>
                    <th> Acción</th>
                </tr>
            </thead>
            <tbody id="detalle_compra">
                <!-- CONTENIDO VISUALIZADO CON AJAX -->
            </tbody>
            <tfoot id="detalle_total">
                <!-- CONTENIDO VISUALIZADO CON AJAX -->
            </tfoot>
        </table>
        <br>
    </section>
    <br><br><br>
    <script type="text/javascript">
        $(document).ready(function(){
        var id_usuario = '<?php echo $id_usuario; ?>';
        serchForDetalle(id_usuario);
        });
    </script>
<?php include_once("Include/plantilla_pie.php");?>