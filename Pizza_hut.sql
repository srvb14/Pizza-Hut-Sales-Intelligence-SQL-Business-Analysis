use pizza_hut;

# Retrieve the total number of orders placed.
select count(distinct order_id ) as total_number_of_orders from order_details;
select count(distinct order_id ) as total_number_of_orders from orders;


# Calculate the total revenue generated from pizza sales.
select round(sum(od.quantity * p.price),2) as total_revenue
from order_details od join pizzas p 
	on od.pizza_id = p.pizza_id;

    
# Identify the highest-priced pizza.
select pt.name, max(p.price) as price
from pizzas p join pizza_types pt
	on p.pizza_type_id = pt.pizza_type_id
group by pt.name 
order by price desc limit 1;

# Identify the most common pizza size ordered.
select p.size, count(distinct od.order_id) as cust_count, sum(od.quantity) as order_count
from order_details od join pizzas p 
	on od.pizza_id = p.pizza_id
group by p.size
order by cust_count desc;


# List the top 5 most ordered pizza types along with their quantities.
select pt.name, SUM(od.quantity) as total_order  
from pizza_types pt join pizzas p
	on pt.pizza_type_id = p.pizza_type_id
join order_details od
	on p.pizza_id = od.pizza_id
group by pt.name
order by total_order desc
limit 5;


#Find the total quantity of each pizza category ordered (this will help us to understand the category which customers 
# prefer the most).
select pt.category , sum(od.quantity) as total_quantity
from pizza_types pt join pizzas p
	on pt.pizza_type_id = p.pizza_type_id
join order_details od 
	on p.pizza_id = od.pizza_id
group by pt.category
order by sum(od.quantity);


# Determine the distribution of orders by hour of the day (at which time the orders are maximum (for inventory
# management and resource allocation).
select hour(str_to_date(time, '%H:%i:%s')) as hours ,
count( distinct order_id) as total_orders
from orders
group by hour(str_to_date(time, '%H:%i:%s'))
order by count( distinct order_id) desc ;


# Find the category-wise distribution of pizzas (to understand customer behaviour).
select category, 
count(distinct pizza_type_id) as distribution
from pizza_types 
group by category;


# Group the orders by date and calculate the average number of pizzas ordered per day.
with cte as(
select str_to_date(o.date, '%d-%m-%Y') as days, sum(od.quantity) as perday_pizza
from orders o join order_details od
	on o.order_id = od.order_id
group by str_to_date(o.date, '%d-%m-%Y')
)
select round(avg(perday_pizza),2) as average_pizza_per_day from cte;


#Determine the top 3 most ordered pizza types based on revenue (let's see the revenue wise pizza orders to
# understand from sales perspective which pizza is the best selling)
select pt.name,
round(sum(od.quantity * p.price),2) as revenue
from order_details od join pizzas p
	on od.pizza_id = p.pizza_id
join pizza_types pt
	on pt.pizza_type_id = p.pizza_type_id
group by pt.name
order by revenue desc limit 3;


# Calculate the percentage contribution of each pizza type to total revenue (to understand % of contribution of
# each pizza in the total revenue)
with cte as (
select pt.name , sum(od.quantity * p.price) as rev
from order_details od join pizzas p 
	on od.pizza_id = p.pizza_id
join pizza_types pt
	on pt.pizza_type_id = p.pizza_type_id
group by pt.name
),
cte2 as (
select name , rev,
round(sum(rev) over(),2) as total_rev
from cte
)
select name , concat(round((rev*100.0)/total_rev,2),' %') as pct_contribution 
from cte2 order by pct_contribution desc;


# Analyze the cumulative revenue generated over time.
with cte as (
select str_to_date(o.date, '%d-%m-%Y') as dates ,
sum(od.quantity * p.price) as revenue
from orders o join order_details od
	on o.order_id = od.order_id
join pizzas p 
	on od.pizza_id = p.pizza_id
group by str_to_date(o.date, '%d-%m-%Y')
)
select dates,revenue, 
round(sum(revenue) over(order by dates asc),2) as cumsum_rev
from cte;


# Determine the top 3 most ordered pizza types based on revenue for each pizza category (In each category which
# pizza is the most selling)
with cte as(
select 
pt.category, pt.name, 
sum(od.quantity * p.price) as revenue
from orders o join order_details od 
	on o.order_id = od.order_id
join pizzas p
	on p.pizza_id = od.pizza_id
join pizza_types pt
	on pt.pizza_type_id = p.pizza_type_id
group by pt.category, pt.name
),
cte2 as(
select category, name, revenue ,
dense_rank() over( partition by category order by revenue desc) as d_rnk
from cte
)
select category,name , revenue 
from cte2 where d_rnk <=3;

# Which pizza category has the highest revenue but lowest order frequency?
select pt.category, 
round(sum(od.quantity * p.price),2) as revenue,
count(distinct od.order_id) as pizz_count
from order_details od join pizzas p
	on od.pizza_id = p.pizza_id
join pizza_types pt 
	on pt.pizza_type_id = p.pizza_type_id
group by pt.category
order by revenue desc, pizz_count asc;


# Are large-sized pizzas generating proportionally more revenue, or are we underpricing them?
select p.size, 
round(sum(od.quantity * p.price),2) as revenue
from orders o join order_details od 
	on o.order_id = od.order_id
join pizzas p
	on p.pizza_id = od.pizza_id
join pizza_types pt
	on pt.pizza_type_id = p.pizza_type_id
group by p.size order by revenue desc;


# What is the revenue contribution trend by category month-over-month?
with cte as(
select month(str_to_date(o.date, '%d-%m-%Y')) months, 
round(sum(od.quantity * p.price),2) as revenue
from orders o join order_details od 
	on o.order_id = od.order_id
join pizzas p
	on p.pizza_id = od.pizza_id
join pizza_types pt
	on pt.pizza_type_id = p.pizza_type_id
group by month(str_to_date(o.date, '%d-%m-%Y'))
),
cte2 as(
select *, lag(revenue) over(order by months asc) as prev_month_revenue
from cte
)
select *, round((revenue-prev_month_revenue)*100.0/ prev_month_revenue,2) as MoM_growth
from cte2 ;


# Do customers buy more during weekends than weekdays?
with cte as (
select weekday(str_to_date(o.date, '%d-%m-%Y')) as weekday,
sum(od.quantity) as total_order
from orders o join order_details od 
	on o.order_id = od.order_id
group by weekday(str_to_date(o.date, '%d-%m-%Y'))
),
cte2 as (
select
(case when weekday>=5 then 'week_end' else 'week_day' end) as flag , total_order
from cte
)
select flag, sum(total_order) as total_sold_pizza
from cte2 group by flag;


