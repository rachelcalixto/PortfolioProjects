/* Dataset source
https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting/data
*/
-------------------

select * from Superstore..train;

-- Get the total sales per YEAR
-- Use CONVERT for Ship Date (NVARCHAR data TYPE)
-- Use CAST to convert Sales (Float) to 2 decimal 
SELECT YEAR(CONVERT(DATE,[Ship Date], 103)) as tyear, 
 CAST(sum([Sales]) AS decimal(18,2)) 
 FROM TRAIN
 GROUP BY YEAR(CONVERT(DATE,[Ship Date], 103))
 ORDER BY YEAR(CONVERT(DATE,[Ship Date], 103));
 
 -- Which product is saleable
SELECT [Product ID],[Product Name], CAST(sum([Sales]) AS decimal(18,2))
FROM train
GROUP BY [Product ID],[Product Name]
ORDER by CAST(sum([Sales]) AS decimal(18,2)) DESC;

-- Get the Average sales per product
SELECT [Product ID],[Product Name], CAST(AVG([Sales]) AS decimal(18,2)) Average_sales
FROM train
GROUP BY [Product ID],[Product Name];

-- Get the count of Ship Mode frequency
select [Ship Mode], COUNT(*) as Ship_Frequency from train
group by [Ship Mode];

-- Which City is most profitable
SELECT City, CAST(AVG([Sales]) AS decimal(18,2)) Average_sales
FROM train
GROUP BY City
ORDER BY CAST(AVG([Sales]) AS decimal(18,2)) DESC;

-- Number of sales by Year and Month 
SELECT YEAR(CONVERT(DATE,[Ship Date], 103)) Year_sold, 
DATENAME(month,CONVERT(DATE,[Ship Date], 103)) Month_sold, 
 count(*) Number_sales
 FROM TRAIN
 GROUP BY YEAR(CONVERT(DATE,[Ship Date], 103)),
 DATENAME(month,CONVERT(DATE,[Ship Date], 103)),
 MONTH(CONVERT(DATE,[Ship Date], 103))
 ORDER BY YEAR(CONVERT(DATE,[Ship Date], 103)),
 MONTH(CONVERT(DATE,[Ship Date], 103));
 
 -- Using CTE to rank sales per year with the most monthly Sales using ROW_NUMBER and PARTITION BY
  WITH RankedSales AS (
    SELECT
        YEAR(CONVERT(DATE,[Ship Date], 103)) Year_sold,
        DATENAME(month,CONVERT(DATE,[Ship Date], 103)) Month_sold,
        CAST(sum([Sales]) AS decimal(18,2)) Total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(CONVERT(DATE,[Ship Date], 103)) 
            ORDER BY CAST(sum([Sales]) AS decimal(18,2)) DESC, DATENAME(month,CONVERT(DATE,[Ship Date], 103)) ASC
        ) AS RowNum
    FROM TRAIN
     GROUP BY YEAR(CONVERT(DATE,[Ship Date], 103)),
 DATENAME(month,CONVERT(DATE,[Ship Date], 103))
)
SELECT
    Year_sold,
    Month_sold,
    Total_sales,
    RowNum
FROM RankedSales
ORDER BY Year_sold, RowNum;

-- Create View for total sales per year and month

Create View TotalSalesPerYearMonth as
SELECT YEAR(CONVERT(DATE,[Ship Date], 103)) Year_sold, 
DATENAME(month,CONVERT(DATE,[Ship Date], 103)) Month_sold, 
 count(*) Number_sales
 FROM TRAIN
 GROUP BY YEAR(CONVERT(DATE,[Ship Date], 103)),
 DATENAME(month,CONVERT(DATE,[Ship Date], 103)),
 MONTH(CONVERT(DATE,[Ship Date], 103));

 select * from TotalSalesPerYearMonth
 order by Year_sold, Month_sold;