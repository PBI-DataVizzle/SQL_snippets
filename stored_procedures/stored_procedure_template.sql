USE [Test_DB]
GO
/****** Step 1, 2, and 3: Check if the Table Exists, Truncate if Not Empty, Insert Data, with Transaction Handling ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Procedure: Check if the Table Exists, Truncate if Not Empty, Insert Data with Transaction Handling
-- =============================================
CREATE OR ALTER PROCEDURE [usp].[try_check_truncate_and_insert_dummy_products]
AS
BEGIN
    -- =============================================
    -- TRY block for Transaction Handling
    -- =============================================
    BEGIN TRY
        -- Begin a transaction
        BEGIN TRANSACTION;

        -- =============================================
        -- SECTION: Checking if the Table Exists (Step 1)
        -- =============================================
        IF OBJECT_ID('dbo.dummy_products', 'U') IS NULL
        BEGIN
            -- If the table does not exist, create it
            PRINT '• Table does not exist. Creating the table now.';
            
            -- Create the table with appropriate column definitions
            CREATE TABLE dbo.dummy_products (
                ProductID BIGINT,
                [Name] VARCHAR(255),
                ProductNumber VARCHAR(255),
                MakeFlag INT
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
        IF EXISTS (SELECT 1 FROM dbo.dummy_products)
        BEGIN
            -- If the table is NOT empty, truncate it
            PRINT '• Table is not empty. Truncating the table.';
            TRUNCATE TABLE dbo.dummy_products;
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
        PRINT '• Inserting data into the dummy_products table.';
        
        -- Define the CTE to pull data from the source
        WITH cte_product_table AS (
            SELECT * FROM [AW_2022].[Production].[Product]
        )

        -- Insert data from the CTE into the dummy_products table
        INSERT INTO dbo.dummy_products 
        (
            ProductID,
            [Name],
            ProductNumber,
            MakeFlag
        )
        SELECT 
            [ProductID],
            [Name],
            [ProductNumber],
            [MakeFlag]
        FROM cte_product_table;

        PRINT CHAR(13) + CHAR(10) + '• Data insertion completed successfully.';

        -- If everything works, commit the transaction
        COMMIT TRANSACTION;
        PRINT '• Transaction committed successfully.';
    
    END TRY
    BEGIN CATCH
        -- =============================================
        -- CATCH block for Error Handling
        -- =============================================

        -- Roll back the transaction if an error occurs
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
            PRINT '• Transaction rolled back due to an error.';
        END
        
        -- Print error details
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        -- Print the error message
        PRINT '• Error Occurred: ' + @ErrorMessage;

        -- Optionally, rethrow the error to allow higher-level handling
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

-- Execute the stored procedure to perform Step 1, Step 2, and Step 3
EXEC usp.[try_check_truncate_and_insert_dummy_products];
PRINT CHAR(13) + CHAR(10) + 'Procedure Completed: Table check, truncation, and data insertion process done.';
