-- Check if the global temporary table exists
IF OBJECT_ID('tempdb..##tbl_data', 'U') IS NOT NULL 
BEGIN
    -- If the table exists, truncate it
    TRUNCATE TABLE ##tbl_data;
	DROP TABLE ##tbl_data;
END
ELSE 
BEGIN
    -- If the table doesn't exist, create the table
    CREATE TABLE ##tbl_data
    (
        id INT,
        text_string NVARCHAR(255)
    );
END;

-- Insert new values into the table
INSERT INTO ##tbl_data (id, text_string)
VALUES 
      (1, 'productA: item_1 - 1AAA; item_2 - 2AAA; item_3 - 3AAA')
    , (2, 'productB: item_1 - 1BBB; item_2 - 2BBB; item_3 - 3BBB; item_4 - 4BBB')
	, (3, 'productC: item_1 - 1CCC; item_2 - 2CCC; item_3 - 3CCC; item_4 - 4CCC')

	;
	SELECT 
		t.id, 
		
		value AS split_text

	FROM Test_DB.dbo.##tbl_data as t
	CROSS APPLY STRING_SPLIT(REPLACE(tempdb.dbo.fn_text_after_delim(t.text_string, ': ', -1), '; ', '|'), '|')

