# SQL Data Warehouse & Business Analytics Project

This project was developed as part of an advanced SQL project using SQL Server and SSMS.

The main goal was to transform the Superstore dataset into a relational data warehouse and use SQL for business analysis and KPI reporting.

## Project Overview

The project includes database design, data modeling, SQL analysis, KPI calculations, views, stored procedures, and business-focused queries.

The database was designed using fact and dimension tables with primary and foreign key relationships.

## Database Design

The project uses a star schema structure with:

* FactSales
* Customers
* T_Product
* Location
* ShipMode
* Dates
* Orders

The `FactSales` table stores the main sales transactions, while the other tables provide descriptive information used for analysis.

## SQL Analysis

The project includes analytical queries using:

* JOINs
* Subqueries
* CTEs
* CASE statements
* GROUP BY
* HAVING
* Aggregate functions
* Date analysis

The analysis covers areas such as:

* Total sales and profit
* Profit margin
* Sales by category and subcategory
* Customer sales
* Top products
* Sales trends by year and month
* Sales by state and city
* Customer segments
* Shipping modes
* Discount analysis
* Unprofitable products
* High-value orders

## Views

The project includes SQL views for analysis, including:

* `vw_SalesDetail`
* `vw_MonthlyKPI`

These views make it easier to work with detailed sales data and monthly KPI results.

## Stored Procedures

The project also includes stored procedures for reusable KPI analysis:

* `sp_KPI_By_Year`
* `sp_TopProducts_ByCategory`

These procedures accept parameters and return analysis based on the selected year or product category.

## Dataset

The project uses the Superstore dataset stored in:

`Central_Superstore.xlsx`

The data was prepared and loaded into the relational tables before running the SQL analysis.

## Tools Used

* SQL Server
* SQL Server Management Studio (SSMS)
* Microsoft Excel

## Project Files

### SQL Script

`Advanced_SQL_Data_Warehouse.sql`

Contains the database creation, table definitions, relationships, analytical queries, views, and stored procedures.

### Dataset

`Central_Superstore.xlsx`

Contains the source data used in the project.

## How to Run

1. Open SQL Server Management Studio.
2. Run the SQL script.
3. Make sure the required data has been loaded into the tables.
4. Execute the analytical queries.
5. Run the views and stored procedures to review the results.

## Academic Project

**University:** Assiut University
**Faculty:** Faculty of Computers & Information
**Course:** Advanced SQL / Database Project

## Author

**Ramy Rashad Zaher Farid**
