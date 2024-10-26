WITH RankedProducts AS (
    SELECT 
       [CategoryName],
       [Manufacturer],
       [Brand],
       CAST(ROUND(SUM([Cost]), 0) AS INT) AS total_cost,
       CAST(ROUND(SUM([Price]), 0) AS INT) AS total_price,

       -- Rank based on total cost without any partitions
       RANK() OVER(ORDER BY SUM([Cost]) DESC) AS cost_rank,

	   -- Rank based on total cost without any partitions
       DENSE_RANK() OVER(ORDER BY SUM([Cost]) DESC) AS cost_dense_rank,

	   -- Rank based on total cost without any partitions
       NTILE(10) OVER(ORDER BY SUM([Cost]) DESC) AS cost_ntile_rank,

       -- Rank per Category by total cost
       ROW_NUMBER() OVER(PARTITION BY [CategoryName] ORDER BY SUM([Cost]) DESC) AS rank_per_category

    FROM [Contoso V2 10k].[Data].[Product]
    GROUP BY [CategoryName], [Manufacturer], [Brand]
)
SELECT * 
FROM RankedProducts
WHERE rank_per_category >= 1
AND cost_ntile_rank = 1
ORDER BY cost_rank ASC;



