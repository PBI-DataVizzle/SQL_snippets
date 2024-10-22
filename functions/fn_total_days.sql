CREATE OR ALTER FUNCTION dbo.fn_CalculateTotalDays(
    @StartDate DATE,
    @EndDate DATE,
    @IncludeEndDate INT
)
RETURNS INT
AS
BEGIN
    -- Calculate total days between the two dates
    -- If @IncludeEndDate is 1, add 1 to include the end date; otherwise, don't add anything
    RETURN DATEDIFF(DAY, @StartDate, @EndDate) + CASE WHEN @IncludeEndDate = 1 THEN 1 ELSE 0 END;
END;
