USE restaurant_db;

-- Objective 1

-- View the menu_items table and write a query to find the number of items on the menu.
SELECT COUNT(*) AS "number of items on the menu"
FROM menu_items;

-- What are the least and most expensive items on the menu?
SELECT * 
FROM menu_items
ORDER BY price DESC
LIMIT 1;

-- How many Italian dishes are on the menu? 
SELECT COUNT(menu_item_id) AS "Total Italian dishes are on the menu"
FROM menu_items
WHERE category = "Italian";

-- What are the least and most expensive Italian dishes on the menu?
SELECT *
FROM menu_items
WHERE category = "Italian"
ORDER BY price DESC
LIMIT 1;

SELECT *
FROM menu_items
WHERE category = "Italian"
ORDER BY price ASC
LIMIT 1;

-- How many dishes are in each category? What is the average dish price within each category?
SELECT category,COUNT(menu_item_id) AS "Number of dishes in each category", ROUND(AVG(price),2) AS "Average dish price"
FROM menu_items
GROUP BY category;


-- Objective 2

-- View the order_details table.
SELECT * 
FROM order_details;
-- What is the date range of the table?
SELECT MIN(order_date), MAX(order_date)
FROM order_details;

-- How many orders were made within this date range?
SELECT order_date, COUNT(DISTINCT order_id) AS "Number of Orders"
FROM order_details
GROUP BY order_date;

-- How many items were ordered within this date range?
SELECT order_date, COUNT(item_id)AS number_of_orders
FROM order_details
GROUP BY order_date;



-- Which orders had the most number of items?
SELECT order_id, COUNT(item_id) AS `number of items`
FROM order_details
GROUP BY order_id
ORDER BY `number of items` DESC;


-- How many orders had more than 12 items?
SELECT COUNT(*) AS  `Count of orders more than 12 items`
FROM 
		(SELECT order_id, COUNT(item_id) AS `number of items`
		FROM order_details
		GROUP BY order_id, order_date
		HAVING `number of items` > 12) AS main_querry;
        
        
-- Objective 3

-- Combine the menu_items and order_details tables into a single table.


SELECT * 
FROM order_details AS od
LEFT JOIN menu_items AS m_items
ON od.item_id = m_items.menu_item_id;

-- What were the top 5 least and most ordered items?

-- least ordered item
WITH menu_and_order_table AS (SELECT * 
				FROM order_details AS od
				LEFT JOIN menu_items AS m_items
				ON od.item_id = m_items.menu_item_id)
                
SELECT item_name,COUNT(order_id) AS number_of_orders
FROM menu_and_order_table
GROUP BY item_name
ORDER BY number_of_orders ASC
LIMIT 5;

-- most ordered item
WITH menu_and_order_table AS (SELECT * 
				FROM order_details AS od
				LEFT JOIN menu_items AS m_items
				ON od.item_id = m_items.menu_item_id)
                
SELECT item_name,COUNT(order_id) AS number_of_orders
FROM menu_and_order_table
GROUP BY item_name
ORDER BY number_of_orders DESC
LIMIT 5;

-- What categories were they in?
WITH menu_and_order_table AS (SELECT * 
				FROM order_details AS od
				LEFT JOIN menu_items AS m_items
				ON od.item_id = m_items.menu_item_id)
            
SELECT item_name, category, COUNT(order_id) AS number_of_orders
FROM menu_and_order_table
GROUP BY item_name,category
ORDER BY number_of_orders DESC;



-- What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS spent_money
FROM order_details AS od
LEFT JOIN menu_items AS m_items
ON od.item_id = m_items.menu_item_id
GROUP BY order_id
ORDER BY spent_money DESC
LIMIT 5;

-- View the details of the highest spend order.
-- What insights can you gather from the results?

# Groupin category to see the how many items bought by this customer
WITH `highest spend order` AS (SELECT order_id, SUM(price) AS spent_money
					FROM order_details AS od
					LEFT JOIN menu_items AS m_items
					ON od.item_id = m_items.menu_item_id
					GROUP BY order_id
					ORDER BY spent_money DESC
					LIMIT 1)
SELECT category, COUNT(od.order_id) AS number_of_orders
FROM `highest spend order` AS high_order
LEFT JOIN (SELECT * 
			FROM order_details AS od
			LEFT JOIN menu_items AS m_items
			ON od.item_id = m_items.menu_item_id) AS od
ON high_order.order_id = od.order_id
GROUP BY category;




-- BONUS:
-- View the details of the top 5 highest spend orders.
-- What insights can you gather from the results?





WITH order_menu_table AS (SELECT * 
					FROM order_details AS od
					LEFT JOIN menu_items AS m_items
					ON od.item_id = m_items.menu_item_id)
                    
SELECT  order_id,category,COUNT(order_id) AS total_orders
FROM order_menu_table
WHERE order_id IN ('440','2075','1957','330','2675')
GROUP BY category,order_id
ORDER BY order_id asc;












                

