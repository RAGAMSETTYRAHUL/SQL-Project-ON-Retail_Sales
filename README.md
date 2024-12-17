**Retail Sales Analysis SQL Project**

Project Overview

Project Title: Retail Sales Analysis

Level: Beginner

Database:SQL_PROJECT1;

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

Objectives

Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.
Project Structure

1. Database Setup
Database Creation: The project starts by creating a database named p1_retail_db.

Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

2. Data Exploration & Cleaning

Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

    
3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

#Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'?

select * from retail_sales
where sale_date= '2022-11-05';

#Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales
where category= 'Clothing' and quantity>=4 and month(sale_date)=11;

#or

select * from retail_sales
where category= 'Clothing' and quantity>=4 and sale_date BETWEEN '2022-11-01' AND '2022-11-30';


#Q.3 Write a SQL query to calculate the total sales (total_sale) for each category?

select category,sum(total_sale) as total_sales from retail_sales
group by  category
order by total_sales desc;

 
#Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?

select category,Round(avg(age)) as Avg_Age from retail_sales
where category='Beauty' 
group by category
order by Avg_Age desc;

#Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000?

select *  from retail_sales
where total_sale>1000;

#Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?

select  category,gender,COUNT(*) as total_trans from retail_sales
group by category,gender;

#Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?

-- Step 1: Calculate monthly average sales
WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_monthly_sale,
        SUM(total_sale) AS total_monthly_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),

-- Step 2: Identify the best-selling month for each year
BestSellingMonths AS (
    SELECT 
        year,
        month,
        total_monthly_sale,
        RANK() OVER (PARTITION BY year ORDER BY total_monthly_sale DESC) AS ranks
    FROM MonthlySales
)

-- Step 3: Output the results
SELECT 
    b.year,
    b.month,
    b.total_monthly_sale AS best_selling_month_sale
FROM BestSellingMonths b
WHERE b.ranks = 1;


#Q.8 Write a SQL query to find the top 5 customers based on the highest total sales?

select customer_id,Sum(total_sale) as Total_sale from retail_sales 
group by customer_id
order by customer_id 
limit 5;

#Q.9 Write a SQL query to find the number of unique customers who purchased items from each category?

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as unique_cus
FROM retail_sales
GROUP BY category;

#Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
ORDER BY shift;



Findings

Customer Demographics: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
High-Value Transactions: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
Sales Trends: Monthly analysis shows variations in sales, helping identify peak seasons.
Customer Insights: The analysis identifies the top-spending customers and the most popular product categories.

Reports

Sales Summary: A detailed report summarizing total sales, customer demographics, and category performance.
Trend Analysis: Insights into sales trends across different months and shifts.
Customer Insights: Reports on top customers and unique customer counts per category.

Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
