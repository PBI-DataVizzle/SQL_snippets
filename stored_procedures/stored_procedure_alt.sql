-- =============================================
-- Procedure: Check if the Table Exists, Truncate if Not Empty, Insert Data with Transaction Handling
-- =============================================
CREATE OR ALTER PROCEDURE [USP].[creat_staging_or_enterprise_table]
AS
BEGIN
    -- =============================================
    -- TRY block for Transaction Handling
    -- =============================================
    BEGIN TRY
        -- Begin a transaction
        BEGIN TRANSACTION;

		-- Step 1: Check if the table exists and truncate if it does
		IF OBJECT_ID('dbo.main_table', 'U') IS NOT NULL
		BEGIN
			-- Step 2: Truncate the table if it exists
			TRUNCATE TABLE STG.peps_sr_join;
			-- DROP TABLE STG.peps_sr_join;

		END;

        -- =============================================
        -- SECTION: Checking if the Table Exists (Step 1)
        -- =============================================
        IF OBJECT_ID('dbo.main_table', 'U') IS NULL
        BEGIN
            -- If the table does not exist, create it
            PRINT '• Table does not exist. Creating the table now.';
            
            -- Create the table with appropriate column definitions
           CREATE TABLE STG.peps_sr_join 
(
    [Column 1] INT
   , [Column 2] NVARCHAR(10)
   , [column 3] DECIMAL (18,5)
);


            
            PRINT '• Table created successfully.';
        END
        ELSE
        BEGIN
            PRINT '• Table already exists.';
        END

        -- =============================================
        -- SECTION: Check if the Table Is Empty (Step 2)
        -- =============================================
        IF EXISTS (SELECT 1 FROM dbo.main_table)
        BEGIN
            -- If the table is NOT empty, truncate it
            PRINT '• Table is not empty. Truncating the table.';
            TRUNCATE TABLE dbo.main_Table;
            PRINT '• Table truncated successfully.';
        END
        ELSE
        BEGIN
            -- If the table is empty, print a message
            PRINT '• Table is already empty.';
        END

        -- =============================================
        -- SECTION: Insert Data into the Table (Step 3)
        -- =============================================
        PRINT '• Inserting data into the STG.peps_sr_join table.';
        
        -- Define the CTE to pull data from the source
  WITH 
		cte_peps_orders_join AS (
 SELECT
		 [Column 1] as column1
   , [Column 2] as column2
   , [column 3] as  column3

  FROM [dbo].[tmp_table] 
 

)
, cte_output AS (
SELECT 
     column1
   , column2
   , column3
FROM cte_etl_step

)
       -- INSERT statement
INSERT INTO dbo.main_table
(
    column1
   , column2
   , column3
)
SELECT
   column1
   , column2
   , column3

FROM cte_output
;



        PRINT CHAR(13) + CHAR(10) + '• Data insertion completed successfully.';

        -- If everything works, commit the transaction
        COMMIT TRANSACTION;
        PRINT '• Transaction committed successfully.';
    
    END TRY
    BEGIN CATCH
    -- Check if there is an open transaction before rolling back
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Rethrow the error to get the error message
    THROW;
END CATCH;
END
;
GO
