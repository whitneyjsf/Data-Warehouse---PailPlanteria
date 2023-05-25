CREATE DATABASE PaiPlanteriaOLAP

GO
USE PaiPlanteriaOLAP
GO

CREATE TABLE PlantDimension(
	PlantCode INT PRIMARY KEY IDENTITY,
	PlantID CHAR(7),
	PlantName VARCHAR(50),
	PlantBuyingPrice INT,
	PlantSellingPrice INT,
	ValidFrom DATETIME,
	ValidTo DATETIME
)

CREATE TABLE CustomerDimension(
	CustomerCode INT PRIMARY KEY IDENTITY,
	CustomerID CHAR(7),
	CustomerName VARCHAR(50),
	CustomerGender VARCHAR(50),
	CustomerAddress VARCHAR(50)
)

CREATE TABLE StaffDimension(
	StaffCode INT PRIMARY KEY IDENTITY,
	StaffID CHAR(7), 
	StaffName VARCHAR(50),	
	StaffSalary INT,
	StaffPhone  VARCHAR(20),
	ValidFrom DATETIME,
	ValidTo DATETIME
)

CREATE TABLE BranchDimension(
	BranchCode INT PRIMARY KEY IDENTITY,
	BranchID CHAR(7),
	BranchAddress VARCHAR(50),
	BranchCity VARCHAR(50),
	BranchFAX VARCHAR(20)
)

CREATE TABLE PotDimension(
	PotCode INT PRIMARY KEY IDENTITY,
	PotID CHAR(7),
	PotName VARCHAR(50),
	PotPrice INT,
	ValidFrom DATETIME,
	ValidTo DATETIME
)

CREATE TABLE SupplierDimension(
	SupplierCode INT PRIMARY KEY IDENTITY,
	SupplierID CHAR(7),
	SupplierAddress VARCHAR(50),
	SupplierCity VARCHAR(50)
)

CREATE TABLE TimeDimension(
	TimeCode INT PRIMARY KEY IDENTITY,
	[Date] DATE,
	[Day] INT,
	[Month] INT,
	[Quarter] INT,
	[Annual] INT
)

CREATE TABLE SalesFact(
	StaffCode INT,
	BranchCode INT,
	CustomerCode INT,
	PlantCode INT,
	TimeCode INT,
	[total sales earning] BIGINT,
	[total sales transaction] BIGINT
)

DROP TABLE SalesFact

CREATE TABLE ReturnFact(
	StaffCode INT,		
	PlantCode INT,
	TimeCode INT,
	[total plants returned] BIGINT,
	[total purchase returned] BIGINT
)

CREATE TABLE PurchaseFact(
	SupplierCode INT,
	BranchCode INT,
	StaffCode INT,
	TimeCode INT,
	[total purchased plant] BIGINT,
	[total purchase cost] BIGINT
)

CREATE TABLE PotFact(
	StaffCode INT,	
	PotCode INT,
	TimeCode INT,
	[total pot transaction] BIGINT,
	[total earning] BIGINT
)

CREATE TABLE FilterTimeStamp(
	TableName VARCHAR(50),
	LastETL DATETIME
)

SELECT * FROM TimeDimension

