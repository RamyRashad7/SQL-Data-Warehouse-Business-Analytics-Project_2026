CREATE DATABASE Mini_Project;
USE Mini_Project;





--------------------------------------------------------------------------------------------------------------------
CREATE TABLE Customers (
  CustomerID   VARCHAR(20)  PRIMARY KEY,
  CustomerName VARCHAR(100) NOT NULL,
  Segment      VARCHAR(30)  NOT NULL
);
GO 


CREATE TABLE T_Product (
  ProductID   VARCHAR(30)  PRIMARY KEY,
  ProductName VARCHAR(255) NOT NULL,
  Category    VARCHAR(50)  NOT NULL,
  SubCategory VARCHAR(50)  NOT NULL
);
GO


CREATE TABLE Location (
  LocationID INT PRIMARY KEY,
  Country    VARCHAR(50),
  State      VARCHAR(50),
  City       VARCHAR(50),
  PostalCode VARCHAR(10),
  Region     VARCHAR(20)
);
GO

CREATE TABLE ShipMode (
  ShipModeID INT PRIMARY KEY,
  ShipMode   VARCHAR(30) NOT NULL UNIQUE
);
GO 


CREATE TABLE Dates (
  DateKey    INT PRIMARY KEY,      -- YYYYMMDD
  FullDate   DATE NOT NULL,
  Year     SMALLINT,
  Quarter  TINYINT,
  Month    TINYINT,
  MonthName  VARCHAR(15),
  Day      TINYINT,
  DayName    VARCHAR(15),
  WeekOfYear TINYINT
);
GO 

CREATE TABLE Orders (
  OrderID      VARCHAR(20) PRIMARY KEY,
  CustomerID   VARCHAR(20) NOT NULL,
  LocationID   INT         NOT NULL,
  ShipModeID   INT         NOT NULL,
  OrderDateKey INT         NOT NULL,
  ShipDateKey  INT         NOT NULL,
  CONSTRAINT fk_o_cust FOREIGN KEY (CustomerID)   REFERENCES Customers(CustomerID),
  CONSTRAINT fk_o_loc  FOREIGN KEY (LocationID)   REFERENCES Location(LocationID),
  CONSTRAINT fk_o_ship FOREIGN KEY (ShipModeID)   REFERENCES ShipMode(ShipModeID),
  CONSTRAINT fk_o_od   FOREIGN KEY (OrderDateKey) REFERENCES Dates(DateKey),
  CONSTRAINT fk_o_sd   FOREIGN KEY (ShipDateKey)  REFERENCES Dates(DateKey)
);
GO 


CREATE TABLE FactSales (
  SalesID      INT PRIMARY KEY,
  OrderID      VARCHAR(20) NOT NULL,
  CustomerID   VARCHAR(20) NOT NULL,
  ProductID    VARCHAR(30) NOT NULL,
  LocationID   INT         NOT NULL,
  ShipModeID   INT         NOT NULL,
  OrderDateKey INT         NOT NULL,
  ShipDateKey  INT         NOT NULL,
  Sales        DECIMAL(12,4) NOT NULL,
  Quantity     INT           NOT NULL,
  Discount     DECIMAL(5,2)  NOT NULL,
  Profit       DECIMAL(12,4) NOT NULL,
  CONSTRAINT fk_f_order FOREIGN KEY (OrderID)      REFERENCES Orders(OrderID),
  CONSTRAINT fk_f_cust  FOREIGN KEY (CustomerID)   REFERENCES Customers(CustomerID),
  CONSTRAINT fk_f_prod  FOREIGN KEY (ProductID)    REFERENCES T_Product(ProductID),
  CONSTRAINT fk_f_loc   FOREIGN KEY (LocationID)   REFERENCES Location(LocationID),
  CONSTRAINT fk_f_ship  FOREIGN KEY (ShipModeID)   REFERENCES ShipMode(ShipModeID),
  CONSTRAINT fk_f_od    FOREIGN KEY (OrderDateKey) REFERENCES Dates(DateKey),
  CONSTRAINT fk_f_sd    FOREIGN KEY (ShipDateKey)  REFERENCES Dates(DateKey)
);
GO

--------------------------------------------------------------------------------------------------------------------
/* 
ف الدتا انا كل جدول عملتله في سيت EXCLE لوحده بعدها حولته الى ملف CSV 
ودخلت كل جدول لوحده 
*/





SELECT COUNT(*) AS Customers FROM Customers;
SELECT COUNT(*) AS Products  FROM T_Product;
SELECT COUNT(*) AS Locations FROM Location;
SELECT COUNT(*) AS ShipModes FROM ShipMode;
SELECT COUNT(*) AS Dates     FROM Dates;
SELECT COUNT(*) AS Orders    FROM Orders;
SELECT COUNT(*) AS FactRows  FROM FactSales;

--------------------------------------------------------------------------------------------------------------------


SELECT ROUND(SUM(Sales),2)  AS TotalSales,
       ROUND(SUM(Profit),2) AS TotalProfit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS ProfitMarginPct
FROM FactSales;


--------------------------------------------------------------------------------------------------------------------



SELECT p.Category,
       ROUND(SUM(f.Sales),2)  AS Sales,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
JOIN T_Product p ON p.ProductID = f.ProductID
GROUP BY p.Category
ORDER BY Sales DESC;



--------------------------------------------------------------------------------------------------------------------



SELECT p.Category, p.SubCategory,
       ROUND(SUM(f.Sales),2)  AS Sales,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
JOIN T_Product p ON p.ProductID = f.ProductID
GROUP BY p.Category, p.SubCategory
ORDER BY Sales DESC;


--------------------------------------------------------------------------------------------------------------------



SELECT c.CustomerID, c.CustomerName, c.Segment,
       ROUND(SUM(f.Sales),2)       AS Sales,
       COUNT(DISTINCT f.OrderID)   AS OrdersCount
FROM FactSales f
JOIN Customers c ON c.CustomerID = f.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Segment
ORDER BY Sales DESC ;


--------------------------------------------------------------------------------------------------------------------




SELECT TOP 10 p.ProductName,
       ROUND(SUM(f.Sales),2)  AS Sales,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
JOIN T_Product p ON p.ProductID = f.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Sales DESC ;




--------------------------------------------------------------------------------------------------------------------





SELECT d.Year,
       ROUND(SUM(f.Sales),2)  AS Sales,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
JOIN Dates d ON d.DateKey = f.OrderDateKey
GROUP BY d.Year
ORDER BY d.Year;


--------------------------------------------------------------------------------------------------------------------




SELECT d.Year, d.Month, d.MonthName,
       ROUND(SUM(f.Sales),2)  AS Sales,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
JOIN Dates d ON d.DateKey = f.OrderDateKey
GROUP BY d.Year, d.Month, d.MonthName
ORDER BY d.Year, d.Month;




--------------------------------------------------------------------------------------------------------------------




SELECT TOP 10  l.State,
       ROUND(SUM(f.Sales),2)  AS Sales,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
JOIN Location l ON l.LocationID = f.LocationID
GROUP BY l.State
ORDER BY Sales DESC ;


--------------------------------------------------------------------------------------------------------------------





SELECT TOP 10 l.City, l.State,
       ROUND(SUM(f.Sales),2) AS Sales
FROM FactSales f
JOIN Location l ON l.LocationID = f.LocationID
GROUP BY l.City, l.State
ORDER BY Sales DESC ;



--------------------------------------------------------------------------------------------------------------------






SELECT c.Segment,
       ROUND(SUM(f.Sales),2) AS Sales,
       ROUND(SUM(f.Sales) / (SELECT SUM(Sales) FROM FactSales) * 100,2) AS PctOfTotal
FROM FactSales f
JOIN Customers c ON c.CustomerID = f.CustomerID
GROUP BY c.Segment
ORDER BY Sales DESC;





--------------------------------------------------------------------------------------------------------------------





SELECT s.ShipMode,
       COUNT(*)               AS LinesCount,
       ROUND(SUM(f.Sales),2)  AS Sales
FROM FactSales f
JOIN ShipMode s ON s.ShipModeID = f.ShipModeID
GROUP BY s.ShipMode
ORDER BY Sales DESC;


--------------------------------------------------------------------------------------------------------------------



SELECT s.ShipMode,
       COUNT(*) AS OrdersCount,
       ROUND(AVG(DATEDIFF(DAY, od.FullDate, sd.FullDate)),2) AS AvgDeliveryDays
FROM Orders o
JOIN ShipMode s ON s.ShipModeID = o.ShipModeID
JOIN Dates od ON od.DateKey = o.OrderDateKey
JOIN Dates sd ON sd.DateKey = o.ShipDateKey
GROUP BY s.ShipMode
ORDER BY AvgDeliveryDays;



--------------------------------------------------------------------------------------------------------------------



SELECT CASE WHEN f.Discount = 0     THEN 'No Discount'
            WHEN f.Discount <= 0.20 THEN 'Low (1-20%)'
            WHEN f.Discount <= 0.40 THEN 'Medium (21-40%)'
            ELSE 'High (>40%)' END AS DiscountBand,
       COUNT(*)               AS LinesCount,
       ROUND(SUM(f.Sales),2)  AS Sales,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
GROUP BY CASE WHEN f.Discount = 0     THEN 'No Discount'
             WHEN f.Discount <= 0.20 THEN 'Low (1-20%)'
             WHEN f.Discount <= 0.40 THEN 'Medium (21-40%)'
             ELSE 'High (>40%)' END
ORDER BY Sales DESC;



--------------------------------------------------------------------------------------------------------------------



SELECT p.ProductName, p.SubCategory,
       ROUND(SUM(f.Profit),2) AS Profit
FROM FactSales f
JOIN T_Product p ON p.ProductID = f.ProductID
GROUP BY p.ProductID, p.ProductName, p.SubCategory
HAVING SUM(f.Profit) < 0
ORDER BY Profit;



--------------------------------------------------------------------------------------------------------------------




SELECT OrderID, ROUND(SUM(Sales),2) AS OrderValue
FROM FactSales
GROUP BY OrderID
HAVING SUM(Sales) > (SELECT AVG(v) FROM (SELECT SUM(Sales) AS v FROM FactSales GROUP BY OrderID) t)
ORDER BY OrderValue DESC;
GO



--------------------------------------------------------------------------------------------------------------------




WITH CustomerSales AS
(
    SELECT
        c.CustomerID,
        c.CustomerName,
        c.Segment,
        ROUND(SUM(f.Sales), 2) AS TotalSales,
        ROUND(SUM(f.Profit), 2) AS TotalProfit
    FROM FactSales f
    JOIN Customers c
        ON c.CustomerID = f.CustomerID
    GROUP BY
        c.CustomerID,
        c.CustomerName,
        c.Segment
)
SELECT TOP 10
    CustomerID,
    CustomerName,
    Segment,
    TotalSales,
    TotalProfit
FROM CustomerSales
ORDER BY TotalSales DESC;
GO



--------------------------------------------------------------------------------------------------------------------





WITH CategoryPerformance AS
(
    SELECT
        p.Category,
        ROUND(SUM(f.Sales), 2) AS TotalSales,
        ROUND(SUM(f.Profit), 2) AS TotalProfit,
        SUM(f.Quantity) AS TotalQuantity
    FROM FactSales f
    JOIN T_Product p
        ON p.ProductID = f.ProductID
    GROUP BY
        p.Category
)
SELECT
    Category,
    TotalSales,
    TotalProfit,
    TotalQuantity,
    CASE
        WHEN TotalSales > 0
        THEN ROUND((TotalProfit / TotalSales) * 100, 2)
        ELSE 0
    END AS ProfitMarginPct
FROM CategoryPerformance
ORDER BY TotalSales DESC;
GO





--------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW vw_SalesDetail
AS
SELECT f.SalesID,
       f.OrderID,
       d.FullDate AS OrderDate,
       d.Year AS SalesYear,
       d.Month AS SalesMonth,
       d.MonthName,
       c.CustomerName,
       c.Segment,
       p.Category,
       p.SubCategory,
       p.ProductName,
       l.State,
       l.City,
       l.Region,
       s.ShipMode,
       f.Sales,
       f.Quantity,
       f.Discount,
       f.Profit
FROM FactSales f
JOIN Dates d
    ON d.DateKey = f.OrderDateKey
JOIN Customers c
    ON c.CustomerID = f.CustomerID
JOIN T_Product p
    ON p.ProductID = f.ProductID
JOIN Location l
    ON l.LocationID = f.LocationID
JOIN ShipMode s
    ON s.ShipModeID = f.ShipModeID;
GO



--------------------------------------------------------------------------------------------------------------------





CREATE OR ALTER VIEW vw_MonthlyKPI
AS
SELECT SalesYear,
       SalesMonth,
       MonthName,
       ROUND(SUM(Sales),2) AS Sales,
       ROUND(SUM(Profit),2) AS Profit,
       COUNT(DISTINCT OrderID) AS OrdersCount
FROM vw_SalesDetail
GROUP BY SalesYear, SalesMonth, MonthName;
GO


SELECT *
FROM vw_MonthlyKPI
ORDER BY SalesYear, SalesMonth;
GO


--------------------------------------------------------------------------------------------------------------------







CREATE OR ALTER PROCEDURE sp_KPI_By_Year
    @p_Year INT
AS
BEGIN
    SELECT
        @p_Year AS Yr,
        ROUND(SUM(f.Sales),2) AS TotalSales,
        ROUND(SUM(f.Profit),2) AS TotalProfit,
        COUNT(DISTINCT f.OrderID) AS OrdersCount,
        COUNT(DISTINCT f.CustomerID) AS CustomersCount
    FROM FactSales f
    JOIN Dates d
        ON d.DateKey = f.OrderDateKey
    WHERE d.Year = @p_Year;
END;
GO

EXEC sp_KPI_By_Year @p_Year = 2025;
GO




--------------------------------------------------------------------------------------------------------------------





CREATE OR ALTER PROCEDURE sp_TopProducts_ByCategory
    @p_Category VARCHAR(50),
    @p_Top INT
AS
BEGIN

    SELECT TOP (@p_Top)
           p.ProductName,
           ROUND(SUM(f.Sales),2) AS Sales,
           ROUND(SUM(f.Profit),2) AS Profit
    FROM FactSales f
    JOIN T_Product p
        ON p.ProductID = f.ProductID
    WHERE p.Category = @p_Category
    GROUP BY p.ProductID, p.ProductName
    ORDER BY Sales DESC;

END;
GO

EXEC sp_TopProducts_ByCategory
    @p_Category = 'Technology',
    @p_Top = 10;



