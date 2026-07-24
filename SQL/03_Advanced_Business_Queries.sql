-- =====================================================
-- Question 1
-- Business Requirement:
-- The CEO wants to identify the top 5 customers
-- based on total sales across all regions.
-- =====================================================
SELECT 
customer_name,
SUM(sales) AS total_sales 
FROM global_superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;

-- =====================================================
-- Question 2
-- Business Requirement:
-- The Finance Team wants to calculate the cumulative
-- (running) sales over time.
-- =====================================================
SELECT 
order_date,
sales,
SUM(sales) OVER(ORDER BY order_date) AS running_sales
FROM global_superstore;

-- =====================================================
-- Question 3
-- Business Requirement:
-- The Sales Director wants to compare each order's
-- sales with the previous order's sales to identify
-- whether sales increased or decreased.
-- =====================================================
SELECT 
order_date,
sales,
LAG(sales) OVER(ORDER BY order_date) AS previous_sales
FROM global_superstore;

-- =====================================================
-- Question 4
-- Business Requirement:
-- The Sales Director wants to know how much each
-- order's sales changed compared to the previous order.
-- =====================================================
SELECT
    order_date,
    sales,
    LAG(sales) OVER(ORDER BY order_date) AS previous_sales,
    sales - LAG(sales) OVER(ORDER BY order_date) AS sales_difference
FROM global_superstore;

-- Using CTE
WITH sales_data AS (
    SELECT
        order_date,
        sales,
        LAG(sales) OVER(ORDER BY order_date) AS previous_sales
    FROM global_superstore
)
SELECT
    order_date,
    sales,
    previous_sales,
    sales - previous_sales AS sales_difference
FROM sales_data;

-- =====================================================
-- Question 5
-- Business Requirement:
-- The Sales Director wants to know the sales of the
-- next order for comparison and forecasting.
-- =====================================================
SELECT 
order_date,
sales,
LEAD(sales) OVER(ORDER BY order_date) AS next_sales
FROM global_superstore;

-- =====================================================
-- Question 6
-- Business Requirement:
-- The Finance Team wants to calculate the
-- Month-over-Month (MoM) sales growth.
-- =====================================================
WITH monthly_sales AS (
    SELECT
        MONTH(order_date) AS month_no,
        MONTHNAME(order_date) AS month_order,
        SUM(sales) AS total_sales
    FROM global_superstore
    GROUP BY
        month_no,
        month_order
)
SELECT
    month_order,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month_no) AS previous_month_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY month_no) AS monthly_growth
FROM monthly_sales;

-- =====================================================
-- Question 7
-- Business Requirement:
-- The Sales Manager wants to identify the highest-selling
-- product in each category.
-- =====================================================
WITH highest_product_sales AS (
SELECT
category,
product_name,
SUM(sales) AS total_sales 
FROM global_superstore
GROUP BY 
category, product_name
),
ranked_product_sales AS (
SELECT 
category,
product_name,
total_sales,
DENSE_RANK() OVER(PARTITION BY category ORDER BY total_sales DESC) AS rank_num
FROM highest_product_sales
)
SELECT * FROM ranked_product_sales
WHERE rank_num =1;

-- =====================================================
-- Question 8
-- Business Requirement:
-- The Sales Director wants to identify the top 3
-- customers by profit in each region.
-- =====================================================
WITH region_profit AS (
SELECT 
region,
customer_name,
SUM(profit) AS total_profit
FROM global_superstore
GROUP BY region, customer_name
),
ranked_region_profit AS (
SELECT 
region,
customer_name,
total_profit,
DENSE_RANK() OVER(PARTITION BY region ORDER BY total_profit DESC) AS rank_num
FROM region_profit
)
SELECT * FROM ranked_region_profit
WHERE rank_num <=3;

-- =====================================================
-- Question 9
-- Business Requirement:
-- The Management Team wants to identify customers whose
-- total sales increased compared to their previous order.
-- =====================================================
WITH customer_sales AS (
    SELECT
        customer_name,
        order_date,
        sales,
        LAG(sales) OVER (
            PARTITION BY customer_name
            ORDER BY order_date
        ) AS previous_sales
    FROM global_superstore
)
SELECT
    customer_name,
    order_date,
    sales,
    previous_sales
FROM customer_sales
WHERE sales > previous_sales;

-- =====================================================
-- Question 10
-- Business Requirement:
-- The CEO wants to identify the product that generated
-- the highest profit in each sub-category.
-- =====================================================
WITH product_profit AS (
SELECT 
sub_category,
product_name,
SUM(profit) AS total_profit
FROM global_superstore
GROUP BY sub_category, product_name
),
ranked_product_profit AS (
SELECT 
sub_category,
product_name,
total_profit,
DENSE_RANK() OVER(PARTITION BY sub_category ORDER BY total_profit DESC) AS rank_num
FROM product_profit
)
SELECT * FROM ranked_product_profit
WHERE rank_num =1;