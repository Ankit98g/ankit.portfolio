select * from amazon;
 
 -- count of distinct cities in dataset
 select count(distinct city) as distinct_cities from amazon;
 
 
 -- for each branch, what is the corresponding city?
 select branch,city from amazon
 group by 1,2;
 
 -- what is the count of distinct product lines in the dataset?
 select count(distinct product_line) as product_lines from amazon;
 
 -- which payment occur most frequently?
 select payment,count(payment) as payment_count from amazon
 group by payment; 
 
 -- which product line has the highest sales?
 select product_line, round(sum(total),2) as total_sales from amazon 
 group by product_line
 order by total_sales desc
 limit 1;
 
 -- how much revenue is generated each month?
 select month_name , round(sum(total),2) as sales_month from amazon
 group by month(date), month_name 
order by month(date);
 
 -- in which month did the cost of goods sold ?
 select month_name, round(sum(cogs),2) as total_cogs
 from amazon 
 group by month_name 
 order by total_cogs desc
 limit 1;
 
 
 -- which product line generated the highest revenue?
 select product_line , round(sum(total),2) as total_revenue from amazon 
 group by product_line
 order by total_revenue desc
 limit 1;
 
 
 -- in which city highest revenue recorded?
 select city,round(sum(total),2) as total_revenue
 from amazon 
 group by city
 order by total_revenue desc
 limit 1;
 
 
 -- which product line incurred the highest vat?
 select product_line, sum(tax_5) as total_vat
 from amazon 
 group by product_line
 order by total_vat desc
 limit 1;

 -- identify the  branch that exceed the avg no of products sold?
 with cte as
 (select 
        avg(quantity) as avg_quantity
from amazon),
branch_performance as (
       select b.branch, 
               case when b.quantity > cte.avg_quantity then 'exceeded avg'
                         else ' below avg' 
				end as performance
                from amazon b
                inner join cte on 1=1
                group by 1,2
)
select branch
from branch_performance
where performance = 'exceeded avg' ;
 
 -- which product line is most frequently associated with each gender?
 select gender , product_line, count(*) as product_count
 from amazon
 group by gender, product_line
 order by product_count desc;
 
 -- calculate the avg rating for each product line.
select product_line , round(avg(rating),2) as avg_rating 
 from amazon 
 group by 1
 order by avg_rating desc; 
 
 -- count the sales occurences for each time of day on every weekday
 select dayname , timeofday, count(*) as sales_count
 from amazon
 where dayofweek(date) between 2 and 6
 group by dayname,timeofday
 order by 1,2;

-- identify the customer type contributing the highest revenue.
select customer_type , round(sum(total),2) as total_sales 
from amazon
group  by 1 
order by 2 desc
limit 1;


-- determine the city with highest vat percentage.
select city , (sum(tax_5)/(select sum(tax_5) from amazon))*100.0 as per_vat
from amazon 
group by city 
order by per_vat desc
limit 1;
-- identify the customer type with the highest vat percentage.
select customer_type,count(tax_5) as total_vat
from amazon 
group by 1
order by 2 desc
limit 1;

-- what is the count of distinct customer types in dataset?
select count(distinct customer_type) as cnt_customer 
from amazon;


-- what is the count of distinct payment methods in the dataset?
select count(distinct payment) as total_cost_payment 
from amazon;

-- which customer type which has highest purchase frequency.
select customer_type ,count(*) as purchase_count
from amazon 
group by customer_type
order by purchase_count desc;

-- determine the gender among customers.
select gender ,count(*) as customer_count from amazon
group by gender
order by customer_count desc
limit 1; 


-- examine the distribution of genders within each branch.
select branch,gender ,count(gender) as count_gender from amazon
group by branch , gender
order by branch; 


-- identify the time of day when customers provide most ratings.
select timeofday, count(rating) as count_of_rating 
from amazon
group by 1
order by 2 desc
limit 1;   


-- determine the time of day with the highest customer rating for each branch
with cte as (
      select branch,timeofday, avg(rating) as avg_rating
      from amazon
      group by branch,timeofday
)
select branch,timeofday,round(avg_rating,2) as cust_ratings
from(
     select branch,timeofday,avg_rating,
     row_number() over (partition by branch order by avg_rating desc) as rn
     from cte
)as ranking 
where 
rn = 1;

-- identify thw day of the week with the highest avg ratings.
select dayname, round(avg(rating),2) as avg_rating
from amazon 
group by dayname 
order by avg_rating desc
limit 1;  


-- determine the day of the week with the highest average rating for each branch
with cte as
(select branch,dayname,avg(rating) as avg_rating,row_number() over(partition by branch order by avg(rating) desc) as row_num
from(
     select branch,dayname,rating 
     from amazon
) as daily_ratings
group by branch,dayname 

)
select branch,dayname,round(avg_rating,2) as highest_avg_rating from cte where row_num=1
group by branch,dayname 
order by branch, avg_rating desc;
