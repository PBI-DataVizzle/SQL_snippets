/****** Object:  UserDefinedFunction [dbo].[fn_text_before_second_delim]    Script Date: 19/10/2024 16:05:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[fn_text_before_second_delim]
(
    @input_string NVARCHAR(MAX),  -- Input string
    @delimiter NVARCHAR(255),     -- Delimiter
    @return_option INT        -- 
)
RETURNS NVARCHAR(MAX) 
AS
BEGIN
    -- Declare the return variable
    DECLARE @result NVARCHAR(MAX);

    -- Logic to extract text before the second occurrence of the delimiter
    SET @result = CASE
                    WHEN CHARINDEX(@delimiter, @input_string) > 0 
                         AND CHARINDEX(@delimiter, @input_string, CHARINDEX(@delimiter, @input_string) + 1) > 0  -- Check if the second delimiter exists
                    THEN TRIM(SUBSTRING(
                            @input_string, 
                            1,  -- Start from the beginning of the string
                            CHARINDEX(@delimiter, @input_string, CHARINDEX(@delimiter, @input_string) + 1) - 1  -- Length up to just before the second occurrence of the delimiter
                        ))
                    ELSE 
                        CASE 
                            WHEN @return_option = -1 THEN NULL         -- If -1, return NULL
							WHEN @return_option = 0 THEN ''    -- If 1, return an empty string when second delimiter is not found
                            WHEN @return_option = 1 THEN @input_string -- If 1, return the full string
                            ELSE NULL
                        END
                  END;

    -- Return the result
    RETURN @result;
END;
GO


