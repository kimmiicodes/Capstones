--//(01) Total Number of Customers//--
SELECT COUNT(*) as 'Total No. of Customers' from [dbo].[Customers]
--OR--
SELECT DISTINCT customerID from [dbo].[TransactionLog]

--//(02) Total Number of Merchants//--
SELECT COUNT(*) as 'Total No. of Merchants' from [dbo].[Merchants]
--OR--
SELECT DISTINCT MerchantID from [dbo].[TransactionLog]

--//(03) The types of Product & Services//--
SELECT COUNT(*) as 'Total No. of Categories' from [dbo].[ProductsServices]
--OR--
SELECT DISTINCT CategoryID from [dbo].[TransactionLog]

--//(04) Total Number of Transaction & Fraud VS NON-Fraud Transaction//--
SELECT TransactionID, FraudDetected,
CASE
    WHEN FraudDetected = 0 THEN 'Normal'
    WHEN FraudDetected = 1 THEN 'Fraud'
    ELSE 'Error'
END AS 'Transaction Check'
FROM [dbo].[TransactionLog]

--//(05) Total Amount of Fraud Transaction//--
SELECT SUM(Amount) as 'Total Transaction Amount' from [dbo].[TransactionLog]
SELECT SUM(Amount) as 'Total Amount (Fraud)' from [dbo].[TransactionLog]
WHERE FraudDetected = 1


--//(06) Max & Min Amount of Fraud Transaction//--
SELECT MAX(Amount) as 'MAX Fraud Amount', MIN(Amount) as 'MIN Fraud Amount', AVG(Amount) as 'Average Fraud Amount'
FROM [dbo].[TransactionLog]
WHERE FraudDetected = 1

SELECT P.CategoryType, MAX(T.Amount) as 'MAX Fraud Amount', 
MIN(T.Amount) as 'MIN Fraud Amount', AVG(T.Amount) as 'Average Fraud Amount'
FROM ProductsServices P INNER JOIN TransactionLog T
ON P.CategoryID = T.CategoryID
WHERE t.FraudDetected = 1
GROUP BY CategoryType

---------------------------------------------------------------------------------------------
--//(07)Fraud Transaction VS Category Types//--
SELECT P.CategoryType, SUM(T.Amount) as 'Total Fraud Amount Per Category'
FROM ProductsServices P INNER JOIN TransactionLog T
ON P.CategoryID = T.CategoryID
WHERE t.FraudDetected = '1'
GROUP BY CategoryType
ORDER BY 'Total Fraud Amount Per Category'

SELECT P.CategoryType, COUNT(P.CategoryType) AS 'Category Count'
FROM ProductsServices P INNER JOIN TransactionLog T
ON P.CategoryID = T.CategoryID
WHERE t.FraudDetected = '1'
GROUP BY CategoryType
ORDER BY 'Category Count'

SELECT P.CategoryType, AVG(T.Amount) as 'Average Fraud Amount Per Category'
FROM ProductsServices P INNER JOIN TransactionLog T
ON P.CategoryID = T.CategoryID
WHERE t.FraudDetected = '1'
GROUP BY CategoryType
ORDER BY 'Average Fraud Amount Per Category'


-----------------------------------------------------------------------------------------------
--//(08)Fraud Transactions VS Gender//-
SELECT C.Gender, SUM(T.Amount) AS 'Total Fraud Amount Per Gender'
FROM Customers C INNER JOIN TransactionLog T
ON C.CustomerID = T.CustomerID
WHERE t.FraudDetected = '1'
GROUP BY Gender
ORDER BY 'Total Fraud Amount Per Gender' DESC

SELECT C.Gender, COUNT(C.Gender)  AS 'Gender Count'
FROM Customers C INNER JOIN TransactionLog T
ON C.CustomerID = T.CustomerID
WHERE t.FraudDetected = '1'
GROUP BY Gender
ORDER BY 'Gender Count' DESC

SELECT C.Gender, AVG(T.Amount) AS 'Average Fraud Amount Per Gender'
FROM Customers C INNER JOIN TransactionLog T
ON C.CustomerID = T.CustomerID
WHERE t.FraudDetected = '1'
GROUP BY Gender
ORDER BY 'Average Fraud Amount Per Gender' DESC

SELECT CustomerID, Gender,
CASE
    WHEN Gender = 'M' THEN 'Male'
    WHEN Gender = 'F' THEN 'Female'
    ELSE 'Others'
END AS 'Gender Breakdown'
FROM [dbo].[Customers]

--------------------------------------------------------------------------------------------
--//(09)Fraud Transactions VS AGE//--
SELECT C.AgeGroup, Sum(T.Amount) AS 'Total Fraud Amount Per Age Group'
FROM Customers C INNER JOIN TransactionLog T
ON C.CustomerID = T.CustomerID
WHERE t.FraudDetected = '1'
GROUP BY AgeGroup
ORDER BY 'Total Fraud Amount Per Age Group'

SELECT C.AgeGroup, Count(C.AgeGroup) AS 'Fraud Count Per Age Group'
FROM Customers C INNER JOIN TransactionLog T
ON C.CustomerID = T.CustomerID
WHERE t.FraudDetected = '1'
GROUP BY AgeGroup
ORDER BY 'Fraud Count Per Age Group'

SELECT C.AgeGroup, AVG(T.Amount) AS 'Average Fraud Amount Per Age Group'
FROM Customers C INNER JOIN TransactionLog T
ON C.CustomerID = T.CustomerID
WHERE t.FraudDetected = '1'
GROUP BY AgeGroup
ORDER BY 'Average Fraud Amount Per Age Group'

SELECT C.AgeGroup, Sum(T.Amount) AS 'Total Fraud Amount Per Age Group'
FROM Customers C INNER JOIN TransactionLog T
ON C.CustomerID = T.CustomerID
GROUP BY AgeGroup
ORDER BY 'Total Fraud Amount Per Age Group'

-----------------------------------------------------------------------------------------------
--//(10)Merchant / Customer with high fraud count--
SELECT C.CustomerID, M.MerchantID, T.FraudDetected
FROM ((TransactionLog T
INNER JOIN Customers C ON C.CustomerID = T.CustomerID)
INNER JOIN Merchants M ON M.MerchantID = T.MerchantID)
WHERE t.FraudDetected = '1'

