select * from superstore;
describe superstore;

-- Top 10 products by revenue
SELECT 
    Sub_Category,
    COUNT(*) AS orders,
    SUM(Sales) AS total_revenue,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
FROM
    superstore
GROUP BY Sub_Category
ORDER BY total_revenue DESC
LIMIT 10;

-- Regions with >$100k revenue
SELECT 
    Region,
    SUM(Sales) AS revenue,
    COUNT(DISTINCT Customer_ID) AS customers,
    AVG(Sales) AS avg_order
FROM
    superstore
GROUP BY Region
HAVING SUM(Sales) > 100000
ORDER BY revenue DESC;

-- Top 10 customers
SELECT 
    Customer_ID,
    COUNT(*) AS order_count,
    SUM(Sales) AS lifetime_value,
    MAX(Order_Date) AS last_order
FROM
    superstore
GROUP BY Customer_ID
ORDER BY lifetime_value DESC
LIMIT 10;

-- Monthly revenue growth
SELECT
DATE_FORMAT(Order_Date,'%Y-%m-01') AS month,
SUM(Sales) AS monthly_revenue,
LAG(SUM(Sales)) OVER (ORDER BY DATE_FORMAT(Order_Date,'%Y-%m-01')) AS prev_month,
ROUND(
100.0 * (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY DATE_FORMAT(Order_Date,'%Y-%m-01')))
/ LAG(SUM(Sales)) OVER (ORDER BY DATE_FORMAT(Order_Date,'%Y-%m-01')),
2
) AS growth_pct
FROM superstore
GROUP BY DATE_FORMAT(Order_Date,'%Y-%m-01')
ORDER BY month DESC;

-- Top product per category
WITH ranked AS (
SELECT
Category,
Sub_Category,
SUM(Sales) AS revenue,
ROW_NUMBER() OVER (
PARTITION BY Category 
ORDER BY SUM(Sales) DESC
) AS rn
FROM superstore
GROUP BY Category, Sub_Category
)

SELECT *
FROM ranked
WHERE rn = 1;






