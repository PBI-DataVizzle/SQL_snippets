WITH RankedProducts AS (
    SELECT 
       [CategoryName],
       [Manufacturer],
       [Brand],
       CAST(ROUND(SUM([Cost]), 0) AS INT) AS total_cost,
       CAST(ROUND(SUM([Price]), 0) AS INT) AS total_price,

       -- Rank based on total cost without any partitions
       RANK() OVER(ORDER BY SUM([Cost]) DESC) AS cost_rank,

       -- Rank per Category by total cost
       ROW_NUMBER() OVER(PARTITION BY [CategoryName] ORDER BY SUM([Cost]) DESC) AS rank_per_category

    FROM [Contoso V2 10k].[Data].[Product]
    GROUP BY [CategoryName], [Manufacturer], [Brand]
)
SELECT * 
FROM RankedProducts
WHERE rank_per_category = 1
ORDER BY [CategoryName], rank_per_category ASC;
