/*
5. Get the Products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code 
product
manufacturing_cost
*/

SELECT 
	FMC.product_code, 
	DP.product, 
    ROUND(FMC.manufacturing_cost,2) AS manufacturing_cost
FROM 
	fact_manufacturing_cost AS FMC 
		JOIN 
	dim_product AS DP
		ON DP.product_code = FMC.product_code
WHERE manufacturing_cost
	IN (
		SELECT MAX(manufacturing_cost) FROM fact_manufacturing_cost
			UNION
		SELECT MIN(manufacturing_cost) FROM fact_manufacturing_cost
		)
ORDER BY manufacturing_cost DESC;


/*
6. Generate a report which contains the top 5 customers who received an average high 
per-invoice_discount_pct for the fiscal year 2021 and in the Indian marker.
The final output contains these fields,
customer_code
customer
average_discount_percentage
*/

WITH CTE1 AS (
	SELECT customer_code, AVG(pre_invoice_discount_pct) AS AVG_PID
    FROM fact_pre_invoice_deductions
    WHERE fiscal_year = '2021'
    GROUP BY customer_code),
    
CTE2 AS (
	SELECT customer_code, customer 
    FROM dim_customer
    WHERE market = 'India')
    
SELECT 
	CTE2.customer_code, 
    CTE2.customer, 
    ROUND(CTE1.AVG_PID, 4) AS average_discount_percentage
FROM 
CTE1 JOIN CTE2 
ON CTE1.customer_code = CTE2.customer_code
ORDER BY average_discount_percentage DESC
LIMIT 5;