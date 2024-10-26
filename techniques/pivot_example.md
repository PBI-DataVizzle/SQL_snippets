## template

``` sql
SELECT <non-pivoted columns>, [pivoted_column_1], [pivoted_column_2], ...
FROM (
    -- Step 1: Define the source query
    SELECT <non-pivoted columns>, <pivot_column>, <aggregate_column>
    FROM <source_table>
) AS SourceTable
PIVOT (
    -- Step 2: Specify the aggregate function and the column to pivot
    <aggregate_function>(<aggregate_column>)
    FOR <pivot_column> IN ([pivoted_column_1], [pivoted_column_2], ...)
) AS PivotTable;

```
**Explanation**
1. Inner Query (SourceTable): The initial query selects columns to pivot, along with the values for pivoting.  
2. Pivot Specification (PIVOT Clause):  
<aggregate_function>(<aggregate_column>): Performs aggregation for the pivoted data. Common functions are COUNT, SUM, or MAX.  
FOR <pivot_column> IN (...): Specifies the column values to pivot and lists distinct values to become columns.  
3. Outer Query: Selects the non-pivoted columns and the newly created pivoted columns.  


## example

``` sql
SELECT ProductID, Name, [Black], [Blue], [Red], [Yellow] -- List pivoted columns for known colors
FROM (
    SELECT ProductID, Name, Color
    FROM [AW_2022].[Production].[Product]
    WHERE Color IS NOT NULL
) AS SourceTable
PIVOT (
    COUNT(Color) -- Counting the occurrence of each color per ProductID
    FOR Color IN ([Black], [Blue], [Red], [Yellow]) -- Specify distinct colors as columns
) AS PivotTable
ORDER BY ProductID;

```

**Explanation of the Query**
1. Source Query (SourceTable):  
We select ProductID, Name, and Color for products where Color is not NULL.  
2. Pivot Specification:  
COUNT(Color): Counts occurrences of each color for each product, which results in either 0 (no match) or 1 (match) in the pivoted columns.  
FOR Color IN (...): Specifies the colors as column headers in the result. Here, you’ll replace [Black], [Blue], [Red], [Yellow] with the actual distinct colors you want in your final table.  
3. Final Selection:  
The outer query selects ProductID, Name, and the newly created columns for each color.  
