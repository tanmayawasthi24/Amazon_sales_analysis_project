select * from amazon_sales;
alter table amazon_sales
change column `gross income` gross_income float;
alter table amazon_sales
modify column cogs float;
-- to change date format in date column
update amazon_sales
set Date=DATE_FORMAT(str_to_date(Date,'%d-%m-%Y'),'%Y-%m-%d');

-- we have changed the datatypes of the columns as well as column names 
-- that have spaces .
-- npw we will add column name
ALTER table amazon_sales#first added column  to the table
add column dayname varchar(50);
UPDATE amazon_sales
SET dayname = dayname(Date);
alter table amazon_sales
add  column month_name varchar(25);
update amazon_Sales
set month_name= monthname(Date);
-- adding timeofday column
alter table amazon_sales
add column timeofday varchar(25);
UPDATE amazon_Sales
SET timeofday =   case 
WHEN HOUR(time) >= 6 AND HOUR(time) < 12 THEN 'Morning'
WHEN HOUR(time) >= 12 AND HOUR(time) < 18 THEN 'Afternoon'
WHEN HOUR(time) >= 18 AND HOUR(time) < 24 THEN 'Evening'
END;

-- 4-Which payment method occurs most frequently?
select payment,count(*) as counts from amazon_sales
group by payment;
-- Ans-Ewallet
-- 5-Which product line has the highest sales?
-- Ans-Food and beverages
select product_line,round(sum(cogs)) as total_sales from amazon_sales
group by product_line
order by total_sales desc;


-- 6-How much revenue is generated each month?
select month_name,round(sum(total)) as total_revenue
from amazon_sales
group by month_name
order by total_revenue desc;


-- 7-In which month did the cost of goods sold reach its peak?
-- Ans-january  i will also show the productlines which have highest sales in each month. 
select month_name,round(sum(cogs)) as total_sales from amazon_sales
group by month_name
order by total_sales desc;
select product_line,round(sum(cogs)) as total_sales from amazon_sales
where month_name = 'March'
group by product_line
order by total_sales desc;
-- 8-In which city was the highest revenue recorded?

select city,round(sum(total)) as total_Sales from 
amazon_sales
group by city
order by total_sales desc;

-- 9-Which product line incurred the highest Value Added Tax?
select product_line,round(sum(Tax_5)) as total_tax 
from amazon_sales
group by product_line
order by total_tax desc;
-- Ans- Food and beverages
-- 10--For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad.
SELECT 
  product_line,
  SUM(total) AS total_sales,
  CASE 
    WHEN SUM(total) > (select avg(total) from amazon_sales) THEN 'Good'
    ELSE 'Bad'
  END AS sales_category
FROM 
  amazon_sales
GROUP BY 
  product_line
  order by total_sales desc ;
  -- every category performed good i.e above average
  
  
  -- Identify the branch that exceeded the average number of products sold.
select Branch,sum(Quantity) as sum_quantity from amazon_sales
group by Branch
order by sum_quantity desc;
-- Identify the branch that exceeded the average number of products sold.
-- Which product line is most frequently associated with each gender?

select gender,product_line,count(*) as counts from amazon_sales
group by gender,product_line 
order by product_line,counts desc;
-- i will show resultant table in  ppt and willl highlight who ordered more.

-- Calculate the average rating for each product line
select product_line,round(avg(rating),1) as avg_rating from amazon_sales
group by product_line
order by avg_rating desc;

-- Count the sales occurrences for each time of day on every weekday.
select dayname,timeofday,count(*) as sales_occurences
from amazon_sales 
group by dayname,timeofday
having dayname not in ('Saturday','Sunday')
order by dayname ,sales_occurences desc;

-- most sales occurred in afternoon in each weekday

-- Identify the customer type contributing the highest revenue
select Customer_type,round(sum(total)) from amazon_sales
group by Customer_type
order by sum(total) desc;

-- Determine the city with the highest VAT percentage
select city,round(sum(Tax_5)) from amazon_sales
group by city 
order by sum(Tax_5) desc;
-- Ans-Naypyitaw
-- Identify the customer type with the highest VAT payments
select Customer_type,round(sum(Tax_5),2) from amazon_sales
group by Customer_type
order by sum(Tax_5) desc;
-- What is the count of distinct customer types in the dataset?
-- What is the count of distinct payment methods in the dataset?
-- Which customer type occurs most frequently?
select  Customer_type,count(*) from amazon_sales
group by Customer_type;
--
-- Identify the customer type with the highest purchase frequency
select Customer_type,count(8) as purchase_freq from 
amazon_sales 
group by Customer_type
order by count(*) desc;

-- Determine the predominant gender among customers
select gender,count(*) from amazon_sales
group by gender
order by count(*) desc;


-----------------------------------------------
-- Examine the distribution of genders within each branch.
select gender,Branch,count(gender) from amazon_sales
group by gender,Branch
order by Branch,count(gender) desc;

-- Identify the time of day when customers provide the most ratings
select timeofday,count(rating) as most_rating
from amazon_sales 
group by timeofday
order by most_rating desc;
-- ans-afternoon
-- Determine the time of day with the highest customer ratings for each branch.
select Branch,timeofday,max(rating) 
from amazon_sales 
group by Branch,timeofday
order by Branch,max(rating) desc;
-- Ans-- so for each branch afternoon got hightest rating.

-- Identify the day of the week with the highest average ratings.
select dayname,round(avg(rating),2) as avg_rating from 
amazon_sales 
group by dayname
order by avg_rating desc;
-- Monday has the highest average rating.

-- Determine the day of the week with the highest average ratings for each branch

WITH AvgRatingByDay AS (
    SELECT
        Branch,
        dayname,
        AVG(rating) AS avg_rating
    FROM amazon_sales
    GROUP BY
        Branch,
        dayname
)
SELECT
    Branch,
    dayname,round(avg_rating,2) as high_avg_rating
FROM AvgRatingByDay
WHERE
    (Branch, avg_rating) IN (
        SELECT
            Branch,
            MAX(avg_rating)
        FROM AvgRatingByDay
        GROUP BY
            Branch
    );


