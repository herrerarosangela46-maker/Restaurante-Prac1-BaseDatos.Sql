
USE  RESTAURANT
--Practica #5 - Encriptación de datos

--En base a su proyecto asignado realice los siguientes ejercicios:
 
--1.Agregue una columna nueva a cualquier de sus tablas y asigne un tipo de datos varbinary(256). 
--En dicha columna va a almacenar los datos encriptados de cualquiera de las columnas que 
--previamente haya tenido dicha tabla. El mecanismo de encriptación que debe utilizar 
--es EncryptedbyPassphrase

--AGREGAR COLUMNA NUEVA


ALTER TABLE [dbo].[CLIENTE] ADD [ESTADOS] [VARBINARY] (256);

--encriptamos el estado del cliente utilizando la funcion EncryptByPassphrase y lo colocamos en la nueva columna

UPDATE [dbo].[CLIENTE] SET ESTADOS = ENCRYPTBYPASSPHRASE('clave/de@encriptacion/123','PENDIENTE',1,CONVERT(VARBINARY, CLIENTEID))
WHERE CLIENTEID = 209;


SELECT ESTADOS FROM [dbo].[CLIENTE];

--2.Crear una consulta SQL que decifre los datos encriptados de la columna creada en el ejercicio anterior.

SELECT CONVERT (VARCHAR, DECRYPTBYPASSPHRASE('clave/de@encriptacion/123',ESTADOS,1,Convert(varbinary,CLIENTEID))) as Estado_Desencriptado 
FROM [dbo].[CLIENTE]
where CLIENTEID = 209;

SELECT * FROM [dbo].[CLIENTE] WHERE CLIENTEID = 209;

--3.Cree una clave maestra encriptada por contraseña

CREATE MASTER KEY ENCRYPTION BY PASSWORD = '23987hx';
GO

--4.Cree un certificado encriptado por contrasseña y que tenga como titulo (SUBJECT)  el texto "encriptacion por certificado"

CREATE CERTIFICATE EncriptacionPorCertificacion ENCRYPTION BY password = 'klk800099' WITH SUBJECT = 'Encriptacion por certificado';


--5.Cree un script que realice respaldo de su clave maestra y que lo almacene en una carpeta de su disco C:

ALTER MASTER KEY REGENERATE WITH ENCRYPTION BY PASSWORD = 'YhjUTvj435907NnmM#sX003';

OPEN MASTER KEY DECRYPTION BY PASSWORD = 'YhjUTvj435907NnmM#sX003';

BACKUP MASTER KEY TO FILE = 'C:\test\MasterKey'
ENCRYPTION BY PASSWORD = 'YhjUTvj435907NnmM#sX003';

CLOSE MASTER KEY; 
GO

--6.Cree un script que realice respaldo de su certificado y que lo almacene en una carpeta de su disco C:

BACKUP CERTIFICATE EncriptacionPorCertificacion TO FILE = 'C:\test\CertificacionbyEncriptacion';

GO


--7.Agregue una columna nueva a cualquier de sus tablas y asigne un tipo de datos varbinary(512). 
--En dicha columna va a almacenar los datos encriptados de cualquiera de las columnas que previamente haya tenido dicha tabla. 
--El mecanismo de encriptación que debe utilizar es EncryptByCert


ALTER TABLE [dbo].[PEDIDO] ADD [Estados_Entrega] [VARBINARY] (512);



UPDATE [dbo].[PEDIDO] set [Estados_Entrega] = ENCRYPTBYCERT(CERT_ID('EncriptacionPorCertificacion'),Convert(varbinary,'ENTREGADO'))
where PEDIDOID = 3;

SELECT Estados_Entrega FROM [dbo].[PEDIDO];

--8.Crear una consulta SQL que decifre los datos encriptados de la columna creada en el ejercicio anterior.


SELECT CONVERT(VARCHAR,  DECRYPTBYCERT(CERT_ID('EncriptacionPorCertificacion'), Estados_Entrega, N'klk800099' )) AS Estado_Desencriptado
FROM [dbo].[PEDIDO]
WHERE PEDIDOID = 3;

--9.Cree una clave asimetrica con algoritmo de encriptación RSA_2048

CREATE ASYMMETRIC KEY Pedidos_Restaurant
WITH ALGORITHM = RSA_2048
ENCRYPTION BY PASSWORD = '89ujHnscbhk$w4ecJH5gh';
GO

--10.Agregue una columna nueva a cualquier de sus tablas y asigne un tipo de datos varbinary(2048). 
--En dicha columna va a almacenar los datos encriptados de 
--cualquiera de las columnas que previamente haya tenido dicha tabla. 
--El mecanismo de encriptación que debe utilizar es EncryptByAsymKey


ALTER TABLE [dbo].[PRODUCTO] ADD [Tiempo_Preparacion] [VARBINARY] (2048);

UPDATE [dbo].[PRODUCTO] set [Tiempo_Preparacion] = EncryptByAsymKey(AsymKey_ID('Pedidos_Restaurant'), Convert (varbinary, '15 minutos'))
where [PRODUCTOID] = 703; 



SELECT Tiempo_Preparacion FROM [dbo].[PRODUCTO];

--11.Crear una consulta SQL que decifre los datos encriptados de la columna creada en el ejercicio anterior.

SELECT CONVERT(VARCHAR, DecryptByAsymKey(AsymKey_ID('Pedidos_Restaurant'),[Tiempo_Preparacion],N'89ujHnscbhk$w4ecJH5gh')) AS Tiempo_Desencriptado
FROM [dbo].[PRODUCTO]
WHERE PRODUCTOID = 703;




Select * from Cliente;
Select * from Pedido;
Select * from Producto;





