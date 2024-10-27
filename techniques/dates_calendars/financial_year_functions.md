# get financial month number (financial period)
### month number by financial year month start

```sql
CREATE FUNCTION [dbo].[fn_FinancialMonthNum] (
    @date DATE,
    @fiscal_year_start_month INT
)
RETURNS INT
AS
BEGIN
    DECLARE @month_num INT = MONTH(@date);

    RETURN 
        CASE 
            WHEN @month_num >= @fiscal_year_start_month AND @fiscal_year_start_month > 1 
                THEN @month_num - (@fiscal_year_start_month - 1)
            WHEN @fiscal_year_start_month = 1 
                THEN @month_num
            ELSE 
                @month_num + (12 - @fiscal_year_start_month + 1)
        END;
END;
-- SELECT dbo.fn_FinancialMonthNum( [date_value], 4 ) AS financial_month_num;

```

# get month offset
### current month offset
```sql
CREATE FUNCTION [dbo].[fn_MonthOffset] (
    @date DATE
)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(MONTH, GETDATE(), @date);
END;
-- SELECT dbo.fn_MonthOffset('2024-05-15') AS month_offset;
```

# get financial year offset
### current financial year offset
```sql
CREATE FUNCTION [dbo].[fn_FinancialYearOffset] (
    @date DATE,
    @fiscal_year_start_month INT
)
RETURNS INT
AS
BEGIN
    DECLARE @current_year INT = YEAR(GETDATE());
    DECLARE @current_month INT = MONTH(GETDATE());
    DECLARE @year_num INT = YEAR(@date);
    DECLARE @month_num INT = MONTH(@date);

    RETURN 
        (CASE WHEN @month_num >= @fiscal_year_start_month THEN @year_num + 1 ELSE @year_num END) - 
        (CASE WHEN @current_month >= @fiscal_year_start_month THEN @current_year + 1 ELSE @current_year END);
END;
-- SELECT dbo.fn_FinancialYearOffset('2024-05-15', 12) AS financial_year_offset;
```

# get financial year
### financial year as YY/YY format
```sql
CREATE FUNCTION [dbo].[fn_FinancialYear] (
    @date DATE,
    @fiscal_year_start_month INT
)
RETURNS VARCHAR(5)
AS
BEGIN
    RETURN CONCAT(
        RIGHT(YEAR(
            CASE 
                WHEN MONTH(@date) >= @fiscal_year_start_month THEN @date 
                ELSE DATEADD(YEAR, -1, @date)
            END
        ), 2), 
        '/',
        RIGHT(YEAR(
            CASE 
                WHEN MONTH(@date) >= @fiscal_year_start_month THEN DATEADD(YEAR, 1, @date) 
                ELSE @date
            END
        ), 2)
    );
END;
-- SELECT dbo.fn_FinancialYear('2024-05-15', 12) AS financial_year;

```

# get financial quarter offset
### financial year quarter offset
```sql
CREATE FUNCTION [dbo].[fn_FinancialQuarterOffset] (
    @date DATE,
    @current_date DATE,
    @fiscal_year_start_month INT
)
RETURNS INT
AS
BEGIN
    DECLARE @n INT = CASE 
                        WHEN @fiscal_year_start_month BETWEEN 2 AND 12 
                        THEN @fiscal_year_start_month - 1 
                        ELSE 0 
                    END;

    RETURN (
        (4 * YEAR(DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(@date), @date)))) + DATEPART(QUARTER, DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(@date), @date)))
    ) - (
        (4 * YEAR(DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(@current_date), @current_date)))) + DATEPART(QUARTER, DATEADD(MONTH, -@n, DATEADD(DAY, 1 - DAY(@current_date), @current_date)))
    );
END;
-- SELECT dbo.fn_FinancialQuarterOffset('2024-05-15', GETDATE(), 12) AS financial_quarter_offset;

```

# get financial quarter name
### financial quarter name as "FQ1"
```sql
CREATE FUNCTION [dbo].[fn_FinancialQuarterName] (
    @date DATE,
    @fiscal_year_start_month INT
)
RETURNS VARCHAR(5)
AS
BEGIN
    RETURN 'FQ' + CAST(dbo.fn_FinancialQuarterNum(@date, @fiscal_year_start_month) AS VARCHAR(3));
END;
-- SELECT dbo.fn_FinancialQuarterName('2024-05-15', 12) AS financial_quarter_name;

```

# get financial quarter number
### financial quarter as number 1,2,3,4
```sql
CREATE FUNCTION [dbo].[fn_FinancialQuarterNum] (
    @date DATE,
    @fiscal_year_start_month INT
)
RETURNS INT
AS
BEGIN
    RETURN FLOOR(((12 + MONTH(@date) - @fiscal_year_start_month) % 12) / 3) + 1;
END;
-- SELECT dbo.fn_FinancialQuarterNum('2024-05-15', 12) AS financial_quarter_num;

```
