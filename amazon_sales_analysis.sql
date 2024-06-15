-- use  amazon_sales_data
-- select * from amazon_sales
 alter table amazon_sales
 change column `Rating` Rating float
alter table amazon_sales
modify column Payment varchar(255)
update amazon_sales
set Date=DATE_FORMAT(str_to_date(Date,'%d-%m-%Y'),'%Y-%m-%d')
--now we had completed the data wrangling task by
--changing datatypes of the  necessary columns.now we 
--will perform data analysis on the data.\



