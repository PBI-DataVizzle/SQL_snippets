-- Check if the global temporary table exists
IF OBJECT_ID('tempdb..##tbl_test', 'U') IS NOT NULL 
BEGIN
    -- If the table exists, truncate it
    TRUNCATE TABLE ##tbl_test;
END
ELSE 
BEGIN
    -- If the table doesn't exist, create the table
    CREATE TABLE ##tbl_test
    (
        id INT,
        column_name NVARCHAR(255)
    );
END;

-- Insert new values into the table
INSERT INTO ##tbl_test (id, column_name)
VALUES 
      (1, 'text string; after-delimiter')
    , (2, 'text;; string;; after-second_delimiter')
	, (3, 'text before-delimiter:: text; string')
    , (4, 'text before-second-delimiter:: string')
    , (5, 'text ~ between same delimiter ~ string')
    , (6, 'text # between-different-delimiters-from-left ~ string')
    , (7, 'text - between-different-delimiters-from-left | string')
	, (8, 'text # between-different-delimiters-from-right _ string')
	, (9, 'text: between-different-delimiters-from-right _ string')
	;
	SELECT * FROM ##tbl_test;
