# TEXT AFTER DELIMITER
#### get text after first delimiter
*returns the text after the starting point of the delimiter*
```SQL
DECLARE @subby VARCHAR(3);  SET @subby = '::';
DECLARE @sublen INT;        SET @sublen = DATALENGTH(@subby);

	SELECT 
	* 
	-- text after delimiter
	, SUBSTRING(column_name,  -- substring
		CHARINDEX( @subby, column_name)+1,	-- starting position
		LEN(column_name)  -- string length to extract after starting position
		) AS text_after_delim

	FROM ##table_name
```

# TEXT AFTER DELIMITER (PROPER)
#### get text after first delimiter
*returns the text after the end point of the delimiter*
```SQL
DECLARE @subby VARCHAR(3);  SET @subby = '::';
DECLARE @sublen INT;        SET @sublen = DATALENGTH(@subby);

SELECT *
		-- text after delimiter proper
	,CASE 
		WHEN CHARINDEX(@subby, column_name) > 0												-- check if substring exists
		THEN																				-- if exists then do transformation
			TRIM(SUBSTRING(
						column_name,														-- expression
						CHARINDEX(@subby, column_name) + @sublen,							-- Start after the entire delimiter
						LEN(column_name) - CHARINDEX(@subby, column_name) - @sublen + 1		-- Adjust the length to extract remaining string
					))
			ELSE column_name																-- if doesn't exist, return string
		END	AS text_after_delim_proper

	FROM ##table_name
```
