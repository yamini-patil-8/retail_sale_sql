CREATE DATABASE retail_sales;

CREATE TABLE sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(20),	
	age	INT,
	category VARCHAR(20),	
	quantiy	INT,
	price_per_unit INT,	
	cogs INT,
	total_sale INT
);
SELECT count(*) FROM sales;

select * from sales
limit 10;

#checking null values
SELECT * FROM sales
WHERE transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null 
or price_per_unit is null
or cogs is null
or total_sale is NULL;

### DATA EPLORATION 
# how many sales we have?
select count(*) as TOtal_Sales
from sales;

## how many unique customer we have?
select count(DISTINCT customer_id) as TOtal_Sales
from sales;

## how many unique categoery we have?
select distinct category from sales;

## Data Analysis & Bussiness key problems & Answer

# My Anlysis and finding 
# 1) write a sql query to retrive all column for sales made on 2022-11-05.
# 2) write a sql query to retrive all transaction where all the category is 'clothing' and the quantity sold is more than 10 in the month of nov-2022.
# 3) write a sql query to calculate for total sales each category.
# 4) write a sql query to find the average age of customer who purchased items from the 'Beauty' category.
# 5) write a sql query to find all transaction where the total sale is greater than 1000.
# 6) write a sql query to find total number of transaction made by each gender in each category.
# 7) write a sql query to calculate average sale for each momth. find out best selling month in each year.
# 8) write a sql query to find the top 5 customer baesd on the highest total sales.
# 9) write a sql query to find the number of unique customer who purchse item from each category.
# 10) write a sql query to create each shift and number of order (Example Morning<=12, Afternoon between 12 & 17, Evening >17).

# 1) write a sql query to retrive all column for sales made on 2022-11-05.
SELECT * 
FROM  sales 
WHERE sale_date ='05-11-2022';

# 2) write a sql query to retrive all transaction where all the category is 'clothing' and the quantity sold is more than 4 in the month of nov-2022.
SELECT * FROM sales
WHERE category = 'clothing'
  AND DATE_FORMAT(STR_TO_DATE(sale_date, '%d-%m-%Y'), '%Y-%m') = '2022-11'
  AND quantiy >= 4;

# 3) write a sql query to calculate for total sales each category.
SELECT category,
SUM(total_sale) as net_sale,
count(*) as total_orders
FROM sales
group by 1;

# 4) write a sql query to find the average age of customer who purchased items from the 'Beauty' category.
SELECT AVG(age)
FROM sales
WHERE category = 'Beauty';

# 5) write a sql query to find all transaction where the total sale is greater than 1000.
SELECT * FROM sales
WHERE total_sale >1000;

# 6) write a sql query to find total number of transaction made by each gender in each category.
SELECT  category,gender,
COUNT(*) AS total_transaction
FROM sales
GROUP BY category, gender
ORDER BY 1;

# 7) write a sql query to calculate average sale for each momth. find out best selling month in each year.
-- Step 1: Calculate the total sales for each month and year
SELECT year, month, avg_sale
FROM 
(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank_
FROM sales 
GROUP BY year, month
) as t1
WHERE rank_= 1;
#ORDER BY year, month;


# 8) write a sql query to find the top 5 customer baesd on the highest total sales.
SELECT  customer_id,
SUM(total_sale) as total_sales
FROM sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

# 9) write a sql query to find the number of unique customer who purchse item from each category.
SELECT category,
COUNT(DISTINCT customer_id)
FROM sales
GROUP BY category;

# 10) write a sql query to create each shift and number of order (Example Morning<=12, Afternoon between 12 & 17, Evening >17).
 

SELECT EXTRACT(HOUR FROM CURRENT_TIME)
;






WITH hourlysale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourlysale
GROUP BY shift;
--------END PROJECT---------