
/****** Object:  UserDefinedFunction [funcs].[ProperCase]    Script Date: 20/10/2024 09:55:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION [funcs].[ProperCase]
(
    @inputString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @outputString NVARCHAR(MAX) = '';
    DECLARE @word NVARCHAR(100);
    DECLARE @position INT = 1;
    DECLARE @delimiter CHAR(1) = ' ';

    -- Split the input string into words and handle each word
    WHILE @position <= LEN(@inputString)
    BEGIN
        -- Extract each word
        SET @word = LTRIM(RTRIM(SUBSTRING(@inputString, @position, 
            CHARINDEX(@delimiter, @inputString + ' ', @position) - @position)));

        -- Convert the word to Proper Case (capitalize first letter, lowercase the rest)
        SET @outputString = @outputString + ' ' + UPPER(LEFT(@word, 1)) + LOWER(SUBSTRING(@word, 2, LEN(@word) - 1));

        -- Move to the next word
        SET @position = CHARINDEX(@delimiter, @inputString + ' ', @position) + 1;
    END

    -- Remove the leading space if it exists
    RETURN LTRIM(@outputString);
END;
GO


