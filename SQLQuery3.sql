create database SupplyChain 
USE [SupplyChain]
GO

/****** Object:  Table [dbo].[supply_chain_data]    Script Date: 10/12/2025 7:20:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[supply_chain_data](
	[Product_type] [nvarchar](50) NOT NULL,
	[SKU] [nvarchar](50) NOT NULL,
	[Price] [float] NOT NULL,
	[Availability] [nvarchar](50) NOT NULL,
	[Number_of_products_sold] [int] NOT NULL,
	[Revenue_generated] [float] NOT NULL,
	[Customer_demographics] [nvarchar](50) NOT NULL,
	[Stock_levels] [nvarchar](50) NOT NULL,
	[Lead_times] [nvarchar](50) NOT NULL,
	[Order_quantities] [nvarchar](50) NOT NULL,
	[Shipping_times] [nvarchar](50) NOT NULL,
	[Shipping_carriers] [nvarchar](50) NOT NULL,
	[Shipping_costs] [float] NOT NULL,
	[Supplier_name] [nvarchar](50) NOT NULL,
	[Location] [nvarchar](50) NOT NULL,
	[Lead_time] [nvarchar](50) NOT NULL,
	[Production_volumes] [int] NOT NULL,
	[Manufacturing_lead_time] [nvarchar](50) NOT NULL,
	[Manufacturing_costs] [float] NOT NULL,
	[Inspection_results] [nvarchar](50) NOT NULL,
	[Defect_rates] [float] NOT NULL,
	[Transportation_modes] [nvarchar](50) NOT NULL,
	[Routes] [nvarchar](50) NOT NULL,
	[Costs] [float] NOT NULL,
	[Record_ID] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Record_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- ✅ Display the primary key information of the table
EXEC sp_pkeys @table_name = 'supply_chain_data';

-- ✅ Check the number of NULL values in each column (for data cleaning purposes)
SELECT 
    SUM(CASE WHEN Product_type IS NULL THEN 1 ELSE 0 END) AS Null_Product_type,
    SUM(CASE WHEN SKU IS NULL THEN 1 ELSE 0 END) AS Null_SKU,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Null_Price,
    SUM(CASE WHEN Availability IS NULL THEN 1 ELSE 0 END) AS Null_Availability,
    SUM(CASE WHEN Number_of_products_sold IS NULL THEN 1 ELSE 0 END) AS Null_Num_Sold,
    SUM(CASE WHEN Revenue_generated IS NULL THEN 1 ELSE 0 END) AS Null_Revenue,
    SUM(CASE WHEN Customer_demographics IS NULL THEN 1 ELSE 0 END) AS Null_Demographics,
    SUM(CASE WHEN Stock_levels IS NULL THEN 1 ELSE 0 END) AS Null_Stock,
    SUM(CASE WHEN Production_Lead_Time IS NULL THEN 1 ELSE 0 END) AS Null_ProductionLeadTime,
    SUM(CASE WHEN Order_quantities IS NULL THEN 1 ELSE 0 END) AS Null_OrderQuantities,
    SUM(CASE WHEN Shipping_times IS NULL THEN 1 ELSE 0 END) AS Null_ShippingTimes,
    SUM(CASE WHEN Shipping_carriers IS NULL THEN 1 ELSE 0 END) AS Null_Carriers,
    SUM(CASE WHEN Shipping_costs IS NULL THEN 1 ELSE 0 END) AS Null_ShippingCosts,
    SUM(CASE WHEN Supplier_name IS NULL THEN 1 ELSE 0 END) AS Null_SupplierName,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS Null_Location,
    SUM(CASE WHEN Supplier_Lead_Time IS NULL THEN 1 ELSE 0 END) AS Null_SupplierLeadTime,
    SUM(CASE WHEN Production_volumes IS NULL THEN 1 ELSE 0 END) AS Null_ProdVolumes,
    SUM(CASE WHEN Manufacturing_lead_time IS NULL THEN 1 ELSE 0 END) AS Null_ManuLeadTime,
    SUM(CASE WHEN Manufacturing_costs IS NULL THEN 1 ELSE 0 END) AS Null_ManuCosts,
    SUM(CASE WHEN Inspection_results IS NULL THEN 1 ELSE 0 END) AS Null_Inspection,
    SUM(CASE WHEN Defect_rates IS NULL THEN 1 ELSE 0 END) AS Null_DefectRates,
    SUM(CASE WHEN Transportation_modes IS NULL THEN 1 ELSE 0 END) AS Null_Transport,
    SUM(CASE WHEN Routes IS NULL THEN 1 ELSE 0 END) AS Null_Routes,
    SUM(CASE WHEN Costs IS NULL THEN 1 ELSE 0 END) AS Null_Costs
FROM dbo.supply_chain_data;

-- ✅ Display all rows in the table ordered by the primary key (Record_ID)
SELECT * FROM dbo.supply_chain_data ORDER BY Record_ID;

-- ✅ Replace 'Unknown' values in Customer_demographics with 'Other' (for clarity and consistency)
UPDATE dbo.supply_chain_data
SET Customer_demographics = 'Other'
WHERE Customer_demographics = 'Unknown';

-- ✅ Preview the updated data to confirm the changes
SELECT * FROM dbo.supply_chain_data ORDER BY Record_ID;

-- Renaming 'Lead_times' column to 'Production_Lead_Time' for clarity,
-- since it refers to the time required to manufacture or prepare products internally before shipping.
EXEC sp_rename 'supply_chain_data.Lead_times', 'Production_Lead_Time', 'COLUMN';

-- Renaming 'Lead_time' to 'Supplier_Lead_Time' to clarify that this column refers to 
-- the delivery time from the supplier to the business, not internal production lead time.
EXEC sp_rename 'dbo.supply_chain_data.Lead_time', 'Supplier_Lead_Time', 'COLUMN';

-- Standardize values in 'Shipping_carriers' column by trimming spaces and unifying carrier names
UPDATE dbo.supply_chain_data
SET Shipping_carriers = 'Carrier A'
WHERE LTRIM(RTRIM(Shipping_carriers)) = 'Carrier A';

UPDATE dbo.supply_chain_data
SET Shipping_carriers = 'Carrier B'
WHERE LTRIM(RTRIM(Shipping_carriers)) = 'Carrier B';

UPDATE dbo.supply_chain_data
SET Shipping_carriers = 'Carrier C'
WHERE LTRIM(RTRIM(Shipping_carriers)) = 'Carrier C';

-- Remove any leading or trailing spaces from Inspection_results
UPDATE dbo.supply_chain_data
SET Inspection_results = LTRIM(RTRIM(Inspection_results));

--✅ Check for duplicate SKU values to ensure product uniqueness.
SELECT SKU, COUNT(*) AS freq
FROM dbo.supply_chain_data
GROUP BY SKU
HAVING COUNT(*) > 1;

-- ✅ Get total units sold for each product type to identify best-selling categories
SELECT 
    Product_type,
    SUM(Number_of_products_sold) AS Total_Units_Sold
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Total_Units_Sold DESC;

-- ✅ Average shipping time by product type (logistic performance)
SELECT 
    Product_type, 
    ROUND(AVG(TRY_CAST(Shipping_times AS FLOAT)), 2) AS Avg_Shipping_Time
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Avg_Shipping_Time DESC;

-- ✅ Top delivery locations by number of orders
SELECT 
    Location, 
    COUNT(*) AS Total_Orders
FROM dbo.supply_chain_data
GROUP BY Location
ORDER BY Total_Orders DESC;

-- ✅ Count of unique products supplied by each supplier
SELECT Supplier_name, COUNT(DISTINCT SKU) AS Product_Count
FROM dbo.supply_chain_data
GROUP BY Supplier_name
ORDER BY Product_Count DESC;

-- ✅ Top suppliers ranked by total revenue generated
SELECT 
    Supplier_name,
    SUM(Revenue_generated) AS Total_Revenue
FROM dbo.supply_chain_data
GROUP BY Supplier_name
ORDER BY Total_Revenue DESC;

-- ✅ Calculate average manufacturing cost for each product type
SELECT 
    Product_type,
    AVG(CAST(Manufacturing_costs AS FLOAT)) AS Avg_Manufacturing_Cost
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Avg_Manufacturing_Cost DESC;

-- ✅ Calculate average defect rate for each product type
SELECT 
    Product_type,
    AVG(CAST(Defect_rates AS FLOAT)) AS Avg_Defect_Rate
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Avg_Defect_Rate DESC;

-- ✅ Calculate average shipping time for each shipping carrier
SELECT 
    Shipping_carriers,
    AVG(CAST(Shipping_times AS FLOAT)) AS Avg_Shipping_Time
FROM dbo.supply_chain_data
GROUP BY Shipping_carriers
ORDER BY Avg_Shipping_Time;

-- ✅ Average shipping time by delivery location
-- This helps identify which locations experience delays and may need logistic optimization.
SELECT 
    Location, 
    ROUND(AVG(TRY_CAST(Shipping_times AS FLOAT)), 2) AS Avg_Shipping_Time
FROM dbo.supply_chain_data
GROUP BY Location
ORDER BY Avg_Shipping_Time DESC;

-- ✅ Analyze relationship between manufacturing cost and defect rate
-- This query groups products by type to check if higher cost leads to lower defect rates.
SELECT 
    Product_type,
    ROUND(AVG(CAST(Manufacturing_costs AS FLOAT)), 2) AS Avg_Manufacturing_Cost,
    ROUND(AVG(CAST(Defect_rates AS FLOAT)), 3) AS Avg_Defect_Rate
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Avg_Defect_Rate ASC;

-- ✅ Identify top-performing suppliers based on cost, defect rate, and lead time
-- Combines average manufacturing cost, defect rate, and supplier lead time to rank suppliers.
SELECT 
    Supplier_name,
    ROUND(AVG(CAST(Manufacturing_costs AS FLOAT)), 2) AS Avg_Manufacturing_Cost,
    ROUND(AVG(CAST(Defect_rates AS FLOAT)), 3) AS Avg_Defect_Rate,
    ROUND(AVG(CAST(Supplier_Lead_Time AS FLOAT)), 2) AS Avg_Supplier_Lead_Time
FROM dbo.supply_chain_data
GROUP BY Supplier_name
ORDER BY Avg_Defect_Rate ASC, Avg_Supplier_Lead_Time ASC;

-- ✅ Evaluate each product type based on profitability, shipping speed, and defect rate
-- This helps in identifying which products are most efficient and reliable
SELECT 
    Product_type,
    ROUND(AVG(CAST(Revenue_generated AS FLOAT)), 2) AS Avg_Revenue,
    ROUND(AVG(CAST(Shipping_times AS FLOAT)), 2) AS Avg_Shipping_Time,
    ROUND(AVG(CAST(Defect_rates AS FLOAT)), 4) AS Avg_Defect_Rate
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Avg_Revenue DESC;

-- ✅ Analyze whether suppliers with longer lead times tend to produce fewer defects
SELECT 
    Supplier_name,
    ROUND(AVG(CAST(Supplier_Lead_Time AS FLOAT)), 2) AS Avg_Lead_Time,
    ROUND(AVG(CAST(Defect_rates AS FLOAT)), 3) AS Avg_Defect_Rate
FROM dbo.supply_chain_data
GROUP BY Supplier_name
ORDER BY Avg_Lead_Time ASC;

-- ✅ Check whether higher product availability is associated with more units sold
SELECT 
    Product_type,
    ROUND(AVG(Availability), 2) AS Avg_Availability,
    SUM(Number_of_products_sold) AS Total_Units_Sold
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Total_Units_Sold DESC;

-- ✅ Identify suppliers with the highest inspection pass rates
SELECT 
    Supplier_name,
    ROUND(SUM(CASE WHEN Inspection_results = 'Pass' THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 3) AS Pass_Rate
FROM dbo.supply_chain_data
GROUP BY Supplier_name
ORDER BY Pass_Rate DESC;

-- ✅ Determine which delivery routes have the highest average shipping cost
SELECT 
    Routes,
    ROUND(AVG(CAST(Shipping_costs AS FLOAT)), 2) AS Avg_Shipping_Cost
FROM dbo.supply_chain_data
GROUP BY Routes
ORDER BY Avg_Shipping_Cost DESC;

-- ✅ Compare average shipping time and cost by route to evaluate efficiency
SELECT 
    Routes,
    ROUND(AVG(CAST(Shipping_times AS FLOAT)), 2) AS Avg_Shipping_Time,
    ROUND(AVG(CAST(Shipping_costs AS FLOAT)), 2) AS Avg_Shipping_Cost
FROM dbo.supply_chain_data
GROUP BY Routes
ORDER BY Avg_Shipping_Time ASC;

-- ✅ Analyze average price per product type
-- This helps identify premium vs low-cost categories for pricing strategy decisions.
SELECT 
    Product_type,
    ROUND(AVG(Price), 2) AS Avg_Price
FROM dbo.supply_chain_data
GROUP BY Product_type
ORDER BY Avg_Price DESC;

-- ✅ Explore relationship between lead time and revenue
-- Helps understand if faster suppliers contribute more to revenue or if customers tolerate longer waits.
SELECT 
    Supplier_Lead_Time,
    ROUND(AVG(Revenue_generated), 2) AS Avg_Revenue
FROM dbo.supply_chain_data
GROUP BY Supplier_Lead_Time
ORDER BY Supplier_Lead_Time ASC;


-- ✅ Identify potentially risky suppliers with both high manufacturing cost and defect rate
SELECT 
    Supplier_name,
    ROUND(AVG(CAST(Manufacturing_costs AS FLOAT)), 2) AS Avg_Manufacturing_Cost,
    ROUND(AVG(CAST(Defect_rates AS FLOAT)), 3) AS Avg_Defect_Rate
FROM dbo.supply_chain_data
GROUP BY Supplier_name
HAVING AVG(CAST(Manufacturing_costs AS FLOAT)) > 2 AND AVG(CAST(Defect_rates AS FLOAT)) > 0.02
ORDER BY Avg_Manufacturing_Cost DESC, Avg_Defect_Rate DESC;

-- ✅ Identify the most cost-efficient supplier per product type
-- This helps understand which supplier offers the lowest manufacturing cost for each product type.
-- ✅ Find the most cost-efficient supplier per product type
WITH AvgCostPerSupplier AS (
    SELECT 
        Product_type,
        Supplier_name,
        ROUND(AVG(CAST(Manufacturing_costs AS FLOAT)), 2) AS Avg_Manufacturing_Cost
    FROM dbo.supply_chain_data
    GROUP BY Product_type, Supplier_name
),
MinCostPerProduct AS (
    SELECT 
        Product_type,
        MIN(Avg_Manufacturing_Cost) AS Min_Cost
    FROM AvgCostPerSupplier
    GROUP BY Product_type
)
SELECT 
    a.Product_type,
    a.Supplier_name,
    a.Avg_Manufacturing_Cost
FROM AvgCostPerSupplier a
JOIN MinCostPerProduct m
    ON a.Product_type = m.Product_type
   AND a.Avg_Manufacturing_Cost = m.Min_Cost
ORDER BY a.Product_type;

-- ✅ Identify suppliers with the highest variation in defect rates (quality inconsistency)
SELECT 
    Supplier_name,
    ROUND(AVG(CAST(Defect_rates AS FLOAT)), 4) AS Avg_Defect_Rate,
    ROUND(STDEV(CAST(Defect_rates AS FLOAT)), 4) AS Std_Dev_Defect_Rate
FROM dbo.supply_chain_data
GROUP BY Supplier_name
ORDER BY Std_Dev_Defect_Rate DESC;




SELECT * FROM dbo.supply_chain_data ORDER BY Record_ID;

