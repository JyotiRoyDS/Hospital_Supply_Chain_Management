use hospital
select * from hospital_supply_chain;

delete from hospital_supply_chain  
where cost_per_unit = 0;

--most common stock status
select stock_status, count(*) as count
from hospital_supply_chain
group by stock_status
order by count desc;

--highest item in the supply data
select top 1 item_name, cost_per_unit
from hospital_supply_chain
order by cost_per_unit DESC;

--lowest item in the supply data 
select top 1 item_name, cost_per_unit
from hospital_supply_chain
order by cost_per_unit asc;

--total cost of supplies from each suppiler
select supplier, sum(total_cost) as total_spending
from hospital_supply_chain
group by supplier
order by total_spending desc;

--showing items which are out of stocks
select count(*)  as OutOfStock_Items
from hospital_supply_chain
where stock_status = 'Out Of Stock';

--showing items which are not delivered
select count(*) as not_deliveed
from hospital_supply_chain
where delivery_date = 'Not Delivered';

select location, avg(Cost_Per_Unit) as Avg_Cost
from hospital_supply_chain
group by location
order by Avg_Cost desc;

--Supplier with the Highest Number of Orders
select top 1 supplier, count(*) as order_count  
from hospital_supply_chain  
group by supplier  
order by order_count desc;


--Rank Items by Total Cost (Highest to Lowest)
SELECT ID, Item_Name, Supplier, Total_Cost,
RANK() OVER (ORDER BY Total_Cost DESC) AS Cost_Rank
FROM hospital_supply_chain;

--Month with the Most Orders
select top 1 month(order_date) as order_month, count(*) as total_orders  
from hospital_supply_chain  
group by month(order_date)  
order by total_orders desc;


--Items with the Lowest Stock Levels
select item_name, quantity, stock_status
from hospital_supply_chain
where stock_status IN ('Low Stock', 'Out Of Stock')
order by quantity asc;

--Average Time Taken for Delivery
select avg(datediff(day, order_date, delivery_date)) as avg_delivery_time  
from hospital_supply_chain  
where delivery_date is not null and delivery_date <> 'Not Delivered';

--Find Monthly Trends in Orders
select year(order_date) as order_year, month(order_date) as order_month, count(*) as total_orders  
from hospital_supply_chain  
group by year(order_date), month(order_date)  
order by order_year desc, order_month desc;

--Count of orders per year
select year(order_date) as order_year, count(*) as total_orders  
from hospital_supply_chain  
group by year(order_date)  
order by order_year desc;

--Find average delivery time in days
select avg(datediff(day, order_date, delivery_date)) as avg_delivery_days  
from hospital_supply_chain  
where delivery_date <> 'not delivered';

-- Identify Items That Are About to Expire in the Next 6 Months
select item_name, expiry_date, stock_status  
from hospital_supply_chain  
where expiry_date between getdate() and dateadd(month, 6, getdate())  
order by expiry_date asc;

--find items that are about to expire within the next 6 months and have the lowest stock.
select item_name, expiry_date, stock_status  
from hospital_supply_chain  
where expiry_date between getdate() and dateadd(month, 6, getdate())  
and quantity = (  
    select min(quantity)  
    from hospital_supply_chain  
    where expiry_date between getdate() and dateadd(month, 6, getdate())  
)  
order by expiry_date asc;

--identifying the most frequently ordered item in a specific storage location.
select item_name, count(*) as order_count  
from hospital_supply_chain  
where item_name = (  
    select top 1 item_name  
    from hospital_supply_chain  
    where location = 'Warehouse A'  
    group by item_name  
    order by count(*) desc  
)  
group by item_name;


