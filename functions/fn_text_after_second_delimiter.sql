/****** Object:  UserDefinedFunction [dbo].[fn_text_after_second_delim]    Script Date: 19/10/2024 16:02:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[fn_text_after_second_delim]
(
    @input_string NVARCHAR(MAX),  -- Input string
    @delimiter NVARCHAR(255),     -- Delimiter
    @return_option INT = 1        -- -1 to return NULL, 1 to return the full string when the second delimiter is not found
)
RETURNS NVARCHAR(MAX) 
AS
BEGIN
    -- Declare the return variable
    DECLARE @result NVARCHAR(MAX);

    -- Declare a variable to store the length of the delimiter
    DECLARE @delim_len INT;
    SET @delim_len = LEN(@delimiter);  -- Calculate and store the length of the delimiter

    -- Logic to extract text after the second occurrence of the delimiter
    SET @result = CASE
                    WHEN CHARINDEX(@delimiter, @input_string) > 0 
                         AND CHARINDEX(@delimiter, @input_string, CHARINDEX(@delimiter, @input_string) + 1) > 0  -- Check if the second delimiter exists
                    THEN TRIM(
                            SUBSTRING(
                                @input_string, 
                                CHARINDEX(@delimiter, @input_string, CHARINDEX(@delimiter, @input_string) + 1) + @delim_len,  -- Start after the second occurrence of the delimiter
                                LEN(@input_string) - CHARINDEX(@delimiter, @input_string, CHARINDEX(@delimiter, @input_string) + 0)  -- Extract everything after the second delimiter
                            )
                        )
                    ELSE 
                        CASE 
                            WHEN @return_option = -1 THEN NULL         -- If -1, return NULL
                            WHEN @return_option = 0 THEN ''            -- If 0, return an empty string when second delimiter is not found
                            WHEN @return_option = 1 THEN @input_string -- If 1, return the full string when the second delimiter is not found
                            ELSE NULL
                        END
                  END;

    -- Return the result
    RETURN @result;
END;
GO


