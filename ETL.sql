--Plant Dimension
SELECT PlantID,
	   PlantName,
	   PlantBuyingPrice,
	   PlantSellingPrice
FROM OLTP..MsPlant

SELECT * FROM PaiPlanteriaOLAP..PlantDimension

--Customer Dimension
SELECT CustomerID,
	   CustomerName,
	   CustomerGender,
	   CustomerAddress
FROM OLTP..MsCustomer

SELECT * FROM PaiPlanteriaOLAP..CustomerDimension


--Staff Dimension
SELECT StaffID,
	   StaffName,
	   StaffGender,	
	   StaffSalary,
	   StaffPhone
FROM OLTP..MsStaff

SELECT * FROM PaiPlanteriaOLAP..StaffDimension


--Branch Dimension
SELECT BranchID,
	   BranchAddress,
   	   CityName,
	   BranchFAX	
FROM OLTP..MsBranch mb, OLTP..MsCity mc
WHERE mb.CityID = mc.CityID

SELECT * FROM PaiPlanteriaOLAP..BranchDimension


--Pot Dimension
SELECT PotID,
	   PotName,
	   PotPrice	
FROM OLTP..MsPot

SELECT * FROM PaiPlanteriaOLAP..PotDimension


--Supplier Dimension
SELECT SupplierID,
	   SupplierAddress,
	   CityName
FROM OLTP..MsSupplier ms, OLTP..MsCity mc
WHERE ms.CityID = mc.CityID

SELECT * FROM PaiPlanteriaOLAP..SupplierDimension


--Time Dimension
IF EXISTS(
	SELECT *
	FROM PaiPlanteriaOLAP..FilterTimeStamp
	WHERE TableName = 'TimeDimension'
)
BEGIN
	SELECT [Date] = x.Date,
		   [Day] = DAY(x.Date),
		   [Month] = MONTH(x.Date),
		   [Quarter] = DATEPART(QUARTER, x.Date),
		   [Annual] = YEAR(x.Date)
	FROM(
		SELECT TransactionDate AS [Date]
		FROM OLTP..TrPotHeader
		UNION
		SELECT PurchaseDate AS [Date]
		FROM OLTP..TrPurchaseHeader
		UNION
		SELECT ReturnDate AS [Date]
		FROM OLTP..TrReturnHeader
		UNION
		SELECT SalesDate AS [Date]
		FROM OLTP..TrSalesHeader
	) AS x
	WHERE [Date] > (
		SELECT LastETL
		FROM PaiPlanteriaOLAP..FilterTimeStamp
		WHERE TableName = 'TimeDimension'
	)
END
ELSE
BEGIN
	SELECT [Date] = x.Date,
		   [Day] = DAY(x.Date),
		   [Month] = MONTH(x.Date),
		   [Quarter] = DATEPART(QUARTER, x.Date),
		   [Annual] = YEAR(x.Date)
	FROM(
		SELECT TransactionDate AS [Date]
		FROM OLTP..TrPotHeader
		UNION
		SELECT PurchaseDate AS [Date]
		FROM OLTP..TrPurchaseHeader
		UNION
		SELECT ReturnDate AS [Date]
		FROM OLTP..TrReturnHeader
		UNION
		SELECT SalesDate AS [Date]
		FROM OLTP..TrSalesHeader
	) AS x
END

-- Update LastETL
IF EXISTS(
	SELECT *
	FROM PaiPlanteriaOLAP..FilterTimeStamp
	WHERE TableName = 'TimeDimension'
)
BEGIN
	UPDATE PaiPlanteriaOLAP..FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'TimeDimension'
END
ELSE
BEGIN
	INSERT INTO PaiPlanteriaOLAP..FilterTimeStamp VALUES
	('TimeDimension', GETDATE())
END

SELECT * FROM PaiPlanteriaOLAP..TimeDimension
SELECT * FROM PaiPlanteriaOLAP..FilterTimeStamp
