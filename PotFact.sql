-- Pot Facts

IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'PotFact'
)
BEGIN
	SELECT
		CustomerCode,
		StaffCode,	
		PotCode,
		TimeCode,
		[total pot transaction] 	= COUNT(pd.PotTransactionID),
		[total earning]				= SUM(Quantity * mpot.PotPrice)
	FROM
		OLTP..TrPotHeader ph 
		JOIN OLTP..TrPotDetail pd ON pd.PotTransactionID = ph.PotTransactionID
		JOIN OLTP..MsPot mpot ON mpot.PotID = pd.PotID
		JOIN CustomerDimension cdim ON cdim.CustomerID = ph.CustomerID
		JOIN StaffDimension sdim ON sdim.StaffID = ph.StaffID
		JOIN PotDimension pdim ON pdim.PotID = mpot.PotID
		JOIN TimeDimension tdim ON tdim.Date = ph.TransactionDate
		WHERE ph.TransactionDate > (
			SELECT LastETL
			FROM FilterTimeStamp
			WHERE TableName = 'PotFact'
		)
	GROUP BY CustomerCode, StaffCode, PotCode, TimeCode
END
ELSE
BEGIN
	SELECT
		CustomerCode,
		StaffCode,	
		PotCode,
		TimeCode,
		[total pot transaction] 	= COUNT(pd.PotTransactionID),
		[total earning]				= SUM(Quantity * mpot.PotPrice)
	FROM
		OLTP..TrPotHeader ph 
		JOIN OLTP..TrPotDetail pd ON pd.PotTransactionID = ph.PotTransactionID
		JOIN OLTP..MsPot mpot ON mpot.PotID = pd.PotID
		JOIN CustomerDimension cdim ON cdim.CustomerID = ph.CustomerID
		JOIN StaffDimension sdim ON sdim.StaffID = ph.StaffID
		JOIN PotDimension pdim ON pdim.PotID = mpot.PotID
		JOIN TimeDimension tdim ON tdim.Date = ph.TransactionDate
		GROUP BY CustomerCode, StaffCode, PotCode, TimeCode
END

-- Query LastETL

IF EXISTS (
	SELECT *
	FROM FilterTimeStamp
	WHERE TableName = 'PotFact'
)
BEGIN
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName = 'PotFact'
END
ELSE
BEGIN
	INSERT INTO FilterTimeStamp VALUES
	('PotFact', GETDATE())
END

SELECT * FROM FilterTimeStamp
SELECT * FROM PotFact
