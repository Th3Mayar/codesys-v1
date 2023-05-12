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
    <section class="container cont_venta">
        <div class="title_page">
            <br><h1><i class="fa-solid fa-file-circle-plus" style="color: #000;"></i> Nueva Venta</h1><hr>
        </div>
        <div class="datos_cliente">
            <div class="action_cliente">
                <h1>Datos del cliente</h1>
                <a href="#" class="btn_new btn_new_cliente"><i class="fa-solid fa-user-plus" style="color: #000;"></i> Nuevo cliente</a>
            </div>
            <form name="form_new_cliente_venta" id="form_new_cliente_venta" class="datos">
                <input type="hidden" name="action" value="addCliente">
                <input type="hidden" name="idcliente" id="idcliente" value="" required>
                <div class="wd30">
                    <label>RNC</label>
                    <input type="text" placeholder="RNC" id="rnc" name="rnc">
                </div>
                <div class="wd30">
                    <label>Nombre Completo</label>
                    <input type="text" placeholder="Nombre Completo" id="name" name="name" disabled required>
                </div>
                <div class="wd30">
                    <label>Apellido</label>
                    <input type="text" placeholder="Apellido" id="apellido" name="apellido" disabled required>
                </div>
                <div class="wd30">
                    <label>Telefono</label>
                    <input type="text" placeholder="Telefono" id="tel" name="tel" disabled required>
                </div>
                <div class="wd100">
                    <label>Direccion</label>
                    <input type="text" placeholder="Direccion" id="location" name="location" disabled required>
                </div>
                <div class="wd30">
                    <label>Correo</label>
                    <input type="text" placeholder="Correo" id="email" name="email" disabled>
                </div>
                <div id="div_registro_cliente" class="wd100">
                    <button type="submit" class="btn_save"><i class="fa-solid fa-floppy-disk" style="color: #525151;"></i> Guardar</button>
                </div>
            </form>
        </div>
        <div class="datos_venta">
            <h4>Datos de venta</h4>
            <div class="datos">
                <div class="wd50">
                    <label style="font-size:14px;">Vendedor</label>
                    <p><?php echo $nombre;?></p><br>
                    <label style="font-size:14px;">Tipo factura</label>
                    <div class="type_fact">
                        <input type="radio" id="tipo_credito" name="tipo_factura" value="Crédito" />
                        <label for="Credito">Credito</label>
                        <input type="radio" id="tipo_contado" name="tipo_factura" value="Contado" checked />
                        <label for="Contado">Contado</label>
                    </div>
                </div>
                <div class="wd50">
                    <label class="action_Factura" style="margin-left:140px; font-size:14px;">Acciones</label>
                    <div class="acciones_venta">
                        <a href="#" class="btn_new textcenter" id="btn_anular_venta" onclick="event.preventDefault();" style="background-color:rgb(218, 56, 56); color:#fff;"><i class="fa-solid fa-ban" style="color: #fff;"></i> Anular</a>
                        <a href="#" class="btn_new textcenter" id="btn_facturar_venta" onclick="event.preventDefault();" style="background-color:rgb(63, 122, 56); color:#fff; display:none;"><i class="fa-solid fa-clipboard-check" style="color: #fff;"></i> Procesar</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="containerTableResponsive">
        <table class="tbl_venta">
            <thead>
                <tr>
                    <th width="100px">Código</th>
                    <th>Descripción</th>
                    <th>Existencia</th>
                    <th width="100px">Cantidad</th>
                    <th class="textright">Precio</th>
                    <th class="textright">Precio Total</th>
                    <th> Acción</th>
                </tr>
                <tr>
                    <td><input type="text" name="txt_cod_producto" id="txt_cod_producto"></td>
                    <td id="txt_descripcion">-</td>
                    <td id="txt_existencia">-</td>
                    <td><input type="text" name="txt_cant_producto" id="txt_cant_producto" value="0" min="1" disabled></td>
                    <td id="txt_precio" class="textright">RD$0.00</td>
                    <td id="txt_precio_total" class="textright">$RD0.00</td>
                    <td><a href="#" id="add_product_venta" class="link_add" style="color:rgb(53, 175, 42);"><i class="fas fa-plus" style="color: rgb(53, 175, 42);"></i> Agregar</a></td>
                </tr>
                <tr>
                    <th width="100px">Código</th>
                    <th colspan="2">Descripción</th>
                    <th width="100px">Cantidad</th>
                    <th class="textright">Precio</th>
                    <th class="textright">Precio Total</th>
                    <th> Acción</th>
                </tr>
            </thead>
            <tbody id="detalle_venta">
                <!-- CONTENIDO VISUALIZADO CON AJAX -->
            </tbody>
            <tfoot id="detalle_totales">
                <!-- CONTENIDO VISUALIZADO CON AJAX -->
            </tfoot>
        </table>
        </div>
        <br>
    </section>
    <script type="text/javascript">
        $(document).ready(function(){
        var id_usuario = '<?php echo $id_usuario; ?>';
        serchForDetalle(id_usuario);
        });
    </script>
<?php include_once("Include/plantilla_pie.php");?>