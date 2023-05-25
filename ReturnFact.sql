-- Return Facts

IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'ReturnFact'
)

BEGIN
	SELECT
		StaffCode,	
		PlantCode,
		TimeCode,
		[total plants returned] 	= SUM(Quantity),
		[total purchase returned]	= COUNT(PurchaseID)
	FROM
		OLTP..TrReturnHeader rh
		JOIN OLTP..TrReturnDetail rd ON rd.ReturnID = rh.ReturnID
		JOIN StaffDimension sdim ON sdim.StaffID = rh.StaffID
		JOIN PlantDimension pdim ON pdim.PlantID = rd.PlantID
		JOIN TimeDimension tdim ON tdim.Date = rh.ReturnDate
		WHERE rh.ReturnDate > (
			SELECT LastETL
			FROM FilterTimeStamp
			WHERE TableName = 'ReturnFact'
		)
	GROUP BY StaffCode, PlantCode, TimeCode
END
ELSE
BEGIN
	SELECT
		StaffCode,	
		PlantCode,
		TimeCode,
		[total plants returned] 	= SUM(Quantity),
		[total purchase returned]	= COUNT(PurchaseID)
	FROM
		OLTP..TrReturnHeader rh
		JOIN OLTP..TrReturnDetail rd ON rd.ReturnID = rh.ReturnID
		JOIN StaffDimension sdim ON sdim.StaffID = rh.StaffID
		JOIN PlantDimension pdim ON pdim.PlantID = rd.PlantID
		JOIN TimeDimension tdim ON tdim.Date = rh.ReturnDate
	GROUP BY StaffCode, PlantCode, TimeCode
END

-- Query LastETL
IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'ReturnFact'
)
BEGIN
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'ReturnFact'
END
ELSE
BEGIN
	INSERT INTO FilterTimeStamp VALUES
	('ReturnFact', GETDATE())
END

SELECT * FROM FilterTimeStamp
SELECT * FROM ReturnFact