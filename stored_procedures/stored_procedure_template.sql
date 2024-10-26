CREATE OR ALTER PROCEDURE [usp].[stored_proc]
AS
BEGIN
    -- Begin the transaction for atomicity
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- =============================================
        -- SECTION: Checking if the Table Exists
        -- =============================================
        IF OBJECT_ID('dbo.dummy_product_groups', 'U') IS NOT NULL
        BEGIN
            -- Table exists, check if it has data
            IF EXISTS (SELECT 1 FROM dbo.dummy_product_groups)
            BEGIN
                -- If the table is NOT empty, truncate it first
                PRINT 'Table is not empty. Truncating the table.';
                TRUNCATE TABLE dbo.dummy_product_groups;
            END
        END
        ELSE
        BEGIN
            -- Table does not exist, so create it
            PRINT 'Table does not exist. Creating the table now.';
            
            CREATE TABLE dbo.dummy_product_groups (
                [ProductCategoryID] BIGINT,
                [Name] VARCHAR(255),
                [rowguid] UNIQUEIDENTIFIER,
                [ModifiedDate] DATE
            );
            
            PRINT 'Table created successfully.';
        END

        -- =============================================
        -- SECTION: Populating the Table
        -- =============================================    
        PRINT 'Computing CTEs now.';
        WITH cte_table1 AS (
        SELECT * FROM [DB].[LND].TABLE1
        )
        , cte_table2 AS (
        SELECT * FROM cte_table1
        )
        
            
        -- =============================================
        -- SECTION: Populating the Table
        -- =============================================
        PRINT 'Populating the table now.';
        INSERT INTO dbo.dummy_product_groups (
            [ProductCategoryID],
            [Name],
            [rowguid],
            [ModifiedDate]
        )
        SELECT 
            [ProductCategoryID],
            [Name],
            [rowguid],
            [ModifiedDate]
        FROM [DB].[SCHEMA].[TBL]; -- Replace with actual source

        PRINT 'Table populated successfully.';
        
        -- =============================================
        -- Commit the transaction if everything goes well
        -- =============================================
        COMMIT TRANSACTION;
        PRINT 'Transaction committed successfully.';
        
    END TRY
    BEGIN CATCH
        -- Error handling: Rollback transaction if an error occurs
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT 'Transaction rolled back due to an error.';
        END

        -- Print the error message details for debugging
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));

        -- Rethrow the original error with THROW
        THROW;
    END CATCH
END;
