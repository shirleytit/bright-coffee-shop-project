SELECT MIN(transaction_date) AS start_dt,
       MAX(transaction_date) AS last_dt 
FROM salesproject.default.sales;
-- This is to check my data, how it looks like before I start processing
SELECT * 
FROM salesproject.default.sales 
LIMIT 100;

-- How many stores do we have?
-- to check the name of the stores locations that i have
SELECT DISTINCT store_location
FROM salesproject.default.sales;

-- What is the period of this data?
-- when did we start collecting this data, and when last did we collect the last record
SELECT MIN(transaction_date) AS start_dt,
       MAX(transaction_date) AS last_dt 
FROM salesproject.default.sales;

-- What are the business hours of the shop?
SELECT MIN(transaction_time) AS opening_time,
       MAX(transaction_time) AS closing_time 
FROM salesproject.default.sales;

-- how many different products are we selling in total?
SELECT  COUNT(DISTINCT product_id)AS number_of_products
FROM salesproject.default.sales;

-- How many products are we selling per store?
SELECT  store_location,
        COUNT(DISTINCT product_id)AS number_of_products
FROM salesproject.default.sales
GROUP BY store_location;

-- What are the different product category we have?
SELECT DISTINCT product_category, product_type, product_detail
FROM salesproject.default.sales
WHERE product_category IN ('Coffee')
ORDER BY product_type;

  SELECT 
    transaction_date,
    DAYNAME(transaction_date) AS Day_name,
    MONTHNAME(transaction_date) AS Month_name,
    COUNT(transaction_id) AS number_of_sales,
    SUM(transaction_qty) AS units_sold,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(store_id) AS number_of_stores,
    SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS revenue,

    CASE 
        WHEN DAYNAME(transaction_date) IN ('Sat','Sun') THEN 'Weekend'
        WHEN DAYNAME(transaction_date) IN ('Mon','Tues','Wed','Thurs','Fri') THEN 'Weekday'
    END AS day_classification,

    CASE 
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
       WHEN transaction_time BETWEEN '18:00:00' AND '20:59:59' THEN 'Evening'
    END AS time_classification,  

    store_location,
    product_category,
    product_type,
    product_detail

FROM salesproject.default.sales

GROUP BY 
    transaction_date,
    month_name,
    day_classification,
    time_classification,
    store_location,
    product_category,
    product_type,
    product_detail;
-- Daily Trend
SELECT transaction_date, 
COUNT(DISTINCT transaction_id) AS total_sales 
FROM salesproject.default.sales 
GROUP BY transaction_date
ORDER BY transaction_date;

-- Hourly Trend
SELECT transaction_time, 
COUNT(DISTINCT transaction_id) AS total_sales 
FROM salesproject.default.sales 
GROUP BY transaction_time 
ORDER BY transaction_time;

-- Top 5 Stores by Revenue
SELECT store_location, 
SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS total_revenue 
FROM salesproject.default.sales 
GROUP BY store_location 
ORDER BY total_revenue DESC
LIMIT 5;

-- Percentage of Drink Sales by Category
SELECT product_category, 
COUNT(DISTINCT transaction_id) AS total_sales, 
COUNT(DISTINCT transaction_id) * 100.0 / (SELECT COUNT(DISTINCT transaction_id) FROM salesproject.default.sales) AS percentage 
FROM salesproject.default.sales 
GROUP BY product_category 
ORDER BY percentage DESC
LIMIT 5;

-- Top 5 Products by Revenue
SELECT product_detail, 
SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS total_revenue 
FROM salesproject.default.sales 
GROUP BY product_detail 
ORDER BY total_revenue DESC
LIMIT 5;


-- Percent of Drink Sales by Size
SELECT product_type, 
COUNT(DISTINCT transaction_id) AS total_sales, 
COUNT(DISTINCT transaction_id) * 100.0 / (SELECT COUNT(DISTINCT transaction_id) FROM salesproject.default.sales) AS percentage 
FROM salesproject.default.sales 
GROUP BY product_type 
ORDER BY percentage DESC
LIMIT 5;

-- Total Drinks sold by Category
SELECT product_category, 
COUNT(DISTINCT transaction_id) AS total_sales 
FROM salesproject.default.sales 
GROUP BY product_category 
ORDER BY total_sales DESC
LIMIT 5;

-- 5 Best Sellers by total drinks sold
SELECT product_detail, 
COUNT(DISTINCT transaction_id) AS total_sales 
FROM salesproject.default.sales 
GROUP BY product_detail 
ORDER BY total_sales DESC
LIMIT 5;

-- 5 Worst Sellers by total drinks sold
SELECT product_detail, 
COUNT(DISTINCT transaction_id) AS total_sales 
FROM salesproject.default.sales 
GROUP BY product_detail 
ORDER BY total_sales ASC
LIMIT 5;
