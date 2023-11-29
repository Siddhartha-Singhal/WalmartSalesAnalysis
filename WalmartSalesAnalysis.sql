-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
select city, avg(vat) as TotalVAT
from sales
group by city
order by TotalVAT desc;

-- Which customer type pays the most in VAT?
select customer_type, avg(vat) as VAT
from sales
group by customer_type
order by VAT desc;

-- How many unique customer types does the data have?
select distinct customer_type, count(customer_type) as custCount
from sales
group by customer_type;

-- How many unique payment methods does the data have?
select payment_methods, count(payment_methods) as payMethods
from sales
group by payment_methods
order by  payMethods desc;

-- What is the most common customer type?
select customer_type, count(customer_type) as CustType
from sales
group by customer_type
order by CustType desc;

-- Which customer type buys the most?
select customer_type, sum(total) as totalPurchase, count(customer_type)
from sales
group by customer_type
order by totalPurchase desc;

-- What is the gender of most of the customers?
select gender, count(gender) as GenderCount
from sales
group by gender
order by GenderCount desc;

-- What is the gender distribution per branch?
select branch, gender, count(gender) as genderDistribution
from sales
group by branch, gender
order by branch;

-- Which time of the day do customers give most ratings?
select time_of_day, count(rating) as ratingCount
from sales
group by time_of_day
order by ratingCount desc;

-- Which time of the day do customers give most ratings per branch?
select time_of_day, branch, count(rating) as ratingCount
from sales
group by time_of_day, branch
order by ratingCount desc;

-- Which day fo the week has the best avg ratings?
select day_name, round(avg(rating), 3) as AvgRating
from sales
group by day_name
order by AvgRating desc;

-- Which day of the week has the best average ratings per branch?
select day_name, round(avg(rating), 3) as AvgRating
from sales
where branch = 'C'
group by day_name
order by AvgRating desc;
















