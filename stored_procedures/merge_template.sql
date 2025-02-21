


-- /** =============================================
-- Procedure: Check if the Table Exists, Truncate if Not Empty, Insert Data with Transaction Handling
-- ============================================= **/
CREATE OR ALTER PROCEDURE [LND].[SP_refresh_LND_table] AS


/***
   ______________  ___  _______    ___  ___  ____  ____________  __  _____  ____
  / __/_  __/ __ \/ _ \/ __/ _ \  / _ \/ _ \/ __ \/ ___/ __/ _ \/ / / / _ \/ __/
 _\ \  / / / /_/ / , _/ _// // / / ___/ , _/ /_/ / /__/ _// // / /_/ / , _/ _/  
/___/ /_/  \____/_/|_/___/____/ /_/  /_/|_|\____/\___/___/____/\____/_/|_/___/

--------------------

   __  __________  _____   ____   ____  ____________ 
  /  |/  / __/ _ \/ ___/_ / __/  /  _/ |/ /_  __/ __ \
 / /|_/ / _// , _/ (_/ _// _/   _/ //    / / / / /_/ /
/_/  /_/___/_/|_|\____/ /___/  /___/_/|_/ /_/  \____/ 

--------------------
   __   ___   _  _____  _____  __  ____
  / /  / _ | / |/ / _ \/  _/ |/ // ___/_
 / /__/ __ |/    / // // //    // (_/ _/ 
/____/_/ |_/_/|_/____/___/_/|_/ \____/  

***/

BEGIN
    -- /** =============================================
    -- BEGIN TRY block for Transaction Handling
    -- ============================================= **/
    BEGIN TRY
        -- Begin a transaction

	-- /** =============================================
    -- BEGIN TRY block for Transaction Handling
    -- ============================================= **/

        BEGIN TRANSACTION;
		PRINT '• Beginning merge process. Hold on tight...';
        -- /** =============================================
        -- SECTION: Select new data to import (Step 1)
        -- ============================================= **/
       
        
        -- Define the CTE to pull data from the source

		WITH cte_name AS (
		SELECT * FROM TBL
		)


		
/******=============================================
SECTION: Define tables to merge on each other (Step 2)
=============================================******/

MERGE DB.SCH.TBL_TARGET AS trg      -- table to merge into
USING DB.SCH.TBL_SOURCE AS src                    -- fresh data to merge 
ON src.ID = trg.ID              -- ids to merge on


/******=============================================
SECTION: Define criteria to match on (Step 3)
=============================================******/

WHEN MATCHED AND src.UPDATED_DATETIME > trg.UPDATED_DATETIME THEN
-- Delete the row from the target table if the source has newer data
    DELETE


/******=============================================
SECTION: Define criteria to insert when not matched (new data!) (Step 3)
=============================================******/

WHEN NOT MATCHED BY TARGET THEN
    -- Insert new rows from the source into the target table

	  INSERT (
	  COLUMNS1, COLUMNS2, COLUMNS3
	  )
	  VALUES (
	  COLUMNS1, COLUMNS2, COLUMNS3
	  )

	  
/******=============================================
SECTION: Define deletion criteria when source data is no longer in target data (stale) (Step 3)
=============================================******/
WHEN NOT MATCHED BY SOURCE THEN
    -- Delete rows from the target table that no longer exist in the source
    DELETE
  
    ;

        PRINT CHAR(13) + CHAR(10) + '• Data merge completed successfully.';

        -- If everything works, commit the transaction
        COMMIT TRANSACTION;
        PRINT '• Transaction committed.';
    
	-- /** =============================================
    -- END TRY block for Transaction Handling
    -- ============================================= **/

    END TRY
    BEGIN CATCH
        -- Step 8: Rollback transaction in case of an error
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
;
GO
