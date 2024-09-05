CREATE DATABASE SuperStore

USE  SuperStore

SELECT * FROM Orders

SELECT [Customer Name] Name, [Customer ID]
FROM Orders
WHERE [Ship Mode] = 'Second Class'


SELECT [Customer Name] Name, [Customer ID]
FROM Orders
WHERE [Ship Mode] = 'Second Class'

SELECT [Customer Name], Discount
FROM Orders
WHERE Discount > 0

-- AND OPERATOR

SELECT [Row ID],[Product Name],Sales
FROM Orders
WHERE Sales NOT BETWEEN  8.832 AND 14.136 

-- IN OPERATOR

SELECT * FROM Orders
WHERE CITY IN ('Columbia', 'Los Angeles','Virginia')

-- NOT IN OPERATOR

SELECT * FROM Orders
WHERE CITY NOT IN ('Columbia', 'Los Angeles','Virginia')

-- NULL OPERATOR

SELECT * FROM Orders
WHERE [Region] IS NULL

-- NOT NULL  OPERATOR

SELECT * FROM Orders
WHERE [Region] IS NOT NULL

-- WILDCARD OPERATORS

SELECT * FROM Orders
WHERE [Customer Name] LIKE 'A%' -- STARTING FROM A LETTRER



SELECT * FROM Orders
WHERE [Customer Name] LIKE '%ey' -- END WITH LAST NAME

SELECT * FROM Orders
WHERE Segment LIKE '_E'

-- ORDER BY CLAUSE

SELECT [Row ID],[Customer Name],[Customer ID], State, Quantity
FROM Orders
ORDER BY Quantity DESC

-- ONLY 5 LIMIT 

SELECT TOP 5 [Row ID],[Customer Name],[Customer ID], State, Quantity
FROM Orders
ORDER BY Quantity ASC


--AGGREGATE FUNCTION

-- COUNT FUNCTION

SELECT COUNT([Customer ID]) AS "NO OF RECORDS"
FROM Orders


-- SUM FUNCTION

SELECT SUM([Profit]) AS "SUM"
FROM Orders

-- AVERAGE


SELECT AVG([Profit]) AS "AVERAGE"
FROM Orders


-- MAXIMUM

SELECT MAX([Profit]) AS "MAXIMUM"
FROM Orders

-- MINIMUM

SELECT MIN([Profit]) AS "MIN"
FROM Orders

-- GROUP BY AND HAVING CLOUSE

SELECT [Quantity],AVG(Sales) AS 'AVERAGE SALES'
FROM Orders
GROUP BY Quantity
HAVING AVG(Sales) > 395

-- STRING FUNCTION

-- CONCAT FUNCTION

SELECT CONCAT('HELLO',' ','KIWI') AS CONCAT

-- LENGTH FUNCTION

SELECT LEN('KIWI IS A GOOD BOY') AS LENGTH

-- UPPER FUNCTION

SELECT UPPER('kiwi my boy') AS UPPER

-- LOWER FUNCTION

SELECT LOWER('KIWI MY BOY') AS LOWER

-- SUBSTRING

SELECT SUBSTRING('HELLO KIWI',6,5) AS SUBSTRING

-- REPLACE

SELECT REPLACE('TOMMY,TOMMY,TOMMY','TOMMY','KIWI') AS REPLACE

-- CHARINDEX

SELECT CHARINDEX('KIWI','MY BABY KIWI') AS POSITION

--LTRIM

SELECT LTRIM('   KIWI') AS LEFT_TRIMMED -- REMOVES LEADING SPACE FROM STRING

--RTRIM

SELECT RTRIM('KIWI     ') AS RIGHT_TRIMMED

--LEFT FUNCTION

SELECT LEFT('KIWI HELLO',5) AS LEFT_PART

--RIGHT FUNCTION

SELECT RIGHT('HELLO KIWI',5) AS RIGHT_PART

--DATE FUNCTION

SELECT GETDATE() AS 'CURRENT DATE'

SELECT [Order id],[order date],[ship date]
FROM Orders

SELECT [order id],[order date],[ship date],DATEDIFF(day,[order date],[ship date]) AS 'DIFFERENCE'
FROM Orders

-- JOINS

SELECT TOP 5 [Customer Name],[Product Name],r.[Order ID]
FROM Orders  o
INNER JOIN Returns r
ON o.[Order ID] = r.[Order ID]

-- LEFT JOIN

SELECT  [Customer Name],[Product Name],r.[Order ID]
FROM Orders  o
LEFT JOIN Returns r
ON o.[Order ID] = r.[Order ID]

-- RIGHT JOIN

SELECT  [Customer Name],[Product Name],r.[Order ID]
FROM Orders  o
RIGHT JOIN Returns r
ON o.[Order ID] = r.[Order ID]

-- FULL OUTER JOIN

SELECT [Customer Name],[Product Name],r.[Order ID]
FROM Orders  o
FULL OUTER JOIN Returns r
ON o.[Order ID] = r.[Order ID]

--CROSS JOIN

SELECT TOP 5 *
FROM Orders
CROSS JOIN Returns

-- SET OPERATOR
-- UNNION (It will not show dupicate rows and there should be same column in both the tables then it will give  the output else trough the error)

SELECT TOP 10 [Order ID]
FROM Orders
UNION
SELECT TOP 10 [Order ID]
FROM Returns

-- UNNION ALL (It will not show dupicate rows and there should be same column in both the tables then it will give  the output else trough the error)

SELECT TOP 10 [Order ID]
FROM Orders
UNION ALL
SELECT TOP 10 [Order ID]
FROM Returns

-- INTERSECT(it shows only common value)

SELECT [Order ID]
FROM Orders
INTERSECT
SELECT [Order ID]
FROM Returns

-- ORDER OF EXECUTION

SELECT TOP 10 [Product Name],COUNT(*) AS Profit
FROM Orders
WHERE  profit > 21
GROUP BY [Product Name]
HAVING COUNT(*)>= 2
ORDER BY Profit DESC

-- CASE STATEMENT

SELECT [Customer Name],[Product Name],[Quantity],Profit,
CASE [Product Name]
WHEN 'Newell Chalk Holder' THEN '1#'
WHEN 'Carina Double Wide Media Storage Towers in Natural & Black' THEN '2#'
WHEN 'Okidata C331dn Printer' THEN '3#'
ELSE 'Not Evaluated'
END AS 'Product',
CASE 
   WHEN Profit >= 146 THEN 'Top Profit'
   WHEN Profit < 146 AND Profit >= 135 THEN 'Average Profit'
   WHEN Profit < 135 AND Profit >= 99 THEN 'Below Profit'
END AS 'Poor Profit'
FROM Orders



SELECT [Customer Name],[Product Name],[Quantity],Profit,
CASE 
   WHEN Profit >= 146 THEN 'Top Profit'
   WHEN Profit < 146 AND Profit >= 135 THEN 'Average Profit'
   WHEN Profit < 135 AND Profit >= 99 THEN 'Below Profit'
END AS 'Poor Profit'
FROM Orders


-- Sub queries
-- single row Subqueries(Retrive a single value from a subquery)

SELECT [Customer Name],[Product Name],Profit
FROM Orders
WHERE[Ship Mode] = 'First Class' AND Profit =(SELECT MAX(Profit)
                                             FROM Orders
											 WHERE [Ship Mode] ='First Class')

-- Multiple Rows Subqueries (Retrieve multiple values from a subquery)

SELECT [Customer Name],[Product Name],Segment
FROM Orders
WHERE [Product Name] IN (
                         SELECT [Product Name]
						 FROM Orders
						 GROUP BY [Product Name]
						 HAVING COUNT(*) >=3)

-- Correlated Subquery (Reference outer query values in the subquery)

-- Find the customer name who have higher profit than the avg profit obtained by product name

SELECT [Product Name] , AVG(Profit) 
FROM Orders
GROUP BY [Product Name]

SELECT [Customer Name],[Product Name],Segment,Profit
FROM Orders s
WHERE Profit > (SELECT AVG(Profit)
FROM Orders
WHERE [Product Name] = s.[Product Name])


-- CTE(WITH Clause)= (Common Table Expression)

WITH cte_avgproduct AS
(
    SELECT [Order ID], AVG(profit) AS 'Avg. product'
    FROM Orders
    GROUP BY [Order ID]
)
SELECT [Customer Name],[product Name],Profit,O.[Order ID] 
FROM Orders O
INNER JOIN cte_avgproduct C
ON O.[Order ID] = C.[Order ID]
AND Profit > C.[Avg. product] 

--Window Function

SELECT [Product Name], AVG(Profit) AS 'AVG. Product'
FROM Orders
GROUP BY [Product Name]

SELECT [Customer Name],[product Name],Profit,[Order ID],
AVG(Profit) OVER(Partition by [Product Name]) AS 'AVG. Product',
COUNT(*) OVER(Partition by [Product Name]) AS 'Customer'
FROM Orders

-- MAX & MIN

SELECT [Product Name], AVG(Profit) AS 'AVG. Product'
FROM Orders
GROUP BY [Product Name]

SELECT TOP 10 [Customer Name],[product Name],Profit,[Order ID],
AVG(Profit) OVER(Partition by [Product Name]) AS 'AVG. Product',
COUNT(*) OVER(Partition by [Product Name]) AS 'Customer',
MAX(Profit) OVER(Partition by [Product Name]) AS 'Max.Customer',
MIN(Profit) OVER(Partition by [Product Name]) AS 'Min.Customer'
FROM Orders

-- Aggregate Window Function(Function like SUM(),MAX(),MIN(),AVG(),COUNT())

SELECT TOP 10 [Customer Name],[product Name],Profit,[Order ID],
SUM(Profit) OVER (Partition by [Product Name] ORDER BY Profit ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'Total'
FROM Orders

SELECT TOP 10 [Customer Name],[product Name],Profit,[Order ID],
SUM(Profit) OVER (Partition by [Product Name] ORDER BY Profit ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS 'Total'
FROM Orders

--Ranking Window Function(Function RANK(),DENSE_RANK(),ROW_NUMBER(),NTILE())


SELECT [Customer Name],[product Name],Profit,[Order ID],
ROW_NUMBER() OVER(PARTITION BY [Product Name] ORDER BY Profit DESC) AS ' ROW NUMBER'
FROM Orders

--Rank() & Dannse_Rank()

SELECT [Customer Name],[product Name],Profit,[Order ID],
RANK() OVER (PARTITION BY [Product Name] ORDER BY profit DESC) AS 'Rank',
DENSE_RANK() OVER(PARTITION BY [Product Name] ORDER BY profit DESC) AS 'Dense_Rank'
FROM Orders


--NTILE()
--Using prders table of sample superstarDB, find out the top 10 percent customers based on the profit

SELECT [Customer Name],SUM(Profit) AS 'Profit'
FROM Orders
GROUP BY [Customer Name]

SELECT [Customer Name],Profit,Segregation
FROM (
     SELECT[Customer Name],SUM(Profit) AS Profit,
     NTILE(10) OVER (ORDER BY SUM(profit) DESC) AS Segregation
     FROM Orders
     GROUP BY [Customer Name] ) AS DerivedTable
	 WHERE Segregation = 1 OR Segregation = 10


-- Value Window Function(LAG(),LEAD(),FIRST_VALUE(),LAST_VALUE())

--LAG() & LEAD()

SELECT TOP 10 [Customer Name],[product Name],Profit,[Order ID],
LAG(Profit) OVER(ORDER BY Profit) AS 'Previous Value',
LEAD(Profit) OVER(ORDER BY Profit) AS 'Next Value'
FROM Orders


--FIRST_VALUE() & LAST_VALUE()

SELECT [Customer Name],[product Name],Profit,[Order ID],
FIRST_VALUE(Profit) OVER(ORDER BY Profit) AS 'First Value',
LAST_VALUE(Profit) OVER(ORDER BY Profit) AS 'Last Value'
FROM Orders