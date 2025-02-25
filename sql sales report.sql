-- TOTAL SALES AND REVENUE 
SELECT SUM(order_quantity*unit_price) AS TOTAL_Revenue, 
		SUM(order_quantity * unit_price - unit_cost * order_quantity) AS PROFIT, year
FROM sales
GROUP BY year;


-- TOP SELLING PRODUCTS BY YEAR
WITH yearly_sales AS (
    SELECT 
        product,
        year,
        SUM(order_quantity) AS total_units_sold,
        SUM(order_quantity * unit_price - unit_cost * order_quantity) AS profit
    FROM sales
    GROUP BY product, year
),
ranked_products AS (
    SELECT 
        product,
        year,
        total_units_sold,
        profit,
        RANK() OVER (PARTITION BY year ORDER BY total_units_sold DESC) AS rank
    FROM yearly_sales
)
SELECT 
    product,
    year,
    total_units_sold,
    profit
FROM ranked_products
WHERE rank = 1;


-- SALES BY REGION
SELECT country, product_category,
		SUM(order_quantity) AS total_units_sold_2011_2016,
        SUM(order_quantity * unit_price - unit_cost * order_quantity) AS profit_2011_2016
FROM sales
GROUP BY country, product_category
order by country desc;


-- MONTHLY SALES TREND PROFIT
SELECT month,
		SUM(order_quantity) AS total_units_sold_2011_2016,
        SUM(order_quantity * unit_price - unit_cost * order_quantity) AS profit_2011_2016
FROM sales
GROUP BY month
ORDER BY profit_2011_2016 desc;


-- MONTHLY SALES TREND REVENUE
SELECT month, 
		month,
		SUM(order_quantity * unit_price) as monthly_revenue 
FROM SALES 
GROUP BY month
order by monthly_revenue desc;

-- CUSTOMER SEGMENTATION 
SELECT customer_gender, COUNT(customer_gender) as gender 
FROM sales
GROUP BY customer_gender
order by customer_gender desc;


-- MOST PRODUCT ORDERED BY MALE AND FEMALE CLIENTS 
WITH popular_product AS (
    SELECT 
	customer_gender,
        product,
        year,
        SUM(order_quantity) AS total_units_sold
    FROM sales
    GROUP BY product, year, customer_gender
),
ranked_products AS (
    SELECT 
		customer_gender,
        product,
        year,
        total_units_sold,
        RANK() OVER (PARTITION BY customer_gender, year ORDER BY total_units_sold DESC) AS rank
    FROM popular_product
)
SELECT 
	customer_gender,
    product,
    year,
    total_units_sold
FROM ranked_products
WHERE rank = 1;


-- WHAT IS THE MOST FREQUENT AGE GROUP OF OUR CLIENTS 
SELECT customer_age, COUNT(customer_age) as no_of_customers
FROM sales 
GROUP BY customer_age
ORDER BY no_of_customers desc;


-- CUSTOMERS AGE GROUP 
SELECT 
    CASE 
        WHEN customer_age < 25 THEN 'Youth'
        WHEN customer_age >= 25 AND customer_age <= 34 THEN 'Young_adults'
        WHEN customer_age >= 35 AND customer_age <= 64 THEN 'Adults'
        ELSE 'Senior' 
    END AS age_group,
    COUNT(*) AS count_per_group
FROM sales
GROUP BY 
    CASE 
        WHEN customer_age < 25 THEN 'Youth'
        WHEN customer_age >= 25 AND customer_age <= 34 THEN 'Young_adults'
        WHEN customer_age >= 35 AND customer_age <= 64 THEN 'Adults'
        ELSE 'Senior' 
    END
ORDER BY count_per_group desc;



