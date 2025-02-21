/***
   ___  __  ____   __ __   _____  _____________  ______
  / _ )/ / / / /  / //_/  /  _/ |/ / __/ __/ _ \/_  __/
 / _  / /_/ / /__/ ,<    _/ //    /\ \/ _// , _/ / /   
/____/\____/____/_/|_|  /___/_/|_/___/___/_/|_| /_/    

***/


-- Step 2A: Create the table
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'main_table')
BEGIN
    CREATE TABLE dbo.main_table (
	-- DROP TABLE PBI.pmg_chart_of_accounts
      column1	INT NOT NULL,
		column2	INT,
		column3	NVARCHAR(MAX)
		
    );
END
ELSE
BEGIN
    -- Truncate table if it already exists (removes all data)
    TRUNCATE TABLE dbo.main_table;

END;


-- Step 2B: Perform BULK INSERT
PRINT NCHAR(10) + 'bulking inserting...';
BULK INSERT dbo.main_table
FROM '\\shared_folder\folder_name\file_name.csv'
WITH
(
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    FIRSTROW = 2,  -- Skips header row
    FIELDTERMINATOR = ',',  -- Comma as delimiter
    ROWTERMINATOR = '\n',   -- Newline as row terminator
    TABLOCK,
    KEEPNULLS  -- Preserves NULL values in columns
);



/*
            |\|\,'\,'\ ,.
            )        ;' |,'
           /              |,'|,.
          /                  ` /__
         ,'                    ,-'
        ,'                    :
       (_                     '
     ,'                      ;
     |---._ ,'     .        '
     :   o Y---.__  ;      ;
     /`,""-|     o`.|     /
    ,  `._  `.    ,'     ;
    ;         `""'      ;
   /                   -'.
   \                   G  )
    `-.__________,   `._,'
            (`   `     |)\
           / `.       ,'  \
          /    `-----'     \
         /
*/
