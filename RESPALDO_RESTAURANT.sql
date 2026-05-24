----Practica #6 - Respaldo y Recuperación de Bases de Datos

----Para completar esta practica debe de realizar los siguientes puntos con la base de datos de su proyecto:
 
---1-Crear un backup full de su base de datos


BACKUP DATABASE [RESTAURANT] TO DISK = N'C:\BD\BACKUPS\RESTAURANT_FULL_1.BAK'
WITH NOFORMAT, NOINIT, NAME = N'RESTAURANT-FULL DATABASE BACKUP_1', SKIP, NOREWIND, 
NOUNLOAD, COMPRESSION, STATS = 10, CHECKSUM, CONTINUE_AFTER_ERROR
GO

declare @backupSetId as int
select @backupSetId = position from msdb..backupset where
name=N'RESTAURANT-FULL DATABASE BACKUP_1' and backup_set_id=(select max(backup_set_id) from
msdb..backupset where name=N'RESTAURANT-FULL DATABASE BACKUP_1' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for
database ''RESTAURANT-FULL DATABASE BACKUP_1'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM DISK = N'C:\BD\BACKUPS\RESTAURANT_FULL_1.BAK' WITH FILE =
@backupSetId, NOUNLOAD, NOREWIND
GO

---2-Crear un backup diferencial de su base de datos

BACKUP DATABASE [RESTAURANT] TO DISK = N'C:\BD\BACKUPS\RESTAURANT_DIFFERENTIAL_1.BAK' WITH DIFFERENTIAL,
NOFORMAT, NOINIT, NAME = N'RESTAURANT-DIFFERENTIAL DATABASE BACKUP_1', SKIP, NOREWIND, 
NOUNLOAD, COMPRESSION, STATS = 10, CHECKSUM, CONTINUE_AFTER_ERROR
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where
name=N'RESTAURANT-DIFFERENTIAL DATABASE BACKUP_1' and backup_set_id=(select max(backup_set_id) from
msdb..backupset where name=N'RESTAURANT-DIFFERENTIAL DATABASE BACKUP_1' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for
database ''RESTAURANT-DIFFERENTIAL DATABASE BACKUP_1'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM DISK = N'C:\BD\BACKUPS\RESTAURANT_DIFFERENTIAL_1.BAK' WITH FILE =
@backupSetId, NOUNLOAD, NOREWIND
GO

---3-Crear un backup de log de su base de datos

BACKUP LOG [RESTAURANT] TO DISK = N'C:\BD\BACKUPS\RESTAURANT_LOG_1.BAK' WITH NOFORMAT,
NOINIT, NAME = N'RESTAURANT-LOG DATABASE BACKUP_1', SKIP, NOREWIND, 
NOUNLOAD, COMPRESSION, STATS = 10, CHECKSUM, CONTINUE_AFTER_ERROR
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where
name=N'RESTAURANT-LOG DATABASE BACKUP_1' and backup_set_id=(select max(backup_set_id) from
msdb..backupset where name=N'RESTAURANT-LOG DATABASE BACKUP_1' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for
database ''RESTAURANT-LOG DATABASE BACKUP_1'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM DISK = N'C:\BD\BACKUPS\RESTAURANT_LOG_1.BAK' WITH FILE =
@backupSetId, NOUNLOAD, NOREWIND
GO

--RESTORES

--FULL RESTORE
ALTER DATABASE [RESTAURANT] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
USE [MASTER]
RESTORE DATABASE [RESTAURANT] 
FROM DISK = N'C:\BD\BACKUPS\RESTAURANT_FULL_1.BAK' WITH FILE = 1, 
NORECOVERY, NOUNLOAD, REPLACE, STATS = 5

--DIFFERENTIAL RESTORE
USE [MASTER]
RESTORE DATABASE [RESTAURANT] 
FROM DISK = N'C:\BD\BACKUPS\RESTAURANT_DIFFERENTIAL_1.BAK' WITH FILE = 1, 
NORECOVERY, NOUNLOAD, REPLACE, STATS = 5

--LOG RESTORE
RESTORE LOG [RESTAURANT] 
FROM DISK = N'C:\BD\BACKUPS\RESTAURANT_LOG_1.BAK' WITH FILE = 1, 
RECOVERY, NOUNLOAD, REPLACE, STATS = 5

