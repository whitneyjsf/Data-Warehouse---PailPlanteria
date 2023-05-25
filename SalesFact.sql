-- Sales Facts

IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'SalesFact'
)

BEGIN
	SELECT
		StaffCode,
		BranchCode,
		CustomerCode,
		TimeCode,
		PlantCode,
		[total sales earning]		= SUM(Quantity * PlantSellingPrice),
		[total sales transaction]	= COUNT(sh.SalesID)
	FROM
		OLTP..TrSalesHeader sh
		JOIN OLTP..TrSalesDetail sd ON sd.SalesID = sh.SalesID
		JOIN StaffDimension sdim ON sdim.StaffID = sh.StaffID
		JOIN BranchDimension bdim ON bdim.BranchID = sh.BranchID
		JOIN CustomerDimension cdim ON cdim.CustomerID = sh.CustomerID
		JOIN TimeDimension tdim ON tdim.Date = sh.SalesDate
		JOIN PlantDimension pdim ON pdim.PlantID = sd.PlantID
	WHERE sh.SalesDate > (
		SELECT LastETL
		FROM FilterTimeStamp
		WHERE TableName = 'SalesFact'
	)
	GROUP BY StaffCode, BranchCode, CustomerCode, TimeCode, PlantCode
END
ELSE
BEGIN
	SELECT
		StaffCode,
		BranchCode,
		CustomerCode,
		TimeCode,
		PlantCode,
		[total sales earning]		= SUM(Quantity * PlantSellingPrice),
		[total sales transaction]	= COUNT(sh.SalesID)
	FROM
		OLTP..TrSalesHeader sh
		JOIN OLTP..TrSalesDetail sd ON sd.SalesID = sh.SalesID
		JOIN StaffDimension sdim ON sdim.StaffID = sh.StaffID
		JOIN BranchDimension bdim ON bdim.BranchID = sh.BranchID
		JOIN CustomerDimension cdim ON cdim.CustomerID = sh.CustomerID
		JOIN TimeDimension tdim ON tdim.Date = sh.SalesDate
		JOIN PlantDimension pdim ON pdim.PlantID = sd.PlantID
	GROUP BY StaffCode, BranchCode, CustomerCode, TimeCode, PlantCode
END

-- Query LastETL
IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'SalesFact'
)
BEGIN
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'SalesFact'
END
ELSE
BEGIN
	INSERT INTO FilterTimeStamp VALUES
	('SalesFact', GETDATE())
END

SELECT * FROM FilterTimeStamp
SELECT * FROM SalesFact

-- Checkpoint
BEGIN TRAN 
	DELETE FROM FilterTimeStamp WHERE TableName = 'SalesFact'
ROLLBACK
