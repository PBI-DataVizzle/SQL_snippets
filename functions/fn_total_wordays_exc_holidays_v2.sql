USE [PBI_DataStore]
GO
/****** Object:  UserDefinedFunction [FN].[DURATION_WORKDAYS_EXC_HOLIDAYS]    Script Date: 23/10/2024 07:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [FN].[DURATION_WORKDAYS_EXC_HOLIDAYS](
    @StartDate DATE,
    @EndDate DATE,
    @IncludeEndDate INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Workdays INT = 0;
    DECLARE @CurrentDate DATE = @StartDate;

    -- Adjust end date based on @IncludeEndDate
    IF @IncludeEndDate = 0
    BEGIN
        SET @EndDate = DATEADD(DAY, -1, @EndDate);  -- Exclude the end date by reducing it by 1 day
    END

    -- Loop through each date and count workdays
    WHILE @CurrentDate <= @EndDate
    BEGIN
        -- Check if the current date is not a weekend and not a holiday
        IF DATEPART(WEEKDAY, @CurrentDate) NOT IN (7, 1) -- Sunday = 1, Saturday = 7 for US settings
            AND @CurrentDate NOT IN (SELECT holiday_date FROM [ENT].uk_holidays)
        BEGIN
            SET @Workdays = @Workdays + 1;
        END

        -- Move to the next day
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END

    RETURN @Workdays;
END;
