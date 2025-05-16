## SQL Groupby techniques
  
``` sql
  
SELECT 
TOP (1000)

  t2.date_year
  , t2.date_month
 , SUM( [SalesAmount] ) as totals
 FROM [Test_DB].[dbo].[MonthlySales] t1
 CROSS APPLY
 (
	VALUES
	(
	 DATEPART( YEAR, t1.[SaleMonth] )
	, DATEPART( MONTH, t1.[SaleMonth] ) 
	)
 ) as t2 ( date_year , date_month )

 GROUP BY t2.date_year, t2.date_month
 ORDER BY t2.date_year, t2.date_month

```
