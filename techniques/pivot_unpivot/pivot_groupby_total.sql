CREATE TABLE #TBL (UserID INT,Subject VARCHAR(20),Score INT)
INSERT INTO #TBL VALUES
(1,'AAA',76),(1,'BBB',87),(1,'CCC',86),(2,'AAA',98),(2,'BBB',82),(2,'CCC',90)

DECLARE @sql_str VARCHAR(8000)
DECLARE @select_column VARCHAR(8000)
DECLARE @spread_elements VARCHAR(8000)

SELECT @spread_elements = ISNULL(@spread_elements + ',','') + QUOTENAME(Subject) 
FROM #TBL 
GROUP BY Subject
--PRINT @spread_elements
SET @select_column = REPLACE(REPLACE(@spread_elements,'[','SUM(['),']','])')
--PRINT @select_column

SET @sql_str = '
;WITH CTE(UserID,'+@spread_elements+') AS
(
SELECT UserID,'+@select_column+' 
FROM (SELECT UserID,Subject,Score FROM #TBL) S 
PIVOT (MAX(Score) FOR Subject IN ( '+ @spread_elements +') ) AS P
GROUP BY GROUPING SETS((UserID),())
)SELECT * FROM CTE; 
'
--PRINT (@sql_str)
EXEC (@sql_str)
