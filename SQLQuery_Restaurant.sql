

CREATE DATABASE RESTAURANT;

USE RESTAURANT;
GO


--PRACTICA #3 Haciendo uso del conocimiento en base al levantamiento de información que han
--realizado para sus proyectos y el diseño físico previamente realizado, Deben
--tomar a consideración y realizar los siguientes puntos dependiendo del proyecto
--asignado:


--1-Debe crear al menos 6 tablas con sus correspondientes llaves primarias. 

--TABLA CLIENTE--
CREATE TABLE CLIENTE (
CLIENTEID INT NOT NULL PRIMARY KEY,
NOMBRE VARCHAR(100) NOT NULL,
TELEFONO VARCHAR(15) NOT NULL,
DIRECCION VARCHAR(200) NOT NULL
);
SELECT * FROM CLIENTE
GO

--TABLA MESA--

CREATE TABLE MESA (
MESAID INT NOT NULL PRIMARY KEY,
NUMEROMESA INT,
CAPACIDAD INT,
UBICACION VARCHAR(100) NOT NULL,
ESTADO VARCHAR(20)
);
GO

--TABLA RESERVA--

CREATE TABLE RESERVA (
RESERVAID INT NOT NULL PRIMARY KEY,
FECHA DATE,
HORARIO TIME,
MESAID INT NOT NULL,
CLIENTEID INT NOT NULL
);
GO
--TABLA EMPLEADO--

CREATE TABLE EMPLEADO (
EMPLEADOID INT NOT NULL PRIMARY KEY,
NOMBRE VARCHAR(100) NOT NULL,
PUESTO VARCHAR(50) NOT NULL,
TELEFONO VARCHAR(15) NOT NULL,
HORARIO TIME NOT NULL
);
GO
--TABLA PEDIDO--
CREATE TABLE PEDIDO (
PEDIDOID INT NOT NULL PRIMARY KEY,
FECHA DATE,
HORA TIME,
ESTADO VARCHAR(20),
EMPLEADOID INT NOT NULL,
MESAID INT NOT NULL, 
CLIENTEID INT NOT NULL
);
GO
--TABLA FACTURA--

CREATE TABLE FACTURA (
FACTURAID INT NOT NULL PRIMARY KEY,
FECHA DATE,
MONTO MONEY,
METODOPAGO VARCHAR(50) NOT NULL,
PEDIDOID INT NOT NULL,
EMPLEADOID INT NOT NULL
);
GO

--TABLA INVENTARIO--

CREATE TABLE INVENTARIO (
INVENTARIOID INT NOT NULL PRIMARY KEY,
NOMBRE VARCHAR(100) NOT NULL,
CANTIDAD INT,
CATEGORIA VARCHAR(50) NOT NULL,
DESCRIPCION VARCHAR(200) NOT NULL
);
GO
--TABLA PRODUCTO--
CREATE TABLE PRODUCTO (
PRODUCTOID INT NOT NULL PRIMARY KEY,
NOMBRE VARCHAR(100) NOT NULL,
DESCRIPCION VARCHAR(200) NOT NULL,
PRECIO MONEY,
CANTIDAD INT,
CATEGORIA VARCHAR(50) NOT NULL,
INVENTARIOID INT NOT NULL
);
GO

--TABLA DETALLEPEDIDO--

CREATE TABLE DETALLEPEDIDO (
PEDIDOID INT NOT NULL,
PRODUCTOID INT NOT NULL,
CANTIDAD INT,
PRECIOUNITARIO MONEY,
SUBTOTAL MONEY
);
GO
--TABLA PROVEEDOR--

CREATE TABLE PROVEEDOR (
PROVEEDORID INT NOT NULL PRIMARY KEY,
NOMBRE VARCHAR(100) NOT NULL,
DIRECCION VARCHAR(200) NOT NULL,
TELEFONO VARCHAR(15) NOT NULL
);
GO
--TABLA PROVEEDOR INVENTARIO--
CREATE TABLE PROVEEDOR_INVENTARIO(
INVENTARIOID INT NOT NULL,
PROVEEDORID INT NOT NULL,
FECHASUMINISTRO DATE,
COSTO MONEY
);
GO

--2-Debe crear las relaciones entre tablas (Llaves Foráneas)

--TABLA RESERVA
ALTER TABLE RESERVA ADD CONSTRAINT FK_RESERVA_MESA FOREIGN KEY (MESAID) REFERENCES MESA(MESAID);
ALTER TABLE RESERVA ADD CONSTRAINT FK_RESERVA_CLIENTE FOREIGN KEY (CLIENTEID) REFERENCES CLIENTE(CLIENTEID);

--TABLA PEDIDO

ALTER TABLE PEDIDO ADD CONSTRAINT  FK_PEDIDO_EMPLEADO FOREIGN KEY (EMPLEADOID) REFERENCES EMPLEADO(EMPLEADOID);
ALTER TABLE PEDIDO ADD CONSTRAINT FK_PEDIDO_MESA FOREIGN KEY (MESAID) REFERENCES MESA(MESAID);
ALTER TABLE PEDIDO ADD CONSTRAINT FK_PEDIDO_CLIENTE FOREIGN KEY (CLIENTEID) REFERENCES CLIENTE(CLIENTEID);

--TABLA FACTURA

ALTER TABLE FACTURA ADD CONSTRAINT FK_FACTURA_PEDIDO FOREIGN KEY (PEDIDOID) REFERENCES PEDIDO(PEDIDOID);
ALTER TABLE FACTURA ADD CONSTRAINT FK_FACTURA_EMPLEADO FOREIGN KEY (EMPLEADOID) REFERENCES EMPLEADO(EMPLEADOID);

--TABLA PRODUCTO


ALTER TABLE PRODUCTO ADD CONSTRAINT FK_PRODUCTO_INVENTARIO FOREIGN KEY (INVENTARIOID) REFERENCES INVENTARIO(INVENTARIOID);

--TABLA DETALLEPEDIDO

ALTER TABLE DETALLEPEDIDO ADD CONSTRAINT PK_DETALLEPEDIDO PRIMARY KEY (PEDIDOID, PRODUCTOID);
ALTER TABLE DETALLEPEDIDO ADD CONSTRAINT FK_DETALLEPEDIDO_PRODUCTO FOREIGN KEY (PRODUCTOID) REFERENCES PRODUCTO(PRODUCTOID);
ALTER TABLE DETALLEPEDIDO ADD CONSTRAINT FK_DETALLEPEDIDO_PEDIDO FOREIGN KEY (PEDIDOID) REFERENCES PEDIDO(PEDIDOID);


--TABLA PROVEEDOR_INVENTARIO

ALTER TABLE PROVEEDOR_INVENTARIO ADD CONSTRAINT PK_PROVEEDOR_INVENTARIO PRIMARY KEY (INVENTARIOID, PROVEEDORID);
ALTER TABLE PROVEEDOR_INVENTARIO ADD CONSTRAINT FK_PROVEEDOR_INVENTARIO_INVENTARIO FOREIGN KEY (INVENTARIOID) REFERENCES INVENTARIO(INVENTARIOID);
ALTER TABLE PROVEEDOR_INVENTARIO ADD CONSTRAINT FK_PROVEEDOR_INVENTARIO_PROVEEDOR FOREIGN KEY (PROVEEDORID) REFERENCES PROVEEDOR(PROVEEDORID);

--3-Debe crear una vista que use al menos la unión entre 3 tablas usando INNER JOIN

GO
CREATE VIEW VISTA_PEDIDO_CLIENTE_MESA AS

SELECT
C.NOMBRE AS CLIENTE,
P.PEDIDOID,
P.FECHA,
P.HORA,
P.ESTADO,
M.NUMEROMESA

FROM PEDIDO P

INNER JOIN CLIENTE C 
ON P.CLIENTEID = C.CLIENTEID

INNER JOIN MESA M 
ON P.MESAID = M.MESAID;

GO

SELECT * 
FROM VISTA_PEDIDO_CLIENTE_MESA;

GO

--4. Debe crear una vista que use al menos la unión entre 3 tablas usando LEFT JOIN

GO

CREATE VIEW VISTA_PEDIDO_CLIENTE_MESA_LEFT AS

SELECT
    P.PEDIDOID,
    P.FECHA,
    P.HORA,
    P.ESTADO,
    C.NOMBRE AS CLIENTE,
    M.NUMEROMESA,
    M.UBICACION
FROM PEDIDO P
LEFT JOIN CLIENTE C ON P.CLIENTEID = C.CLIENTEID
LEFT JOIN MESA M ON P.MESAID = M.MESAID;
GO

SELECT * 
FROM VISTA_PEDIDO_CLIENTE_MESA_LEFT;
GO

--5. Debe crear una vista que use una consulta con una función de agrupación cualquiera (Sum, Avg, Max, Min)

GO
CREATE VIEW VISTA_PRODUCTO_CATEGORÍA AS
SELECT 
    CATEGORIA,
    COUNT(*) AS TOTAL_PRODUCTOS,
    SUM(PRECIO) AS PRECIO_TOTAL,
    AVG(PRECIO) AS PRECIO_PROMEDIO
    FROM PRODUCTO
    GROUP BY CATEGORIA;
    GO
    SELECT * FROM VISTA_PRODUCTO_CATEGORÍA;

--6. Debe crear un procedimiento almacenado que inserte un registro en cualquiera
--de sus tablas y que luego haga una consulta que muestre dicho registro. Debe
--de pasar los datos que se van a insertar al procedimiento almacenado.

GO
DROP PROCEDURE IF EXISTS INSERTARNUEVOCLIENTE;
GO
CREATE PROCEDURE INSERTARNUEVOCLIENTE
@CLIENTEID INT,
@NOMBRE VARCHAR(100),
@TELEFONO VARCHAR(15),
@DIRECCION VARCHAR(200)


AS
BEGIN
INSERT INTO CLIENTE (CLIENTEID, NOMBRE, TELEFONO, DIRECCION) 
VALUES (@CLIENTEID, @NOMBRE, @TELEFONO, @DIRECCION);

SELECT * FROM CLIENTE WHERE CLIENTEID = @CLIENTEID;

END;
GO
EXEC INSERTARNUEVOCLIENTE @CLIENTEID = 216, @NOMBRE = 'Carla Colladoo', 
@TELEFONO = '809-549-9488', @DIRECCION = 'Barrio Duarte #69 Las Palmas de Herrera';


--7. Debe crear un procedimiento almacenado que actualice una tabla en cualquiera
--de sus columnas y que muestre la cantidad total de registro que tiene dicha tabla, dicha cantidad debe ser pasada por parámetro de salida.

GO
CREATE PROCEDURE ACTUALIZARCLIENTE
@CLIENTEID INT,
@NUEVO_TELEFONO VARCHAR(15),
@NUEVA_DIRECCION VARCHAR(200),
@TOTALREGISTROS INT OUTPUT

AS
BEGIN

UPDATE CLIENTE
SET TELEFONO = @NUEVO_TELEFONO, DIRECCION = @NUEVA_DIRECCION
WHERE CLIENTEID = @CLIENTEID;

SELECT @TOTALREGISTROS = COUNT(*) FROM CLIENTE;
END;

DECLARE @TOTAL INT;
EXEC ACTUALIZARCLIENTE @CLIENTEID = 201, @NUEVO_TELEFONO = '849-565-1234',
@NUEVA_DIRECCION = 'Buenos Aires de Herrera, 15, Santo Domingo Oeste',
@TOTALREGISTROS = @TOTAL OUTPUT;

SELECT @TOTAL AS TotalRegistros;

GO




--8. Debe crear un trigger que inserte un registro que fue actualizado en una tabla
--histórica de cambios.

--TABLA HISTORICO_CAMBIOS
GO
CREATE TABLE HISTORICO_CAMBIOS (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CLIENTEID INT,
    NOMBRE VARCHAR(100),
    TELEFONO VARCHAR(15),
    DIRECCION VARCHAR(200),
    FECHACAMBIO DATETIME DEFAULT GETDATE()
);
GO
--TRIGGER
UPDATE CLIENTE SET TELEFONO = '849-567-1803', DIRECCION = 'Reparto Rosa, 16, Santo Domingo Oeste'
WHERE CLIENTEID = 201;

GO
CREATE TRIGGER TRG_ACTUALIZARCLIENTE
ON CLIENTE
AFTER UPDATE
AS
BEGIN
    INSERT INTO HISTORICO_CAMBIOS (CLIENTEID, NOMBRE, TELEFONO, DIRECCION)
    SELECT CLIENTEID, NOMBRE, TELEFONO, DIRECCION
    FROM INSERTED;
END;
GO
SELECT * FROM HISTORICO_CAMBIOS;


--9. Debe crear una función que muestre el total de registros que tienen todas sus
--tablas en la base de datos. Debe de sumar todos los registros que tiene cada
--tabla y mostrar en una función de tipo tabla. El resultado de consultar la función
--será que muestre el nombre los nombres de las tablas y la cantidad de registro
--que tiene cada una. 

GO

CREATE FUNCTION dbo.FN_SUMA_REGISTROS_TABLAS()
RETURNS TABLE 
AS

RETURN

(

    SELECT 'CLIENTE' AS Tabla, COUNT(*) AS TotalRegistros FROM CLIENTE
    UNION ALL
    SELECT 'MESA' AS Tabla, COUNT(*) AS TotalRegistros FROM MESA
    UNION ALL
    SELECT 'RESERVA' AS Tabla, COUNT(*) AS TotalRegistros FROM RESERVA
    UNION ALL
    SELECT 'EMPLEADO' AS Tabla, COUNT(*) AS TotalRegistros FROM EMPLEADO
    UNION ALL
    SELECT 'PEDIDO' AS Tabla, COUNT(*) AS TotalRegistros FROM PEDIDO
    UNION ALL
    SELECT 'FACTURA' AS Tabla, COUNT(*) AS TotalRegistros FROM FACTURA
    UNION ALL
    SELECT 'INVENTARIO' AS Tabla, COUNT(*) AS TotalRegistros FROM INVENTARIO
    UNION ALL
    SELECT 'PRODUCTO' AS Tabla, COUNT(*) AS TotalRegistros FROM PRODUCTO
    UNION ALL
    SELECT 'DETALLEPEDIDO' AS Tabla, COUNT(*) AS TotalRegistros FROM DETALLEPEDIDO
    UNION ALL
    SELECT 'PROVEEDOR' AS Tabla, COUNT(*) AS TotalRegistros FROM PROVEEDOR
    UNION ALL
    SELECT 'PROVEEDOR_INVENTARIO' AS Tabla, COUNT(*) AS TotalRegistros FROM PROVEEDOR_INVENTARIO


);

GO

SELECT * FROM dbo.FN_SUMA_REGISTROS_TABLAS() ORDER BY TotalRegistros DESC;


  

--10.Crear una función escalar que muestre el resultado de la multiplicación de dos
--números. Los números deben ser pasados como parámetros a la función.


----FUNCION ESCALAR: multiplicación de dos números, 
--en este caso el precio de un platillo por 61 para obtener el valor en dolares
GO
CREATE FUNCTION dbo.FN_MULTIPLICAR_NUMEROS
(
    @PRECIO FLOAT,
    @DOLAR FLOAT
)
RETURNS FLOAT
AS
BEGIN
    RETURN @PRECIO * @DOLAR;
END
GO

SELECT dbo.FN_MULTIPLICAR_NUMEROS(500, 0.016) AS Precio_en_Dolares;


















--INSERTANDO REGISTROS EN LAS TABLAS

GO
INSERT INTO CLIENTE (CLIENTEID, NOMBRE, TELEFONO, DIRECCION) VALUES
(201, 'Hugo Sánchez', '809-565-1234', 'Buenos Aires de Herrera, 12, Santo Domingo Oeste'),
(202, 'Miguel Núñez', '809-556-1235', 'Los Mina, 13, Santo Domingo Este'),
(203, 'Daninsa Torres', '809-557-1236', 'Villa Faro, 14, Santo Domingo Este'),
(204, 'Amanda Ruiz', '809-558-1237', 'Alma Rosa, 15, Santo Domingo Este'),
(205, 'Carlos Collado', '809-559-1238', 'Las Palmas de Herrera, 16, Santo Domingo Oeste'),
(206, 'José Herrera', '849-678-0901', 'Simón Bólivar, 11, Distrito Nacional'),
(207, 'Luis Martínez', '829-789-7012', 'Cristo Rey, 22, Distrito Nacional'),
(208, 'María Medina', '849-890-4123', 'Manoguayabo, 3, Santo Domingo Oeste'),
(209, 'Juan Guerra', '849-933-8234', 'El Libertador de Herrera, 44, Santo Domingo Oeste'),
(210,'Cristina Hernández', '829-882-6345', 'Bayona, 56, Santo Domingo Oeste');

SELECT * FROM CLIENTE;
 
INSERT INTO MESA (MESAID, NUMEROMESA, CAPACIDAD, UBICACION, ESTADO) VALUES
 (01, 1, 4, 'Cerca de la ventana', 'Disponible'),
 (02, 2, 2, 'En el centro del restaurante', 'Ocupada'),
 (03, 3, 6, 'Junto a la barra', 'Disponible'),
 (04, 4, 4, 'En la esquina', 'Ocupada'),
 (05, 5, 8, 'Cerca de la entrada', 'Disponible'),
 (06, 6, 2, 'En el pasillo', 'Ocupada'),
 (07, 8, 4, 'Junto a la cocina', 'Disponible'),
 (08, 8, 6, 'En el patio', 'Ocupada'),
 (09, 9, 4, 'Cerca del escenario', 'Disponible'),
 (010,10, 8,'En el salón principal', 'Ocupada');

 SELECT * FROM MESA;

 
 INSERT INTO EMPLEADO (EMPLEADOID, NOMBRE, PUESTO, TELEFONO, HORARIO) VALUES
 (101, 'Ana Gómez', 'Cocinera', '809-555-5678', '08:00:00'),
 (102, 'Luis Martínez', 'Mesero', '809-555-5679', '12:00:00'),
 (103, 'María Rodríguez', 'Cocinera', '809-555-5680', '08:00:00'),
 (104, 'Carlos Pérez', 'Mesero', '809-555-5681', '12:00:00'),
 (105, 'Sofía López', 'Cocinera', '809-555-5682', '08:00:00'),
 (106, 'Javier Sánchez', 'Mesero', '809-555-5683', '12:00:00'),
 (107, 'Laura Torres', 'Cocinera', '809-555-5684', '08:00:00'),
 (108, 'Miguel Herrera', 'Mesero', '809-555-5685', '12:00:00'),
 (109, 'Elena Castillo', 'Cocinera', '809-555-5686', '08:00:00'),
 (110,'Pedro Vega',  'Mesero','809-555-5687','12:00:00');

 SELECT * FROM EMPLEADO;

  INSERT INTO PROVEEDOR (PROVEEDORID, NOMBRE, DIRECCION, TELEFONO) VALUES
 (801, 'Proveedor A', 'Cristo Rey, 23, Distrito Nacional', '809-555-6789'),
 (802, 'Proveedor B', 'Manoguayabo, 56, Santo Domingo Oeste', '809-555-6790'),
 (803, 'Proveedor C', 'Simón Bolívar, 89, Distrito Nacional', '809-555-6791');

 SELECT * FROM PROVEEDOR;

 INSERT INTO INVENTARIO (INVENTARIOID, NOMBRE, CANTIDAD, CATEGORIA, DESCRIPCION) VALUES
 (601, 'Tomate', 100, 'Verdura', 'Tomates frescos para ensaladas y salsas'),
 (602, 'Arroz', 50, 'Grano', 'Arroz para el arancini'),
 (603, 'Carne de res', 30, 'Carne', 'Carne de res de alta calidad para platos principales'),
 (604, 'Maíz', 40, 'Grano', 'Maíz para el puré de polenta'),
 (605, 'Pasta', 80, 'Grano', 'Pasta seca para platos italianos'),
 (606, 'Queso', 20, 'Lácteo', 'Queso rallado para pizzas y pastas'),
 (607, 'Aceite de oliva', 60, 'Aceite', 'Aceite de oliva virgen extra para cocinar y aderezar'),
 (608, 'Sal', 100, 'Condimento', 'Sal fina para sazonar los platos'),
 (609,'Azúcar', 70,'Condimento','Azúcar blanca para postres y bebidas');

 SELECT * FROM INVENTARIO;

 INSERT INTO PRODUCTO (PRODUCTOID, NOMBRE, DESCRIPCION, PRECIO, CANTIDAD, CATEGORIA, INVENTARIOID) VALUES
 (701, 'Pasta Alfredo', 'Espaguetis con una salsa a base de mantequilla, crema y queso parmesano.', 450, 2, 'Pasta', 605),
 (702, 'Carbonara', 'Pasta con salsa de huevo, queso pecorino, panceta y pimienta negra.', 500, 3, 'Pasta', 605),
 (703, 'Lasagna de carne', 'Capas de pasta con carne molida y salsa de tomate', 550, 2, 'Pasta', 603),
 (704, 'Bruschetta clásica', 'Pan tostado con tomate fresco, ajo, albahaca y aceite de oliva.', 320, 4, 'Ensalada', 601),
 (705, 'Tabla de quesos y embutidos', 'Selección de quesos curados y embutidos finos', 600, 5, 'Tapas', 606),
 (706, 'Polenta cremosa', 'Puré de maíz cocido lentamente, suave y cremoso', 450, 3, 'Puré', 604),
 (707, 'Ensalada mediterranea', 'Mezcla de tomate, pepino, cebolla roja, aceitunas y queso feta, aliñada con aceite de oliva.', 350, 2, 'Ensalada', 601),
 (708, 'Arancini', 'Bolas de arroz fritas rellenas de ragú, mozzarella y a veces guisantes, crocantes por fuera', 250, 6, 'Tapas', 602),
 (709, 'Pasta Alfredo', 'Espaguetis con una salsa a base de mantequilla, crema y queso parmesano.', 450, 2, 'Pasta', 605),
 (710, 'Pizza grande', ' Masa redonda con salsa de tomate, queso mozzarella y toppings a elección, horneada hasta dorar.', 650, 2, 'Pasta', 605);
 
 SELECT * FROM PRODUCTO;

 INSERT INTO RESERVA (RESERVAID, FECHA, HORARIO, MESAID, CLIENTEID) VALUES

 (301, '2026-01-13', '11:45:00', 1, 201),
 (302, '2026-01-13', '11:45:00', 2, 202),
 (303, '2026-01-13', '12:20:00', 3, 203),
 (304, '2026-01-13', '12:30:32', 4, 204),
 (305, '2026-01-13', '12:40:10', 5, 205),
 (306, '2026-01-13', '12:55:00', 6, 206),
 (307, '2026-01-13', '01:10:00', 7, 207),
 (308, '2026-01-13', '01:25:20', 8, 208),
 (309, '2026-01-14', '01:40:05', 9, 209),
 (310,'2026-01-14', '02:00:00', 10,210);
 

 SELECT * FROM RESERVA;

 INSERT INTO PEDIDO (PEDIDOID, FECHA, HORA, ESTADO, EMPLEADOID, MESAID, CLIENTEID) VALUES
 (01, '2026-01-13', '11:45:00', 'En preparación', 101, 1, 201),
 (02, '2026-01-13', '11:45:00', 'Servido', 102, 2, 202),
 (03, '2026-01-13', '12:20:00', 'En preparación', 103, 3, 203),
 (04, '2026-01-13', '12:30:32', 'Servido', 104, 4, 204),
 (05, '2026-01-13', '12:40:10', 'En preparación', 105, 5, 205),
 (06, '2026-01-13', '12:55:00', 'Servido', 106, 6, 206),
 (07, '2026-01-13', '01:10:00', 'En preparación', 107, 7, 207),
 (08, '2026-01-13', '01:10:00', 'Servido', 108, 8, 208),
 (09, '2026-01-14', '01:25:20', 'En preparación', 109, 9, 209),
 (010,'2026-01-14', '02:00:00', 'Servido',110 ,10 ,210);

 SELECT * FROM PEDIDO;


 INSERT INTO DETALLEPEDIDO (PEDIDOID, PRODUCTOID, CANTIDAD, PRECIOUNITARIO, SUBTOTAL) VALUES
 (01, 701, 2, 450, 450),
 (02, 702, 3, 500, 500),
 (03, 703, 2, 550, 550),
 (04, 704, 4, 350, 350),
 (05, 705, 5, 600, 600),
 (06, 706, 3, 450, 450),
 (07, 707, 2, 350, 350),
 (08, 708, 6, 250, 250),
 (09, 709, 2, 450, 450),
 (010, 710, 2, 650, 650);
 
 SELECT * FROM DETALLEPEDIDO;

 INSERT INTO FACTURA (FACTURAID, FECHA, MONTO, METODOPAGO, PEDIDOID, EMPLEADOID) VALUES
(501, '2026-01-13', 450, 'Efectivo', 01, 101),
(502, '2026-01-13', 500, 'Efectivo', 02, 102),
(503, '2026-01-13', 550, 'Tarjeta de débito', 03, 103),
(504, '2026-01-13', 350, 'Transferencia', 04, 104),
(505, '2026-01-13', 600, 'Transferencia', 05, 105),
(506, '2026-01-13', 450, 'Transferencia', 06, 106),
(507, '2026-01-13', 350, 'Efectivo', 07, 107),
(508, '2026-01-13', 250, 'Tarjeta de débito', 08, 108),
(509, '2026-01-14', 450, 'Efectivo', 09, 109),
(510,'2026-01-14', 650, 'Tarjeta de débito', 010,110);
 SELECT * FROM FACTURA;



 INSERT INTO PROVEEDOR_INVENTARIO (INVENTARIOID, PROVEEDORID, FECHASUMINISTRO, COSTO) VALUES
(601, 801, '2026-01-10', 100),
(602, 801, '2026-01-11', 50),
(603, 802, '2026-01-12', 30),
(604, 802, '2026-01-13', 40),
(605, 803, '2026-01-14', 80),
(606, 803, '2026-01-15', 20),
(607, 801, '2026-01-16', 60),
(608, 801, '2026-01-17', 100),
(609, 802, '2026-01-18', 70);


SELECT * FROM PROVEEDOR_INVENTARIO;
GO




  









  --SELECTS
GO
  SELECT * FROM CLIENTE;
  SELECT * FROM MESA;
  SELECT * FROM RESERVA;
  SELECT * FROM PRODUCTO;
  SELECT * FROM PEDIDO;
  SELECT * FROM EMPLEADO;
  SELECT * FROM FACTURA;
  SELECT * FROM PROVEEDOR;
  SELECT * FROM INVENTARIO;
  SELECT * FROM PROVEEDOR_INVENTARIO;
  SELECT * FROM DETALLEPEDIDO;
  SELECT * FROM VISTA_PEDIDO_CLIENTE_MESA;
  SELECT * FROM VISTA_PEDIDO_CLIENTE_MESA_LEFT;
  SELECT * FROM VISTA_PRODUCTO_CATEGORÍA;
  EXEC INSERTARNUEVOCLIENTE @CLIENTEID = 211, @NOMBRE = 'Carla Collado', 
@TELEFONO = '809-549-9488', @DIRECCION = 'Barrio Duarte #69 Las Palmas de Herrera';
 SELECT COUNT(*) AS TotalRegistros FROM CLIENTE;
  SELECT * FROM HISTORICO_CAMBIOS;
  SELECT * FROM dbo.FN_SUMA_REGISTROS_TABLAS() ORDER BY TotalRegistros DESC;
  SELECT dbo.FN_MULTIPLICAR_NUMEROS(500, 0.016) AS Precio_en_Dolares;
  GO


   






--1-tablas: CLIENTE, MESA, RESERVA, EMPLEADO, PEDIDO, FACTURA, INVENTARIO, PRODUCTO, DETALLEPEDIDO, PROVEEDOR, PROVEEDOR_INVENTARIO
--2-relaciones entre tablas: RESERVA-MESA, RESERVA-CLIENTE, PEDIDO-EMPLEADO, PEDIDO-MESA, PEDIDO-CLIENTE, FACTURA-PEDIDO, FACTURA-EMPLEADO, PRODUCTO-INVENTARIO, DETALLEPEDIDO-PRODUCTO, PROVEEDOR_INVENTARIO-INVENTARIO, PROVEEDOR_INVENTARIO-PROVEEDOR
--3-vista con INNER JOIN: VISTA_PEDIDO_CLIENTE_MESA
--4-vista con LEFT JOIN: VISTA_PEDIDO_CLIENTE_MESA
--5-vista con función de agrupación: VISTA_PRODUCTO
--6-procedimiento almacenado para insertar un registro y mostrarlo: insertar otro nombre en la tabla cliente
--7-procedimiento almacenado para actualizar un registro y mostrar la cantidad total de registros: ACTUALIZARCLIENTE
--8-trigger para insertar un registro en una tabla histórica de cambios: TRG_ACTUALIZARCLIENTE
--9-función de tipo tabla para mostrar el total de registros en cada tabla: FN_SUMA_REGISTROS_TABLAS
--10-función escalar para multiplicar dos números: FN_MULTIPLICAR_NUMEROS





