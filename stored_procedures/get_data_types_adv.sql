

  CREATE OR ALTER PROCEDURE dbo.SP_get_data_types

    @table_schema NVARCHAR(128),
    @table_name NVARCHAR(128)
AS

 --EXEC dbo.SP_get_data_types @table_schema = 'Data', @table_name = 'Orders';
 -- EXEC dbo.SP_get_data_types @table_schema = 'Data', @table_name = 'Customer';

/***
------------------------------------------------------------------------------
   ______________  ___  _______    ___  ___  ____  ____________  __  _____  ____
  / __/_  __/ __ \/ _ \/ __/ _ \  / _ \/ _ \/ __ \/ ___/ __/ _ \/ / / / _ \/ __/
 _\ \  / / / /_/ / , _/ _// // / / ___/ , _/ /_/ / /__/ _// // / /_/ / , _/ _/  
/___/ /_/  \____/_/|_/___/____/ /_/  /_/|_|\____/\___/___/____/\____/_/|_/___/ 

-----------------------------------------------------------------------------
	  ____  __  ___________  __
	 / __ \/ / / / __/ _ \ \/ /
	/ /_/ / /_/ / _// , _/\  / 
	\___\_\____/___/_/|_| /_/  
	
-----------------------------------------------------------------------------
***/

BEGIN
    SET NOCOUNT ON;

   WITH info_schema_columns_data AS (
    SELECT 
        COLUMN_NAME AS column_name, 
        DATA_TYPE AS old_data_type,
        CASE 
            WHEN DATA_TYPE IN ('varchar', 'text') THEN 'nvarchar'
            WHEN DATA_TYPE = 'char' THEN 'nchar'
            WHEN DATA_TYPE IN ('bit', 'int', 'bigint', 'smallint', 'tinyint') THEN 'int'
            WHEN DATA_TYPE IN ('decimal', 'numeric', 'float', 'real', 'money', 'smallmoney') THEN 'decimal'
            ELSE DATA_TYPE
        END AS simplified_data_type, 
        NUMERIC_PRECISION AS numeric_precision,
        NUMERIC_SCALE AS numeric_scale,
        CHARACTER_MAXIMUM_LENGTH AS text_character_length,
        CASE 
            WHEN DATA_TYPE IN ('bit', 'int', 'bigint', 'smallint', 'tinyint') THEN NULL  -- No precision/scale for whole numbers
            WHEN DATA_TYPE IN ('decimal', 'numeric', 'float', 'real', 'money', 'smallmoney') -- decimal precision maintained
            THEN CAST(CONCAT(NUMERIC_PRECISION, ',', NUMERIC_SCALE) AS NVARCHAR) 
            ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR) 
        END AS character_length,
        IS_NULLABLE AS is_nullable,
        ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS ix
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'Sales'  
    AND TABLE_NAME = 'vStoreWithDemographics'
),
cte_prepared_output AS (
    SELECT 
        column_name,
        old_data_type,
        simplified_data_type,
        text_character_length,
        character_length,
        -- Generate a final character length representation
        CASE
            WHEN character_length IS NULL THEN NULL
            WHEN text_character_length = -1 THEN '(MAX)'
            WHEN character_length IS NOT NULL THEN CONCAT('(', character_length, ')')
            ELSE CONCAT( '(', 
                    CASE 
                        WHEN text_character_length BETWEEN 9 AND 10 THEN 10				-- round to 10
                        WHEN text_character_length BETWEEN 11 AND 15 THEN 15			-- round 11-15
                        WHEN text_character_length BETWEEN 16 AND 20 THEN 20			-- round 16-20
                        WHEN text_character_length BETWEEN 90 AND 100 THEN 100			-- round 90-100
                        WHEN text_character_length BETWEEN 101 AND 200 THEN 200			-- round 101-200
                        WHEN text_character_length BETWEEN 201 AND 255 THEN 255			-- round 201-255
                        ELSE text_character_length
                    END
            , ')' )
        END AS final_character_length, 
        is_nullable,
        ix
    FROM info_schema_columns_data
)
SELECT 
    column_name,
    old_data_type,
    simplified_data_type,
    text_character_length,
    character_length,
    final_character_length,
    is_nullable,

    -- Generating column names for INSERT INTO statement
    CASE 
        WHEN ix = 1 THEN column_name
        ELSE ', ' + column_name
    END AS insert_table_script,

    -- Same as above, but wrapped in square brackets for SQL Server compatibility
    CASE 
        WHEN ix = 1 THEN CONCAT('[', column_name, ']')
        ELSE ', ' + CONCAT('[', column_name, ']')
    END AS insert_table_script_v2,

    -- Generating CREATE TABLE script
    CASE 
        WHEN ix = 1 THEN CONCAT_WS('  ', column_name , UPPER(simplified_data_type) , COALESCE(final_character_length, ''))
        ELSE ', ' + CONCAT_WS('  ', column_name , UPPER(simplified_data_type) , COALESCE(final_character_length, ''))
    END AS create_table_script,

    -- Same as above but with square brackets for SQL Server compatibility
    CASE 
        WHEN ix = 1 THEN CONCAT_WS(' ', CONCAT('[', column_name, ']') , UPPER(simplified_data_type) , COALESCE(final_character_length, ''))
        ELSE ', ' + CONCAT_WS(' ', CONCAT('[', column_name, ']') , UPPER(simplified_data_type) , COALESCE(final_character_length, ''))
    END AS create_table_script_v2
FROM cte_prepared_output;


END;

/*
________________________________________________________________
|   insert_table_script        |   create_table_script         |
|------------------------------|-------------------------------|
|        column1               |    column1 NVARCHAR (10)      |
|      , column2               |   , column2 INT               |
|      , column3               |   , column3 DECIMAL (18,5)    |



*/
