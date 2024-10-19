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

-- Select the data to verify the results
SELECT 
	*
	-- text after delimiter
	, dbo.fn_text_after_delim( column_name, 'text string;' , -1) AS text_after_first_delim
	, dbo.fn_text_after_second_delim( column_name, ';;' , -1) AS text_after_second_delim

	-- text before delimiter
	, dbo.fn_text_before_delim( column_name, '::' , -1 ) AS text_before_first_delim
	, dbo.fn_text_before_second_delim( column_name, ':' , -1) AS text_before_second_delim

	-- text between first & second delimiter (same delimiter)
	, dbo.fn_text_between_first_and_second_delim( column_name, '~' , -1) AS text_between_same_delims

	-- text between first & second delimiter from left (different delimiters)
	, dbo.fn_text_between_diff_delim_from_left( column_name, ' # ', '~', -1) AS text_btwn_diff_delims_left
	, dbo.fn_text_between_diff_delim_from_left( column_name, 'text - ', ' | string', -1) AS text_btwn_diff_delims_left2

	-- text between first & second delimiter from left (different delimiters)
	, dbo.fn_text_between_diff_delim_from_right( column_name, '_', '#', -1) AS text_btwn_diff_delims_right
	, dbo.fn_text_between_diff_delim_from_right( column_name, '_ string', 'text:', -1) AS text_btwn_diff_delims_right2


FROM ##tbl_test;
