CREATE OR ALTER PROCEDURE [USP].SP_exec_get_data_types

    @table_schema NVARCHAR(128),
    @table_name NVARCHAR(128)
AS

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

    WITH ColumnData AS (
        SELECT 
            COLUMN_NAME AS column_name, 
            DATA_TYPE AS old_data_type,
            CASE 
                WHEN DATA_TYPE = 'varchar' THEN 'nvarchar'
                WHEN DATA_TYPE IN ('bit', 'int', 'bigint', 'smallint') THEN 'int'
                ELSE DATA_TYPE
            END AS new_data_type, 
            NUMERIC_PRECISION AS numeric_precision,
            NUMERIC_SCALE AS numeric_scale,
            CHARACTER_MAXIMUM_LENGTH AS old_data_length,
            CASE 
                WHEN DATA_TYPE = 'decimal' THEN CONCAT(NUMERIC_PRECISION, ',', NUMERIC_SCALE) 
                ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR) 
            END AS data_length,
            IS_NULLABLE AS is_nullable,
            ROW_NUMBER() OVER (ORDER BY ORDINAL_POSITION) AS rn
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @table_schema  
        AND TABLE_NAME = @table_name  
    ),
    cte_cleaned AS (
        SELECT 
            column_name,
            old_data_type,
            new_data_type,
            data_length,
            old_data_length,
            CASE
                WHEN old_data_type = 'decimal' THEN CONCAT('(', numeric_precision, ',', numeric_scale, ')')
                WHEN old_data_length IS NULL THEN NULL
                WHEN old_data_length = -1 THEN '(MAX)'
                ELSE CONCAT( '(', 
                        CASE 
                            WHEN old_data_length BETWEEN 9 AND 10 THEN 10
                            WHEN old_data_length BETWEEN 11 AND 15 THEN 15
                            WHEN old_data_length BETWEEN 16 AND 20 THEN 20
                            WHEN old_data_length BETWEEN 90 AND 100 THEN 100
                            WHEN old_data_length BETWEEN 101 AND 200 THEN 200
                            WHEN old_data_length BETWEEN 201 AND 255 THEN 255
                            ELSE old_data_length
                        END
                , ')' )
            END AS new_data_length, 
            is_nullable,
            rn
        FROM ColumnData
    )
    SELECT 
        column_name,
        old_data_type,
        new_data_type,
        data_length,
        new_data_length,
        is_nullable,

        -- Add comma prefix for all rows except the first one
        CASE 
            WHEN rn = 1 THEN column_name
            ELSE ', ' + column_name
        END AS insert_table_script,

		CASE 
            WHEN rn = 1 THEN CONCAT('[',column_name,']')
            ELSE ', ' + CONCAT('[',column_name,']')
        END AS insert_table_script_v2,

        -- Add comma prefix for all rows except the first one
        CASE 
            WHEN rn = 1 THEN CONCAT_WS( '  ', column_name , UPPER(new_data_type) , new_data_length )
            ELSE ', ' + CONCAT_WS( '  ', column_name , UPPER(new_data_type) , new_data_length )
        END AS create_table_script,
		CASE 
            WHEN rn = 1 THEN CONCAT_WS( '  ', CONCAT('[',column_name,']') , UPPER(new_data_type) , new_data_length )
            ELSE ', ' + CONCAT_WS( '  ', CONCAT('[',column_name,']') , UPPER(new_data_type) , new_data_length )
        END AS create_table_script_v2
    FROM cte_cleaned;
END;
