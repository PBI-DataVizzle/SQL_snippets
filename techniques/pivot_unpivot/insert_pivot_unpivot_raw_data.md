# DATA TO UNPIVOT
### copy, paste, execute

``` sql

CREATE TABLE dbo.data_to_unpivot (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductCategoryID INT,
    ProductCategoryName NVARCHAR(50),
    ProductName NVARCHAR(100),

    -- Monthly sales columns from Jan-24 to Dec-24
    [2024-01-01] INT,
    [2024-02-01] INT,
    [2024-03-01] INT,
    [2024-04-01] INT,
    [2024-05-01] INT,
    [2024-06-01] INT,
    [2024-07-01] INT,
    [2024-08-01] INT,
    [2024-09-01] INT,
    [2024-10-01] INT,
    [2024-11-01] INT,
    [2024-12-01] INT
);

-- Step 2: Insert 3 products for each category, with random sales values for each month
INSERT INTO dbo.data_to_unpivot (
    ProductCategoryID, ProductCategoryName, ProductName,
    [2024-01-01], [2024-02-01], [2024-03-01], [2024-04-01], [2024-05-01], [2024-06-01],
    [2024-07-01], [2024-08-01], [2024-09-01], [2024-10-01], [2024-11-01], [2024-12-01]
)
VALUES 
    -- Bikes Category
    (1, 'Bikes', 'Mountain Bike', 
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)
    ),
    (1, 'Bikes', 'Road Bike', 
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)
    ),
    (1, 'Bikes', 'Hybrid Bike', 
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)
    ),
    -- Repeat similarly for Components, Clothing, and Accessories categories
    -- (ProductCategoryID, 'Category Name', 'Product Name', [Jan] - [Dec] random values)
    
    (2, 'Components', 'Brakes', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),

    (2, 'Components', 'Wheels', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),

    (2, 'Components', 'Saddles', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),
    
    (3, 'Clothing', 'Jersey', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),

    (3, 'Clothing', 'Gloves', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),

    (3, 'Clothing', 'Helmet', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),
    
    (4, 'Accessories', 'Water Bottle', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),

    (4, 'Accessories', 'Lights', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0)),

    (4, 'Accessories', 'Lock', ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0),
        ROUND(100 + RAND(CHECKSUM(NEWID())) * (1000-100), 0));

-- Step 3: Verify the inserted data
SELECT * FROM dbo.data_to_unpivot;

```


# DATA TO PIVOT
### copy, paste, execute

``` sql

-- Step 2: Create the product_catalog table with specified columns
CREATE TABLE dbo.data_to_pivot (
    ProductID INT PRIMARY KEY,                -- Unique identifier for each product
    ProductCategoryID INT,                    -- Identifier for product category
    ProductCategoryName NVARCHAR(50),         -- Name of the product category
    Size NVARCHAR(100),                -- Name of the product
    Quantity INT                              -- Quantity available for each product
);

-- Step 3: Insert predefined data into the product_catalog table
INSERT INTO dbo.data_to_pivot (ProductID, ProductCategoryID, ProductCategoryName, Size, Quantity)
VALUES
    (1, 1, 'Bikes', 'Big', 10),
    (2, 1, 'Bikes', 'Big', 5),
    (3, 1, 'Bikes', 'Small', 50),
    (4, 2, 'Components', 'Small', 200),
    (5, 2, 'Components', 'Small', 150),
    (6, 2, 'Components', 'Big', 350),
    (7, 3, 'Clothing', 'Big', 65),
    (8, 3, 'Clothing', 'Small', 50),
    (9, 3, 'Clothing', 'Big', 40),
    (10, 4, 'Accessories', 'Small', 500),
    (11, 4, 'Accessories', 'Small', 350),
    (12, 4, 'Accessories', 'Small', 850);

-- Step 4: Verify the inserted data
SELECT * FROM dbo.data_to_pivot;

```
