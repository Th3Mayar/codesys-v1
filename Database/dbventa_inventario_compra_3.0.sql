-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-05-2023 a las 18:34:04
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
(30, 'JOSE FRANCISCO', 'HENRIQUEZ', '402-0899804-3', '2023-04-29 20:34:12', '8093713192', 'Entrada Presa de Taveras', 'josehenriquez.02.26@gmail.com', 2, 1),
(32, 'Manuel', 'Cepeda', '402-0899804-9', '2023-04-30 21:00:36', '8093713192', 'Entrada Presa de Taveras', 'mcmanuel12@gmail.com', 1, 1),
(36, 'Henry', 'Cavill', '402-0899804-2', '2023-04-30 21:14:14', '8093713192', 'Texas City', 'cavillhenry@gmail.com', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_compra`
--

CREATE TABLE `t_compra` (
  `ID_Ingreso` int(11) NOT NULL,
  `ID_Proveedor` int(11) NOT NULL,
  `ID_Usuario` int(11) NOT NULL,
  `Cod_Producto` int(11) NOT NULL,
  `Tipo_Comprobante` varchar(20) NOT NULL,
  `Serie_Comprobante` varchar(20) DEFAULT NULL,
  `Num_Comprobante` varchar(20) NOT NULL,
  `Fecha` datetime NOT NULL DEFAULT current_timestamp(),
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
  `Telefono` varchar(20) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Direccion` text NOT NULL,
  `ITBIS` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `t_configuracion`
--

INSERT INTO `t_configuracion` (`ID_Config`, `CIF`, `Nombre`, `Razon_Social`, `Telefono`, `Email`, `Direccion`, `ITBIS`) VALUES
(1, '67389826123', 'Yafreisi Comunicaciones', '', '8096620472', 'yafreisicomunications@gmail.com', 'Las Canas abajo', '18.00'),
(2, '89289289', 'Estneil Comunications', '', '8093713192', 'estneil@gmail.com', 'Santiago City', '16.00');

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
(22, 9, 1184, 1, '385.00'),
(23, 10, 1184, 1, '385.00'),
(24, 11, 1184, 1, '385.00'),
(25, 12, 1184, 1, '385.00'),
(26, 12, 1962, 1, '13500.00'),
(28, 13, 1184, 1, '385.00'),
(29, 13, 1184, 2, '385.00'),
(31, 14, 1184, 1, '385.00'),
(32, 14, 1962, 2, '13500.00'),
(34, 15, 1184, 1, '385.00'),
(35, 16, 1184, 5, '385.00'),
(36, 16, 4455, 3, '259.28'),
(38, 17, 1184, 5, '385.00'),
(39, 18, 1184, 1, '385.00'),
(40, 19, 1184, 1, '385.00'),
(41, 20, 1184, 1, '385.00'),
(42, 21, 1184, 1, '385.00'),
(43, 22, 1184, 1, '385.00'),
(44, 23, 1184, 1, '385.00'),
(45, 24, 4455, 1, '259.28'),
(46, 25, 1184, 1, '385.00'),
(47, 26, 1184, 1, '385.00'),
(48, 27, 1184, 1, '385.00'),
(49, 28, 1184, 1, '385.00'),
(50, 29, 1184, 1, '385.00'),
(51, 30, 1184, 1, '385.00'),
(52, 31, 1184, 1, '385.00'),
(53, 32, 1184, 1, '385.00'),
(54, 33, 1184, 1, '385.00'),
(55, 34, 1184, 1, '385.00'),
(56, 35, 1184, 1, '385.00'),
(57, 36, 1184, 1, '385.00'),
(58, 37, 1184, 1, '385.00'),
(59, 38, 1184, 1, '385.00'),
(60, 39, 1184, 1, '385.00'),
(61, 40, 1184, 1, '385.00'),
(62, 41, 1184, 1, '385.00'),
(63, 42, 1184, 1, '385.00'),
(64, 43, 1184, 1, '385.00'),
(65, 44, 1184, 1, '385.00'),
(66, 45, 1184, 1, '385.00'),
(67, 46, 1184, 1, '385.00'),
(68, 47, 1184, 1, '385.00'),
(69, 48, 1184, 1, '385.00'),
(70, 49, 1184, 1, '385.00'),
(71, 50, 1184, 1, '385.00'),
(72, 51, 1962, 1, '13500.00'),
(73, 52, 1962, 1, '13500.00'),
(74, 53, 1184, 1, '385.00'),
(75, 54, 1184, 1, '385.00'),
(76, 55, 1184, 1, '385.00'),
(77, 56, 1962, 3, '13500.00'),
(78, 56, 1184, 2, '385.00'),
(80, 57, 1184, 1, '385.00'),
(81, 58, 1184, 1, '385.00'),
(82, 59, 1184, 1, '385.00'),
(83, 60, 1184, 1, '385.00'),
(84, 61, 1184, 1, '385.00'),
(85, 62, 1184, 1, '385.00'),
(86, 63, 1184, 1, '385.00'),
(87, 64, 1184, 1, '385.00'),
(88, 65, 1184, 1, '385.00'),
(89, 66, 1184, 1, '385.00'),
(90, 67, 1184, 1, '385.00'),
(91, 68, 1184, 1, '385.00'),
(92, 69, 1962, 1, '13500.00'),
(93, 70, 1962, 1, '13500.00'),
(94, 71, 1184, 1, '385.00'),
(95, 72, 1962, 2, '13500.00'),
(96, 73, 1962, 3, '13500.00'),
(97, 74, 1962, 3, '13500.00'),
(98, 75, 1962, 2, '13500.00'),
(99, 76, 1184, 2, '385.00'),
(100, 77, 1184, 1, '385.00'),
(101, 78, 1184, 9, '385.00'),
(102, 79, 1962, 7, '13500.00'),
(103, 80, 1184, 5, '385.00'),
(104, 81, 1184, 2, '385.00'),
(105, 81, 1962, 1, '13500.00'),
(107, 82, 1184, 3, '385.00'),
(108, 83, 1962, 9, '13500.00'),
(109, 84, 1184, 1, '385.00'),
(110, 84, 1962, 1, '13500.00'),
(111, 84, 1184, 1, '385.00'),
(112, 84, 1184, 3, '385.00'),
(113, 84, 6886, 3, '135.00'),
(114, 84, 8105, 1, '9500.00'),
(115, 84, 4455, 1, '259.28'),
(116, 84, 4881, 1, '465.00'),
(124, 85, 1184, 5, '385.00'),
(125, 86, 1184, 1, '385.00'),
(126, 87, 1184, 1, '385.00'),
(127, 88, 1184, 2, '385.00'),
(128, 89, 1184, 1, '385.00'),
(129, 90, 1184, 1, '385.00'),
(130, 91, 1184, 1, '385.00'),
(131, 92, 1184, 1, '385.00'),
(132, 93, 1184, 1, '385.00'),
(133, 94, 1184, 1, '385.00'),
(134, 94, 1962, 1, '13500.00'),
(135, 94, 6886, 1, '135.00'),
(136, 94, 6886, 1, '135.00'),
(137, 94, 6886, 1, '135.00'),
(138, 94, 6886, 1, '135.00'),
(139, 94, 1184, 1, '385.00'),
(140, 95, 1184, 1, '385.00'),
(141, 96, 1962, 8, '13500.00'),
(142, 97, 1184, 2, '385.00'),
(143, 97, 6886, 3, '135.00'),
(144, 97, 4165, 1, '8550.00'),
(145, 97, 4455, 2, '259.28'),
(146, 97, 4881, 1, '465.00'),
(147, 97, 7501, 1, '368.33'),
(148, 97, 1184, 2, '385.00'),
(149, 97, 4455, 2, '259.28'),
(150, 97, 7501, 1, '368.33'),
(151, 97, 1184, 2, '385.00'),
(157, 98, 1184, 2, '385.00'),
(158, 98, 4165, 1, '8550.00'),
(159, 98, 6886, 2, '135.00'),
(160, 98, 4455, 2, '259.28'),
(161, 98, 1184, 1, '385.00'),
(162, 98, 1184, 1, '385.00'),
(163, 98, 6886, 1, '135.00'),
(164, 98, 1184, 2, '385.00'),
(172, 99, 1184, 1, '385.00'),
(173, 100, 1184, 5, '385.00'),
(174, 101, 1184, 1, '385.00'),
(175, 102, 1184, 3, '385.00'),
(176, 103, 1184, 6, '385.00'),
(177, 103, 1962, 1, '13500.00'),
(179, 104, 1184, 1, '385.00'),
(180, 105, 1184, 2, '385.00'),
(181, 106, 1184, 3, '385.00'),
(182, 107, 1184, 2, '385.00'),
(183, 108, 1962, 2, '13500.00'),
(184, 109, 1184, 2, '385.00'),
(185, 110, 1184, 2, '385.00'),
(186, 111, 1184, 5, '385.00'),
(187, 112, 1962, 2, '13055.42'),
(188, 113, 1184, 1, '385.00');

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
(86, 1184, '2023-04-28 23:32:33', 5, '385.00', 1),
(87, 1184, '2023-04-30 20:54:21', 50, '385.00', 1),
(88, 1962, '2023-05-02 14:16:36', 2, '385.00', 1),
(89, 1184, '2023-05-03 12:44:05', 10, '385.00', 1),
(90, 1184, '2023-05-03 12:44:13', 5, '385.00', 1),
(91, 1184, '2023-05-03 14:31:25', 2, '385.00', 1);

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
  `Total_Factura` decimal(10,2) DEFAULT NULL,
  `Tipo_Factura` varchar(10) CHARACTER SET utf8mb4 NOT NULL,
  `ID_Estado` int(11) NOT NULL DEFAULT 4
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `t_factura`
--

INSERT INTO `t_factura` (`ID_Factura`, `Fecha`, `Usuario`, `Cod_cliente`, `Total_Factura`, `Tipo_Factura`, `ID_Estado`) VALUES
(9, '2023-04-29 20:36:13', 1, 30, '385.00', '', 3),
(10, '2023-04-29 21:07:49', 1, 30, '385.00', '', 4),
(11, '2023-04-29 21:44:04', 1, 30, '385.00', '', 3),
(12, '2023-04-29 21:46:37', 1, 1, '13885.00', '', 4),
(13, '2023-04-29 22:00:35', 1, 1, '1155.00', '', 3),
(14, '2023-04-29 22:04:48', 1, 1, '27385.00', '', 4),
(15, '2023-04-30 00:39:49', 1, 1, '385.00', '', 3),
(16, '2023-04-30 01:39:21', 1, 30, '2702.84', '', 4),
(17, '2023-04-30 01:41:02', 1, 30, '1925.00', '', 3),
(18, '2023-04-30 01:41:40', 1, 1, '385.00', '', 4),
(19, '2023-04-30 01:42:23', 1, 1, '385.00', '', 4),
(20, '2023-04-30 01:43:04', 1, 1, '385.00', '', 4),
(21, '2023-04-30 01:44:50', 1, 1, '385.00', '', 4),
(22, '2023-04-30 01:50:02', 1, 1, '385.00', '', 4),
(23, '2023-04-30 01:52:28', 1, 1, '385.00', '', 4),
(24, '2023-04-30 01:54:25', 1, 1, '259.28', '', 4),
(25, '2023-04-30 01:59:08', 1, 1, '385.00', '', 3),
(26, '2023-04-30 01:59:46', 1, 1, '385.00', '', 4),
(27, '2023-04-30 02:00:16', 1, 1, '385.00', '', 4),
(28, '2023-04-30 02:17:45', 1, 1, '385.00', '', 4),
(29, '2023-04-30 02:19:51', 1, 1, '385.00', '', 4),
(30, '2023-04-30 02:20:31', 1, 30, '385.00', '', 3),
(31, '2023-04-30 02:22:43', 1, 30, '385.00', '', 4),
(32, '2023-04-30 02:31:04', 1, 1, '385.00', '', 4),
(33, '2023-04-30 02:35:19', 1, 1, '385.00', '', 4),
(34, '2023-04-30 02:38:03', 1, 1, '385.00', '', 4),
(35, '2023-04-30 02:38:36', 1, 1, '385.00', '', 4),
(36, '2023-04-30 11:50:34', 1, 1, '385.00', '', 4),
(37, '2023-04-30 11:51:19', 1, 1, '385.00', '', 4),
(38, '2023-04-30 11:53:15', 1, 1, '385.00', '', 4),
(39, '2023-04-30 11:54:12', 1, 1, '385.00', '', 4),
(40, '2023-04-30 11:55:38', 1, 1, '385.00', '', 4),
(41, '2023-04-30 11:56:02', 1, 1, '385.00', '', 4),
(42, '2023-04-30 11:58:09', 1, 1, '385.00', '', 4),
(43, '2023-04-30 11:58:40', 1, 1, '385.00', '', 4),
(44, '2023-04-30 12:01:14', 1, 1, '385.00', '', 4),
(45, '2023-04-30 12:02:36', 38, 1, '385.00', '', 4),
(46, '2023-04-30 12:21:51', 1, 1, '385.00', '', 4),
(47, '2023-04-30 12:28:43', 38, 1, '385.00', '', 4),
(48, '2023-04-30 12:31:07', 1, 1, '385.00', '', 4),
(49, '2023-04-30 12:32:12', 38, 1, '385.00', '', 4),
(50, '2023-04-30 12:33:12', 38, 1, '385.00', '', 4),
(51, '2023-04-30 12:33:50', 38, 1, '13500.00', '', 4),
(52, '2023-04-30 12:42:45', 38, 1, '13500.00', '', 4),
(53, '2023-04-30 12:45:58', 38, 1, '385.00', '', 4),
(54, '2023-04-30 12:46:10', 38, 1, '385.00', '', 4),
(55, '2023-04-30 12:56:40', 1, 1, '385.00', '', 4),
(56, '2023-04-30 13:00:18', 38, 1, '41270.00', '', 4),
(57, '2023-04-30 13:06:07', 38, 1, '385.00', '', 4),
(58, '2023-04-30 13:06:24', 38, 1, '385.00', '', 4),
(59, '2023-04-30 13:07:19', 38, 1, '385.00', '', 4),
(60, '2023-04-30 13:18:01', 38, 1, '385.00', '', 4),
(61, '2023-04-30 13:19:09', 38, 1, '385.00', '', 4),
(62, '2023-04-30 13:29:43', 1, 1, '385.00', '', 4),
(63, '2023-04-30 13:29:58', 1, 1, '385.00', '', 4),
(64, '2023-04-30 13:30:53', 1, 1, '385.00', '', 4),
(65, '2023-04-30 13:31:49', 38, 1, '385.00', '', 4),
(66, '2023-04-30 13:33:18', 38, 1, '385.00', '', 4),
(67, '2023-04-30 13:34:52', 38, 1, '385.00', '', 4),
(68, '2023-04-30 13:37:33', 1, 1, '385.00', '', 4),
(69, '2023-04-30 13:38:42', 38, 1, '13500.00', '', 4),
(70, '2023-04-30 13:39:17', 38, 1, '13500.00', '', 4),
(71, '2023-04-30 13:39:42', 38, 1, '385.00', '', 4),
(72, '2023-04-30 13:40:11', 38, 1, '27000.00', '', 4),
(73, '2023-04-30 13:40:55', 38, 1, '40500.00', '', 4),
(74, '2023-04-30 13:42:16', 38, 1, '40500.00', '', 4),
(75, '2023-04-30 13:42:37', 38, 1, '27000.00', '', 4),
(76, '2023-04-30 13:43:19', 38, 1, '770.00', '', 4),
(77, '2023-04-30 13:44:08', 38, 1, '385.00', '', 4),
(78, '2023-04-30 13:47:15', 38, 1, '3465.00', '', 4),
(79, '2023-04-30 13:47:37', 38, 1, '94500.00', '', 4),
(80, '2023-04-30 13:48:08', 38, 1, '1925.00', '', 4),
(81, '2023-04-30 13:49:07', 38, 1, '14270.00', '', 4),
(82, '2023-04-30 13:50:55', 38, 1, '1155.00', '', 4),
(83, '2023-04-30 13:54:25', 1, 1, '121500.00', '', 4),
(84, '2023-04-30 13:58:33', 1, 1, '26054.28', '', 4),
(85, '2023-04-30 17:03:14', 38, 1, '1925.00', '', 4),
(86, '2023-04-30 17:04:33', 1, 30, '385.00', '', 4),
(87, '2023-04-30 17:13:46', 1, 1, '385.00', '', 4),
(88, '2023-04-30 17:14:49', 1, 1, '770.00', '', 4),
(89, '2023-04-30 19:36:51', 1, 1, '385.00', '', 4),
(90, '2023-04-30 19:39:12', 1, 1, '385.00', '', 4),
(91, '2023-04-30 19:41:32', 1, 1, '385.00', '', 4),
(92, '2023-04-30 20:03:52', 1, 1, '385.00', '', 4),
(93, '2023-04-30 20:04:38', 1, 1, '385.00', '', 4),
(94, '2023-04-30 20:36:42', 1, 1, '14810.00', '', 4),
(95, '2023-04-30 20:52:52', 1, 1, '385.00', '', 4),
(96, '2023-04-30 20:53:43', 1, 30, '108000.00', '', 4),
(97, '2023-04-30 20:56:55', 1, 1, '13503.78', '', 4),
(98, '2023-04-30 21:00:50', 1, 32, '11783.56', '', 4),
(99, '2023-04-30 21:14:23', 1, 36, '385.00', '', 4),
(100, '2023-04-30 21:34:20', 1, 36, '1925.00', '', 4),
(101, '2023-04-30 23:24:17', 34, 1, '385.00', '', 4),
(102, '2023-05-01 11:49:10', 34, 1, '1155.00', '', 4),
(103, '2023-05-02 11:16:16', 34, 1, '15810.00', '', 4),
(104, '2023-05-02 11:26:14', 34, 1, '385.00', '', 4),
(105, '2023-05-02 11:41:26', 34, 1, '770.00', '', 4),
(106, '2023-05-02 11:44:35', 38, 1, '1155.00', '', 4),
(107, '2023-05-02 11:50:27', 38, 1, '770.00', '', 4),
(108, '2023-05-02 14:15:39', 1, 36, '27000.00', '', 4),
(109, '2023-05-02 17:43:29', 1, 1, '770.00', '', 4),
(110, '2023-05-03 18:28:58', 1, 1, '770.00', '', 4),
(111, '2023-05-03 20:52:23', 1, 1, '1925.00', '', 4),
(112, '2023-05-03 20:52:42', 38, 1, '26110.84', '', 4),
(113, '2023-05-03 22:12:49', 1, 1, '385.00', '', 4);

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
(1184, 'Cover de iphone x', 'Cover de celular', 2, '385.00', 29, '2023-04-24 17:30:39', '60', 'img_2ab29740282d2c2e86875a0916ba126d.jpg', 35, 1, 1),
(1962, 'Iphone x', 'Celular de Apple, IOS 13.5.1', 1, '13055.42', 57, '2023-04-24 17:30:39', '10002', 'iphone_x.PNG', 38, 1, 2),
(4165, 'Redmi note 7', 'Celular de Xiomi', 3, '8550.00', 18, '2023-04-24 18:51:23', '6700', 'img_df18ae7a108614cbc2f2d23dab71426e.jpg', 1, 1, 2),
(4419, 'Iphone 8', 'Celular de Apple', 2, '8666.67', 15, '2023-04-24 19:29:24', '7200', 'iphone_8.PNG', 1, 1, 2),
(4455, 'Cover xiaomi', 'Cover de celular', 2, '259.28', 24, '2023-04-25 01:12:33', '50', 'img_45de149981e1ba18000192479d90a960.jpg', 1, 1, 1),
(4699, 'Iphone 12 pro max', 'Celular de Apple, IOS 16', 1, '32942.86', 7, '2023-04-24 17:30:39', '28900', 'iphone_12_pro_max.PNG', 39, 1, 2),
(4881, 'Cover iphone 11 pro', 'Cover de celular', 2, '465.00', 18, '2023-04-25 01:09:42', '120', 'exampleproduct.png', 1, 1, 1),
(4952, 'Redmi note 8.1', 'Celular de Xiomi', 8, '5097.08', 103, '2023-04-25 01:04:31', '6500', 'exampleproduct.png', 1, 2, 2),
(5545, 'Iphone 13', 'Celular de Apple', 8, '45000.00', 2, '2023-04-25 00:59:42', '41000', 'exampleproduct.png', 1, 1, 2),
(6886, 'Cover de iphone xr', 'Cover de celular', 2, '135.00', 17, '2023-04-27 12:39:24', '285', 'img_6a439a4474202f668894e7df8c437c8b.jpg', 1, 1, 1),
(7501, 'Cover de iphone 12', 'Cover de celular', 2, '368.33', 19, '2023-04-25 01:06:31', '80', 'img_1e4595ee8b114faf9232c3d2766f8cd8.jpg', 1, 1, 1),
(7538, 'Redmi note 6', 'Celular de Xiomi', 2, '8500.00', 10, '2023-04-24 19:17:32', '6500', 'exampleproduct.png', 1, 1, 2),
(8105, 'Redmi note 8', 'Celular de Xiomi', 8, '9500.00', 11, '2023-04-24 18:37:56', '7600', 'redmi_note_8.PNG', 1, 1, 2),
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
(9, 'Luz Conexion', 38, '2023-04-24 00:00:00', 'conexionluz23@yahoo.net', '8297654528', 'Moca', 1),
(10, 'Tecno Master', 1, '2023-04-29 19:36:19', 'tecnomaster@yahoo', '8093713190', 'Santo Domingo', 1);

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

--
-- Volcado de datos para la tabla `t_salida_inventario`
--

INSERT INTO `t_salida_inventario` (`ID_Detalle_Salida`, `Cod_Fact`, `Cod_producto`, `Fecha_Salida`, `Cantidad`, `Precio_total`) VALUES
(1, 100, 1184, '2023-04-30 21:34:20', 5, '385.00'),
(2, 101, 1184, '2023-04-30 23:24:17', 1, '385.00'),
(3, 102, 1184, '2023-05-01 11:49:10', 3, '385.00'),
(4, 103, 1184, '2023-05-02 11:16:16', 6, '385.00'),
(5, 103, 1962, '2023-05-02 11:16:16', 1, '13500.00'),
(6, 104, 1184, '2023-05-02 11:26:14', 1, '385.00'),
(7, 105, 1184, '2023-05-02 11:41:26', 2, '385.00'),
(8, 106, 1184, '2023-05-02 11:44:35', 3, '385.00'),
(9, 107, 1184, '2023-05-02 11:50:27', 2, '385.00'),
(10, 108, 1962, '2023-05-02 14:15:39', 2, '13500.00'),
(11, 109, 1184, '2023-05-02 17:43:30', 2, '385.00'),
(12, 110, 1184, '2023-05-03 18:28:58', 2, '385.00'),
(13, 111, 1184, '2023-05-03 20:52:23', 5, '385.00'),
(14, 112, 1962, '2023-05-03 20:52:42', 2, '13055.42'),
(15, 113, 1184, '2023-05-03 22:12:49', 1, '385.00');

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
(34, 'Yandil De Jesus', 'yando123@yahoo', 'yandel', '827ccb0eea8a706c4c34a16891f84e7b', 4, 1),
(35, 'Yafreisi Antonio', 'yafreisi@gmail.com', 'Yafrec', '81dc9bdb52d04dc20036dbd8313ed055', 3, 1),
(36, 'Rosa Elvira', 'r.elviragar@gmail.com', 'r.elvira044', '202cb962ac59075b964b07152d234b70', 2, 1),
(38, 'Bianny Michelle', 'Biannymichelle.02@gmail.com', 'Biannycp', '202cb962ac59075b964b07152d234b70', 4, 1),
(39, 'Juanpi Zurt', 'zurtjuan2@gmail.com', 'zurtjk', '202cb962ac59075b964b07152d234b70', 2, 2),
(40, 'Jose Antonio', 'antonioJose@gmail.com', 'jAtonio12', '81dc9bdb52d04dc20036dbd8313ed055', 2, 2),
(41, 'Jose Francisco', 'josehenriquez.02.26@gmail.com', 'Administrador', '202cb962ac59075b964b07152d234b70', 1, 2),
(42, 'Juanpi Francisco', 'juanpifer2@gmail.com', 'Juanpi', '202cb962ac59075b964b07152d234b70', 2, 2),
(43, 'Fernando Matias', 'matifer42@gmail.com', 'mfeid', '81dc9bdb52d04dc20036dbd8313ed055', 3, 2),
(44, 'Manuel Tejeda', 'tejedamanuel@yahoo', 'tejedamanuel', '202cb962ac59075b964b07152d234b70', 4, 2),
(45, 'Jauno', 'jauno@yahoo', 'jaunoc', '81dc9bdb52d04dc20036dbd8313ed055', 4, 2);

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
-- Indices de la tabla `t_compra`
--
ALTER TABLE `t_compra`
  ADD PRIMARY KEY (`ID_Ingreso`),
  ADD KEY `FK_ID_Proveedor_Compra_Producto` (`ID_Proveedor`),
  ADD KEY `FK_Cod_Usuario_Compra` (`ID_Usuario`),
  ADD KEY `FK_ID_Estado_Compra` (`ID_Estado`),
  ADD KEY `FK_Code_Product` (`Cod_Producto`);

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
  MODIFY `ID_Cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

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
  MODIFY `ID_Config` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `t_detalle_fac_almacenada`
--
ALTER TABLE `t_detalle_fac_almacenada`
  MODIFY `Correlativo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=189;

--
-- AUTO_INCREMENT de la tabla `t_empleado`
--
ALTER TABLE `t_empleado`
  MODIFY `ID_Empleado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  MODIFY `ID_Entrada` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT de la tabla `t_estado`
--
ALTER TABLE `t_estado`
  MODIFY `ID_Estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `t_factura`
--
ALTER TABLE `t_factura`
  MODIFY `ID_Factura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT de la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  MODIFY `ID_Fact_Detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=307;

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
  MODIFY `ID_Detalle_Salida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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
  ADD CONSTRAINT `t_cliente_ibfk_1` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`),
  ADD CONSTRAINT `t_cliente_ibfk_2` FOREIGN KEY (`Usuario_ID`) REFERENCES `t_usuario` (`ID_Usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_compra`
--
ALTER TABLE `t_compra`
  ADD CONSTRAINT `t_compra_ibfk_1` FOREIGN KEY (`ID_Usuario`) REFERENCES `t_usuario` (`ID_Usuario`),
  ADD CONSTRAINT `t_compra_ibfk_2` FOREIGN KEY (`ID_Estado`) REFERENCES `t_estado` (`ID_Estado`),
  ADD CONSTRAINT `t_compra_ibfk_3` FOREIGN KEY (`ID_Proveedor`) REFERENCES `t_proveedor` (`ID_Proveedor`),
  ADD CONSTRAINT `t_compra_ibfk_4` FOREIGN KEY (`Cod_Producto`) REFERENCES `t_producto` (`Cod_Producto`) ON DELETE CASCADE ON UPDATE CASCADE;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
