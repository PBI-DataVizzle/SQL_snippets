SELECT 
    COLUMN_NAME,
    DATA_TYPE

FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'dim_calendar'   -- Replace with your table name
    AND TABLE_SCHEMA = 'dbo';  -- Optional: specify schema if needed
