--======================
-- DYNAMIC PIVOT TABLE
--======================
DECLARE @DynamicSQL NVARCHAR(MAX);		-- variable to capture dynamic SQL Query script
DECLARE @pivot_attributes NVARCHAR(MAX);	-- varaible to capture pivot attribute values

-- Step 1: Build a comma-separated list of unique sizes to pivot
WITH cte_pivot_attributes AS (
	SELECT DISTINCT 
            [Size]								-- column with pivot attributes
        FROM [Test_DB].[dbo].[data_to_pivot]	-- source table
        WHERE 
            [Size] IS NOT NULL					-- remove nulls
)
SELECT 
   @pivot_attributes = STRING_AGG('[' + [Size] + ']', ', ') -- column to extract attributes
FROM cte_pivot_attributes;

-- Debug: Check the generated pivot columns
PRINT 'Pivot Columns Attributes: ' +@pivot_attributes;

-- Step 2: Construct the dynamic SQL; replace attributes with @pivot_attributes
SET @DynamicSQL = '
    -- Part 0: query imported table
    WITH cte_raw_table AS (
        SELECT * FROM [Test_DB].[dbo].[data_to_pivot]
    ),

    -- Part 1: define pre-pivot table
    cte_raw_data_to_pivot AS (			
        SELECT								
            [ProductCategoryName],			
            [Size],							
            [Quantity]						
        FROM cte_raw_table
    ),

    -- Part 2a: define post-pivot table
    cte_pivot_table AS (
        SELECT 
            [ProductCategoryName], ' +@pivot_attributes + ' -- Dynamically include pivot columns
        FROM cte_raw_data_to_pivot

	-- Part 2b: define pivot table
        PIVOT (								
            SUM([Quantity]) -- pivot values
            FOR [Size] IN (' +@pivot_attributes + ')  -- Use dynamic list
        ) AS piv_tbl
    )
    SELECT * FROM cte_pivot_table;';				-- final output

-- Debug: Print the generated SQL to verify
PRINT 'Generated SQL: ' + @DynamicSQL;			

-- Step 3: Execute the dynamic SQL
EXEC sp_executesql @DynamicSQL;
