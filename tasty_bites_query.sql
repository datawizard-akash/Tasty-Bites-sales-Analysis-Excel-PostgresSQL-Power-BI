create table tasty_bites
(
order_id char(7) primary key,
order_date DATE,
productI_id varchar(10),
product_name varchar(20),
category varchar(10),
quantity int8,
unit_price int,
cost_per_unit int,
discount decimal(10,2),
customer_type varchar(10),
payment_mode varchar(10)
)


-- Imported datset from csv file
select * from tasty_bites

--1. Which top products generated the highest revenue?

select product_name, sum(quantity * unit_price) as revenue
from tasty_bites
group by 1
order by 2 desc;

--2. Total quantity sold per product.
select product_name, sum(quantity)
from tasty_bites
group by 1
order by 2 desc;

-- 3.Profit Margin per Product?

select product_name,
		sum(quantity * unit_price) as revenue,
		sum((quantity * unit_price) - (quantity * cost_per_unit)) as profit,
		round((sum(quantity * unit_price) - sum(quantity * cost_per_unit))/ sum(quantity * unit_price),2) as profit_margin
from tasty_bites
group by 1

--4. Discount Impact: Profit loss due to discounts.

with my_cte as 
(
select category, product_name,
		(sum(quantity * unit_price) - sum(quantity * cost_per_unit)) as profit_loss,
		(sum(quantity * unit_price) - sum(quantity * cost_per_unit)) - sum(discount) as profit_after_discount
from tasty_bites
group by 1,2
)
select category,product_name, profit_loss, profit_after_discount,
		(sum(profit_loss) - sum(profit_after_discount)) as loss_amount
from my_cte
group by 1,2,3,4
order by loss_amount desc;


--5. Average order value (AOV)?

select round(sum(quantity * unit_price) / count(distinct order_id),2) as AOV
from tasty_bites


--6. Contribution to Total Profit: Percentage contribution of each product to overall profit?

with product_profit as 
(
select product_name,
		(sum(quantity * unit_price) - sum(quantity * cost_per_unit)) as product_profit
from tasty_bites
group by 1
),
total_profit as 
(
select sum(product_profit) as total_profit
from product_profit
)
select p.product_name,
		p.product_profit,
		concat(round(p.product_profit * 100 / t.total_profit,2),'%') as profit_percentage
from product_profit as p
join total_profit as t 
on 1=1


--7. Customers by total orders 

select customer_type, count(*) as total_orders
from tasty_bites
group by 1

--8. Most used payment method?

select payment_mode, count(*) as total_orders
from tasty_bites
group by 1 
order by 2 desc


-- 9. Most discounted products
select category, product_name, sum(discount) as total_discount
from tasty_bites
group by 1,2
order by 3 desc

