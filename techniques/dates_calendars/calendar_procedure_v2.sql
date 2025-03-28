ALTER PROCEDURE [USP].[SP_exec_create_dim_calendar_refresh]
AS
BEGIN
    SET NOCOUNT ON;

    -- Central date context
    DECLARE @today DATE = CAST(GETDATE() AS DATE);
    DECLARE @current_year INT = YEAR(@today);
    DECLARE @current_month INT = MONTH(@today);
    DECLARE @financial_year_start_month INT = 12;
    DECLARE @n INT = IIF(@financial_year_start_month > 1, @financial_year_start_month - 1, 0);

    -- Truncate target table if exists
    IF OBJECT_ID('[PBI_DataStore].PBI.dim_calendar', 'U') IS NOT NULL
    BEGIN
        TRUNCATE TABLE [PBI_DataStore].PBI.dim_calendar;
    END;

    -- Recursive date series generator
    WITH date_series AS (
        SELECT DATEFROMPARTS(@current_year - 3, 1, 1) AS date_id
        UNION ALL
        SELECT DATEADD(DAY, 1, date_id)
        FROM date_series
        WHERE date_id < DATEFROMPARTS(@current_year + 3, 12, 31)
    )
    , core_date_fields AS (
        SELECT 
              date_id
            , YEAR(date_id) AS year_num
            , MONTH(date_id) AS month_num
            , DAY(date_id) AS day_month_num
            , DATENAME(MONTH, date_id) AS month_name
            , LEFT(DATENAME(MONTH, date_id), 3) AS month_name_short
            , DATENAME(WEEKDAY, date_id) AS day_name
            , LEFT(DATENAME(WEEKDAY, date_id), 3) AS day_name_short
            , ((DATEPART(WEEKDAY, date_id) + 5) % 7) + 1 AS iso_weekday_num  -- ISO: 1=Monday, 7=Sunday
            , DATEPART(DAYOFYEAR, date_id) AS day_year_num
            , DATEPART(QUARTER, date_id) AS quarter_num
            , DATEFROMPARTS(YEAR(date_id), MONTH(date_id), 1) AS month_start
            , EOMONTH(date_id) AS month_end
            , LEFT(DATENAME(WEEKDAY, date_id), 1) AS day_initial
            , LEFT(DATENAME(MONTH, date_id), 1) AS month_initial
        FROM date_series
    )
    , additional_date_fields AS (
        SELECT
              date_id
            , year_num
            , year_num - @current_year AS year_offset
            , CASE WHEN date_id <= @today THEN 1 ELSE 0 END AS is_ytd
            , CASE WHEN date_id > @today THEN 1 ELSE 0 END AS is_frc
            , CASE WHEN DATEDIFF(MONTH, @today, date_id) < 0 THEN 1 ELSE 0 END AS is_cmtd

            , CONCAT(
                RIGHT(YEAR(CASE WHEN month_num >= @financial_year_start_month THEN date_id ELSE DATEADD(YEAR, -1, date_id) END), 2), '/',
                RIGHT(YEAR(CASE WHEN month_num >= @financial_year_start_month THEN DATEADD(YEAR, 1, date_id) ELSE date_id END), 2)
              ) AS financial_year

            , (CASE WHEN month_num >= @financial_year_start_month THEN year_num + 1 ELSE year_num END)
              - (CASE WHEN @current_month >= @financial_year_start_month THEN @current_year + 1 ELSE @current_year END) AS financial_year_offset

            , month_num, month_name, month_name_short, month_initial, month_start, month_end
            , DATEDIFF(MONTH, @today, date_id) AS month_offset
            , CASE 
                WHEN month_num >= @financial_year_start_month AND @financial_year_start_month > 1 THEN month_num - (@financial_year_start_month - 1)
                WHEN @financial_year_start_month = 1 THEN month_num
                ELSE month_num + (12 - @financial_year_start_month + 1)
              END AS financial_month_num

            , day_initial, day_name, day_name_short, day_year_num, day_month_num
            , iso_weekday_num AS day_week_num
            , DATEDIFF(DAY, @today, date_id) AS day_offset
            , IIF(iso_weekday_num BETWEEN 1 AND 5, 1, 0) AS is_weekday
            , IIF(iso_weekday_num IN (6, 7), 1, 0) AS is_weekend
            , quarter_num
            , CONCAT('Q', quarter_num) AS quarter_name
            , ((4 * year_num) + quarter_num) - ((4 * @current_year) + DATEPART(QUARTER, @today)) AS quarter_offset

            , FLOOR(((12 + month_num - @financial_year_start_month) % 12) / 3 ) + 1 AS financial_quarter_num
            , 'FQ' + CAST(FLOOR(((12 + month_num - @financial_year_start_month) % 12) / 3 ) + 1 AS VARCHAR(3)) AS financial_quarter_name

            , ((4 * YEAR(DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(date_id), date_id))))
                + DATEPART(QUARTER, DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(date_id), date_id))))
              - ((4 * YEAR(DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(@today), @today))))
                + DATEPART(QUARTER, DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(@today), @today)))) AS financial_quarter_offset

            , DATEADD(DAY, 1 - iso_weekday_num, date_id) AS week_start
            , DATEADD(DAY, 7 - iso_weekday_num, date_id) AS week_end
            , DATEDIFF(WEEK,
                DATEADD(DAY, 1 - ((DATEPART(WEEKDAY, @today) + 5) % 7 + 1), @today),
                DATEADD(DAY, 1 - iso_weekday_num, date_id)
              ) AS week_offset
        FROM core_date_fields
    )
    , cte_dim_calendar_output AS (
        SELECT 
            adf.*
            , DATEADD(DAY, -364, @today) AS py_date_id
            , DATEADD(DAY, -728, @today) AS py_minus_1_date_id
            , DATEADD(DAY, -30, @today) AS pm_date_id
            , DATEADD(DAY, -60, @today) AS pm_minus_1_date_id

            , CASE 
                WHEN (DATEPART(WEEK, date_id) % 2) = 1 
                    THEN DATEADD(DAY, 1 - iso_weekday_num, date_id)
                ELSE DATEADD(DAY, 1 - iso_weekday_num, DATEADD(DAY, -7, date_id))
              END AS [2W Date]

            , EOMONTH(DATEADD(MONTH, -((MONTH(date_id) - 1) % 2), date_id)) AS [2M Date]
            , EOMONTH(DATEADD(MONTH, -((MONTH(date_id) - 1) % 3), date_id)) AS [3M Date]
            , EOMONTH(DATEADD(MONTH, -((MONTH(date_id) - 1) % 6), date_id)) AS [6M Date]

            , (year_num * 12) + month_num - 1 AS date_int_key
            , (year_num * 10000) + (month_num * 100) + day_month_num AS date_int
            , DATEFROMPARTS(year_num, 1, 1) AS year_start
            , EOMONTH(DATEFROMPARTS(year_num, 12, 1)) AS year_end
            , IIF(year_offset = -1, 1, 0) AS is_previous_year
            , IIF(year_offset = 0, 1, 0) AS is_current_year
            , IIF(year_offset = 0, 'Current CY', CAST(year_num AS VARCHAR)) AS year_selection
            , IIF(financial_year_offset = -1, 1, 0) AS is_previous_fy
            , IIF(financial_year_offset = 0, 1, 0) AS is_current_fy
            , IIF(financial_year_offset = 0, 'Current FY', financial_year) AS fy_selection

            , CASE WHEN month_num >= @financial_year_start_month THEN DATEFROMPARTS(year_num, @financial_year_start_month, 1)
                   ELSE DATEFROMPARTS(year_num - 1, @financial_year_start_month, 1) END AS financial_year_start
            , CASE WHEN month_num >= @financial_year_start_month THEN EOMONTH(DATEFROMPARTS(year_num + 1, @financial_year_start_month - 1, 1))
                   ELSE EOMONTH(DATEFROMPARTS(year_num, @financial_year_start_month - 1, 1)) END AS financial_year_end

            , FORMAT(date_id, 'MMM-yy') AS month_year_short
            , FORMAT(date_id, 'MMM-yyyy') AS month_year_long
            , (year_num * 100) + month_num AS month_year_int
            , IIF(month_offset = 0, 1, 0) AS is_current_month
            , IIF(month_offset = 0, 'Current Month', month_name_short) AS current_month_selection

            , month_name AS financial_month
            , month_name_short AS financial_month_short
            , month_initial AS financial_month_initial
            , month_start AS financial_month_start
            , month_end AS financial_month_end
            , FORMAT(date_id, 'MMM-yy') AS financial_month_year_short
            , FORMAT(date_id, 'MMM-yyyy') AS financial_month_year_long
            , (CAST(REPLACE(financial_year, '/', '') AS INT) * 100) + financial_month_num AS financial_month_year_int
            , month_offset AS financial_month_offset

            , (year_num * 100) + quarter_num AS quarter_year_int
            , (CAST(REPLACE(financial_year, '/', '') AS INT) * 100) + financial_quarter_num AS financial_quarter_year_int
            , hol.is_holiday, hol.holiday_name
            , CASE 
                WHEN is_weekday = 1 AND is_weekend = 0 AND COALESCE(hol.is_holiday, 0) = 0 
                THEN 1 ELSE 0 
              END AS is_workday

        FROM additional_date_fields adf
        LEFT JOIN ENT.sql_holidays hol ON adf.date_id = hol.holiday_date
    )
    INSERT INTO [PBI_DataStore].PBI.dim_calendar (
        [date_id],[date_int_key],[date_int],[year_num],[year_start],[year_end],[is_previous_year],[is_current_year],[year_selection],
        [year_offset],[is_ytd],[is_frc],[is_cmtd],[py_date_id],[py_minus_1_date_id],[pm_date_id],[pm_minus_1_date_id],[2W Date],[2M Date],
        [3M Date],[6M Date],[financial_year],[financial_year_start],[financial_year_end],[is_previous_fy],[is_current_fy],[fy_selection],
        [financial_year_offset],[month_num],[month_name],[month_name_short],[month_initial],[month_start],[month_end],[month_year_short],
        [month_year_long],[month_year_int],[is_current_month],[current_month_selection],[month_offset],[financial_month_num],[financial_month],
        [financial_month_short],[financial_month_initial],[financial_month_start],[financial_month_end],[financial_month_year_short],[financial_month_year_long],
        [financial_month_year_int],[financial_month_offset],[day_initial],[day_name],[day_name_short],[day_year_num],[day_month_num],
        [day_week_num],[day_offset],[is_weekday],[is_weekend],[is_holiday],[is_workday],[holiday_name],[quarter_num],[quarter_name],
        [quarter_year_int],[quarter_offset],[financial_quarter_num],[financial_quarter_name],[financial_quarter_year_int],[financial_quarter_offset],
        [week_start],[week_end],[week_offset]
    )
    SELECT * FROM cte_dim_calendar_output
    OPTION (MAXRECURSION 0);

    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE name = 'IX_dim_calendar_date_id' 
        AND object_id = OBJECT_ID('[PBI_DataStore].PBI.dim_calendar')
    )
    BEGIN
        CREATE INDEX IX_dim_calendar_date_id 
        ON [PBI_DataStore].PBI.dim_calendar ([date_id]);
    END;
END;
