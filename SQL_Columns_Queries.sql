
/*All the columns will be built one by one to highlight the functions and techniques used. 

  Some prefixes mean in the column name:
  Tc: Candidate field or calculated field for Tableau
  Ov: Columns output from Window function OVER
  Lag = columns output from the Window function LAG OVER
  Mv = Columns output from window function OVER (Preceding)
  Cte = Columns output from CTE (Common Table Expression) queries


We will build the first 5 columns for SalesValue, ProductCost, SalesTax, TransportCost, OrderCount using aggregate functions */
Select 
	ProductKey, 
	OrderDate,
	City as city, 
	StateProvinceName as State, 
	CountryRegionName as country, 
	Sum(SalesAmount) as tcSalesValue, 
	Sum(TotalProductCost) as tcProductCost,
	Sum(TaxAmt) as tcSalestax,
	Sum(Freight) as tcTransportCost, 
	Count(distinct SalesOrderNumber) as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	0 as lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	0 as mvSalesvalue, 
	0 as mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

From 
	OnlineSales os inner join Customer cus on
	os.CustomerKey = cus.CustomerKey left join 
	GeoLocation geo on cus.GeographyKey = geo.GeographyKey

Where 
	year (OrderDate) between 2017 and 2019 
Group by 
	ProductKey, 
	OrderDate,
	City, 
	StateProvinceName, 
	CountryRegionName

--We will build the OrderCount and RunningOrderCount (Cumulative Order Count) columns using the OVER window function
Union all 
Select 
	0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	ovOrderCount, 
	ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	0 as lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	0 as mvSalesvalue, 
	0 as mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty
From
(
Select 
	OrderDate, 
	Count(distinct SalesOrderNumber) as ovOrderCount,
	Sum(Count(distinct SalesOrderNumber)) Over (Order by OrderDate) as ovRunningOrderCount

From OnlineSales
Where 
	Year(OrderDate) between 2017 and 2019
Group by 
	OrderDate
) dt1

--Lets build the column for Salesvalue and RunningSalesvalue using the OVER window function 
Union all 
Select 
	0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	 ovSalesValue, 
	ovRunningSalesTotal, 
	0 as lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	0 as mvSalesvalue, 
	0 as mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty
From
(
Select 
	orderDate, 
	Sum (SalesAmount) as ovSalesValue,
	Sum(Sum (SalesAmount)) over (order by Orderdate) as ovRunningSalesTotal

From 
	OnlineSales
where 
	year(orderdate) between 2017 and 2019 
Group by 
	OrderDate 
) dt2

--Lets build the columns for SalesGrowthIn$ and SalesGrowthIn% using the LAG window function to calculate the growth rate 
Union all 
Select 
	0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	 lagSalesGrowthIn$, 
	 lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	0 as mvSalesvalue, 
	0 as mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

from
(
Select 
	MonthStartDate as OrderDate, --It is the same as the data in the OrderDate column 
	Sum(SalesAmount) as SalesValue, 
	lag(Sum(SalesAmount), 1) Over (Order by MonthStartDate) as PreviousYearMonthSales,
	Sum (SalesAmount) - lag(Sum(SalesAmount), 1) Over (Order by MonthStartDate) as lagSalesGrowthIn$,
	100 * ((Sum (SalesAmount) - lag(Sum(SalesAmount), 1) Over (Order by MonthStartDate))/
		lag(Sum(SalesAmount), 1) Over (Order by MonthStartDate)	
	) as lagSalesGrowthInPercent
From 
	OnlineSales os inner join 
	Calendar cal on os.OrderDate = cal.DisplayDate
Where
	Year (orderDate) between 2017 and 2019
Group by	
	MonthStartDate) dt3

--Lets build the columns for FreightGrowthIn$ and FreightGrowthPercent using the LAG window function 
Union all 
Select 
	0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	0 as  lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	 lagFreightGrowthIn$, 
	 lagFreightGrowthInPercent, 
	0 as mvSalesvalue, 
	0 as mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders,  
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

from
(
Select 
	WeekStartDate as OrderDate, 
	sum(Freight) as Freightvalue, 
	lag(sum(freight) , 1) over (order by weekstartDate) as PreviousYearWeekfreight,
	Sum(Freight) - lag(sum(freight) , 1) over (order by weekstartDate) as lagFreightGrowthIn$,
	((Sum(Freight) - lag(sum(freight) , 1) over (order by weekstartDate))/
	(lag(sum(freight) , 1) over (order by weekstartDate))) *100 as LagFreightGrowthInPercent

From 
	OnlineSales os Inner join 
	Calendar cal on os.OrderDate = cal.DisplayDate
Where 
	year(orderDate) between 2017 and 2019 
Group by 
	WeekStartDate ) dt4

--lets build our moving SalesValue and moving Average Sales 
Union All 
Select 
	0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	0 as  lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	 mvSalesvalue, 
	 mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders,  
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

from

(Select 
	OrderDate,
	Sum(SalesAmount) as mvSalesValue,
	Avg(Sum(SalesAmount)) over (Order by OrderDate rows between 30 preceding and current row)
	as mvAvgSales ---The 30 is 30 days previous the first rows

From 
	OnlineSales

Where 
	year (OrderDate) between 2017 and 2019 
group by 
	OrderDate ) dt5


--Lets build our mvOrderCount and moving average Order columns 

Union All 
Select 
	0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	0 as  lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	0 as mvSalesvalue, 
	0 as  mvAvgSales, 
	 mvOrderCount, 
	 mvAvgOrders,  
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

from

(
Select 
	OrderDate, 
	Count(distinct(SalesOrderNumber)) as mvOrderCount,
	Avg(Count(distinct(SalesOrderNumber))) over (Order By OrderDate rows between 30 preceding and current row) 
		as mvAvgOrders

From 
	OnlineSales
where 
	year(OrderDate) between 2017 and 2019 
group by 
	OrderDate ) dt6


--By this point, the result from all of the above queries should be inserted into an Excel file for further Tableau usage 

--Lets build our Average customer Sales value using Temp table and We will run this one separtely from the above columns 
With Sales_CTE (OrderDate, CustomerKey, SalesValue)
As
(
Select
	Cast(Year(OrderDate) as char(4)) + '-01-01' as OrderDate,
	CustomerKey,
	Sum(SalesAmount) as SalesValue 

From 
	OnlineSales

Where 
	year(OrderDate) between 2017 and 2019 
Group by 
	year(OrderDate),
	CustomerKey
	)

Select 
0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	0 as  lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	0 as  mvSalesvalue, 
	0 as  mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	Avg(SalesValue) as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

From 
	Sales_CTE
Group by 
	OrderDate
Order by 
	OrderDate

--Lets build our Average Customer Order Quantity with temp table, we will run this separately from the above queries for visualisation
With OrderQuantity_CTE (OrderDate, CustomerKey, OrderQuantity) as 
(
Select 
	Cast(Year(OrderDate) as char(4)) + '-01-01' as OrderDate,
	Customerkey, 
	Sum(Orderquantity) as OrderQuantity 
 From 
	OnlineSales 

Where 
	year(OrderDate) between 2017 and 2019 
group by 
	orderDate, 
	CustomerKey
	)

	Select 
0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	' ' as country, 
	0 as tcSalesValue, 
	0 as tcProductCost,
	0 as tcSalestax,
	0 as tcTransportCost, 
	0 as tcOrderCount, 
	0 as ovOrderCount, 
	0 as ovRunningOrderCount, 
	0 as ovSalesValue, 
	0 as ovRunningSalesTotal, 
	0 as  lagSalesGrowthIn$, 
	0 as lagSalesGrowthInPercent, 
	0 as lagFreightGrowthIn$, 
	0 as lagFreightGrowthInPercent, 
	0 as  mvSalesvalue, 
	0 as  mvAvgSales, 
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	0 as cteAverageCustSales$,
	Avg(OrderQuantity) as cteAvgOrderProductQty

From 
	OrderQuantity_CTE
Group by 
	OrderDate 
Order by 
	OrderDate 

--Lastly, update our previous Excel worksheet with the outcomes of the last two columns (cteAverageCustSles$ and cteAvgOrderProductQty)
--The total rows we would  have is 123,061 rows (include the last 3 rows)