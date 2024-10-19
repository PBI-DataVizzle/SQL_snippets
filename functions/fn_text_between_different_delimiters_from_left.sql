USE [Contoso 1M]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_text_between_diff_delim_from_left]    Script Date: 19/10/2024 16:06:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[fn_text_between_diff_delim_from_left]
(
    @input_string NVARCHAR(MAX),  -- Input string
    @delim_left NVARCHAR(255),    -- Left delimiter
    @delim_right NVARCHAR(255),   -- Right delimiter
    @return_option INT         -- 
)
RETURNS NVARCHAR(MAX) 
AS
BEGIN
    -- Declare the return variable
    DECLARE @result NVARCHAR(MAX);

    -- Declare variables to store the lengths of the delimiters
    DECLARE @left_len INT, @right_len INT;
    SET @left_len = LEN(@delim_left);   -- Use LEN() for the left delimiter length
    SET @right_len = LEN(@delim_right); -- Use LEN() for the right delimiter length

    -- Logic to extract text between different delimiters
    SET @result = CASE
                    WHEN CHARINDEX(@delim_left, @input_string) > 0 
                         AND CHARINDEX(@delim_right, @input_string, CHARINDEX(@delim_left, @input_string) + @left_len) > 0  -- Check if both delimiters exist
                    THEN TRIM(SUBSTRING(
                            @input_string, 
                            CHARINDEX(@delim_left, @input_string) + @left_len,  -- Start after the left delimiter
                            CHARINDEX(@delim_right, @input_string, CHARINDEX(@delim_left, @input_string) + @left_len) 
                            - (CHARINDEX(@delim_left, @input_string) + @left_len)  -- Length between the left and right delimiters
                        ))
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


