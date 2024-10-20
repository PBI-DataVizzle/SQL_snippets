

/****** Object:  UserDefinedFunction [funcs].[ProperCaseWithExceptions]    Script Date: 20/10/2024 09:51:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION [funcs].[ProperCaseWithExceptions]
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
    DECLARE @exceptions TABLE (ExceptionWord NVARCHAR(50));

    -- Add the exception words (those that should remain unchanged)
    INSERT INTO @exceptions (ExceptionWord)
    VALUES ('NHS'), ('LTD'), ('CO.');

    -- Split the input string into words and handle each word
    WHILE @position <= LEN(@inputString)
    BEGIN
        -- Extract each word
        SET @word = LTRIM(RTRIM(SUBSTRING(@inputString, @position, 
            CHARINDEX(@delimiter, @inputString + ' ', @position) - @position)));

        -- Check if the word is in the exception list
        IF EXISTS (SELECT 1 FROM @exceptions WHERE ExceptionWord = @word)
        BEGIN
            -- If it's an exception, leave it as is
            SET @outputString = @outputString + ' ' + @word;
        END
        ELSE
        BEGIN
            -- Otherwise, convert it to Proper Case (capitalize first letter, lowercase the rest)
            SET @outputString = @outputString + ' ' + UPPER(LEFT(@word, 1)) + LOWER(SUBSTRING(@word, 2, LEN(@word) - 1));
        END

        -- Move to the next word
        SET @position = CHARINDEX(@delimiter, @inputString + ' ', @position) + 1;
    END

    -- Remove the leading space if it exists
    RETURN LTRIM(@outputString);
END;
GO


