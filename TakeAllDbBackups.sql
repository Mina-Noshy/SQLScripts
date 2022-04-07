

/*
	You can write the next code in "takeBackup.bat" file to execute this procedure

	sqlcmd -S "EPMS-ERP\SQLEXPRESS" -U "sa" -P "000000" -d "ePMSBackup" -Q "EXEC TakeEpmsBackups"
*/





/*
	this procedure to create backup from all databases;
*/


USE MASTER
GO

CREATE DATABASE ePMSBackup
GO

USE ePMSBackup
GO


CREATE PROCEDURE [dbo].[TakeEpmsBackups]

AS   

DECLARE @PATH NVARCHAR(300) = 'F:\Eng Mina Noshy\Daily_Backups\' + CAST(CONVERT(DATE, GETDATE()) AS NVARCHAR(300)) + '\'
EXEC master.dbo.xp_create_subdir @PATH


DECLARE @Tbl_Names AS TABLE (name NVARCHAR(100));

INSERT INTO @Tbl_Names
SELECT name FROM master.sys.databases ;

DECLARE @db_name NVARCHAR(100);

DECLARE @NEW_PATH NVARCHAR(300);


WHILE EXISTS (SELECT 1 FROM @Tbl_Names)
BEGIN
     SELECT TOP 1 @db_name =  name FROM @Tbl_Names;

	 SET @NEW_PATH = @PATH + @db_name + '.bak';

	 BACKUP DATABASE ePMS3001 TO DISK = @NEW_PATH;

     DELETE FROM @Tbl_Names WHERE name = @db_name;
END

SELECT (name + ' ==> Created Backup Successfully') FROM master.sys.databases ;

GO