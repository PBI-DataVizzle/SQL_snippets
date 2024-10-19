# SQL Function: Text After Delimiter

```sql
CREATE OR ALTER FUNCTION dbo.fn_text_after_delim
(
    @input_string NVARCHAR(MAX),  -- Input string
    @delimiter NVARCHAR(255)       -- Delimiter
)
RETURNS NVARCHAR(MAX) 
AS
BEGIN
    -- Declare the return variable
    DECLARE @result NVARCHAR(MAX);

    -- Logic to extract text after the delimiter
    SET @result = CASE
                    WHEN CHARINDEX(@delimiter, @input_string) > 0
                    THEN TRIM(
							SUBSTRING(@input_string, 
                                  CHARINDEX(@delimiter, @input_string) + LEN(@delimiter),  -- Start after the delimiter
                                  LEN(@input_string)
							)
						  )-- Extract until the end
                    ELSE @input_string  -- If no delimiter, return the full string
                  END;

    -- Return the result
    RETURN @result;
END;

```

### Example:

```sql
dbo.fn_text_after_delim(column_name, ':') AS text_after_delim_fn
```
