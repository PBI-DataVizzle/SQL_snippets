/****** Object:  UserDefinedFunction [dbo].[fn_text_between_diff_delim_from_right]    Script Date: 19/10/2024 16:08:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[fn_text_between_diff_delim_from_right]
(
    @input_string NVARCHAR(MAX),  -- Input string
    @delim_right NVARCHAR(255),   -- First delimiter from the right
    @delim_left NVARCHAR(255),    -- Second delimiter from the right (which is further left in the original string)
    @return_option INT 
)
RETURNS NVARCHAR(MAX) 
AS
BEGIN
    -- Declare the return variable
    DECLARE @result NVARCHAR(MAX);

    -- Declare variables to store the lengths of the delimiters
    DECLARE @right_len INT, @left_len INT;
    SET @right_len = LEN(@delim_right);   -- Use LEN() for the right delimiter length
    SET @left_len = LEN(@delim_left);     -- Use LEN() for the left delimiter length

    -- Logic to extract text between different delimiters from the right
    SET @result = CASE
                    WHEN CHARINDEX(REVERSE(@delim_right), REVERSE(@input_string)) > 0  -- Find the first right delimiter in the reversed string
                         AND CHARINDEX(REVERSE(@delim_left), REVERSE(@input_string), CHARINDEX(REVERSE(@delim_right), REVERSE(@input_string)) + @right_len) > 0  -- Find the second delimiter from the right
                    THEN TRIM(REVERSE(SUBSTRING(
                            REVERSE(@input_string),  -- Work with the reversed string
                            CHARINDEX(REVERSE(@delim_right), REVERSE(@input_string)) + @right_len,  -- Start after the right delimiter (from the right)
                            CHARINDEX(REVERSE(@delim_left), REVERSE(@input_string), CHARINDEX(REVERSE(@delim_right), REVERSE(@input_string)) + @right_len) 
                            - (CHARINDEX(REVERSE(@delim_right), REVERSE(@input_string)) + @right_len)  -- Length between the delimiters
                        )))
                    ELSE 
                        CASE 
                            WHEN @return_option = -1 THEN NULL         -- If -1, return NULL
                            WHEN @return_option = 0 THEN ''            -- If 0, return an empty string when delimiters are not found
                            WHEN @return_option = 1 THEN @input_string -- If 1, return the full string when delimiters are not found
                            ELSE NULL
                        END
                  END;

    -- Return the result
    RETURN @result;
END;
GO


