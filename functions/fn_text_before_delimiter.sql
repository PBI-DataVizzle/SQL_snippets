/****** Object:  UserDefinedFunction [dbo].[fn_text_before_delim]    Script Date: 19/10/2024 16:04:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[fn_text_before_delim]
(
    @input_string NVARCHAR(MAX),  -- Input string
    @delimiter NVARCHAR(255),       -- Delimiter
	@return_option INT				-- return type (null, blank, input string)
)
RETURNS NVARCHAR(MAX) 
AS
BEGIN
    -- Declare the return variable
    DECLARE @result NVARCHAR(MAX);

    -- Logic to extract text before the delimiter
    SET @result = CASE
                    WHEN CHARINDEX(@delimiter, @input_string) > 0
                    THEN TRIM(
							SUBSTRING(
                                @input_string,    -- Input string
                                1,                -- Start from the beginning of the string
                                CHARINDEX(@delimiter, @input_string) - 1 -- Extract up to the delimiter
                            )
						)
                    ELSE 
						CASE 
                            WHEN @return_option = -1 THEN NULL -- If -1, return NULL
							WHEN @return_option = 0 THEN ''    -- If 1, return an empty string when second delimiter is not found
                            WHEN @return_option = 1 THEN @input_string -- If 1, return the full string
							ELSE NULL
                        END
                  END;

    -- Return the result
    RETURN @result;
END;
GO


