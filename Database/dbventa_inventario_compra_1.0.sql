-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-04-2023 a las 02:30:02
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
(3, 'Jose Francisco', 'Henriquez', '402-0798815-3', '8093713192', 'Entrada Presa de Taveras', 'josehenriquez.02@gmail.com', 1),
(4, 'Juan Manuel', 'Capellan', '402-0758814-3', '8096538171', 'Entrada Presa de Taveras', 'juanitohernandez@gmail.com', 1),
(5, 'Francisco Rosa', 'Rosario Mend', '402-0798804-3', '8297836171', 'La Vega', 'francrosa2@gmail.com', 1),
(6, 'Juanma', 'Puntiele', '402-0798814-3', '8093713192', 'Entrada Presa de Taveras', 'juanmaz@gmail.com', 1),
(7, 'Juana Maria', 'Henriquez', '402-0899804-3', '8093713191', 'Entrada Presa de Taveras', 'juanamaria@gmail.com', 2),
(8, 'Juanma', 'Garcia', '402-0998804-3', '8093563452', 'Moca', 'juanma26@yahoo', 1);

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
(2, 1962, '2023-04-24 18:06:06', 4, '12000.00', 38),
(3, 4699, '2023-04-24 18:06:06', 2, '32800.00', 39),
(4, 9051, '2023-04-24 18:06:06', 10, '7800.00', 38),
(5, 9317, '2023-04-24 18:06:06', 10, '15000.00', 35),
(6, 8105, '2023-04-24 18:37:56', 12, '9500.00', 1),
(7, 4165, '2023-04-24 18:51:23', 15, '8500.00', 1),
(8, 7538, '2023-04-24 19:17:32', 10, '8500.00', 1),
(9, 4419, '2023-04-24 19:29:24', 5, '8500.00', 1);

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
(2, 'Inactivo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_factura`
--

CREATE TABLE `t_factura` (
  `ID_Factura` int(11) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `Cod_cliente` int(11) DEFAULT NULL,
  `Total_Factura` decimal(10,2) DEFAULT NULL,
  `Tipo_Factura` varchar(10) CHARACTER SET utf8mb4 NOT NULL,
  `ID_Empleado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `t_fact_detalle`
--

CREATE TABLE `t_fact_detalle` (
  `ID_Fact_Detalle` int(11) NOT NULL,
  `Cod_Fact` int(11) DEFAULT NULL,
  `Cod_producto` int(11) DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `Precio_total` decimal(10,2) DEFAULT NULL,
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
(1184, 'Cover de iphone x', 'Cover de celular', 2, '350.00', 20, '2023-04-24 17:30:39', '50', 'cover_iphone_x.PNG', 35, 1, 1),
(1962, 'Iphone x', 'Celular de Apple, IOS 13.5.1', 1, '12000.00', 4, '2023-04-24 17:30:39', '10000', 'iphone_x.PNG', 38, 1, 2),
(4165, 'Redmi note 7', 'Celular de Xiomi', 3, '8500.00', 15, '2023-04-24 18:51:23', '6700', 'exampleproduct.png', 1, 1, 2),
(4419, 'Iphone 8', 'Celular de Apple', 2, '8500.00', 5, '2023-04-24 19:29:24', '7200', 'iphone_8.PNG', 1, 1, 2),
(4699, 'Iphone 12 pro max', 'Celular de Apple, IOS 16', 1, '32800.00', 2, '2023-04-24 17:30:39', '28900', 'iphone_12_pro_max.PNG', 39, 2, 2),
(7538, 'Redmi note 6', 'Celular de Xiomi', 2, '8500.00', 10, '2023-04-24 19:17:32', '6500', 'exampleproduct.png', 1, 1, 2),
(8105, 'Redmi note 8', 'Celular de Xiomi', 8, '9500.00', 12, '2023-04-24 18:37:56', '7600', 'redmi_note_8.PNG', 1, 1, 2),
(9051, 'Redmi note 9', 'Celular de Xiaomi', 2, '7800.00', 10, '2023-04-24 17:30:39', '5000', 'redmi_note_9.PNG', 38, 1, 2),
(9317, 'Iphone xs', 'Celular de Apple, IOS 13.5.1', 1, '15000.00', 10, '2023-04-24 17:30:39', '13500', 'iphone_x.PNG', 35, 1, 2);

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
(36, 'Rosa Elvira', 'r.elviragar@gmail.com', 'r.elvira044', '202cb962ac59075b964b07152d234b70', 2, 2),
(38, 'Bianny Michelle', 'Biannymichelle.02@gmail.com', 'Biannycp', '202cb962ac59075b964b07152d234b70', 2, 1),
(39, 'Juanpi Zurt', 'zurtjuan2@gmail.com', 'zurtjk', '202cb962ac59075b964b07152d234b70', 2, 1),
(40, 'Jose Antonio', 'antonioJose@gmail.com', 'jAtonio12', '81dc9bdb52d04dc20036dbd8313ed055', 2, 1),
(41, 'Jose Francisco', 'josehenriquez.02.26@gmail.com', 'Administrador', '202cb962ac59075b964b07152d234b70', 1, 1),
(42, 'Juanpi Francisco', 'juanpifer2@gmail.com', 'Juanpi', '202cb962ac59075b964b07152d234b70', 2, 1),
(43, 'Fernando Matias', 'matifer42@gmail.com', 'mfeid', '81dc9bdb52d04dc20036dbd8313ed055', 3, 1),
(44, 'Manuel Tejeda', 'tejedamanuel@yahoo', 'tejedamanuel', '202cb962ac59075b964b07152d234b70', 4, 1);

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
  ADD KEY `FK_Cod_Empleado` (`ID_Empleado`);

--
-- Indices de la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  ADD PRIMARY KEY (`ID_Fact_Detalle`),
  ADD KEY `FK_Cod_Fact` (`Cod_Fact`),
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
  MODIFY `ID_Cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
-- AUTO_INCREMENT de la tabla `t_empleado`
--
ALTER TABLE `t_empleado`
  MODIFY `ID_Empleado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  MODIFY `ID_Entrada` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `t_estado`
--
ALTER TABLE `t_estado`
  MODIFY `ID_Estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `t_factura`
--
ALTER TABLE `t_factura`
  MODIFY `ID_Factura` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  MODIFY `ID_Fact_Detalle` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `ID_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

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
-- Filtros para la tabla `t_entrada_inventario`
--
ALTER TABLE `t_entrada_inventario`
  ADD CONSTRAINT `t_entrada_inventario_ibfk_1` FOREIGN KEY (`Cod_producto`) REFERENCES `t_producto` (`Cod_Producto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `t_factura`
--
ALTER TABLE `t_factura`
  ADD CONSTRAINT `t_factura_ibfk_3` FOREIGN KEY (`Cod_cliente`) REFERENCES `t_cliente` (`ID_Cliente`),
  ADD CONSTRAINT `t_factura_ibfk_4` FOREIGN KEY (`ID_Empleado`) REFERENCES `t_usuario` (`ID_Usuario`);

--
-- Filtros para la tabla `t_fact_detalle`
--
ALTER TABLE `t_fact_detalle`
  ADD CONSTRAINT `t_fact_detalle_ibfk_2` FOREIGN KEY (`Cod_Fact`) REFERENCES `t_factura` (`ID_Factura`),
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
  ADD CONSTRAINT `t_salida_inventario_ibfk_1` FOREIGN KEY (`Cod_Fact`) REFERENCES `t_factura` (`ID_Factura`),
  ADD CONSTRAINT `t_salida_inventario_ibfk_2` FOREIGN KEY (`Cod_producto`) REFERENCES `t_producto` (`Cod_Producto`);

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
