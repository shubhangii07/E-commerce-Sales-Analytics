-- ============================================
-- ECOMMERCE SQL ANALYSIS
-- Database: ecommerce
-- Table: orders
-- ============================================

USE ecommerce;


-- ============================================
-- 1. DATA OVERVIEW
-- ============================================

-- Preview the data
SELECT *
FROM orders;


-- Check total number of records
SELECT COUNT(DISTINCT Order_ID)
FROM orders;


-- Check duplicate Order IDs
SELECT
    COUNT(*) - COUNT(DISTINCT Order_ID) AS Duplicate_Order_IDs
FROM orders;


-- Check missing values in important columns
SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS Missing_Customer,
    SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS Missing_Product,
    SUM(CASE WHEN Qty IS NULL THEN 1 ELSE 0 END) AS Missing_Qty,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Price,
    SUM(CASE WHEN Net_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Net_Amount
FROM orders;


-- ============================================
-- 2. OVERALL BUSINESS KPIs
-- ============================================

-- Calculate the main business KPIs
SELECT
    COUNT(*) AS Total_Orders,
    COUNT(DISTINCT Customer_Name) AS Total_Customers,
    COUNT(DISTINCT City) AS Total_Cities,
    SUM(Qty) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    ROUND(AVG(Net_Amount), 2) AS Average_Order_Value,
    ROUND(MAX(Net_Amount), 2) AS Highest_Order_Value,
    ROUND(MIN(Net_Amount), 2) AS Lowest_Order_Value
FROM orders;


-- ============================================
-- 3. SALES ANALYSIS
-- ============================================

-- Calculate total gross sales
SELECT
    ROUND(SUM(Sales), 2) AS Total_Gross_Sales
FROM orders;


-- Calculate total discount amount
SELECT
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount
FROM orders;


-- Calculate total net sales
SELECT
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders;


-- Calculate overall discount percentage
SELECT
    ROUND(
        SUM(Discount_Amount) / NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Discount_Percentage
FROM orders;


-- Find the highest order value
SELECT
    Order_ID,
    Customer_Name,
    Product,
    Net_Amount
FROM orders
ORDER BY Net_Amount DESC
LIMIT 1;


-- Find the lowest order value
SELECT
    Order_ID,
    Customer_Name,
    Product,
    Net_Amount
FROM orders
ORDER BY Net_Amount ASC
LIMIT 1;


-- Find the second-highest order value
SELECT
    MAX(Net_Amount) AS Second_Highest_Order
FROM orders
WHERE Net_Amount < (
    SELECT MAX(Net_Amount)
    FROM orders
);


-- ============================================
-- 4. CATEGORY ANALYSIS
-- ============================================

-- Display all product categories
SELECT DISTINCT Category
FROM orders
ORDER BY Category;


-- Analyze category performance
SELECT
    Category,
    COUNT(*) AS Total_Orders,
    SUM(Qty) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    ROUND(AVG(Net_Amount), 2) AS Average_Order_Value
FROM orders
GROUP BY Category
ORDER BY Total_Net_Sales DESC;


-- Find the category with the highest net sales
SELECT
    Category,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY Category
ORDER BY Total_Net_Sales DESC
LIMIT 1;


-- Find the category with the highest quantity sold
SELECT
    Category,
    SUM(Qty) AS Total_Quantity
FROM orders
GROUP BY Category
ORDER BY Total_Quantity DESC
LIMIT 1;


-- ============================================
-- 5. PRODUCT ANALYSIS
-- ============================================

-- Top 10 products by gross sales
SELECT
    Product,
    SUM(Qty) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Gross_Sales,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY Product
ORDER BY Total_Net_Sales DESC
LIMIT 10;


-- Top 10 products by quantity sold
SELECT
    Product,
    SUM(Qty) AS Total_Quantity
FROM orders
GROUP BY Product
ORDER BY Total_Quantity DESC
LIMIT 10;


-- Find the product with the highest net sales
SELECT
    Product,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY Product
ORDER BY Total_Net_Sales DESC
LIMIT 1;


-- ============================================
-- 6. CUSTOMER ANALYSIS
-- ============================================

-- Top 10 customers by spending
SELECT
    Customer_Name,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Spending,
    SUM(Qty) AS Total_Quantity
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Spending DESC
LIMIT 10;


-- Find the highest-spending customer
SELECT
    Customer_Name,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Spending
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Spending DESC
LIMIT 1;


-- Find customers with more than 5 orders
SELECT
    Customer_Name,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Spending
FROM orders
GROUP BY Customer_Name
HAVING COUNT(*) > 5
ORDER BY Total_Orders DESC;


-- ============================================
-- 7. GEOGRAPHICAL ANALYSIS
-- ============================================

-- Analyze sales by state
SELECT
    State,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    SUM(Qty) AS Total_Quantity
FROM orders
GROUP BY State
ORDER BY Total_Net_Sales DESC;


-- Find the top 10 cities by order volume
SELECT
    City,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY City
ORDER BY Total_Orders DESC
LIMIT 10;


-- Find the top 10 cities by net sales
SELECT
    City,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY City
ORDER BY Total_Net_Sales DESC
LIMIT 10;


-- ============================================
-- 8. PAYMENT ANALYSIS
-- ============================================

-- Analyze orders by payment mode
SELECT
    Payment_Mode,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    ROUND(AVG(Net_Amount), 2) AS Average_Order_Value
FROM orders
GROUP BY Payment_Mode
ORDER BY Total_Net_Sales DESC;


-- ============================================
-- 9. ORDER STATUS ANALYSIS
-- ============================================

-- Analyze orders by status
SELECT
    Order_Status,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    ROUND(AVG(Net_Amount), 2) AS Average_Order_Value
FROM orders
GROUP BY Order_Status
ORDER BY Total_Orders DESC;


-- Count cancelled orders
SELECT
    COUNT(*) AS Cancelled_Orders
FROM orders
WHERE Order_Status = 'Cancelled';


-- Calculate cancellation percentage
SELECT
    ROUND(
        100.0 *
        SUM(CASE
            WHEN Order_Status = 'Cancelled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS Cancellation_Percentage
FROM orders;


-- ============================================
-- 10. TIME-BASED ANALYSIS
-- ============================================

-- Analyze yearly performance
SELECT
    Year,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY Year
ORDER BY Year;


-- Analyze monthly performance by year
SELECT
    Year,
    Month,
    Month_Name,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY Year, Month, Month_Name
ORDER BY Year, Month;


-- Analyze overall sales by month number
SELECT
    Month,
    Month_Name,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY Month, Month_Name
ORDER BY Month;


-- Analyze orders by weekday
SELECT
    Weekday,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales
FROM orders
GROUP BY Weekday
ORDER BY Total_Orders DESC;


-- ============================================
-- 11. DISCOUNT ANALYSIS
-- ============================================

-- Analyze performance by discount percentage
SELECT
    Discount,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    ROUND(AVG(Net_Amount), 2) AS Average_Order_Value
FROM orders
GROUP BY Discount
ORDER BY Discount;


-- Compare discounted vs non-discounted orders
SELECT
    CASE
        WHEN Discount > 0 THEN 'Discounted'
        ELSE 'No Discount'
    END AS Discount_Type,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    ROUND(AVG(Net_Amount), 2) AS Average_Order_Value
FROM orders
GROUP BY Discount_Type;


-- ============================================
-- 12. DELIVERY ANALYSIS
-- ============================================

-- Calculate average delivery time
SELECT
    ROUND(AVG(Delivery_Days), 2) AS Average_Delivery_Days
FROM orders
WHERE Delivery_Days IS NOT NULL;


-- Find the fastest delivery
SELECT
    MIN(Delivery_Days) AS Fastest_Delivery_Days
FROM orders
WHERE Delivery_Days IS NOT NULL;


-- Find the longest delivery
SELECT
    MAX(Delivery_Days) AS Longest_Delivery_Days
FROM orders
WHERE Delivery_Days IS NOT NULL;


-- Analyze delivery time by order status
SELECT
    Order_Status,
    COUNT(Delivery_Days) AS Orders_With_Delivery_Data,
    ROUND(AVG(Delivery_Days), 2) AS Average_Delivery_Days
FROM orders
GROUP BY Order_Status
ORDER BY Average_Delivery_Days;


-- ============================================
-- 13. ORDER VALUE ANALYSIS
-- ============================================

-- Display high-value orders above 10,000
SELECT
    Order_ID,
    Customer_Name,
    Product,
    Category,
    Net_Amount
FROM orders
WHERE Net_Amount > 10000
ORDER BY Net_Amount DESC;


-- Count high-value orders
SELECT
    COUNT(*) AS High_Value_Orders
FROM orders
WHERE Net_Amount > 10000;


-- ============================================
-- 14. DATA QUALITY CHECKS
-- ============================================

-- Check records where Unit Price was originally missing
SELECT
    Unit_Price_Missing,
    COUNT(*) AS Total_Records
FROM orders
GROUP BY Unit_Price_Missing;


-- Check records where Quantity was originally missing
SELECT
    Qty_Missing,
    COUNT(*) AS Total_Records
FROM orders
GROUP BY Qty_Missing;


-- Check records where Discount was originally missing
SELECT
    Discount_Missing,
    COUNT(*) AS Total_Records
FROM orders
GROUP BY Discount_Missing;


-- Check records where Phone was originally missing
SELECT
    Phone_Missing,
    COUNT(*) AS Total_Records
FROM orders
GROUP BY Phone_Missing;


-- Check records where Delivery Date was originally missing
SELECT
    Delivery_Date_Missing,
    COUNT(*) AS Total_Records
FROM orders
GROUP BY Delivery_Date_Missing;


-- Check invalid quantities identified during cleaning
SELECT
    Qty_Invalid,
    COUNT(*) AS Total_Records
FROM orders
GROUP BY Qty_Invalid;


-- ============================================
-- 15. CALCULATION VALIDATION CHECKS
-- ============================================

-- Check Sales calculation
-- Sales should equal Qty × Unit_Price
SELECT
    COUNT(*) AS Sales_Mismatch
FROM orders
WHERE ROUND(Sales, 2) <> ROUND(Qty * Unit_Price, 2);


-- Check Discount Amount calculation
-- Discount Amount should equal Sales × Discount / 100
SELECT
    COUNT(*) AS Discount_Amount_Mismatch
FROM orders
WHERE ROUND(Discount_Amount, 2)
      <> ROUND(Sales * Discount / 100, 2);


-- Check Net Amount calculation
-- Net Amount should equal Sales - Discount Amount
SELECT
    COUNT(*) AS Net_Amount_Mismatch
FROM orders
WHERE ROUND(Net_Amount, 2)
      <> ROUND(Sales - Discount_Amount, 2);


-- Check invalid Delivery Dates
-- Delivery Date should not be before Order Date
SELECT
    COUNT(*) AS Invalid_Delivery_Dates
FROM orders
WHERE Delivery_Date IS NOT NULL
  AND Delivery_Date < Order_Date;


-- Check duplicate Order IDs
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Unique_Order_IDs,
    COUNT(*) - COUNT(DISTINCT Order_ID) AS Duplicate_Rows
FROM orders;


-- ============================================
--  CLEANING SUMMARY
-- ============================================

-- Summary of records affected during cleaning
SELECT
    SUM(Unit_Price_Missing) AS Unit_Price_Imputed,
    SUM(Qty_Missing) AS Qty_Imputed,
    SUM(Discount_Missing) AS Discount_Imputed,
    SUM(Phone_Missing) AS Phone_Missing,
    SUM(Delivery_Date_Missing) AS Delivery_Date_Missing_Original,
    SUM(Qty_Invalid) AS Invalid_Qty
FROM orders;

-- ============================================
-- 16. FINAL BUSINESS KPI SUMMARY
-- ============================================

SELECT
    COUNT(*) AS Total_Orders,
    COUNT(DISTINCT Customer_Name) AS Total_Customers,
    SUM(Qty) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Gross_Sales,
    ROUND(SUM(Discount_Amount), 2) AS Total_Discount,
    ROUND(SUM(Net_Amount), 2) AS Total_Net_Sales,
    ROUND(AVG(Net_Amount), 2) AS Average_Order_Value,
    ROUND(
        SUM(Discount_Amount) /
        NULLIF(SUM(Sales), 0) * 100,
        2
    ) AS Discount_Percentage,
    ROUND(
        100.0 *
        SUM(CASE
            WHEN Order_Status = 'Cancelled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS Cancellation_Percentage,
    ROUND(AVG(Delivery_Days), 2) AS Average_Delivery_Days
FROM orders;



-- ============================================
-- BUSINESS INSIGHTS
-- ============================================

-- Insight 1:
-- Identify the category generating the highest net sales.
-- This helps determine the strongest product category.

-- Insight 2:
-- Identify the top customers by total spending.
-- This helps understand high-value customers and retention opportunities.

-- Insight 3:
-- Identify products with high sales volume and high net sales.
-- These products can be considered key products for the business.

-- Insight 4:
-- Analyze states with high net sales and order volume.
-- This helps identify strong-performing geographic markets.

-- Insight 5:
-- Compare discounted and non-discounted orders.
-- This helps evaluate the relationship between discounts and net sales.

-- Insight 6:
-- Analyze cancelled orders and the cancellation percentage.
-- A high cancellation rate may indicate an area requiring further investigation.

-- Insight 7:
-- Analyze average delivery time by order status.
-- This can help identify potential delivery-performance issues.