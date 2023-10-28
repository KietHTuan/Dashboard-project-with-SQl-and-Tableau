# Dashboard-project-with-SQl-and-Tableau
This data analysis project encompassed a complete cycle from gathering requirements to querying data using SQL, analyzing key metrics, and creating an interactive dashboard in Tableau. 

## Problems and Requirements 
The stakeholders at an eCommerce enterprise specializing in technology products require two dashboards to be built for sales performance tracking:
1. Sales Performance Dashboard (Includes Sales, MonthlySalesGrowth, SalesMovingAverage, OrderCount, OverRunningOrderCount, AverageCustomerSales, GlobalSalesValue)
2. General Performance Dashboard (Includes TransportCost, OrderCount, OverRunnningOrderCount, Running SalesValue, WeeklyFreightGrowth, AverageCustomerOrderCount, GlobalFreightCost)

*For both of the dashboards, they must:
1. Have filter options by the year
2. Contain data for the three years 2017, 2018, 2019 only. 

## About the dataset 
This is the dataset about an eCommerce enterprise product sales provided by dropbox, and even though the origin company information has been anonymized, an assessment of data quality (checking for nulls, outliers, inconsistencies) has been done before the analysis. 
You can download the database backup file from this [Dropbox link](https://www.dropbox.com/s/36tizd0u8hwklla/The%20eCommerce%20database%20backup%20for%20SQL%202014%20users.zip?dl=0).

![Data model](https://user-images.githubusercontent.com/144747702/278792803-9ac88391-1c6d-4d58-a93c-fcec0687f502.png)

## Methodologies
The first stage of the project we will load the dataset into Microsoft SQL Server 2019 by using the object explorer.

In this project, SQL was utilized for data retrieval and manipulation. Complex SQL queries were formulated to extract the required data from the database, including a combination of filters, joins, and aggregations. For further metrics calculation such as growth rate and moving average, window functions (OVER, LAG) will be utilized. 
(see "SQL_Columns_Queries.sql"). Note that we will only interested in the year 2017, 2018, 2019 only. 

After retrieving the outcomes from the queries, we transfer the data to an Excel worksheet, which serves as a preparation step for creating visualizations in Tableau

In Tableau, we employ the intuitive drag-and-drop functionality to construct calculated fields and progressively create individual graphs and charts. Additionally, interactive actions are added to enable filtering of data by year. The final step of this process involves assembling all the components into a comprehensive and aesthetic dashboard.

Here is the links to our Dashboards:

![Sales Performance](https://public.tableau.com/views/SalesPerformance_16984747516920/SalesPerformance?:language=en-GB&:display_count=n&:origin=viz_share_link)

![General Performance](https://public.tableau.com/views/GeneralPerformance_16984748007190/GenearalPerformance?:language=en-GB&:display_count=n&:origin=viz_share_link)





## Limitations
The source origin of the dataset is yet to be determined and this could potentially affect its credibility. For improvements, extra steps of checking the data quality have been taken before the analysis.  


## References

- Paul Scotchford, [ Queries Guide]. Available at: [https://www.awari.au/blog].

- Fan Wu, [Statistical Metric Calculation Guide]. Can be contact at: [https://www.uvic.ca/science/math-statistics/people/home/faculty/wu_fan.php]

- Nathan Rosodi. (2023). [The ultimate guide on SQL Window]. Stratascratch. [https://www.stratascratch.com/blog/the-ultimate-guide-to-sql-window-functions/]

- Alex the Analyst. [How to Create a Portfolio Website]. Youtube. [https://youtu.be/ocdwh0KYeUs]

- Alex the Analyst. [Advanced SQL Tutorial | CTE (Common Table Expression)]. Youtube. [https://youtu.be/K1WeoKxLZ5o?list=PLUaB-1hjhk8EBZNL4nx4Otoa5Wb--rEpU]

- Datacamp. https://www.datacamp.com/tutorial/cleaning-data-sql?utm_source=google&utm_medium=paid_search&utm_campaignid=19589720821&utm_adgroupid=157156375591&utm_device=c&utm_keyword=&utm_matchtype=&utm_network=g&utm_adpostion=&utm_creative=676354849181&utm_targetid=aud-1704732079567:dsa-2218886984820&utm_loc_interest_ms=&utm_loc_physical_ms=9001604&utm_content=&utm_campaign=230119_1-sea~dsa~tofu_2-b2c_3-row-p1_4-prc_5-na_6-na_7-le_8-pdsh-go_9-na_10-na_11-na-oct23&gad_source=1&gclid=CjwKCAjwv-2pBhB-EiwAtsQZFLDJVFnKOCZN0OKZ6EzS7-KTCR3QWtL_gVPKfhRm3dtIfOwwS4fE8xoCG2gQAvD_BwE


