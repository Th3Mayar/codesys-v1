-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-05-2023 a las 22:58:25
-- Versión del servidor: 10.4.25-MariaDB
-- Versión de PHP: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `codesys-v1`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_precio_producto` (IN `n_cantidad` INT, IN `n_precio` DECIMAL(10,2), IN `codigo` INT)   BEGIN
    	DECLARE nueva_existencia int;
        DECLARE nuevo_total  decimal(10,2);
        DECLARE nuevo_precio decimal(10,2);
        
        DECLARE cant_actual int;
        DECLARE pre_actual decimal(10,2);
        
        DECLARE actual_existencia int;
        DECLARE actual_precio decimal(10,2);
                
        SELECT Precio_Unitario,Cantidad INTO actual_precio,actual_existencia FROM t_producto WHERE Cod_Producto = codigo;
        SET nueva_existencia = actual_existencia + n_cantidad;
        SET nuevo_total = (actual_existencia * actual_precio) + (n_cantidad * n_precio);
        SET nuevo_precio = nuevo_total / nueva_existencia;
        
        UPDATE t_producto SET Cantidad = nueva_existencia, Precio_Unitario = nuevo_precio WHERE Cod_Producto = codigo;
        
        SELECT nueva_existencia,nuevo_precio;
        
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_detalle_fact` (IN `codigo` INT, IN `cantidad` INT, IN `token_user` VARCHAR(50))   BEGIN
    	DECLARE precio_actual decimal(10,2);
        SELECT Precio_Unitario INTO precio_actual FROM t_producto WHERE Cod_Producto = codigo;
        
        INSERT INTO t_fact_detalle(Token_User,Cod_producto,Cantidad,Precio_Venta) VALUES (token_user,codigo,cantidad,precio_actual);
        
        SELECT tfd.ID_Fact_Detalle, tfd.Cod_producto,prod.Descripcion,tfd.Cantidad,tfd.Precio_Venta FROM t_fact_detalle tfd
        INNER JOIN t_producto prod
        ON tfd.Cod_producto = prod.Cod_Producto
        WHERE tfd.Token_User = token_user; 
        
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `anular_factura` (IN `no_factura` INT)   BEGIN
          DECLARE factura_existente INT;

          SELECT COUNT(*) INTO factura_existente FROM t_detalle_fac_almacenada WHERE Num_Factura = no_factura;

          IF factura_existente > 0 THEN
            UPDATE t_factura SET ID_Estado = 3 WHERE ID_Factura = no_factura;
            UPDATE t_producto, t_detalle_fac_almacenada
            SET t_producto.Cantidad = t_producto.Cantidad + t_detalle_fac_almacenada.Cantidad
            WHERE t_detalle_fac_almacenada.Num_Factura = no_factura
              AND t_producto.Cod_Producto = t_detalle_fac_almacenada.Cod_Producto;
            SELECT * FROM t_factura WHERE ID_Factura = no_factura;
          ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La factura especificada no existe.';
          END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dataDashboard` ()   BEGIN
    
    	DECLARE usuarios int;
        DECLARE clientes int;
        DECLARE proveedores int;
        DECLARE productos int;
        DECLARE ventas int;
        
        SELECT COUNT(*) INTO usuarios FROM t_usuario WHERE ID_Estado != 7;
         SELECT COUNT(*) INTO clientes FROM t_cliente WHERE ID_Estado != 7;
          SELECT COUNT(*) INTO proveedores FROM t_proveedor WHERE ID_Estado != 7;
           SELECT COUNT(*) INTO productos FROM t_producto WHERE ID_Estado != 7;
            SELECT COUNT(*) INTO ventas FROM t_factura WHERE Fecha > CURDATE() AND ID_Estado != 7;
            
            SELECT usuarios,clientes,proveedores,productos,ventas;

        END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_detalle_fact` (`id_detalle` INT, `token` VARCHAR(50))   BEGIN
          DELETE FROM t_fact_detalle WHERE ID_Fact_Detalle = id_detalle;

          SELECT tfd.ID_Fact_Detalle, tfd.Cod_producto,prod.Descripcion,tfd.Cantidad,tfd.Precio_Venta FROM t_fact_detalle tfd
          INNER JOIN t_producto prod
          ON tfd.Cod_producto = prod.Cod_Producto
          WHERE tfd.Token_User = token;
      END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modificar_entrada_inventario` (IN `id_entrada` INT, IN `cantidad_ingresada` INT)   BEGIN
      DECLARE entrada_existente int;
      DECLARE id_producto int;
      DECLARE cantidad_actual int;
      
      SELECT COUNT(*) INTO entrada_existente FROM t_entrada_inventario WHERE ID_Entrada = id_entrada;

      IF entrada_existente = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La entrada especificada no existe.';
        
      ELSE
        
        SELECT Cod_producto, Cantidad INTO id_producto, cantidad_actual FROM t_entrada_inventario WHERE ID_Entrada = id_entrada;

        SELECT Cantidad INTO cantidad_actual FROM t_producto WHERE Cod_Producto = id_producto;

        IF cantidad_ingresada > cantidad_actual THEN
          UPDATE t_producto SET Cantidad = Cantidad + (cantidad_ingresada - cantidad_actual) WHERE Cod_Producto = id_producto;
        END IF;

        UPDATE t_entrada_inventario SET Cantidad = cantidad_ingresada WHERE ID_Entrada = id_entrada;
        SELECT 'La entrada ha sido modificada exitosamente.' AS mensaje;
      END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `procesar_venta` (IN `cod_usuario` INT, IN `cod_cliente` INT, IN `token` VARCHAR(50))   BEGIN
        	DECLARE factura INT;
           
        	DECLARE registros INT;
            DECLARE total DECIMAL(10,2);
            
            DECLARE nueva_existencia int;
            DECLARE existencia_actual int;
            
            DECLARE tmp_cod_producto int;
            DECLARE tmp_cant_producto int;
            DECLARE a INT;
            SET a = 1;
            
            CREATE TEMPORARY TABLE tbl_tmp_tokenuser (
                	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                	cod_prod BIGINT,
                	cant_prod int);
             SET registros = (SELECT COUNT(*) FROM t_fact_detalle WHERE Token_User = token);
             
             IF registros > 0 THEN 
             	INSERT INTO tbl_tmp_tokenuser(cod_prod,cant_prod) SELECT Cod_producto, Cantidad FROM t_fact_detalle WHERE Token_User = token;
                
                INSERT INTO t_factura(Usuario, Cod_cliente) VALUES(cod_usuario,cod_cliente);
                SET factura = LAST_INSERT_ID();
                
                INSERT INTO t_detalle_fac_almacenada(Num_Factura, Cod_Producto, Cantidad, Precio_Venta) SELECT (factura) as nofactura, Cod_producto,Cantidad,Precio_Venta FROM t_fact_detalle WHERE Token_User = token; 
                
                WHILE a <= registros DO
                	SELECT cod_prod,cant_prod INTO tmp_cod_producto,tmp_cant_producto FROM tbl_tmp_tokenuser WHERE id = a;
                    SELECT Cantidad INTO existencia_actual FROM t_producto WHERE Cod_Producto = tmp_cod_producto;
                    
                    SET nueva_existencia = existencia_actual - tmp_cant_producto;
                    UPDATE t_producto SET Cantidad = nueva_existencia WHERE Cod_Producto = tmp_cod_producto;
                    
                    SET a=a+1;
                
                END WHILE; 
                
                SET total = (SELECT SUM(Cantidad * Precio_Venta) FROM t_fact_detalle WHERE Token_User = token);
                UPDATE t_factura SET Total_Factura = total WHERE ID_Factura = factura;
                DELETE FROM t_fact_detalle WHERE Token_User = token;
                TRUNCATE TABLE tbl_tmp_tokenuser;
                SELECT * FROM t_factura WHERE ID_Factura = factura;
             
             ELSE
             	SELECT 0;
             END IF;
      	END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_credito` (IN `cliente_id` INT(11))   BEGIN
          DECLARE factura_id int;
          DECLARE total_factura decimal(10, 2);
          SELECT ID_Factura, Total_Factura INTO factura_id, total_factura FROM t_factura WHERE Cod_cliente = cliente_id;
          INSERT INTO t_venta_credito(ID_Cliente, ID_Factura, Total_Factura) VALUES (cliente_id, factura_id, total_factura);
          SELECT * FROM t_venta_credito;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_categoria`
--

CREATE TABLE `t_categoria` (
  `ID_Categoria` int(11) NOT NULL,
  `Nombre_Categoria` varchar(50) NOT NULL,
  `Descripcion` varchar(100) NOT NULL,
  `ID_Estado` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `t_categoria`
--

INSERT INTO `t_categoria` (`ID_Categoria`, `Nombre_Categoria`, `Descripcion`, `ID_Estado`) VALUES
(1, 'Accesorios', 'Productos decorativos', 1),
(2, 'Celulares', 'Dispositivos móviles gama media y alta', 1),
(7, 'Privacy', 'Cristales de protección de celulares', 1),
(8, 'Glass', 'Cristales de protección de celulares', 1),
(9, 'GLASS', 'Cristales de protección de celulares', 2),
(10, 'Machena Wilsone', 'Cristales de protección', 2),
(11, 'Privacy', 'Cristales de protección', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_cliente`
--

CREATE TABLE `t_cliente` (
  `ID_Cliente` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Apellido` varchar(50) NOT NULL,
  `RNC` varchar(50) NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT current_timestamp(),
  `Telefono` varchar(20) DEFAULT NULL,
  `Direccion` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `Correo` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ID_Estado` int(11) NOT NULL,
  `Usuario_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_cliente`
--

INSERT INTO `t_cliente` (`ID_Cliente`, `Nombre`, `Apellido`, `RNC`, `Fecha_Registro`, `Telefono`, `Direccion`, `Correo`, `ID_Estado`, `Usuario_ID`) VALUES
(1, 'CF', '', 'C/F', '2023-04-29 20:20:29', '8096620472', 'Carrt. Entrada Presa de Taveras', 'yafreisi.comunicaciones@gmail.com', 1, 1),

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_configuracion`
--

CREATE TABLE `t_configuracion` (
  `ID_Config` bigint(20) NOT NULL,
  `CIF` varchar(50) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Razon_Social` varchar(100) NOT NULL,
  `Telefono` varchar(20) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Direccion` text NOT NULL,
  `ITBIS` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `t_configuracion`
--

INSERT INTO `t_configuracion` (`ID_Config`, `CIF`, `Nombre`, `Razon_Social`, `Telefono`, `Email`, `Direccion`, `ITBIS`) VALUES
(1, '67389826', 'Yafreisi Comunicaciones', '', '8096620472', 'yafreisicomunications@gmail.com', 'Las Canas abajo', '18.00'),
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_detalle_fac_almacenada`
--

CREATE TABLE `t_detalle_fac_almacenada` (
  `Correlativo` int(11) NOT NULL,
  `Num_Factura` int(11) NOT NULL,
  `Cod_Producto` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Precio_Venta` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `t_detalle_fac_almacenada`
--
DELIMITER $$
CREATE TRIGGER `salidas_A_I` AFTER INSERT ON `t_detalle_fac_almacenada` FOR EACH ROW BEGIN
            INSERT INTO t_salida_inventario(Cod_Fact, Cod_producto, Cantidad, Precio_total)
            VALUES(new.Num_Factura, new.Cod_Producto, new.Cantidad, new.Precio_Venta);
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_entrada_inventario`
--

CREATE TABLE `t_entrada_inventario` (
  `ID_Entrada` int(11) NOT NULL,
  `Cod_producto` int(11) NOT NULL,
  `Fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `Cantidad` int(11) NOT NULL,
  `Precio_Unitario` decimal(10,2) NOT NULL,
  `ID_Usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Estructura de tabla para la tabla `t_estado`
--

CREATE TABLE `t_estado` (
  `ID_Estado` int(11) NOT NULL,
  `Estado` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `t_estado`
--

INSERT INTO `t_estado` (`ID_Estado`, `Estado`) VALUES
(1, 'Activo'),
(2, 'Inactivo'),
(3, 'Anulada'),
(4, 'Pagada'),
(5, 'En proceso'),
(7, 'Eliminado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_factura`
--

CREATE TABLE `t_factura` (
  `ID_Factura` int(11) NOT NULL,
  `Fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `Usuario` int(11) DEFAULT NULL,
  `Cod_cliente` int(11) DEFAULT NULL,
  `Total_Factura` decimal(10,2) NOT NULL,
  `Tipo_Factura` varchar(20) NOT NULL DEFAULT 'Contado',
  `ID_Estado` int(11) NOT NULL DEFAULT 4
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_factura`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_fact_detalle`
--

CREATE TABLE `t_fact_detalle` (
  `ID_Fact_Detalle` int(11) NOT NULL,
  `Token_User` varchar(50) DEFAULT NULL,
  `Cod_producto` int(11) DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `Precio_Venta` decimal(10,2) DEFAULT NULL,
  `ITBIS` decimal(10,3) NOT NULL,
  `Importe` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_producto`
--

CREATE TABLE `t_producto` (
  `Cod_Producto` int(11) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Descripcion` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Proveedor` int(11) DEFAULT NULL,
  `Precio_Unitario` decimal(10,2) DEFAULT NULL,
  `Cantidad` int(11) NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT current_timestamp(),
  `Costo` decimal(50,0) NOT NULL,
  `Imagen` text DEFAULT NULL,
  `ID_Usuario` int(11) NOT NULL,
  `ID_Estado` int(11) NOT NULL,
  `ID_Categoria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_producto`
--

--
-- Disparadores `t_producto`
--
DELIMITER $$
CREATE TRIGGER `entrada_A_I` AFTER INSERT ON `t_producto` FOR EACH ROW BEGIN
    	INSERT INTO t_entrada_inventario(Cod_producto, Cantidad, Precio_Unitario, ID_Usuario)
        VALUES(new.Cod_Producto, new.Cantidad, new.Precio_Unitario, new.ID_Usuario);
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_proveedor`
--

CREATE TABLE `t_proveedor` (
  `ID_Proveedor` int(11) NOT NULL,
  `Proveedor` varchar(50) DEFAULT NULL,
  `Cod_Usuario` int(11) NOT NULL,
  `Fecha_Registro` datetime NOT NULL DEFAULT current_timestamp(),
  `Contacto` varchar(50) DEFAULT NULL,
  `Telefono` varchar(15) DEFAULT NULL,
  `Direccion` varchar(100) DEFAULT NULL,
  `ID_Estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_rol`
--

CREATE TABLE `t_rol` (
  `ID_Rol` int(11) NOT NULL,
  `Rol` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_rol`
--

INSERT INTO `t_rol` (`ID_Rol`, `Rol`) VALUES
(1, 'admin'),
(2, 'user'),
(3, 'supervisor'),
(4, 'vendedor');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_salida_inventario`
--

CREATE TABLE `t_salida_inventario` (
  `ID_Detalle_Salida` int(11) NOT NULL,
  `Cod_Fact` int(11) NOT NULL,
  `Cod_producto` int(11) NOT NULL,
  `Fecha_Salida` datetime DEFAULT current_timestamp(),
  `Cantidad` int(11) NOT NULL,
  `Precio_total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_usuario`
--

CREATE TABLE `t_usuario` (
  `ID_Usuario` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Usuario` varchar(15) DEFAULT NULL,
  `Pass` varchar(150) DEFAULT NULL,
  `Rol` int(11) DEFAULT NULL,
  `ID_Estado` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_usuario`
--

INSERT INTO `t_usuario` (`ID_Usuario`, `Nombre`, `Email`, `Usuario`, `Pass`, `Rol`, `ID_Estado`) VALUES
(1, 'Jose Francisco', 'josehenriquez.02@gmail.com', 'admin', 'addf1c1e90d29e3e9359c2cdc51c3448', 1, 1),
(2, 'Yandil De Jesus', 'yando123@yahoo', 'yandel', '81dc9bdb52d04dc20036dbd8313ed055', 4, 1),
(3, 'Yafreisi Antonio', 'yafreisi@gmail.com', 'Yafrec', '202cb962ac59075b964b07152d234b70', 3, 1),

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_venta_credito`
--

CREATE TABLE `t_venta_credito` (
  `ID_Credito` int(11) NOT NULL,
  `ID_Cliente` int(11) DEFAULT NULL,
  `ID_Factura` int(11) NOT NULL,
  `Fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `Total_Factura` decimal(10,2) DEFAULT 0.00,
  `Pago` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `t_categoria`
--
ALTER TABLE `t_categoria`
  ADD PRIMARY KEY (`ID_Categoria`);

--
-- Indices de la tabla `t_cliente`
--
ALTER TABLE `t_cliente`
  ADD PRIMARY KEY (`ID_Cliente`),
  ADD KEY `FK_ID_Estado_Cliente` (`ID_Estado`),
  ADD KEY `FK_Usuario_ID` (`Usuario_ID`);

--
-- Indices de la tabla `t_configuracion`
--
ALTER TABLE `t_configuracion`
  ADD PRIMARY KEY (`ID_Config`);

--
-- Indices de la tabla `t_detalle_fac_almacenada`
--
ALTER TABLE `t_detalle_fac_almacenada`
  ADD PRIMARY KEY (`Correlativo`),
  ADD KEY `FK_Num_Factura` (`Num_Factura`),
  ADD KEY `FK_Codigo_Producto` (`Cod_Producto`);

--
-- Indices de la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  ADD PRIMARY KEY (`ID_Entrada`),
  ADD KEY `FK_ID_Producto_Entrada` (`Cod_producto`);

--
-- Indices de la tabla `t_estado`
--
ALTER TABLE `t_estado`
  ADD PRIMARY KEY (`ID_Estado`);

--
-- Indices de la tabla `t_factura`
--
ALTER TABLE `t_factura`
  ADD PRIMARY KEY (`ID_Factura`),
  ADD KEY `FK_ID_Cliente` (`Cod_cliente`),
  ADD KEY `FK_ID_Estado_Fact` (`ID_Estado`),
  ADD KEY `FK_Codigo_Usuario` (`Usuario`) USING BTREE;

--
-- Indices de la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  ADD PRIMARY KEY (`ID_Fact_Detalle`),
  ADD KEY `FK_Cod_Fact` (`Token_User`),
  ADD KEY `FK_id_product` (`Cod_producto`);

--
-- Indices de la tabla `t_producto`
--
ALTER TABLE `t_producto`
  ADD PRIMARY KEY (`Cod_Producto`),
  ADD KEY `FK_ID_Estado_Producto` (`ID_Estado`),
  ADD KEY `FK_Cod_Categoria_Producto` (`ID_Categoria`),
  ADD KEY `FK_Proveedor_Producto` (`Proveedor`),
  ADD KEY `FK_ID_Usuario_Registro_Prod` (`ID_Usuario`) USING BTREE;

--
-- Indices de la tabla `t_proveedor`
--
ALTER TABLE `t_proveedor`
  ADD PRIMARY KEY (`ID_Proveedor`),
  ADD KEY `FK_ID_Estado_Proveedor` (`ID_Estado`),
  ADD KEY `FK_Cod_User` (`Cod_Usuario`) USING BTREE;

--
-- Indices de la tabla `t_rol`
--
ALTER TABLE `t_rol`
  ADD PRIMARY KEY (`ID_Rol`);

--
-- Indices de la tabla `t_salida_inventario`
--
ALTER TABLE `t_salida_inventario`
  ADD PRIMARY KEY (`ID_Detalle_Salida`),
  ADD KEY `FK_ID_Factura_Salida` (`Cod_Fact`),
  ADD KEY `FK_Cod_Salida_Producto` (`Cod_producto`);

--
-- Indices de la tabla `t_usuario`
--
ALTER TABLE `t_usuario`
  ADD PRIMARY KEY (`ID_Usuario`),
  ADD KEY `FK_ID_Estado_Usuario` (`ID_Estado`),
  ADD KEY `FK_ID_Nivel_Usuario` (`Rol`);

--
-- Indices de la tabla `t_venta_credito`
--
ALTER TABLE `t_venta_credito`
  ADD PRIMARY KEY (`ID_Credito`),
  ADD KEY `FK_codigo_factura_credito` (`ID_Factura`),
  ADD KEY `FK_codigo_cliente_credito` (`ID_Cliente`) USING BTREE;

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `t_categoria`
--
ALTER TABLE `t_categoria`
  MODIFY `ID_Categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `t_cliente`
--
ALTER TABLE `t_cliente`
  MODIFY `ID_Cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `t_configuracion`
--
ALTER TABLE `t_configuracion`
  MODIFY `ID_Config` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `t_detalle_fac_almacenada`
--
ALTER TABLE `t_detalle_fac_almacenada`
  MODIFY `Correlativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=301;

--
-- AUTO_INCREMENT de la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  MODIFY `ID_Entrada` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT de la tabla `t_estado`
--
ALTER TABLE `t_estado`
  MODIFY `ID_Estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `t_factura`
--
ALTER TABLE `t_factura`
  MODIFY `ID_Factura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=271;

--
-- AUTO_INCREMENT de la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  MODIFY `ID_Fact_Detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=433;

--
-- AUTO_INCREMENT de la tabla `t_proveedor`
--
ALTER TABLE `t_proveedor`
  MODIFY `ID_Proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `t_rol`
--
ALTER TABLE `t_rol`
  MODIFY `ID_Rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `t_salida_inventario`
--
ALTER TABLE `t_salida_inventario`
  MODIFY `ID_Detalle_Salida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT de la tabla `t_usuario`
--
ALTER TABLE `t_usuario`
  MODIFY `ID_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT de la tabla `t_venta_credito`
--
ALTER TABLE `t_venta_credito`
  MODIFY `ID_Credito` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=207;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `t_cliente`
--
ALTER TABLE `t_cliente`
  ADD CONSTRAINT `t_cliente_ibfk_1` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`),
  ADD CONSTRAINT `t_cliente_ibfk_2` FOREIGN KEY (`Usuario_ID`) REFERENCES `t_usuario` (`ID_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_detalle_fac_almacenada`
--
ALTER TABLE `t_detalle_fac_almacenada`
  ADD CONSTRAINT `t_detalle_fac_almacenada_ibfk_2` FOREIGN KEY (`Num_Factura`) REFERENCES `t_factura` (`ID_Factura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `t_detalle_fac_almacenada_ibfk_3` FOREIGN KEY (`Cod_Producto`) REFERENCES `t_producto` (`Cod_Producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  ADD CONSTRAINT `t_entrada_inventario_ibfk_1` FOREIGN KEY (`Cod_producto`) REFERENCES `t_producto` (`Cod_Producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_factura`
--
ALTER TABLE `t_factura`
  ADD CONSTRAINT `t_factura_ibfk_4` FOREIGN KEY (`Usuario`) REFERENCES `t_usuario` (`ID_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `t_factura_ibfk_5` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `t_factura_ibfk_6` FOREIGN KEY (`Cod_cliente`) REFERENCES `t_cliente` (`ID_Cliente`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  ADD CONSTRAINT `t_fact_detalle_ibfk_3` FOREIGN KEY (`Cod_producto`) REFERENCES `t_producto` (`Cod_Producto`);

--
-- Filtros para la tabla `t_producto`
--
ALTER TABLE `t_producto`
  ADD CONSTRAINT `t_producto_ibfk_1` FOREIGN KEY (`ID_Categoria`) REFERENCES `t_categoria` (`ID_Categoria`),
  ADD CONSTRAINT `t_producto_ibfk_2` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`),
  ADD CONSTRAINT `t_producto_ibfk_3` FOREIGN KEY (`Proveedor`) REFERENCES `t_proveedor` (`ID_Proveedor`),
  ADD CONSTRAINT `t_producto_ibfk_4` FOREIGN KEY (`ID_Usuario`) REFERENCES `t_usuario` (`ID_Usuario`);

--
-- Filtros para la tabla `t_proveedor`
--
ALTER TABLE `t_proveedor`
  ADD CONSTRAINT `t_proveedor_ibfk_1` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`),
  ADD CONSTRAINT `t_proveedor_ibfk_2` FOREIGN KEY (`Cod_Usuario`) REFERENCES `t_usuario` (`ID_Usuario`);

--
-- Filtros para la tabla `t_salida_inventario`
--
ALTER TABLE `t_salida_inventario`
  ADD CONSTRAINT `t_salida_inventario_ibfk_2` FOREIGN KEY (`Cod_producto`) REFERENCES `t_producto` (`Cod_Producto`),
  ADD CONSTRAINT `t_salida_inventario_ibfk_3` FOREIGN KEY (`Cod_Fact`) REFERENCES `t_factura` (`ID_Factura`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_usuario`
--
ALTER TABLE `t_usuario`
  ADD CONSTRAINT `t_usuario_ibfk_1` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`),
  ADD CONSTRAINT `t_usuario_ibfk_2` FOREIGN KEY (`Rol`) REFERENCES `t_rol` (`ID_Rol`);

--
-- Filtros para la tabla `t_venta_credito`
--
ALTER TABLE `t_venta_credito`
  ADD CONSTRAINT `t_venta_credito_ibfk_1` FOREIGN KEY (`ID_Cliente`) REFERENCES `t_cliente` (`ID_Cliente`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `t_venta_credito_ibfk_2` FOREIGN KEY (`ID_Factura`) REFERENCES `t_factura` (`ID_Factura`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
