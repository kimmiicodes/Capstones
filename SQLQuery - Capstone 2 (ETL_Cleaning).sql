--//Importing Dataset into SQL//--
select * from [dbo].[RawDataSet] order by step

--//Rename of Column and Remove Duplicate Columns//--
EXEC sp_rename '[dbo].[RawDataSet].step', 'Step', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].customer', 'CustomerID', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].age', 'AgeTag', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].gender', 'Gender', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].zipcodeOri', 'Zipcode', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].merchant', 'MerchantID', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].category', 'CategoryType', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].amount', 'Amount', 'COLUMN'
EXEC sp_rename '[dbo].[RawDataSet].fraud', 'FraudDetected', 'COLUMN'
ALTER TABLE [dbo].[RawDataSet] DROP COLUMN zipMerchant

select * from [dbo].[RawDataSet] order by step

-----------------------------------------------------------------------------------------------------
--/*Creating Customer Table*/--
SELECT * into [dbo].[Customers] from [dbo].[RawDataSet]

SELECT * from [dbo].[Customers] order by Step

--/*Cleaning Customer Table*/--
ALTER TABLE [dbo].[Customers]
DROP COLUMN Step, MerchantID, CategoryType, Amount, FraudDetected

SELECT * from [dbo].[Customers]

--/*Removing CustomerID Duplicates*/--
SELECT count(CustomerID) as 'CustomerID Count' from [dbo].[Customers] 
--Result: CustomerID Count 594643--

SELECT DISTINCT CustomerID, AgeTag, Gender, Zipcode from [dbo].[Customers]
--Result: 4112rows--

WITH cte 
AS (SELECT CustomerID, AgeTag, Gender, Zipcode, 
    ROW_NUMBER() 
	OVER (PARTITION BY CustomerID, AgeTag, Gender, Zipcode
    ORDER BY CustomerID) row_num
	FROM [dbo].[Customers])
DELETE FROM cte
WHERE row_num > 1

SELECT count(CustomerID) as 'CustomerID Count' from [dbo].[Customers] 
--Result: CustomerID Count 4112--

/*Add AgeGroup Column*/
ALTER TABLE [dbo].[Customers]
ADD AgeGroup VARCHAR(50) NULL
/*Update AgeGroup Values*/
UPDATE [dbo].[Customers]
SET AgeGroup = '<= 18'
WHERE AgeTag = '0'

UPDATE [dbo].[Customers]
SET AgeGroup = '19-25'
WHERE AgeTag = '1'

UPDATE [dbo].[Customers]
SET AgeGroup = '26-35'
WHERE AgeTag = '2'

UPDATE [dbo].[Customers]
SET AgeGroup = '36-45'
WHERE AgeTag = '3'

UPDATE [dbo].[Customers]
SET AgeGroup = '46-55'
WHERE AgeTag = '4'

UPDATE [dbo].[Customers]
SET AgeGroup = '56-65'
WHERE AgeTag = '5'

UPDATE [dbo].[Customers]
SET AgeGroup = '>65'
WHERE AgeTag = '6'

UPDATE [dbo].[Customers]
SET AgeGroup = 'Unknown'
WHERE AgeTag = 'U'

/*Reflect Gender Strings*/
UPDATE [dbo].[Customers]
SET Gender = 'Female'
WHERE Gender = 'F'

UPDATE [dbo].[Customers]
SET Gender = 'Male'
WHERE Gender = 'M'

UPDATE [dbo].[Customers]
SET Gender = 'Enterprise'
WHERE Gender = 'E'

----OR----
SELECT CustomerID, Gender,
CASE
    WHEN Gender = 'M' THEN 'Male'
    WHEN Gender = 'F' THEN 'Female'
    ELSE 'Others'
END AS 'Gender Breakdown'
FROM [dbo].[Customers]


--Adding contraints--
ALTER TABLE [dbo].[Customers]
ADD PRIMARY KEY (CustomerID)

ALTER TABLE [dbo].[Customers]
ADD FOREIGN KEY (Zipcode) REFERENCES [dbo].[Country](Zipcode)

SELECT * from [dbo].[Customers]


------------------------------------------------------------------------------------------------------
--/*Creating Merchant Table*/--
SELECT * into [dbo].[Merchants] from [dbo].[RawDataSet]

--/*Clearing Merchants Table*/--
ALTER TABLE [dbo].[Merchants]
DROP COLUMN Step, CustomerID, AgeTag, Gender, Amount, FraudDetected

--/*Removing MerchantID Duplicates*/--
SELECT count(MerchantID) as 'MerchantID Count' from [dbo].[Merchants] 
--Result: MerchantID Count 594643--

SELECT DISTINCT MerchantID, Zipcode, CategoryType from [dbo].[Merchants]
--Result: 50 rows--
SELECT DISTINCT CategoryType from [dbo].[Merchants]
--Result: 15 rows--

WITH cte 
AS (SELECT MerchantID, Zipcode, CategoryType, 
    ROW_NUMBER() 
	OVER (PARTITION BY MerchantID, Zipcode, CategoryType
    ORDER BY MerchantID) row_num
	FROM [dbo].[Merchants])
DELETE FROM cte
WHERE row_num > 1

/*Update CategoryType Strings*/
UPDATE [dbo].[Merchants]
SET CategoryType = 'Bars & Restaurants'
WHERE CategoryType = 'es_barsandrestaurants'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Contents'
WHERE CategoryType = 'es_contents'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Food'
WHERE CategoryType = 'es_food'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Fashion'
WHERE CategoryType = 'es_fashion'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Health'
WHERE CategoryType = 'es_health'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Home'
WHERE CategoryType = 'es_home'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Hotel & Services'
WHERE CategoryType = 'es_hotelservices'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Hyper'
WHERE CategoryType = 'es_hyper'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Leisure'
WHERE CategoryType = 'es_leisure'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Other Services'
WHERE CategoryType = 'es_otherservices'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Sports & Toys'
WHERE CategoryType = 'es_sportsandtoys'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Tech'
WHERE CategoryType = 'es_tech'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Transportation'
WHERE CategoryType = 'es_transportation'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Travel'
WHERE CategoryType = 'es_travel'

UPDATE [dbo].[Merchants]
SET CategoryType = 'Wellness & Beauty'
WHERE CategoryType = 'es_wellnessandbeauty'

--Adding contraints--
ALTER TABLE [dbo].[Merchants]
ADD PRIMARY KEY (MerchantID)

ALTER TABLE [dbo].[Merchants]
ADD FOREIGN KEY (CategoryID) REFERENCES [dbo].[ProductsServices] (CategoryID)

ALTER TABLE [dbo].[Merchants]
ADD FOREIGN KEY (Zipcode) REFERENCES [dbo].[Country] (Zipcode)

SELECT * from [dbo].[Merchants]


------------------------------------------------------------------------------------------------------
--/*Creating Country Table*/--
SELECT * into [dbo].[Country] from [dbo].[RawDataSet]

--/*Cleaning Country Table*/--
ALTER TABLE [dbo].[Country]
DROP COLUMN Step, CustomerID, AgeTag, Gender, MerchantID, CategoryType, Amount, FraudDetected

SELECT DISTINCT Zipcode from [dbo].[Country]
--Result: 1 row--

--/*Removing Zipcode Duplicates*/--
WITH cte 
AS (SELECT Zipcode, Country, 
    ROW_NUMBER() 
	OVER (PARTITION BY Zipcode
    ORDER BY zipcode) row_num
	FROM [dbo].[Country])
DELETE FROM cte
WHERE row_num > 1

--/*Add Country Column*/--
ALTER TABLE [dbo].[Country]
ADD Country VARCHAR(50) NULL
--/*Update Country String*/--
UPDATE [dbo].[Country]
SET Country = 'Ansonville'
WHERE Zipcode = '28007'

--Adding Constraints--
ALTER TABLE [dbo].[Country]
ADD PRIMARY KEY (Zipcode)

SELECT * from [dbo].[Country]

------------------------------------------------------------------------------------------------------
--/*Creating Products_Services Table*/--
SELECT * into [dbo].[ProductsServices] from [dbo].[Merchants]

--/*Cleaning Products&Services Table*/--
ALTER TABLE [dbo].[ProductsServices]
DROP COLUMN Zipcode, MerchantID

--/*Removing CategoryType Duplicates*/--
SELECT count(CategoryType) as 'Category Count' from [dbo].[ProductsServices]
--Result: Category Count 50--

SELECT DISTINCT CategoryType from [dbo].[ProductsServices]
--Result: 15 rows--

WITH cte 
AS (SELECT CategoryType,
    ROW_NUMBER() 
	OVER (PARTITION BY CategoryType
    ORDER BY CategoryType) row_num
	FROM [dbo].[ProductsServices])
DELETE FROM cte
WHERE row_num > 1

--/*Add CategoryID column */--
ALTER TABLE [dbo].[ProductsServices]
ADD CategoryID tinyint IDENTITY(1,1) 

--/*Update CategoryID Value*/--
UPDATE [dbo].[ProductsServices]
SET CategoryID = '1'
WHERE CategoryType = 'Bars & Restaurants'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '2'
WHERE CategoryType = 'Contents'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '3'
WHERE CategoryType = 'Fashion'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '4'
WHERE CategoryType = 'Food'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '5'
WHERE CategoryType = 'Health'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '6'
WHERE CategoryType = 'Home'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '7'
WHERE CategoryType = 'Hotel & Services'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '8'
WHERE CategoryType = 'Hyper'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '9'
WHERE CategoryType = 'Leisure'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '10'
WHERE CategoryType = 'Other Services'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '11'
WHERE CategoryType = 'Sports & Toys'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '12'
WHERE CategoryType = 'Tech'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '13'
WHERE CategoryType = 'Transportation'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '14'
WHERE CategoryType = 'Travel'

UPDATE [dbo].[ProductsServices]
SET CategoryID = '15'
WHERE CategoryType = 'Wellness & Beauty'

--Constraints--
ALTER TABLE [dbo].[ProductsServices]
ADD PRIMARY KEY (CategoryID)

SELECT * from [dbo].[ProductsServices]

------------------------------------------------------------------------------------------------------
--/*Creating TransactionLog */--
SELECT * into [dbo].[TransactionLog] from [dbo].[RawDataSet]

ALTER TABLE [dbo].[TransactionLog]
ADD TransactionID INT IDENTITY(1,1) 

--Adding contraints--
ALTER TABLE [dbo].[TransactionLog]
ADD PRIMARY KEY (TransactionID)

ALTER TABLE [dbo].[TransactionLog]
ADD FOREIGN KEY (CustomerID) REFERENCES [dbo].[Customers](CustomerID)

ALTER TABLE [dbo].[TransactionLog]
ADD FOREIGN KEY (MerchantID) REFERENCES [dbo].[Merchants](MerchantID)

ALTER TABLE [dbo].[TransactionLog]
ADD FOREIGN KEY (CategoryID) REFERENCES [dbo].[ProductsServices] (CategoryID)

ALTER TABLE [dbo].[TransactionLog]
ADD CategoryID tinyint NULL

--/*Update CategoryID String*/--
UPDATE [dbo].[TransactionLog]
SET CategoryID = '1'
WHERE category = 'es_barsandrestaurants'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '2'
WHERE category = 'es_contents'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '3'
WHERE category = 'es_fashion'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '4'
WHERE category = 'es_food'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '5'
WHERE category = 'es_health'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '6'
WHERE category = 'es_home'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '7'
WHERE category = 'es_hotelservices'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '8'
WHERE category = 'es_hyper'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '9'
WHERE category = 'es_leisure'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '10'
WHERE category = 'es_otherservices'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '11'
WHERE category = 'es_sportsandtoys'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '12'
WHERE category = 'es_tech'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '13'
WHERE category = 'es_transportation'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '14'
WHERE category = 'es_travel'

UPDATE [dbo].[TransactionLog]
SET CategoryID = '15'
WHERE category = 'es_wellnessandbeauty'

--//Remove unwanted columns//--
ALTER TABLE [dbo].[TransactionLog]
DROP COLUMN AgeTag, Gender, Zipcode, CategoryType

SELECT * from [dbo].[TransactionLog]
