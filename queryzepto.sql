drop table if exists zepto ; 

create table zepto (
sku_id serial primary key ,
category varchar(120) ,
name varchar (150) not null ,
mrp numeric (8,2) ,
discountPercent numeric (5,2) ,
availableQuantity integer ,
discountedSellingPrice numeric (8,2) ,
weightInGms integer ,
outofStock boolean ,
quantity integer 
);

--data exploration 
--count of rows  
select count (*) from zepto ; 
--sample data 
select * from zepto 
limit 10 ;
--null values 
select * from zepto where 
name is null or 
category  is null or 
mrp is null or 
discountpercent is null or 
availablequantity is null or 
discountedsellingprice is null or 
weightingms is null or 
outofstock is null or 
quantity is null ;
--product categories 
select distinct category from zepto 
order by category ;
--product in stock and out of stock 
select outofstock, count(sku_id)
from zepto 
group by outofstock ;
--product name present multiple times 
select name  , count(sku_id) as "Number of SKU's "
from zepto 
group by name 
having count(sku_id)> 1
order by count(sku_id) desc
--data cleaning 
--products with price zero 
select * from zepto where 
mrp='0' or discountedsellingprice = '0'

delete from zepto 
where mrp='0' ;
--converting paise to rupees
update zepto 
set mrp = mrp/100.0 ,
discountedsellingprice = discountedsellingprice/100.0 ;

select mrp,discountedsellingprice from zepto ;

--Business insights 
--top 10 best value  products on the discount percentage 
select distinct name , mrp , discountpercent from zepto 
order by  discountpercent desc
limit 10 ;
--products with high mrp but out of stock 
select distinct name , mrp from zepto where outofstock = 'true' 
order by mrp desc
limit 10 ;
--estimated revenue for each category 
select category ,
sum (discountedsellingprice * availablequantity) as Total_revenue
from zepto
group by category 
order by Total_revenue 
--find all products where mrp is > 500 and discount < 10 % 
select distinct name ,mrp,discountpercent from zepto 
where mrp>'500' and discountpercent<'10'
order by mrp desc
--top 5 categories offering highest average discount percentage 
select category ,
avg (discountpercent) as avg_discount from zepto 
group by category
order by avg_discount desc 
limit 5 ;
--price per gram for products above 100 g and sort by best value 
select distinct name , weightingms , discountedsellingprice , discountedsellingprice/weightingms as price_per_gram  
from zepto 
where weightingms > '100' 
order by price_per_gram  
--group the products on the basis of weight as low , medium , bulk 
select distinct name , weightingms ,
case when weightingms < 1000 then 'low' 
when weightingms < 5000 then 'medium'
else 'bulk'
end as weight_category 
from zepto 
--Total inventory weight per category 
select category ,
sum( weightingms * availablequantity) as total_weight from zepto
group by category 
order by total_weight ;


