CREATE OR ALTER PROCEDURE [ENT].[SP_refresh_ENT_sage_sop_order_return_header]
AS

/***
--------------------
   ______________  ___  _______    ___  ___  ____  ____________  __  _____  ____
  / __/_  __/ __ \/ _ \/ __/ _ \  / _ \/ _ \/ __ \/ ___/ __/ _ \/ / / / _ \/ __/
 _\ \  / / / /_/ / , _/ _// // / / ___/ , _/ /_/ / /__/ _// // / /_/ / , _/ _/  
/___/ /_/  \____/_/|_/___/____/ /_/  /_/|_|\____/\___/___/____/\____/_/|_/___/

--------------------
   _____  _____________  ______  _____  ____________ 
  /  _/ |/ / __/ __/ _ \/_  __/ /  _/ |/ /_  __/ __ \
 _/ //    /\ \/ _// , _/ / /   _/ //    / / / / /_/ /
/___/_/|_/___/___/_/|_| /_/   /___/_/|_/ /_/  \____/ 
                                                     
--------------------

***/

BEGIN
    SET NOCOUNT ON;  -- Improves performance by preventing extra messages

    BEGIN TRY
        PRINT 'Checking if table [dbo].[main_table] exists...';

        /*********************** 
		STEP 1: CHECK IF TABLE EXISTS
		************************/
        IF EXISTS (
            SELECT 1 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_SCHEMA = 'dbo' 
              AND TABLE_NAME = 'main_table'
        )
        BEGIN
            PRINT 'Table exists. Truncating table...';
            TRUNCATE TABLE dbo.main_table;
			--DROP TABLE [PBI_DataStore].[ENT].[sage_sop_order_return_header];
        END
		ELSE
		BEGIN
			PRINT 'Table does not exist. Creating table...';
        

		/*********************** 
		STEP 2: SELECT FROM DATA
		************************/
        CREATE TABLE dbo.main_table (
			column1 NVARCHAR(10)
      , column2 INT
      , column3 BIT

 

);
END		
		/*********************** 
		STEP 3: INSERT INTO
		************************/
		INSERT INTO dbo.main_table (
			column1
      , column2
      , column3


)
		
		/*********************** 
		STEP 4: SELECT FROM DATA
		************************/
		SELECT
			column1
      , column2
      , column3


FROM [database].[dbo].[tbl]
;
		
        PRINT 'Stored procedure execution completed successfully!';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred!';
        PRINT ERROR_MESSAGE();  -- Capture and print the error
    END CATCH
END;
