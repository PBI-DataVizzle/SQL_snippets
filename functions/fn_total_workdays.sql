CREATE OR ALTER FUNCTION dbo.fn_CalculateWorkdays(
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
        -- Check if the current date is not a weekend (Sat or Sun)
        IF DATEPART(WEEKDAY, @CurrentDate) NOT IN (7, 1) -- Sunday = 1, Saturday = 7 for US settings
        BEGIN
            SET @Workdays = @Workdays + 1;
        END
        
        -- Move to the next day
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END

    RETURN @Workdays;
END;
