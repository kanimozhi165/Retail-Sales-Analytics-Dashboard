-- =====================================================
-- Question 1
-- Business Requirement:
-- The Sales Director wants to identify all customers
-- whose total sales are greater than the average
-- customer sales.
-- =====================================================
WITH customer_total_sales AS (
SELECT 
customer_name,
SUM(sales) AS total_sales 
FROM global_superstore 
GROUP BY customer_name
),
customer_average_sales AS (
SELECT 
AVG(total_sales) AS avg_sales
FROM customer_total_sales)
SELECT 
cts.customer_name,
cts.total_sales
FROM customer_total_sales cts
CROSS JOIN customer_average_sales cas
WHERE cts.total_sales > cas.avg_sales;

-- =====================================================
-- Question 2
-- Business Requirement:
-- The Regional Sales Manager wants to identify the
-- highest-selling customer in each region.
-- =====================================================
WITH customer_region_total_sales AS (
SELECT 
region,
customer_name,
SUM(sales) AS total_sales
FROM global_superstore
GROUP BY region, customer_name
),
region_customer_highest_rank AS (
SELECT 
region,
customer_name,
total_sales,
DENSE_RANK() OVER(PARTITION BY region ORDER BY total_sales DESC) AS rank_value
FROM customer_region_total_sales )
SELECT * FROM region_customer_highest_rank
WHERE rank_value = 1;
-- ORDER BY total_sales DESC;

-- =====================================================
-- Question 3
-- Business Requirement:
-- The Sales Manager wants to identify the top 3
-- highest-selling products in each category.
-- =====================================================
WITH product_category_sales AS (
SELECT 
category,
product_name,
SUM(sales) AS total_sales 
FROM global_superstore
GROUP BY category, product_name
),
top_3_highest_product_category_sales AS (
SELECT 
category,
product_name,
total_sales,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_sales DESC) AS row_num
FROM product_category_sales)
SELECT * FROM top_3_highest_product_category_sales
WHERE row_num <=3;

-- =====================================================
-- Question 4
-- Business Requirement:
-- The Finance Manager wants to identify all categories
-- whose total profit is greater than the average total
-- profit across all categories.
-- =====================================================
WITH category_total_profit AS (
SELECT 
category,
SUM(profit) AS total_profit 
FROM global_superstore
GROUP BY category 
),
category_average_total_profit AS (
SELECT 
AVG(total_profit) AS avg_profit 
FROM category_total_profit
)
SELECT 
ctp.category,
ctp.total_profit 
FROM category_total_profit ctp
CROSS JOIN category_average_total_profit catp
WHERE ctp.total_profit > catp.avg_profit;

-- =====================================================
-- Question 5
-- Business Requirement:
-- The Sales Director wants to identify customers who
-- have placed more than 10 orders and whose total sales
-- exceed ₹20,000.
-- =====================================================
SELECT 
customer_name,
COUNT(*) AS total_orders,
SUM(sales) AS total_sales
FROM global_superstore
GROUP BY customer_name
HAVING total_orders > 10 AND total_sales > 20000;

-- =====================================================
-- Question 6
-- Business Requirement:
-- The Regional Manager wants to identify the top
-- 2 customers by total profit in each region.
-- =====================================================
WITH region_profit AS (
SELECT 
region,
customer_name,
SUM(profit) AS total_profit
FROM global_superstore
GROUP BY region, customer_name
),
region_rank AS (
SELECT 
region,
customer_name,
total_profit,
DENSE_RANK() OVER(PARTITION BY region ORDER BY total_profit DESC) AS rank_num
FROM region_profit
)
SELECT * FROM region_rank
WHERE rank_num <=2;

-- =====================================================
-- Question 7
-- Business Requirement:
-- The Operations Manager wants to identify customers
-- who have purchased products from more than 3
-- different categories.
-- =====================================================
SELECT 
customer_name,
COUNT(DISTINCT category) AS category_count
FROM global_superstore
GROUP BY customer_name
HAVING COUNT(DISTINCT category) >=3;

-- =====================================================
-- Question 8
-- Business Requirement:
-- The Sales Director wants to identify the month
-- with the highest total sales.
-- =====================================================
SELECT 
MONTHNAME(order_date) AS month_order,
SUM(sales) AS total_sales
FROM global_superstore
GROUP BY month_order
ORDER BY total_sales DESC
LIMIT 1;

-- =====================================================
-- Question 9
-- Business Requirement:
-- The Finance Team wants to identify products whose
-- total profit is below the average profit of all
-- products.
-- =====================================================
WITH product_profit AS (
SELECT 
product_name,
SUM(profit) AS total_profit
FROM global_superstore
GROUP BY product_name
),
product_average_profit AS (
SELECT 
AVG(total_profit) AS avg_profit
FROM product_profit 
)
SELECT
pp.product_name,
pp.total_profit
FROM product_profit pp
CROSS JOIN product_average_profit pap
WHERE pp.total_profit < pap.avg_profit;

-- =====================================================
-- Question 10
-- Business Requirement:
-- The Regional Sales Manager wants to identify the
-- highest-selling product in each region.
-- =====================================================
WITH region_product_sales AS (
SELECT 
region, 
product_name,
SUM(sales) AS total_sales
FROM global_superstore
GROUP BY region, product_name
),
product_sale_rank AS (
SELECT 
region,
product_name,
total_sales,
DENSE_RANK() OVER(PARTITION BY region ORDER BY total_sales DESC) AS rank_num
FROM region_product_sales
)
SELECT * FROM product_sale_rank
WHERE rank_num = 1;
