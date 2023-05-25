-- Purchase Facts

IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'PurchaseFact'
)

BEGIN
	SELECT
		SupplierCode,
		BranchCode,
		StaffCode,
		PlantCode,
		TimeCode,
		[total purchased plant]		= SUM(Quantity),
		[total purchase cost]		= SUM(Quantity * PlantBuyingPrice)
	FROM
		OLTP..TrPurchaseHeader ph 
		JOIN OLTP..TrPurchaseDetail pd ON pd.PurchaseID = ph.PurchaseID
		JOIN SupplierDimension sdim ON sdim.SupplierID = ph.SupplierID
		JOIN BranchDimension bdim ON bdim.BranchID = ph.BranchID
		JOIN StaffDimension stdim ON stdim.StaffID = ph.StaffID
		JOIN PlantDimension pdim ON pdim.PlantID = pd.PlantID
		JOIN TimeDimension tdim ON tdim.Date = ph.PurchaseDate
		WHERE ph.PurchaseDate > (
			SELECT LastETL
			FROM FilterTimeStamp
			WHERE TableName = 'PurchaseFact'
		)
	GROUP BY SupplierCode, BranchCode, StaffCode, PlantCode, TimeCode
END
ELSE
BEGIN
	SELECT
		SupplierCode,
		BranchCode,
		StaffCode,
		PlantCode,
		TimeCode,
		[total purchased plant]		= SUM(Quantity),
		[total purchase cost]		= SUM(Quantity * PlantBuyingPrice)
	FROM
		OLTP..TrPurchaseHeader ph 
		JOIN OLTP..TrPurchaseDetail pd ON pd.PurchaseID = ph.PurchaseID
		JOIN SupplierDimension sdim ON sdim.SupplierID = ph.SupplierID
		JOIN BranchDimension bdim ON bdim.BranchID = ph.BranchID
		JOIN StaffDimension stdim ON stdim.StaffID = ph.StaffID
		JOIN PlantDimension pdim ON pdim.PlantID = pd.PlantID
		JOIN TimeDimension tdim ON tdim.Date = ph.PurchaseDate
	GROUP BY SupplierCode, BranchCode, StaffCode, PlantCode, TimeCode
END

-- Query LastETL

IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'PurchaseFact'
)
BEGIN
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'PurchaseFact'
END
ELSE
BEGIN
	INSERT INTO FilterTimeStamp VALUES
	('PurchaseFact', GETDATE())
END

SELECT * FROM FilterTimeStamp
SELECT * FROM PurchaseFact