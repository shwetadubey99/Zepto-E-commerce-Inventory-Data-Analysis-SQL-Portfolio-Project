# Zepto-E-commerce-Inventory-Data-Analysis-SQL-Portfolio-Project
This project is a practical data analytics portfolio project built using an e-commerce inventory dataset inspired by product listings from [Zepto](https://www.zepto.com/), one of India’s rapidly growing quick-commerce platforms.

This project is perfect for:

 📊 Data Analyst aspirants who want to build a strong Portfolio Project for interviews and LinkedIn

 📚 Anyone learning SQL hands-on
 
 💼 Preparing for interviews in retail, e-commerce, or product analytics

 
## 📌 Project Overview

The main goal of this project is to simulate real-world analytical tasks by using SQL to:

✅ Build and structure an e-commerce inventory database from raw dataset files

✅ Perform Exploratory Data Analysis (EDA) to understand product categories, pricing distribution, and stock availability

✅ Conduct data cleaning by handling missing values, removing inconsistent records, and converting price values from paise to rupees

✅ Develop business-focused SQL queries to generate insights about pricing trends, inventory levels, product availability, and potential revenue opportunities

## 📊 Dataset Description

The dataset used in this project was sourced from [kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv), and represent product listings originally collected from the Zepto platform.

It reflects the structure of a typical e-commerce inventory dataset, where each row corresponds to a unique SKU (Stock Keeping Unit).

Product names may appear multiple times because the same item can exist in different package sizes, weights, discounts, or categories, which is common in real online retail catalogs.

### 🧾 Dataset Columns

sku_id : 
Unique identifier assigned to each product entry (Primary Key).

name : 
Name of the product as listed on the application.

category : 
Product category such as Fruits, Snacks, Beverages, Dairy, etc.

mrp : 
Maximum Retail Price of the product (originally in paise, later converted to Indian Rupees).

discountPercent : 
Percentage discount applied to the product’s MRP.

discountedSellingPrice :
Final selling price after applying the discount (converted to ₹).

availableQuantity :
Total quantity of the product currently available in the inventory.

weightInGms :
Weight of the product measured in grams.

outOfStock :
Boolean indicator showing whether the product is currently out of stock.

quantity :
Number of units included in a product package (for some products this may represent loose quantity such as fruits or vegetables).

## 🔧 Project Workflow

Here’s a step-by-step breakdown of what we do in this project:

### 1. Database & Table Creation

```sql
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
```

### 2. Data Import

Loaded CSV using Table Data import wizard feature.

If you're not able to use the import feature, write this code instead:

```sql
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
```
Faced encoding issues (UTF-8 error), which were fixed by saving the CSV file using CSV UTF-8 format.

### 3. Data Exploration

> Counted the total number of records in the dataset

> Viewed a sample of the dataset to understand structure and content

> Checked for null values across all columns

> Identified distinct product categories available in the dataset

> Compared in-stock vs out-of-stock product counts

> Detected products present multiple times, representing different SKUs

### 4. Data Cleaning

Identified and removed rows where MRP or discounted selling price was zero

Converted mrp and discountedSellingPrice from paise to rupees for consistency and readability

### 5. Business Insights

Found top 10 best-value products based on discount percentage

Identified high-MRP products that are currently out of stock

Estimated potential revenue for each product category

Filtered expensive products (MRP > ₹500) with minimal discount

Ranked top 5 categories offering highest average discounts

Calculated price per gram to identify value-for-money products

Grouped products based on weight into Low, Medium, and Bulk categories

Measured total inventory weight per product category

## 🛠 Tools Used
- SQL (MySQL)
- Data Cleaning
- Exploratory Data Analysis (EDA)
