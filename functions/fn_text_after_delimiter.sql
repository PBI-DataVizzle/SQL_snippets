/****** Object:  UserDefinedFunction [dbo].[fn_text_after_delim]    Script Date: 19/10/2024 14:01:08 ******/
SET 
  ANSI_NULLS ON GO 
SET 
  QUOTED_IDENTIFIER ON GO CREATE 
  OR ALTER FUNCTION [dbo].[fn_text_after_delim] (
    @input_string NVARCHAR(MAX), 
    -- Input string
    @delimiter NVARCHAR(255), 
    
    @return_option INT -- 
    ) 
	RETURNS NVARCHAR(MAX) AS 
	BEGIN 
		DECLARE @result NVARCHAR(MAX); -- Declare the return variable

-- Logic to extract text after the delimiter
SET 
  @result = 
  CASE WHEN CHARINDEX(@delimiter, @input_string) > 0 THEN TRIM(
    SUBSTRING(
      @input_string, -- substring expression
      CHARINDEX(@delimiter, @input_string) + LEN(@delimiter), -- character position starts after end of delimiter string
      LEN(@input_string) -- length of input string (Extract until the end of string)
      )
  ) ELSE CASE WHEN @return_option = -1 THEN NULL -- If -1, return NULL
  WHEN @return_option = 0 THEN '' -- If 1, return an empty string when second delimiter is not found
  WHEN @return_option = 1 THEN @input_string -- If 1, return the full string
  ELSE NULL END END;
-- Return the result
RETURN @result;
END;
GO
