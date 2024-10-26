
-- part 0: query imported table
WITH cte_raw_table AS (
    SELECT * FROM [Test_DB].[dbo].[data_to_pivot]
)

-- part 1: define pre-pivot table
, cte_raw_data_to_pivot AS (			
    SELECT								-- RAW DATA TO PIVOT
        [ProductCategoryName],			-- column to keep
        [Size],							-- column to pivot
        [Quantity]						-- pivot value
    FROM cte_raw_table
) 

-- part 2a: define post-pivot table
, cte_pivot_table AS (					-- post-pivot table
    SELECT 
        [ProductCategoryName],			-- column to keep
			[Big],						-- ProductSizeValues (will make dynamic later)
			[Small]						-- ProductSizeValues (will make dynamic later)

    FROM cte_raw_data_to_pivot

-- part2b: define pivot table properties
    PIVOT (								-- pivot table operation
        SUM([Quantity])					-- pivot values
        FOR [Size] IN (					-- pivot attributes
				[Big],					-- attribute values (will make dynamic later)
				[Small]					-- attribute values (will make dynamic later)
			)
    ) AS piv_tbl						-- pivot table name
)
SELECT * FROM cte_pivot_table;
SELECT * FROM [Test_DB].[dbo].[data_to_pivot];
