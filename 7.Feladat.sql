USE SQL_Projekt_Feladat
GO
ALTER DATABASE [SQL_Projekt_Feladat] ADD FILE ( NAME = N'SQL_Projekt_Feladat2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SQL_Projekt_Feladat2.ndf' , SIZE = 307200KB , FILEGROWTH = 65536KB ) TO FILEGROUP [PRIMARY]
GO
ALTER DATABASE [SQL_Projekt_Feladat] ADD FILE ( NAME = N'SQL_Projekt_Feladat3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SQL_Projekt_Feladat3.ndf' , SIZE = 307200KB , FILEGROWTH = 65536KB ) TO FILEGROUP [PRIMARY]
GO
ALTER DATABASE [SQL_Projekt_Feladat] ADD FILE ( NAME = N'SQL_Projekt_Feladat4', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SQL_Projekt_Feladat4.ndf' , SIZE = 307200KB , FILEGROWTH = 65536KB ) TO FILEGROUP [PRIMARY]
GO
ALTER DATABASE [SQL_Projekt_Feladat] ADD FILE ( NAME = N'SQL_Projekt_Feladat5', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SQL_Projekt_Feladat5.ndf' , SIZE = 307200KB , FILEGROWTH = 65536KB ) TO FILEGROUP [PRIMARY]
GO
go
DBCC SHRINKFILE ('SQL_Projekt_Feladat5', EMPTYFILE);
GO
ALTER DATABASE SQL_Projekt_Feladat REMOVE FILE SQL_Projekt_Feladat5