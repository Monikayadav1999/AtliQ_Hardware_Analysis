/* 
3. Provide a report with all the unique product counts for each segment and sort them 
in descending order of product counts. The final output contains 2 fields,
segment
product_code
*/

SELECT 
    segment, COUNT(DISTINCT product_code) AS product_count
FROM
    dim_product
GROUP BY segment
ORDER BY product_count DESC;

/* 
4. Follow-up : Which segment had the most increase in unique products in 2021 vs 2021?
The output contains these fields,
segment
product_count_2020
product_count_2021
difference
*/

WITH CTE1 AS  
	(SELECT DP.segment, COUNT(DISTINCT FSM.product_code) AS product_count_2020 
	 FROM fact_sales_monthly AS FSM 
	 JOIN
	 dim_product AS DP 
	 ON DP.product_code = FSM.product_code
	 WHERE FSM.fiscal_year = 2020
     GROUP BY DP.segment),
CTE2 AS
	(SELECT DP.segment, COUNT(DISTINCT FSM.product_code) AS product_count_2021 
	FROM fact_sales_monthly AS FSM 
	JOIN
	dim_product AS DP 
	ON DP.product_code = FSM.product_code
	WHERE FSM.fiscal_year = 2021
    GROUP BY DP.segment)

SELECT CTE1.segment, CTE1.product_count_2020, CTE2.product_count_2021, 
(CTE2.product_count_2021 - CTE1.product_count_2020) AS Difference
FROM CTE1 , CTE2
WHERE CTE1.segment = CTE2.segment
ORDER BY Difference DESC;