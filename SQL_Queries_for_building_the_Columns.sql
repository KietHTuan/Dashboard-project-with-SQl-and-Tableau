
--We will build the required columns
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
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

--We will build the ovOrderCount and ovRunningOrderCount columns 
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
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

--Lets build the column for ovSalesvalue and ovRunningSalesvalue
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
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

--Lets build the columns for lagSalesGrowthIn$ and lagSalesGrowthIn%
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
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

--Lets build the columns for lagFreightGrowthIn$ and LagFreightGrowthPercent
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
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

--lets build our mvSalesValue and mvAvgSales
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
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


--Lets build our mvOrderCount and mvAvgOrder columns 

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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
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

--Lets build the xjSalesTypeName and xjSaleStatus
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
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	 xjSaleTypename, 
	 xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

from

(
Select 
	prod.ProductKey,
	st.SaleTypeName as xjSaleTypeName,
	CASE
		when Salesvalue > 0 then 'Had Sales'
		when Salesvalue is null then 'No Sales'
	End as xjSaleStatus, '2019-12-31' as OrderDate 
From 
	SaleType st cross join 
	Product prod left join 
(
Select 
	SaleTypeKey, 
	ProductKey,
	Sum(SalesAmount) as Salesvalue 

From 
	OnlineSales 
Where 
	Year(OrderDate) between 2017 and 2019 
Group by 
	SaleTypeKey,
	ProductKey 
	)as SalesTypeSales on SalesTypeSales.SaleTypeKey =st.SaleTypeKey and 
									SalesTypeSales. ProductKey = prod.ProductKey

Where 
	prod.ProductKey > 0 ) dt7


--Let build xjGeoSaleStatus and xjGeoSaleStatusCount
Union All 
Select 
	0 as ProductKey, 
	OrderDate,
	' ' as city, 
    ' ' as State, 
	 country, 
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
	0 as mvOrderCount, 
	0 as mvAvgOrders, 
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	 xjGeoSaleStatus, 
	Count(xjGeoSaleStatus) as xjGeoSaleStatusCount, 
	0 as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

from
(
Select 
	Distinct (prod.ProductKey),
	Geo. CountryRegionName as country, 
	CASE
		When SalesValue > 0 then 'Had Sales'
		When Salesvalue is null then 'No Sales' 
	End as xjGeoSaleStatus, '2019-12-31' as OrderDate  
From 
	Geolocation geo cross join 
	product prod left join 
(
	Select 
		Cus.GeographyKey,
		ProductKey,
		Sum (SalesAmount) as SalesValue 
	From 
		OnlineSales os inner join 
		Customer cus on os. CustomerKey = cus. CustomerKey
	Where 
		year(orderDate) between 2017 and 2019 
	Group by 
		GeographyKey, ProductKey 
		) as GeoSaleTypeSales on GeoSaleTypeSales. GeographyKey = geo.GeographyKey and
									GeoSaleTypeSales. ProductKey = prod.ProductKey

Where 
	prod. ProductKey > 0 ) dt8

Group by ProductKey, Country, xjGeoSaleStatus, OrderDate



--Lets build our cteAverageCustSales$ --We will run this one separtely from the above columns
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
	Avg(SalesValue) as cteAverageCustSales$,
	0 as cteAvgOrderProductQty

From 
	Sales_CTE
Group by 
	OrderDate
Order by 
	OrderDate

--Lets build our cteAvgOrderProductQty, we will run this separately from the above queries for visualisation
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
	' ' as xjSaleTypename, 
	' ' as xjSaleStatus, 
	' ' as xjGeoSaleStatus, 
	0 as xjGeoSaleStatusCount, 
	0 as cteAverageCustSales$,
	Avg(OrderQuantity) as cteAvgOrderProductQty

From 
	OrderQuantity_CTE
Group by 
	OrderDate 
Order by 
	OrderDate 