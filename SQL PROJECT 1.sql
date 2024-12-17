Create database SQL_PROJECT1;
USE SQL_PROJECT1;

#SQL Retail Sales P1

#create Table

Create Table  retail_sales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age	int,
category varchar(20),	
quantity int,
price_per_unit float,
cogs float,
total_sale float
);

#Count the Records
SELECT COUNT(*) FROM retail_sales;

#Check for NUll Values

SELECT * FROM retail_sales
WHERE transactions_id IS NULL OR
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
#Delete Null Values

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;    


#S2-Data Exploration

#How many Sales We have

SELECT count(*) as Total_Sales FROM retail_sales;

#How many Customers we have?

SELECT count(distinct(customer_id)) as Unique_Customers FROM retail_sales;

#How many Categories we have?

SELECT distinct(category) FROM retail_sales;


#S3.Business Analysis By Q & alter

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


