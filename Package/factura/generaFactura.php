<?php

	//print_r($_REQUEST);
	//exit;
	//echo base64_encode('2');
	//exit;

	include "../../Database/conn_backend.php";
	require_once '../pdf/vendor/autoload.php';

	use Dompdf\Dompdf;

	if(empty($_REQUEST['cl']) || empty($_REQUEST['f'])){
		echo "No es posible generar la factura.";

	}else{
		$codCliente = $_REQUEST['cl'];
		$noFactura = $_REQUEST['f'];
		$anulada = '';
		$tipo_factura = $_REQUEST['t'];

		$query_config   = mysqli_query($conn, "SELECT * FROM t_configuracion");
		$result_config  = mysqli_num_rows($query_config);

		if($result_config > 0){
			$configuracion = mysqli_fetch_assoc($query_config);
		}

		$query_update_type = mysqli_query($conn, "UPDATE t_factura SET Tipo_Factura = '$tipo_factura' WHERE ID_Factura = $noFactura");

		if($query_update_type){

			$query = mysqli_query($conn, "SELECT f.ID_Factura, DATE_FORMAT(f.Fecha, '%d/%m/%Y') as fecha, DATE_FORMAT(f.Fecha,'%H:%i:%s') as  hora, f.Cod_cliente, f.ID_Estado,
													u.Nombre as vendedor, ce.RNC, ce.Nombre, ce.Telefono, ce.Direccion, f.Tipo_Factura
												FROM t_factura f
												INNER JOIN t_usuario u
												ON f.Usuario = u.ID_Usuario
												INNER JOIN t_cliente ce
												ON f.Cod_cliente = ce.ID_Cliente
												WHERE f.ID_Factura = $noFactura AND f.Cod_cliente = $codCliente  AND f.ID_Estado != 7");

			$result = mysqli_num_rows($query);

			if($result > 0){

				$factura = mysqli_fetch_assoc($query);
				$no_factura = $factura['ID_Factura'];

				if($factura['ID_Estado'] == 3){
					$anulada = '<img class="anulada" style="margin-top:-200px;" src="img/anulado.png" alt="Anulada">';
				}
				if($factura['Tipo_Factura'] == "Crédito"){
					$query_update_fact = mysqli_query($conn, "UPDATE t_factura SET ID_Estado = 5 WHERE ID_Factura = $no_factura");
				}
				
				$query_productos = mysqli_query($conn, "SELECT prod.Descripcion, dft.Cantidad, dft.Precio_Venta, (dft.Cantidad * dft.Precio_Venta) as precio_total
															FROM t_factura f
															INNER JOIN t_detalle_fac_almacenada dft
															ON f.ID_Factura = dft.Num_Factura
															INNER JOIN t_producto prod
															ON dft.Cod_Producto = prod.Cod_Producto
															WHERE f.ID_Factura = $no_factura");
				$result_detalle = mysqli_num_rows($query_productos);

				ob_start();
				//include(dirname('__FILE__').'/factura.php');
				include(dirname('__FILE__').'/factura_small.php');
				$html = ob_get_clean();

				// instantiate and use the dompdf class
				$dompdf = new Dompdf();

				$dompdf->loadHtml($html);
				// (Optional) Setup the paper size and orientation
				$dompdf->setPaper('letter', 'portrait');
				// Render the HTML as PDF
				$dompdf->render();
				// Output the generated PDF to Browser
				ob_get_clean();
				$dompdf->stream('factura_'.$noFactura.'.pdf',array('Attachment'=>0));
				exit;
				}
			}else{
				echo "error";
				mysqli_close($conn);
				exit;
			}
		}

?>