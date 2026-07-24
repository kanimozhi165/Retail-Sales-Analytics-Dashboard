-- =====================================================
-- KPI Question 1
-- Business Requirement:
-- The CEO wants to know the company's total sales.
-- =====================================================
SELECT SUM(sales) AS total_sales FROM global_superstore;

-- =====================================================
-- KPI Question 2
-- Business Requirement:
-- The CEO wants to know the company's total profit.
-- =====================================================
SELECT SUM(profit) AS total_profit FROM global_superstore;

-- =====================================================
-- KPI Question 3
-- Business Requirement:
-- The Operations Team wants to know the total number
-- of orders placed by customers.
-- =====================================================
SELECT 
COUNT(DISTINCT order_id) AS total_orders
FROM global_superstore;

-- =====================================================
-- KPI Question 4
-- Business Requirement:
-- The Sales Director wants to know the Average Order
-- Value (AOV) of the company.
-- =====================================================
SELECT
    SUM(sales) / COUNT(DISTINCT order_id) AS average_order_value
FROM global_superstore;

-- =====================================================
-- KPI Question 5
-- Business Requirement:
-- The Finance Team wants to calculate the company's
-- Profit Margin (%).
-- Formula:
-- Profit Margin = (Total Profit / Total Sales) * 100
-- =====================================================
SELECT
(SUM(profit) / SUM(sales)) * 100 AS profit_margin 
FROM global_superstore;

-- =====================================================
-- KPI Question 6
-- Business Requirement:
-- The CEO wants to see the Total Sales for each Month.
-- =====================================================
SELECT 
YEAR(order_date) AS order_year,
MONTH(order_date) AS month_no,
MONTHNAME(order_date) AS order_month,
SUM(sales) AS total_sales
FROM global_superstore
GROUP BY order_year, month_no, order_month
ORDER BY order_year, month_no;

-- =====================================================
-- KPI Question 7
-- Business Requirement:
-- The Finance Team wants to calculate the
-- Month-over-Month (MoM) Sales Growth (%).
-- =====================================================
WITH monthly_sales AS
(
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sales) AS total_sales
    FROM global_superstore
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)

SELECT
    order_year,
    order_month,
    total_sales,
    LAG(total_sales) OVER
    (
        ORDER BY order_year, order_month
    ) AS previous_month_sales,
    (
        (
            total_sales -
            LAG(total_sales) OVER
            (
                ORDER BY order_year, order_month
            )
        )
        /
        LAG(total_sales) OVER
        (
            ORDER BY order_year, order_month
        )
    ) * 100 AS mon_growth_percentage
FROM monthly_sales;

-- =====================================================
-- KPI Question 8
-- Business Requirement:
-- The Management Team wants to calculate the
-- Year-to-Date (YTD) Sales.
-- =====================================================

SELECT
    order_date,
    sales,
    SUM(sales) OVER
    (
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
    ) AS ytd_sales
FROM global_superstore;

-- =====================================================
-- KPI Question 9
-- Business Requirement:
-- The Management Team wants to calculate the
-- Month-to-Date (MTD) Sales.
-- =====================================================

SELECT
    order_date,
    sales,
    SUM(sales) OVER
    (
        PARTITION BY
            YEAR(order_date),
            MONTH(order_date)
        ORDER BY order_date
    ) AS mtd_sales
FROM global_superstore;

-- =====================================================
-- KPI Question 10
-- Business Requirement:
-- The Sales Team wants to identify the Top 5 Customers
-- based on Total Sales.
-- =====================================================

SELECT
    customer_name,
    SUM(sales) AS total_sales
FROM global_superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;


