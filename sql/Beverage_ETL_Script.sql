-- use Table Import wizard of MySQL Workbench to import the
-- beverage sales data of year 2021, 2022, and 2023 from data folder to the database

DROP TABLE IF EXISTS consolidated_beverage_data;

RENAME TABLE `beverage-orders-2021` TO beverage_orders_2021;
RENAME TABLE `beverage-orders-2022` TO beverage_orders_2022;
RENAME TABLE `beverage-orders-2023` TO beverage_orders_2023;

CREATE TABLE consolidated_beverage_data (
    Product VARCHAR(100),
    Weight INT,
    Volume INT,
    Caffeine INT,
    Per_Unit_Price DECIMAL(10,2),
    Quantity INT,
    Volume_Quantity INT,
    Weight_Quantity INT,
    Revenue_Quantity DECIMAL(12,2),
    Region VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    Category VARCHAR(50),
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Year INT
);

INSERT INTO consolidated_beverage_data (
    Product, Weight, Volume, Caffeine, Per_Unit_Price, Quantity,
    Volume_Quantity, Weight_Quantity, Revenue_Quantity,
    Region, State, Country, Category,
    First_Name, Last_Name, Year
)
SELECT DISTINCT
    t.Product,
    t.Weight,
    t.Volume,
    NULL AS Caffeine,
    t.Per_Unit_Price,
    t.Quantity,

    (t.Volume * t.Quantity) AS Volume_Quantity,
    (t.Weight * t.Quantity) AS Weight_Quantity,
    (t.Per_Unit_Price * t.Quantity) AS Revenue_Quantity,

    t.Region,
    t.State,
    t.Country,
    c.Category_Name,
    o.First_Name,
    o.Last_Name,
    2021 AS Year
FROM beverage_orders_2021 t
JOIN Category c
    ON t.Product = c.Product_Name
JOIN org_chart_table o
    ON c.Category_Name = o.Category_Name
WHERE o.First_Name IN ('Remi', 'Buford', 'Bodhi', 'Rowan');


INSERT INTO consolidated_beverage_data (
    Product, Weight, Volume, Caffeine, Per_Unit_Price, Quantity,
    Volume_Quantity, Weight_Quantity, Revenue_Quantity,
    Region, State, Country, Category,
    First_Name, Last_Name, Year
)
SELECT DISTINCT
    t.Product,
    t.Weight,
    t.Volume,
    t.Caffeine,
    t.Per_Unit_Price,
    t.Quantity,

    (t.Volume * t.Quantity) AS Volume_Quantity,
    (t.Weight * t.Quantity) AS Weight_Quantity,
    (t.Per_Unit_Price * t.Quantity) AS Revenue_Quantity,

    t.Region,
    t.State,
    t.Country,
    c.Category_Name,
    o.First_Name,
    o.Last_Name,
    2022 AS Year
FROM beverage_orders_2022 t
JOIN Category c
    ON t.Product = c.Product_Name
JOIN org_chart_table o
    ON c.Category_Name = o.Category_Name
WHERE o.First_Name IN ('Remi', 'Buford', 'Bodhi', 'Rowan');

INSERT INTO consolidated_beverage_data (
    Product, Weight, Volume, Caffeine, Per_Unit_Price, Quantity,
    Volume_Quantity, Weight_Quantity, Revenue_Quantity,
    Region, State, Country, Category,
    First_Name, Last_Name, Year
)
SELECT DISTINCT
    t.Product,
    t.Weight,
    t.Volume,
    t.Caffeine,
    t.Per_Unit_Price,
    t.Quantity,

    (t.Volume * t.Quantity) AS Volume_Quantity,
    (t.Weight * t.Quantity) AS Weight_Quantity,
    (t.Per_Unit_Price * t.Quantity) AS Revenue_Quantity,

    t.Region,
    t.State,
    t.Country,
    c.Category_Name,
    o.First_Name,
    o.Last_Name,
    2023 AS Year
FROM beverage_orders_2023 t
JOIN Category c
    ON t.Product = c.Product_Name
JOIN org_chart_table o
    ON c.Category_Name = o.Category_Name
WHERE o.First_Name IN ('Remi', 'Buford', 'Bodhi', 'Rowan');

SELECT * FROM consolidated_beverage_data;

SELECT *
FROM consolidated_beverage_data
ORDER BY 
    Last_Name ASC,
    Year ASC,
    Revenue_Quantity DESC;
    
# query for getting the final output
SELECT
	Last_Name,
    First_Name,
    Year,
    Category,
    Product,
    Country,
    Region,
    State,
    Weight,
    Volume,
    Caffeine,
    Per_Unit_Price,
	SUM(Quantity) AS Quantity_Sum,
    SUM(Revenue_Quantity) AS Revenue_Quantity_Sum
FROM consolidated_beverage_data
GROUP BY
	Last_Name,
    First_Name,
    Year,
    Category,
    Product,
    Country,
    Region,
    State,
    Weight,
    Volume,
    Caffeine,
    Per_Unit_Price
ORDER BY
	Last_Name,
    First_Name,
    Year,
    Category,
    Product,
    Country,
    Region,
    Revenue_Quantity_Sum DESC;

-- use export table wizard to export the data and put it to the output_final.csv

/* ============================================================
   5. EXPORT (MAC USERS: USE WORKBENCH EXPORT RESULTSET)
   ============================================================ */

/* This will only work if secure_file_priv allows it.
   On macOS, you will likely export manually from Workbench. */

-- SELECT *
-- INTO OUTFILE '/output/G3_output_final.csv'
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- FROM consolidated_beverage_data;

