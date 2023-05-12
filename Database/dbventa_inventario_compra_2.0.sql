-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-04-2023 a las 15:34:31
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
-- Base de datos: `dbventa_inventario_compra`
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `del_detalle_fact` (`id_detalle` INT, `token` VARCHAR(50))   BEGIN
          DELETE FROM t_fact_detalle WHERE ID_Fact_Detalle = id_detalle;

          SELECT tfd.ID_Fact_Detalle, tfd.Cod_producto,prod.Descripcion,tfd.Cantidad,tfd.Precio_Venta FROM t_fact_detalle tfd
          INNER JOIN t_producto prod
          ON tfd.Cod_producto = prod.Cod_Producto
          WHERE tfd.Token_User = token;
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_categoria`
--

CREATE TABLE `t_categoria` (
  `ID_Categoria` int(11) NOT NULL,
  `Nombre_Categoria` varchar(50) NOT NULL,
  `Descripcion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `t_categoria`
--

INSERT INTO `t_categoria` (`ID_Categoria`, `Nombre_Categoria`, `Descripcion`) VALUES
(1, 'Accesorios', 'Productos decorativos'),
(2, 'Celulares', 'Dispositivos móviles gama media y alta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_cliente`
--

CREATE TABLE `t_cliente` (
  `ID_Cliente` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Apellido` varchar(50) NOT NULL,
  `RNC` varchar(50) NOT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `Direccion` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `Correo` varchar(50) CHARACTER SET utf8 NOT NULL,
  `ID_Estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_cliente`
--

INSERT INTO `t_cliente` (`ID_Cliente`, `Nombre`, `Apellido`, `RNC`, `Telefono`, `Direccion`, `Correo`, `ID_Estado`) VALUES
(3, 'Jose Francisco', 'Henriquez', '402-0798815-3', '8093713192', 'Entrada Presa de Taveras', 'josehenriquez.02@gmail.com', 2),
(4, 'Juan Manuel', 'Capellan', '402-0758814-3', '8096538171', 'Entrada Presa de Taveras', 'juanitohernandez@gmail.com', 1),
(5, 'Francisco Rosa', 'Rosario Mend', '402-0798804-3', '8297836171', 'La Vega', 'francrosa2@gmail.com', 1),
(6, 'Juanma', 'Puntiele', '402-0798814-3', '8093713192', 'Entrada Presa de Taveras', 'juanmaz@gmail.com', 1),
(7, 'Juana Maria', 'Henriquez', '402-0899804-3', '8093713191', 'Entrada Presa de Taveras', 'juanamaria@gmail.com', 1),
(8, 'Juanma', 'Garcia', '402-0998804-3', '8093563452', 'Moca', 'juanma26@yahoo', 2),
(9, 'Juan Fran', 'HENRIQUEZ', '402-0718315-3', '8296735618', 'Entrada Presa de Taveras', 'juanfran.2003@gmail.com', 2),
(10, 'Yafreisi Antonio', 'Garcia', '402-0899804-2', '8096574839', 'Palmarito, La Vega', 'yafroc@gmail.com', 2),
(11, 'Yafreisi Antonio', 'Garcia', '402-0899804-2', '8096574839', 'Palmarito, La Vega', 'yafroc@gmail.com', 2),
(12, 'Yandelo', 'Garc', '402-0899804-1', '809748239', 'Presa de Taveras', 'yando123@gmail.com', 2),
(13, 'Yandelo', 'Garc', '402-0899804-1', '809748239', 'Presa de Taveras', 'yando123@gmail.com', 2),
(14, 'Jhonson', 'Ovalles', '402-0899804-4', '8497849382', 'Soto, La Vega', 'ovallesjhonson@yahoo', 1),
(15, 'Franzua', 'Moritzi', '402-0899804-6', '4023674873', 'Soto, La Vega', 'moritzifran@yahoo', 2),
(16, 'Franzua', 'Moritzi', '402-0899804-6', '4023674873', 'Soto, La Vega', 'moritzifran@yahoo', 2),
(17, 'Franzua', 'Moritzi', '402-0899804-6', '4023674873', 'Soto, La Vega', 'moritzifran@yahoo', 2),
(18, 'Franzua', 'Moritzi', '402-0899804-6', '4023674873', 'Soto, La Vega', 'moritzifran@yahoo', 1),
(19, 'JOSE FRANCISCO', 'HENRIQUEZ', '402-0899804-7', '8093713192', 'Entrada Presa de Taveras', 'josehenriquez.02.26@gmail.com', 2),
(20, 'JOSE FRANCISCO', 'HENRIQUEZ', '402-0899804-7', '8093713192', 'Entrada Presa de Taveras', 'josehenriquez.02.26@gmail.com', 2),
(21, 'Juanito Hernandez', 'Garcia', '402-0899804-8', '8093713191', 'Entrada Presa de Taveras', 'josehenriquez.02.26@gmail.com', 2),
(22, 'Yendol', 'Garcia', '402-0899804-5', '8492783562', 'Entrada Presa de Taveras', 'yendol12@gmail.com', 2),
(23, 'Juanma', 'Frimoritzi', '402-0899804-8', '4027846738', 'Francia, La mure', 'frimoritzi2@yahoo.com', 2),
(24, 'JOSE FRANCISCO', 'HENRIQUEZ', '402-0899804-312', '8093713192', 'Entrada Presa de Taveras', 'josehenriquez.02.26@gmail.com', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_compra`
--

CREATE TABLE `t_compra` (
  `ID_Ingreso` int(11) NOT NULL,
  `ID_Proveedor` int(11) NOT NULL,
  `ID_Usuario` int(11) NOT NULL,
  `Tipo_Comprobante` varchar(20) NOT NULL,
  `Serie_Comprobante` varchar(7) DEFAULT NULL,
  `Num_Comprobante` varchar(10) NOT NULL,
  `Fecha` datetime NOT NULL,
  `ITBIS` decimal(4,2) NOT NULL,
  `Total` decimal(11,2) NOT NULL,
  `ID_Estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_compra_detalle`
--

CREATE TABLE `t_compra_detalle` (
  `ID_Detalle_Compra` int(11) NOT NULL,
  `ID_Compra` int(11) NOT NULL,
  `ID_Producto` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Precio` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_configuracion`
--

CREATE TABLE `t_configuracion` (
  `ID_Config` bigint(20) NOT NULL,
  `CIF` varchar(50) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Razon_Social` varchar(100) NOT NULL,
  `Telefono` bigint(20) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Direccion` text NOT NULL,
  `ITBIS` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `t_configuracion`
--

INSERT INTO `t_configuracion` (`ID_Config`, `CIF`, `Nombre`, `Razon_Social`, `Telefono`, `Email`, `Direccion`, `ITBIS`) VALUES
(1, '67389826123', 'Yafreisi Comunicaciones', '', 8096620472, 'yafreisicomunications@gmail.com', 'Las Canas abajo', '18.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_detalle_fac_almacenada`
--

CREATE TABLE `t_detalle_fac_almacenada` (
  `Correlativo` bigint(20) NOT NULL,
  `Num_Factura` int(11) DEFAULT NULL,
  `Cod_Producto` int(11) DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `Precio_Venta` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `t_detalle_fac_almacenada`
--

INSERT INTO `t_detalle_fac_almacenada` (`Correlativo`, `Num_Factura`, `Cod_Producto`, `Cantidad`, `Precio_Venta`) VALUES
(10, 5, 1184, 5, '385.00'),
(11, 5, 1184, 1, '385.00'),
(12, 5, 1184, 1, '385.00'),
(13, 5, 1962, 1, '13500.00'),
(17, 6, 1962, 1, '13500.00'),
(18, 6, 1962, 1, '13500.00'),
(20, 7, 1184, 1, '385.00'),
(21, 7, 1184, 1, '385.00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_empleado`
--

CREATE TABLE `t_empleado` (
  `ID_Empleado` int(11) NOT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Apellido` varchar(50) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `Direccion` varchar(100) DEFAULT NULL,
  `Correo` varchar(50) DEFAULT NULL,
  `Sexo` varchar(10) NOT NULL,
  `Fecha_Nac` date NOT NULL,
  `Salario` double NOT NULL,
  `Departamento` varchar(50) NOT NULL,
  `Estado_Civil` varchar(15) NOT NULL,
  `ID_Estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

--
-- Volcado de datos para la tabla `t_entrada_inventario`
--

INSERT INTO `t_entrada_inventario` (`ID_Entrada`, `Cod_producto`, `Fecha`, `Cantidad`, `Precio_Unitario`, `ID_Usuario`) VALUES
(1, 1184, '2023-04-24 18:06:06', 20, '350.00', 35),
(2, 1184, '2023-04-24 18:06:06', 3, '12000.00', 38),
(3, 4699, '2023-04-24 18:06:06', 2, '32800.00', 39),
(4, 9051, '2023-04-24 18:06:06', 10, '7800.00', 38),
(5, 9317, '2023-04-24 18:06:06', 10, '15000.00', 35),
(6, 8105, '2023-04-24 18:37:56', 12, '9500.00', 1),
(7, 4165, '2023-04-24 18:51:23', 15, '8500.00', 1),
(8, 7538, '2023-04-24 19:17:32', 10, '8500.00', 1),
(9, 1184, '2023-04-24 19:29:24', 5, '8500.00', 1),
(10, 8571, '2023-04-24 23:06:18', 2, '10600.00', 1),
(11, 5545, '2023-04-25 00:59:42', 2, '45000.00', 1),
(12, 9507, '2023-04-25 01:01:57', 2, '4000.00', 1),
(13, 4952, '2023-04-25 01:04:31', 3, '5000.00', 1),
(14, 7501, '2023-04-25 01:06:31', 10, '350.00', 1),
(15, 4881, '2023-04-25 01:09:42', 12, '450.00', 1),
(16, 4455, '2023-04-25 01:12:33', 20, '250.00', 1),
(17, 1184, '2023-04-25 19:13:01', 50, '385.00', 1),
(18, 1184, '2023-04-25 19:17:02', 10, '13500.00', 1),
(19, 4419, '2023-04-25 19:41:42', 10, '8750.00', 1),
(20, 4455, '2023-04-25 19:42:29', 5, '255.00', 1),
(21, 1184, '2023-04-25 19:45:21', 5, '375.00', 1),
(22, 1184, '2023-04-25 20:53:28', 2, '390.00', 1),
(23, 1184, '2023-04-25 20:54:46', 3, '350.00', 1),
(24, 4455, '2023-04-25 20:56:49', 3, '260.00', 1),
(25, 1184, '2023-04-25 20:57:06', 2, '350.00', 1),
(26, 1184, '2023-04-25 21:21:39', 2, '340.00', 1),
(27, 4455, '2023-04-25 21:24:10', 2, '385.00', 1),
(28, 1184, '2023-04-25 22:55:44', 1, '385.00', 1),
(29, 1184, '2023-04-25 22:55:56', 1, '385.00', 1),
(30, 4455, '2023-04-25 22:59:32', 5, '250.00', 1),
(31, 1184, '2023-04-25 23:03:28', 1, '385.00', 1),
(32, 1184, '2023-04-25 23:03:38', 1, '385.00', 1),
(33, 1184, '2023-04-25 23:12:25', 5, '13500.00', 1),
(34, 7501, '2023-04-25 23:13:32', 10, '385.00', 1),
(35, 7501, '2023-04-25 23:14:06', 1, '385.00', 1),
(36, 1184, '2023-04-25 23:41:26', 2, '385.00', 1),
(37, 1184, '2023-04-26 19:20:41', 5, '385.00', 1),
(38, 1184, '2023-04-26 19:21:36', 5, '385.00', 1),
(39, 1962, '2023-04-26 19:26:09', 1, '13500.00', 1),
(40, 1184, '2023-04-26 19:30:22', 5, '8700.00', 1),
(41, 1184, '2023-04-26 19:31:29', 5, '385.00', 1),
(42, 4699, '2023-04-26 19:34:18', 5, '33000.00', 1),
(43, 4881, '2023-04-26 19:46:48', 2, '450.00', 1),
(44, 1184, '2023-04-26 19:47:58', 2, '385.00', 38),
(45, 1184, '2023-04-26 20:22:40', 30, '385.00', 1),
(46, 1184, '2023-04-27 00:06:09', 10, '385.00', 1),
(47, 1184, '2023-04-27 00:14:57', 60, '385.00', 1),
(48, 1184, '2023-04-27 00:16:05', 50, '385.00', 1),
(49, 1184, '2023-04-27 00:23:52', 22, '385.00', 1),
(50, 1184, '2023-04-27 00:29:50', 2, '385.00', 1),
(51, 1184, '2023-04-27 00:37:15', 20, '385.00', 1),
(52, 1184, '2023-04-27 00:37:21', 2, '385.00', 1),
(53, 1962, '2023-04-27 00:46:24', 30, '13500.00', 1),
(54, 1184, '2023-04-27 00:58:31', 100, '13500.00', 1),
(55, 1962, '2023-04-27 00:58:39', 20, '13500.00', 1),
(56, 1184, '2023-04-27 01:06:49', 50, '385.00', 1),
(57, 1962, '2023-04-27 01:06:59', 100, '13500.00', 1),
(58, 1184, '2023-04-27 11:14:23', 100, '385.00', 1),
(59, 1184, '2023-04-27 11:14:46', 50, '385.00', 1),
(60, 1184, '2023-04-27 11:16:28', 150, '385.00', 1),
(61, 1184, '2023-04-27 11:16:43', 50, '385.00', 1),
(62, 1184, '2023-04-27 11:16:56', 15, '385.00', 1),
(63, 1184, '2023-04-27 11:22:02', 50, '385.00', 1),
(64, 1184, '2023-04-27 11:22:08', 15, '385.00', 1),
(65, 1184, '2023-04-27 11:24:41', 50, '385.00', 1),
(66, 1184, '2023-04-27 11:24:46', 100, '385.00', 1),
(67, 1184, '2023-04-27 11:29:32', 25, '385.00', 1),
(68, 1184, '2023-04-27 11:29:37', 50, '385.00', 1),
(69, 1184, '2023-04-27 11:29:44', 10, '385.00', 1),
(70, 4952, '2023-04-27 11:48:17', 5, '5100.00', 1),
(71, 4952, '2023-04-27 11:48:23', 10, '5100.00', 1),
(72, 4952, '2023-04-27 11:48:32', 10, '5100.00', 1),
(73, 4952, '2023-04-27 11:48:40', 50, '5100.00', 1),
(74, 4952, '2023-04-27 11:48:46', 25, '5100.00', 1),
(75, 6886, '2023-04-27 12:39:24', 20, '60.00', 1),
(85, 1184, '2023-04-28 23:32:18', 5, '385.00', 1),
(86, 1184, '2023-04-28 23:32:33', 5, '385.00', 1);

-- --------------------------------------------------------

--
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
(5, 'En proceso');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_factura`
--

CREATE TABLE `t_factura` (
  `ID_Factura` int(11) NOT NULL,
  `Fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `Usuario` int(11) DEFAULT NULL,
  `Cod_cliente` int(11) DEFAULT NULL,
  `Total_Factura` decimal(10,2) DEFAULT NULL,
  `Tipo_Factura` varchar(10) CHARACTER SET utf8mb4 NOT NULL,
  `ID_Estado` int(11) NOT NULL DEFAULT 4
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_factura`
--

INSERT INTO `t_factura` (`ID_Factura`, `Fecha`, `Usuario`, `Cod_cliente`, `Total_Factura`, `Tipo_Factura`, `ID_Estado`) VALUES
(5, '2023-04-29 10:13:32', 38, 6, '16195.00', '', 4),
(6, '2023-04-29 10:15:43', 1, 6, '27000.00', '', 4),
(7, '2023-04-29 10:20:35', 1, 6, '770.00', '', 4);

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
  `Cantidad` int(11) DEFAULT NULL,
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

INSERT INTO `t_producto` (`Cod_Producto`, `Nombre`, `Descripcion`, `Proveedor`, `Precio_Unitario`, `Cantidad`, `Fecha_Registro`, `Costo`, `Imagen`, `ID_Usuario`, `ID_Estado`, `ID_Categoria`) VALUES
(1184, 'Cover de iphone x', 'Cover de celular', 2, '385.00', 121, '2023-04-24 17:30:39', '60', 'img_2ab29740282d2c2e86875a0916ba126d.jpg', 35, 1, 1),
(1962, 'Iphone x', 'Celular de Apple, IOS 13.5.1', 1, '13500.00', 107, '2023-04-24 17:30:39', '10002', 'iphone_x.PNG', 38, 1, 2),
(4165, 'Redmi note 7', 'Celular de Xiomi', 3, '8550.00', 20, '2023-04-24 18:51:23', '6700', 'img_df18ae7a108614cbc2f2d23dab71426e.jpg', 1, 1, 2),
(4419, 'Iphone 8', 'Celular de Apple', 2, '8666.67', 15, '2023-04-24 19:29:24', '7200', 'iphone_8.PNG', 1, 1, 2),
(4455, 'Cover xiaomi', 'Cover de celular', 2, '259.28', 35, '2023-04-25 01:12:33', '50', 'img_45de149981e1ba18000192479d90a960.jpg', 1, 1, 1),
(4699, 'Iphone 12 pro max', 'Celular de Apple, IOS 16', 1, '32942.86', 7, '2023-04-24 17:30:39', '28900', 'iphone_12_pro_max.PNG', 39, 1, 2),
(4881, 'Cover iphone 11 pro', 'Cover de celular', 2, '465.00', 20, '2023-04-25 01:09:42', '120', 'exampleproduct.png', 1, 1, 1),
(4952, 'Redmi note 8.1', 'Celular de Xiomi', 8, '5097.08', 103, '2023-04-25 01:04:31', '6500', 'exampleproduct.png', 1, 2, 2),
(5545, 'Iphone 13', 'Celular de Apple', 8, '45000.00', 2, '2023-04-25 00:59:42', '41000', 'exampleproduct.png', 1, 1, 2),
(6886, 'Cover de iphone xr', 'Cover de celular', 2, '135.00', 30, '2023-04-27 12:39:24', '285', 'img_6a439a4474202f668894e7df8c437c8b.jpg', 1, 1, 1),
(7501, 'Cover de iphone 12', 'Cover de celular', 2, '368.33', 21, '2023-04-25 01:06:31', '80', 'img_1e4595ee8b114faf9232c3d2766f8cd8.jpg', 1, 1, 1),
(7538, 'Redmi note 6', 'Celular de Xiomi', 2, '8500.00', 10, '2023-04-24 19:17:32', '6500', 'exampleproduct.png', 1, 1, 2),
(8105, 'Redmi note 8', 'Celular de Xiomi', 8, '9500.00', 12, '2023-04-24 18:37:56', '7600', 'redmi_note_8.PNG', 1, 1, 2),
(8571, 'Iphone xr', 'Celular de Apple', 8, '10600.00', 2, '2023-04-24 23:06:18', '13700', 'exampleproduct.png', 1, 2, 2),
(9051, 'Redmi note 9', 'Celular de Xiaomi', 2, '7800.00', 10, '2023-04-24 17:30:39', '5000', 'redmi_note_9.PNG', 38, 2, 2),
(9317, 'Iphone xs', 'Celular de Apple, IOS 13.5.1', 1, '15000.00', 10, '2023-04-24 17:30:39', '13500', 'iphone_x.PNG', 35, 2, 2),
(9507, 'Redmi note 5', 'Celular de Xiomi', 3, '4000.00', 2, '2023-04-25 01:01:57', '3000', 'exampleproduct.png', 1, 2, 2);

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

--
-- Volcado de datos para la tabla `t_proveedor`
--

INSERT INTO `t_proveedor` (`ID_Proveedor`, `Proveedor`, `Cod_Usuario`, `Fecha_Registro`, `Contacto`, `Telefono`, `Direccion`, `ID_Estado`) VALUES
(1, 'Smart Cell', 39, '2023-04-24 12:10:00', 'cellsmart@gmail.com', '8093536723', 'Palmarito, La Vega', 1),
(2, 'Estnel Comunicaciones', 38, '2023-04-24 12:10:00', 'estnelcomunicacion@yahoo', '8094940572', 'Santiago De Los Caballeros', 1),
(3, 'Jacob Cell', 35, '2023-04-24 00:00:00', 'jacobcell23@yahoo.com', '8094940562', 'Entrada Presa de Taveras', 2),
(8, 'Tecno Cell', 38, '2023-04-24 00:00:00', 'tecnocell2!@gmail.com', '8498763425', 'Santiago De Los Caballeros', 1),
(9, 'Luz Conexion', 38, '2023-04-24 00:00:00', 'conexionluz23@yahoo.net', '8297654528', 'Moca', 1);

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
(1, 'Jose Francisco', 'josehenriquez.02@gmail.com', 'admin', '202cb962ac59075b964b07152d234b70', 1, 1),
(34, 'Yandil De Jesus', 'yando123@yahoo', 'yandel', '827ccb0eea8a706c4c34a16891f84e7b', 2, 1),
(35, 'Yafreisi Antonio', 'yafreisi@gmail.com', 'Yafrec', '202cb962ac59075b964b07152d234b70', 2, 1),
(36, 'Rosa Elvira', 'r.elviragar@gmail.com', 'r.elvira044', '202cb962ac59075b964b07152d234b70', 2, 1),
(38, 'Bianny Michelle', 'Biannymichelle.02@gmail.com', 'Biannycp', '202cb962ac59075b964b07152d234b70', 4, 1),
(39, 'Juanpi Zurt', 'zurtjuan2@gmail.com', 'zurtjk', '202cb962ac59075b964b07152d234b70', 2, 2),
(40, 'Jose Antonio', 'antonioJose@gmail.com', 'jAtonio12', '81dc9bdb52d04dc20036dbd8313ed055', 2, 2),
(41, 'Jose Francisco', 'josehenriquez.02.26@gmail.com', 'Administrador', '202cb962ac59075b964b07152d234b70', 1, 2),
(42, 'Juanpi Francisco', 'juanpifer2@gmail.com', 'Juanpi', '202cb962ac59075b964b07152d234b70', 2, 2),
(43, 'Fernando Matias', 'matifer42@gmail.com', 'mfeid', '81dc9bdb52d04dc20036dbd8313ed055', 3, 2),
(44, 'Manuel Tejeda', 'tejedamanuel@yahoo', 'tejedamanuel', '202cb962ac59075b964b07152d234b70', 4, 2),
(45, 'Jauno', 'jauno@yahoo', 'jaunoc', '81dc9bdb52d04dc20036dbd8313ed055', 4, 1);

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
  ADD KEY `FK_ID_Estado_Cliente` (`ID_Estado`);

--
-- Indices de la tabla `t_compra`
--
ALTER TABLE `t_compra`
  ADD PRIMARY KEY (`ID_Ingreso`),
  ADD KEY `FK_ID_Proveedor_Compra_Producto` (`ID_Proveedor`),
  ADD KEY `FK_Cod_Usuario_Compra` (`ID_Usuario`),
  ADD KEY `FK_ID_Estado_Compra` (`ID_Estado`);

--
-- Indices de la tabla `t_compra_detalle`
--
ALTER TABLE `t_compra_detalle`
  ADD PRIMARY KEY (`ID_Detalle_Compra`),
  ADD KEY `FK_ID_Compra` (`ID_Compra`),
  ADD KEY `FK_ID_Producto_Compra_Detalle` (`ID_Producto`);

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
-- Indices de la tabla `t_empleado`
--
ALTER TABLE `t_empleado`
  ADD PRIMARY KEY (`ID_Empleado`),
  ADD KEY `FK_ID_Estado_Empleado` (`ID_Estado`);

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
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `t_categoria`
--
ALTER TABLE `t_categoria`
  MODIFY `ID_Categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `t_cliente`
--
ALTER TABLE `t_cliente`
  MODIFY `ID_Cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `t_compra`
--
ALTER TABLE `t_compra`
  MODIFY `ID_Ingreso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `t_compra_detalle`
--
ALTER TABLE `t_compra_detalle`
  MODIFY `ID_Detalle_Compra` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `t_configuracion`
--
ALTER TABLE `t_configuracion`
  MODIFY `ID_Config` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `t_detalle_fac_almacenada`
--
ALTER TABLE `t_detalle_fac_almacenada`
  MODIFY `Correlativo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `t_empleado`
--
ALTER TABLE `t_empleado`
  MODIFY `ID_Empleado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  MODIFY `ID_Entrada` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT de la tabla `t_estado`
--
ALTER TABLE `t_estado`
  MODIFY `ID_Estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `t_factura`
--
ALTER TABLE `t_factura`
  MODIFY `ID_Factura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  MODIFY `ID_Fact_Detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT de la tabla `t_proveedor`
--
ALTER TABLE `t_proveedor`
  MODIFY `ID_Proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `t_rol`
--
ALTER TABLE `t_rol`
  MODIFY `ID_Rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `t_salida_inventario`
--
ALTER TABLE `t_salida_inventario`
  MODIFY `ID_Detalle_Salida` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `t_usuario`
--
ALTER TABLE `t_usuario`
  MODIFY `ID_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `t_cliente`
--
ALTER TABLE `t_cliente`
  ADD CONSTRAINT `t_cliente_ibfk_1` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`);

--
-- Filtros para la tabla `t_compra`
--
ALTER TABLE `t_compra`
  ADD CONSTRAINT `t_compra_ibfk_1` FOREIGN KEY (`ID_Usuario`) REFERENCES `t_usuario` (`ID_Usuario`),
  ADD CONSTRAINT `t_compra_ibfk_2` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`),
  ADD CONSTRAINT `t_compra_ibfk_3` FOREIGN KEY (`ID_Proveedor`) REFERENCES `t_proveedor` (`ID_Proveedor`);

--
-- Filtros para la tabla `t_compra_detalle`
--
ALTER TABLE `t_compra_detalle`
  ADD CONSTRAINT `t_compra_detalle_ibfk_1` FOREIGN KEY (`ID_Compra`) REFERENCES `t_compra` (`ID_Ingreso`);

--
-- Filtros para la tabla `t_detalle_fac_almacenada`
--
ALTER TABLE `t_detalle_fac_almacenada`
  ADD CONSTRAINT `t_detalle_fac_almacenada_ibfk_1` FOREIGN KEY (`Cod_Producto`) REFERENCES `t_producto` (`Cod_Producto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `t_detalle_fac_almacenada_ibfk_2` FOREIGN KEY (`Num_Factura`) REFERENCES `t_factura` (`ID_Factura`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  ADD CONSTRAINT `t_entrada_inventario_ibfk_1` FOREIGN KEY (`Cod_producto`) REFERENCES `t_producto` (`Cod_Producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_factura`
--
ALTER TABLE `t_factura`
  ADD CONSTRAINT `t_factura_ibfk_3` FOREIGN KEY (`Cod_cliente`) REFERENCES `t_cliente` (`ID_Cliente`),
  ADD CONSTRAINT `t_factura_ibfk_4` FOREIGN KEY (`Usuario`) REFERENCES `t_usuario` (`ID_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `t_factura_ibfk_5` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`) ON DELETE CASCADE ON UPDATE CASCADE;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
