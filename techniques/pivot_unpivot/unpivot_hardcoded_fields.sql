
-- part 0: query imported table
WITH cte_raw_table AS (
    SELECT * FROM [Test_DB].[dbo].[data_to_unpivot]
),

-- part 1: define pre-pivot table
cte_table_to_unpivot AS(
SELECT 
    ProductCategoryName,				-- columns to keep
    ProductName,						-- columns to keep
    ActivityDate,						-- new attribute
    Revenue							-- new value
FROM cte_raw_table

-- part 2: define post-pivot table
UNPIVOT ( -- attribute values
    Revenue FOR ActivityDate IN (	-- unpivot columns (will make dynamic later)
       [2024-01-01]
      ,[2024-02-01]
      ,[2024-03-01]
      ,[2024-04-01]
      ,[2024-05-01]
      ,[2024-06-01]
      ,[2024-07-01]
      ,[2024-08-01]
      ,[2024-09-01]
      ,[2024-10-01]
      ,[2024-11-01]
      ,[2024-12-01]
    )
) AS UnpivotedTable
)
-- final output

SELECT * FROM cte_table_to_unpivot
ORDER BY ProductCategoryName, ActivityDate;
SELECT * FROM [Test_DB].[dbo].[data_to_unpivot];
