/* 
9. Which channel helped to bring more gross sales in the fiscal year 2021 and the 
percentage of contribution? The final output contains these fields,
Channel
Gross_sales_m1n
Percentage
*/

WITH CTE AS(
	SELECT 
		DC.channel,
        ROUND(SUM(FGP.gross_price * FSM.sold_quantity/1000000),2) AS Gross_sales_mln
	FROM 
		fact_sales_monthly AS FSM 
        JOIN
        dim_customer AS DC ON DC.customer_code = FSM.customer_code
        JOIN
        fact_gross_price AS FGP ON FGP.product_code = FSM.product_code
	WHERE 
		FSM.fiscal_year = 2021
	GROUP BY 
		DC.channel
        )

SELECT 
	channel AS Channel,
    CONCAT(Gross_sales_mln, 'M') AS Gross_sales_in_Million, 
    CONCAT(ROUND(Gross_sales_mln * 100/total, 2 ), ' %') AS Percentage
FROM
	(
		(SELECT SUM(Gross_sales_mln) AS total From CTE) A,
        (SELECT * FROM CTE) B
	)
ORDER BY Percentage DESC;


/*
10. Get the Top 3 Products in each Division that have a high Total sold quantity in the
fiscal year 2021? The final output contains these fields,
Division
Product_code
Product
Total_sold_quantity
Rank_order
*/

WITH CTE1 AS (
	SELECT 
		DP.division,
        FSM.product_code,
        DP.product,
        SUM(FSM.sold_quantity) AS Total_sold_quantity
	FROM 
		dim_product AS DP
			JOIN
		fact_sales_monthly AS FSM
		ON DP.product_code = FSM.product_code
	WHERE FSM.fiscal_year = '2021'
    GROUP BY FSM.product_code, DP.division, DP.product),

CTE2 AS(
	SELECT 
		division, 
        product_code, 
        product, 
        Total_sold_quantity,
		RANK() OVER(PARTITION BY division ORDER BY Total_sold_quantity DESC) AS Rank_Order
    FROM
		CTE1 )

SELECT 
	CTE1.division,
    CTE1.product_code,
    CTE1.product,
    CTE1.Total_sold_quantity,
    CTE2.Rank_Order
FROM
	CTE1 JOIN CTE2
    ON CTE1.product_code = CTE2.product_code
WHERE 
	CTE2.Rank_Order IN (1,2,3);

    