
USE SQL_Projekt_Feladat
GO

IF OBJECT_ID('dbo.Bookings') IS NOT NULL
	drop table Bookings
IF OBJECT_ID('tempdb..#euCountriesIsos') IS NOT NULL
	drop table #euCountriesIsos
IF OBJECT_ID('tempdb..#selectedCities') IS NOT NULL
	drop table #selectedCities
IF OBJECT_ID('tempdb..#cids') IS NOT NULL
	drop table #cids
IF OBJECT_ID('tempdb..#cidPairs') IS NOT NULL
	drop table #cidPairs
IF OBJECT_ID('tempdb..#bookingsAll') IS NOT NULL
	drop table #bookingsAll
GO


CREATE TABLE Bookings(
[BookingID] int NOT NULL IDENTITY(1,1) PRIMARY KEY,
[CustomerID] int NOT NULL,
[CCountry] varchar(2) NOT NULL,
[DepartureStation] varchar(30) NOT NULL,
[Date] datetime NOT NULL DEFAULT (GETDATE()),
[Price] money NOT NULL,
[Seats] int NOT NULL
)
GO

SELECT c.asciiname, ic.Code
INTO #euCountriesIsos
FROM Iso2Codes ic
INNER JOIN Countries c on ic.Name = c.country

CREATE TABLE #selectedCities (
ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
asciiname VARCHAR(255) NOT NULL UNIQUE,
Code CHAR(2) NOT NULL
)

INSERT INTO #selectedCities
SELECT tmp.asciiname, tmp.Code
FROM (SELECT DISTINCT TOP 15 Code, asciiname FROM #euCountriesIsos eci WHERE (ABS(CAST((CHECKSUM(*) * RAND()) as int)) % 100) < 30) tmp
UNION
(SELECT 'Luton' asciiname, 'GB' Code)
GO


WITH
  l0(i) AS (SELECT 0 UNION ALL SELECT 0),
  l1(i) AS (SELECT 0 FROM l0 a, l0 b),
  l2(i) AS (SELECT 0 FROM l1 a, l1 b),
  l3(i) AS (SELECT 0 FROM l2 a, l2 b),
  l4(i) AS (SELECT 0 FROM l3 a, l3 b),
  numbers(i) AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 0)) FROM l4)
SELECT DISTINCT TOP(2500) (CEILING(RAND(CHECKSUM(NEWID()))*899999)+100000) CustomerID INTO #cids FROM numbers ORDER BY CustomerID


SELECT cp.CustomerID CustomerID, sc.Code CCountry
INTO #cidPairs
FROM (SELECT cids.CustomerID, (CEILING(RAND(CHECKSUM(NEWID()))*(SELECT COUNT(*) FROM #selectedCities))) CountryID FROM #cids cids) cp
INNER JOIN #selectedCities sc on cp.CountryID = sc.ID
ORDER BY CustomerID
GO


WITH
  l0(i) AS (SELECT 0 UNION ALL SELECT 0),
  l1(i) AS (SELECT 0 FROM l0 a, l0 b),
  l2(i) AS (SELECT 0 FROM l1 a, l1 b),
  l3(i) AS (SELECT 0 FROM l2 a, l2 b),
  numbers(i) AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 0)) FROM l3)
SELECT TOP(1000000)
	cp.CustomerID,
	cp.CCountry,
	sc.asciiname DepartureStation,
	(DATEADD(ms,RAND(CHECKSUM(NEWID())) * 86400000,DATEADD(d,RAND(CHECKSUM(NEWID()))*365,'2019-01-01'))) [Date],
	(ROUND(RAND(CHECKSUM(NEWID()))*200+10,2)) Price,
	(CEILING(RAND(CHECKSUM(NEWID()))*50)) Seats
INTO #bookingsAll
from numbers
CROSS APPLY (
   SELECT 
	cp.CustomerID, 
	cp.CCountry,
	(
		SELECT CEILING(RAND(CHECKSUM(NEWID()))*(SELECT COUNT(*) FROM #selectedCities))
	) DepartureStationID
		FROM #cidPairs AS cp
) AS cp
INNER JOIN #selectedCities sc on sc.ID = cp.DepartureStationID

INSERT INTO Bookings
SELECT TOP(10000) *
FROM #bookingsAll
WHERE (ABS(CAST((CHECKSUM(*) * RAND()) as int)) % 100) < 30

GO

CREATE NONCLUSTERED INDEX NC_Bookings_countryCid ON [dbo].[Bookings]
(
	[CCountry] ASC,
	[CustomerID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX NC_Bookings_countryCidDate ON [dbo].[Bookings]
(
	[Date] ASC,
	[CCountry] ASC,
	[CustomerID] ASC
)
INCLUDE([Price]) 
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX NC_Bookings_countryDateStation ON [dbo].[Bookings]
(
	[DepartureStation] ASC,
	[Date] ASC,
	[CCountry] ASC
)
INCLUDE([Price])
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO