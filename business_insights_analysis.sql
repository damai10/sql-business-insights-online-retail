-- ==============================
-- CREATE DATABASE
-- ==============================
CREATE DATABASE online_retail_project;
USE online_retail_project;
SET SQL_SAFE_UPDATES = 0;

-- Check Data
SELECT * 
FROM retail_sample
LIMIT 10;
ALTER TABLE retail_sample
CHANGE COLUMN `Ã¯Â»Â¿InvoiceNo` InvoiceNo VARCHAR(20);

-- ==============================
-- DATA CLEANING 
-- ==============================

-- Remove missing customers
DELETE FROM retail_sample
WHERE CustomerID IS NULL;

-- Remove invalid values
DELETE FROM retail_sample
WHERE Quantity <= 0 OR UnitPrice <= 0;
-- ==============================
-- CREATE REVENUE COLUMN (VIEW)
-- ==============================
CREATE VIEW retail_clean AS
SELECT *,
       Quantity * UnitPrice AS Revenue
FROM retail_sample;
SELECT * FROM retail_clean LIMIT 10;

-- ==============================
-- BUSINESS PERFORMANCE
-- ==============================
-- Total Revenue
SELECT SUM(Revenue) AS Total_Revenue
FROM retail_clean;
-- Total Orders
SELECT COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM retail_clean;
-- Total Customers
SELECT COUNT(DISTINCT CustomerID) AS Total_Customers
FROM retail_clean;

-- ==============================
-- REVENUE TRENDS
-- ==============================
-- Monthly Revenue
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    SUM(Revenue) AS Monthly_Revenue
FROM retail_clean
GROUP BY Month
ORDER BY Month;

-- ==============================
-- CUSTOMER ANALYSIS
-- ==============================
-- Top Customers
SELECT 
    CustomerID,
    SUM(Revenue) AS Total_Spent
FROM retail_clean
GROUP BY CustomerID
ORDER BY Total_Spent DESC
LIMIT 10;
-- Repeat Customers
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Orders
FROM retail_clean
GROUP BY CustomerID
HAVING Orders > 1;
-- Revenue by Country
SELECT 
    Country,
    SUM(Revenue) AS Total_Revenue
FROM retail_clean
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- ==============================
-- PRODUCT ANALYSIS
-- ==============================
-- Top Products by Quantity
SELECT 
    Description,
    SUM(Quantity) AS Total_Quantity
FROM retail_clean
GROUP BY Description
ORDER BY Total_Quantity DESC
LIMIT 10;
-- Profit Proxy
SELECT 
    Description,
    SUM(Revenue) AS Product_Revenue
FROM retail_clean
GROUP BY Description
ORDER BY Product_Revenue DESC
LIMIT 10;
-- Average Order Value
SELECT 
    SUM(Revenue) / COUNT(DISTINCT InvoiceNo) AS Avg_Order_Value
FROM retail_clean;
-- High Value Customers 
SELECT 
    CustomerID,
    SUM(Revenue) AS Total_Spent
FROM retail_clean
GROUP BY CustomerID
HAVING Total_Spent > 1000
ORDER BY Total_Spent DESC;