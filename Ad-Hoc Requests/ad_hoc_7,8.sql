/*
7. Get the complete report of the Gross sales amount for the customer "Atliq Exclusive"
for each month. The analysis helps to get an idea of low and high performing months 
and take strategic decisions. The final output contains these fields,
Month
Year
Gross Sale Amount
*/

SELECT
    FSM.fiscal_year AS Year, 
    MONTH(FSM.date) AS Month, 
    ROUND(SUM(FSM.sold_quantity * FGP.gross_price),2) AS Gross_sale_amount
FROM
    fact_sales_monthly FSM
        JOIN
    fact_gross_price AS FGP ON FSM.product_code = FGP.product_code
        JOIN
    dim_customer AS DC ON DC.customer_code = FSM.customer_code
WHERE
    DC.customer = 'Atliq Exclusive'
    GROUP BY FSM.fiscal_year,  Month
    ORDER BY FSM.fiscal_year;
    
    
/* 
8. In which quarter of 2020, got the maximum Total sold quantity? The final output contains 
these fields,
Quarter
Total_sold_quantity
*/


SELECT 
    CASE
        WHEN MONTH(date) IN (9 , 10, 11) THEN 1
        WHEN MONTH(date) IN (12 , 1, 2) THEN 2
        WHEN MONTH(date) IN (3 , 4, 5) THEN 3
        ELSE 4
    END AS Quarter,
    SUM(sold_quantity) AS Total_sold_quantity
FROM
    fact_sales_monthly
WHERE
    fiscal_year = '2020'
GROUP BY Quarter
ORDER BY Total_sold_quantity DESC;