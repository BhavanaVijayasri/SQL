/** CREATING NEW DATABASE **/
CREATE DATABASE COFEE_SHOP_SALES_DBcoffee_shop_sales

/** DISPLAYING THE DATA USING SELECT QUERY **/
SELECT * FROM COFFEE_SHOP_SALES;

/** DESCRIBING THE TYPES OF COLUMNS IN THE GIVEN DATA **/
DESC coffee_shop_sales;

/** UPDATING THE TRANSACTION_DATE FORMAT IN THE GIVEN DATA **/
UPDATE coffee_shop_sales 
SET TRANSACTION_DATE= str_to_date(TRANSACTION_DATE,'%d-%m-%Y');

/** MODIFYING THE TRANSACTION_DATE COLUMN TYPE FROM "STRING" TO "DATE" **/
ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE; 

/** UPDATING THE TRANSACTION_TIME FORMAT IN THE GIVEN DATA **/
UPDATE coffee_shop_sales 
SET TRANSACTION_TIME= str_to_date(TRANSACTION_TIME,'%H:%i:%s');

/** MODIFYING THE TRANSACTION_DATE COLUMN TYPE FROM "STRING" TO "TIME" **/
ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time time;

/** ALTERING COLUMN NAME IN THE GIVEN DATA **/
ALTER TABLE coffee_shop_sales 
CHANGE COLUMN ï»¿transaction_id transaction_id int;

SELECT ROUND(SUM(UNIT_PRICE * transaction_qty)) AS TOTAL_SALES
FROM coffee_shop_sales
WHERE
month(TRANSACTION_DATE)=5 -- MAY MONTH

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    
SELECT COUNT(transaction_id) AS TOTAL_ORDERS 
FROM coffee_shop_sales
WHERE 
month(TRANSACTION_DATE)=5; -- MAY MONTH


SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

SELECT SUM(transaction_qty) AS TOTAL_QUANTITY_SOLD 
FROM coffee_shop_sales
WHERE 
month(TRANSACTION_DATE)=5; -- MAY MONTH


SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

SELECT 
CONCAT(ROUND(sum(UNIT_PRICE * TRANSACTION_QTY)/1000,1),'K')AS TOTAL_SALES,
CONCAT(ROUND(SUM(TRANSACTION_QTY)/1000,1),'K')AS TOTAL_QTY_SOLD,
CONCAT(ROUND(COUNT(TRANSACTION_ID)/1000,1),'K')AS TOTAL_ORDERS
FROM COFFEE_SHOP_SALES
WHERE 
TRANSACTION_DATE='2023-05-18'; -- CONCAT IS TO JOIN TWO OUTPUTS

SELECT month(transaction_date) as Month,
CONCAT(ROUND(sum(UNIT_PRICE * TRANSACTION_QTY)/1000,1),'K')AS TOTAL_SALES,
CONCAT(ROUND(SUM(TRANSACTION_QTY)/1000,1),'K')AS TOTAL_QTY_SOLD,
CONCAT(ROUND(COUNT(TRANSACTION_ID)/1000,1),'K')AS TOTAL_ORDERS
FROM COFFEE_SHOP_SALES
WHERE 
month(transaction_date)=6;

SELECT AVG(total_sales) AS avg_sales
FROM (
    SELECT concat(round(SUM(unit_price * transaction_qty)/1000,1),'K') AS total_sales
    FROM coffee_shop_sales
	WHERE MONTH(transaction_date) = 6  -- Filter for May
    GROUP BY transaction_date
) AS internal_query; -- AVG TOTAL SALES IN MAY MONTH

SELECT 
    month(transaction_date), DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date); -- DAILY SALES FOR MONTH SELECTED


/*COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” 
and LESSER THAN “BELOW AVERAGE”*/
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;
    

/*SALES BY WEEKDAY / WEEKEND:*/
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 2  -- Filter for May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;
    

/*SALES BY STORE LOCATION*/
SELECT 
	store_location,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY TOTAL_SALES DESC;


/*SALES BY PRODUCT CATEGORY*/
SELECT 
	product_category,
	concat(ROUND(SUM(unit_price * transaction_qty/1000),1),'K') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY total_sales DESC;


/*SALES BY PRODUCTS (TOP 10)*/
SELECT product_category,
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 and
    product_category='loose tea'
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;


/*SALES BY DAY | HOUR*/
SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)
    

/*TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY*/
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;

/*TO GET SALES FOR ALL HOURS FOR MONTH OF MAY*/
SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);
    
    



