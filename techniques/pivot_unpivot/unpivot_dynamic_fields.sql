--======================
-- DYNAMIC PIVOT TABLE
--======================
DECLARE @DynamicSQL NVARCHAR(MAX);
DECLARE @columns_to_unpivot NVARCHAR(MAX);

-- Step 1: Dynamically build a comma-separated list of date columns to unpivot
WITH cte_unpivot_attributes AS (
    
	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
    WHERE 
		TABLE_NAME = 'data_to_unpivot'									-- Table name in [dbo] schema
        AND COLUMN_NAME NOT IN ('ProductCategoryName', 'ProductName', 'ProductId', 'ProductCategoryId')	-- Exclude non-date columns
)
SELECT 
    @columns_to_unpivot = STRING_AGG('[' + COLUMN_NAME + ']', ', ')
FROM cte_unpivot_attributes;

-- Debug: Check the generated pivot columns
PRINT 'Unpivot Columns: ' + @columns_to_unpivot;



-- Step 3: Construct the dynamic SQL; replace attributes with @columns_to_unpivot
SET @DynamicSQL = '
    
    SELECT 
        ProductCategoryName,											-- columns to keep
        ProductName,													-- columns to keep
        CONVERT(DATE, ActivityDate, 120) AS ActivityDate,		-- unpivot attributes
        Revenue														-- unpivot value
    FROM 
        dbo.data_to_unpivot 
    UNPIVOT (
        Revenue FOR ActivityDate IN (' + @columns_to_unpivot + ')		-- attribute values
    ) AS UnpivotedTable
    ORDER BY 
		ProductCategoryName, ActivityDate;';

-- Debug: Print the generated SQL to verify
PRINT 'Generated SQL: ' + @DynamicSQL;

-- Step 4: Execute the dynamic SQL
EXEC sp_executesql @DynamicSQL;
