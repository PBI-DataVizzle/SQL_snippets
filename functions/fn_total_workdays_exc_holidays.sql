CREATE OR ALTER FUNCTION dbo.fn_CalculateWorkdaysWithHardcodedHolidays(
    @StartDate DATE,
    @EndDate DATE,
    @IncludeEndDate INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Workdays INT = 1;
    DECLARE @CurrentDate DATE = @StartDate;

    -- Hardcoded UK holidays as a JSON array
    DECLARE @UKHolidays NVARCHAR(MAX) = '[
       "2023-01-02",
       "2023-04-07",
       "2023-04-10",
       "2023-05-01",
       "2023-05-08",
       "2023-05-29",
       "2023-08-28",
       "2023-12-25",
       "2023-12-26",
       "2024-01-01",
       "2024-03-29",
       "2024-04-01",
       "2024-05-06",
       "2024-05-27",
       "2024-08-26",
       "2024-12-25",
       "2024-12-26",
       "2025-01-01",
       "2025-04-18",
       "2025-04-21",
       "2025-05-05",
       "2025-05-26",
       "2025-08-25",
       "2025-12-25",
       "2025-12-26",
       "2026-01-01",
       "2026-04-03",
       "2026-04-06",
       "2026-05-04",
       "2026-05-25",
       "2026-08-31",
       "2026-12-25",
       "2026-12-28"
    ]';

    -- Table variable to store the parsed holidays
    DECLARE @HolidayDates TABLE (HolidayDate DATE);

    -- Parse the hardcoded JSON array into the @HolidayDates table
    INSERT INTO @HolidayDates (HolidayDate)
    SELECT CAST(value AS DATE)
    FROM OPENJSON(@UKHolidays);

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
            AND @CurrentDate NOT IN (SELECT HolidayDate FROM @HolidayDates)
        BEGIN
            SET @Workdays = @Workdays + 1;
        END

        -- Move to the next day
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END

    RETURN @Workdays;
END;
