CREATE DATABASE Zepto_sql_project;

DROP DATABASE IF EXISTS Zepto_sql_project;

use Zepto_sql_project;

CREATE TABLE Zepto (
 sku_id SERIAL PRIMARY KEY,
 category VARCHAR(120),
 name VARCHAR (150) NOT NULL,
 mrp DECIMAL (10,2),
 Disc_percent DECIMAL (5,2),
 available_qty INT,
 Disc_sellprice DECIMAL (8,2),
 weightingm INT,
 outofstock BOOLEAN,
 Qty INT);
 
 ALTER TABLE Zepto DROP COLUMN sku_id;
 ALTER TABLE Zepto MODIFY COLUMN outofstock VARCHAR(10);
 ALTER TABLE Zepto ADD COLUMN sku_id SERIAL PRIMARY KEY FIRST;
 

 TRUNCATE TABLE Zepto;
 DROP TABLE Zepto;
 
 
SET GLOBAL local_infile = 1; 

LOAD DATA LOCAL INFILE '/Users/shwet/Documents/zepto_v2_.csv'
INTO TABLE Zepto
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, Disc_percent, available_qty, Disc_sellPrice, weightingm, @outofstock, Qty)
SET outofstock = CASE 
    WHEN LOWER(@outofstock) = 'true' THEN 1 
    ELSE 0 
END;

 SET SQL_SAFE_UPDATES =0; 

UPDATE Zepto SET outofstock = '0' WHERE outofstock = 'FALSE';

UPDATE Zepto set outofstock = '1' WHERE outofstock = 'TRUE';

SET SQL_SAFE_UPDATES =1;

--- Data exploration
 --- count of rows
 
SELECT COUNT(*) FROM Zepto;
 
 SELECT * FROM Zepto;
 
-- Sample data
SELECT * FROM Zepto LIMIT 10;

--- Null values
SELECT * FROM Zepto WHERE name is NULL
or mrp is NULL
OR Disc_percent IS NULL
OR available_qty IS NULL
OR Disc_sellPrice IS NULL
OR weightingm IS NULL
OR outofstock IS NULL
OR Qty IS NULL;

--- Different product categories
SELECT DISTINCT category from Zepto
ORDER BY category;

SELECT DISTINCT outofstock from Zepto;


--- Product in stock vs outofstock
SELECT outofstock, COUNT(sku_id) AS total_products
FROM Zepto
GROUP BY outofstock;

-- product name reflects multiple time
SELECT name, COUNT(sku_id) AS "No of SKUs"
FROM Zepto 
GROUP BY name 
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- data cleaning
--- product price with 0

SELECT * FROM Zepto
WHERE mrp = 0 OR Disc_sellprice = 0;

DELETE FROM Zepto WHERE mrp = 0;

--- convert mrp paisa into Rupee
UPDATE Zepto SET mrp = mrp/100.0,
Disc_sellprice = Disc_sellprice/100.0;

Select mrp, Disc_sellprice from zepto;

-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, Disc_percent
FROM Zepto 
ORDER BY Disc_percent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
from Zepto
where outofstock = 1 and mrp > 300
order by mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category, SUM(Disc_sellprice * available_qty) AS total_revenue
from zepto
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, Disc_percent from Zepto
WHERE mrp > 500 and Disc_percent < 10
order by mrp DESC, Disc_percent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
Select DISTINCT category, ROUND(AVG(Disc_percent), 2) AS Avg_disc
from zepto 
GROUP BY category
order by Avg_disc DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name, weightingm, Disc_sellprice, 
ROUND(Disc_sellprice/weightingm, 2) AS "price_pergm"
 from zepto
where weightingm >= 100
order by price_pergm DESC;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightingm,
CASE WHEN weightingm <1000 then "Low"
     when weightingm <5000 then "Medium"
     ELSE "BULK"
     END AS weight_category
from zepto;     

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category, SUM(weightingm * available_qty) AS total_weight
from zepto
group by category
order by total_weight;
 