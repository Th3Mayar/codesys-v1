<?php
	$subtotal 	= 0;
	$itbis 	 	= 0;
	$impuesto 	= 0;
	$tl_sitbis   = 0;
	$total 		= 0;
	include_once("generaFactura.php");
 	//print_r($configuracion); ?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Factura</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<?php echo $anulada; ?>
<div id="page_pdf">
	<table id="factura_head">
		<tr>
			<td class="logo_factura">
				<div>
					<img src="img/logo.png" alt="CODESYS LOGO" height="250px" width="200px">
				</div>
			</td>
			<td class="info_empresa">
				<?php
					if($result_config > 0){
						$itbis = $configuracion['ITBIS'];
				?>
				<div>
					<span class="h2"><?php echo strtoupper($configuracion['Nombre']); ?></span>
					<p><?php echo $configuracion['Razon_Social']; ?></p>
					<p><?php echo $configuracion['Direccion']; ?></p>
					<p>CIF: <?php echo $configuracion['CIF']; ?></p>
					<p>Teléfono: <?php echo $configuracion['Telefono']; ?></p>
					<p>Email: <?php echo $configuracion['Email']; ?></p>
				</div>
				<?php
					}
				?>
			</td>
			<td class="info_factura">
				<div class="round">
					<span class="h3">Datos Factura</span>
					<p>No. Factura: <strong><?php echo $factura['ID_Factura']; ?></strong></p>
					<p>Fecha: <?php echo $factura['fecha']; ?></p>
					<p>Hora: <?php echo $factura['hora']; ?></p>
					<p>Vendedor: <?php echo $factura['vendedor']; ?></p>
					<p>Tipo Factura: <b><?php echo $factura['Tipo_Factura']?></b></p>
				</div>
			</td>
		</tr>
	</table>
	<table id="factura_cliente">
		<tr>
			<td class="info_cliente">
				<div class="round">
					<span class="h3">Datos Cliente</span>
					<table class="datos_cliente">
						<tr>
							<td><label>RNC:</label><p><?php echo $factura['RNC']; ?></p></td>
							<td><label>Teléfono:</label> <p><?php echo $factura['Telefono']; ?></p></td>
						</tr>
						<tr>
							<td><label>Nombre:</label> <p><?php echo $factura['Nombre']; ?></p></td>
							<td><label>Dirección:</label> <p><?php echo $factura['Direccion']; ?></p></td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>

	<table id="factura_detalle">
			<thead>
				<tr>
					<th width="50px">Cant.</th>
					<th class="textleft">Descripción</th>
					<th class="textright" width="150px">Precio Unitario.</th>
					<th class="textright" width="150px"> Precio Total</th>
				</tr>
			</thead>
			<tbody id="detalle_productos">

			<?php

				if($result_detalle > 0){

					while ($row = mysqli_fetch_assoc($query_productos)){
			?>
				<tr>
					<td class="textcenter"><?php echo $row['Cantidad']; ?></td>
					<td><?php echo $row['Descripcion']; ?></td>
					<td class="textright"><?php echo $p_v = number_format($row['Precio_Venta'], 2, '.',','); ?></td>
					<td class="textright"><?php echo $p_t = number_format($row['precio_total'], 2, '.',','); ?></td>
				</tr>
			<?php
						$precio_total = $row['precio_total'];
						$subtotal = round($subtotal + $precio_total, 2);
					}
				}

				$impuesto 	= round($subtotal * ($itbis / 100), 2);
				$tl_sitbis 	= round($subtotal - $impuesto,2 );
				$total 		= round($tl_sitbis + $impuesto,2);

				$impuesto = number_format($impuesto, 2, '.',',');
				$tl_sitbis = number_format($tl_sitbis, 2, '.',',');
				$total = number_format($total, 2, '.',',')
			?>
			</tbody>
			<tfoot id="detalle_totales">
				<tr>
					<td colspan="3" class="textright"><span>SUBTOTAL</span></td>
					<td class="textright"><span><?php echo $tl_sitbis; ?></span></td>
				</tr>
				<tr>
					<td colspan="3" class="textright"><span>ITBIS (<?php echo $itbis; ?> %)</span></td>
					<td class="textright"><span><?php echo $impuesto; ?></span></td>
				</tr>
				<tr>
					<td colspan="3" class="textright"><span>IMPORTE</span></td>
					<td class="textright"><span><?php echo $total; ?></span></td>
				</tr>
		</tfoot>
	</table>
	<div>
		<p class="nota">Si usted tiene preguntas o inconvenientes con esta factura, <br>póngase en contacto con nuestro nombre, teléfono y Email</p>
		<h4 class="label_gracias">¡Gracias por preferirnos!</h4>
	</div>
</div>
</body>
</html>