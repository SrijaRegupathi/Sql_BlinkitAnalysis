-- dispaly the records
select * from blinkit;

-- data cleaning
ALTER TABLE blinkit
RENAME COLUMN `Item fat content` TO item_fat_content;

ALTER TABLE blinkit
RENAME COLUMN `Item Identifier` TO item_identifier;

ALTER TABLE blinkit
RENAME COLUMN `Item Type` TO item_type;

ALTER TABLE blinkit
RENAME COLUMN `Outlet Establishment Year` TO out_est_year;

ALTER TABLE blinkit
RENAME COLUMN `Outlet Identifier` TO out_id;

ALTER TABLE blinkit
RENAME COLUMN `Outlet Location Type` TO location;

ALTER TABLE blinkit
RENAME COLUMN `Outlet Size` TO size;

ALTER TABLE blinkit
RENAME COLUMN type TO outlet_type;

ALTER TABLE blinkit
RENAME COLUMN `Item Visibility` TO item_visibility;

ALTER TABLE blinkit
RENAME COLUMN `Item Weight` TO item_weight;

ALTER TABLE blinkit
RENAME COLUMN `Total Sales` TO total_sales;

update blinkit
set item_fat_content = 
    case when item_fat_content in ('LF', 'low fat') then 'Low Fat'
         when item_fat_content = 'reg' then 'Regular'
    else item_fat_content
    end;

-- Total Sales
select round(sum(total_sales)/1000000,2) as total_sales_million from blinkit;

-- Avg Sales
select round(avg(total_sales)) as avg_sales from blinkit;

-- Number of items
select count(*) as Number_items from blinkit;

-- Average rating
select round(avg(Rating)) from blinkit;

-- Total Sales by Fat Content
select item_fat_content, round(sum(total_sales),2) as Total_sales
from blinkit
group by item_fat_content;

-- Total Sales by Item Type
select item_type,round(sum(total_sales),2) as Total_sales
from blinkit
group by item_type
order by total_sales desc;

-- Fat Content by outlet for Total Sales
SELECT 
    location,
    ROUND(SUM(CASE WHEN item_fat_content = 'Low Fat' THEN total_sales ELSE 0 END), 2) AS Low_Fat_Sales,
    ROUND(SUM(CASE WHEN item_fat_content = 'Regular' THEN total_sales ELSE 0 END), 2) AS Regular_Sales
FROM blinkit
GROUP BY location
ORDER BY location;

-- Total Sales by outlet establishment
select round(sum(total_sales)), out_est_year
from blinkit
group by out_est_year
order by out_est_year;

-- Percentage of sales by outlet size
SELECT 
    size,
    ROUND(
        SUM(total_sales) * 100.0 / (SELECT SUM(total_sales) FROM blinkit),
        2
    ) AS percent_size
FROM blinkit
GROUP BY size
ORDER BY size;

-- Sales by location
SELECT location, round(SUM(total_sales),2) AS total_sales
FROM blinkit
GROUP BY location
ORDER BY location;

-- All Metrics By Outlet Type
select outlet_type, round(sum(total_sales),2) as Total_sales, round(avg(total_sales),2) as Average_sales, count(*) as Number_items, round(avg(Rating),2) as Average_rating, round(avg(item_visibility),2) as Avg_Visibility
from blinkit
group by outlet_type
order by outlet_type;