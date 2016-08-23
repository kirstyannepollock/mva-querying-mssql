select 
	ROW_NUMBER() OVER (order by SalesOrderDetailID) as R1,

	-- within each order, row number ordered by detail id
	ROW_NUMBER() OVER (PARTITION BY SalesOrderID order by SalesOrderDetailID) as R2,
	
	Sum(unitprice) OVER (PARTITION BY SalesOrderID) as totalorderprice,	
	rank() Over (PARTITION BY SalesOrderID order by unitprice) as salesrank

	--Can't do this ...
	--rank() Over ( ORDER BY Sum(unitprice) OVER (PARTITION BY SalesOrderID) ) as ss

from sales.salesorderdetail as t
order by SalesOrderDetailID


--all customers and last 5 orders with APPLY
select

	c.customerid,
	c.accountnumber,
	o.*

from
	sales.customer as c
OUTER APPLY
(
	SELECT TOP (5) soh.orderdate, soh.salesorderid
	FROM sales.SalesOrderHeader as soh
	WHERE soh.CustomerID = c.CustomerID
	ORDER BY soh.orderdate desc
) as o
WHERE c.territoryId = 1
order by c.customerid

--Current balance
select
	*,
	amount - LAG(amount, 1, 0) OVER (PARTITION BY accountID ORDER BY transactiondate, transactionid) as diff,
	sum(amount) OVER (PARTITION BY accountID) as finalBalance,
	sum(amount) OVER 
	(
		PARTITION BY accountID
		ORDER BY transactiondate, transactionid

		--  implicit with order by?
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) as currentbalance
from
	transactions --you'd need to create this!
WHERE
	accountid = 12345 --or whatever
ORDER BY 
	transactiondate, transactionid
	
	select @@version


