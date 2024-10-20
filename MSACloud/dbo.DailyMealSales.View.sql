USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DailyMealSales]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DailyMealSales]
AS
SELECT 
	CONVERT(datetime, CAST(datepart(mm, o.orderdate) as VARCHAR) + '/' + CAST(datepart(dd, o.orderdate) as VARCHAR) + '/' + CAST(datepart(yyyy, o.orderdate) as VARCHAR)) as ORDERDATE, 
	DATEPART(mm, o.OrderDate) as Month,
	DATEPART(yyyy, o.OrderDate) as Year,
	o.School_Id as SCHID,
	SUM(CASE WHEN ((c.isStudent = 1 OR c.id = -3) and (m.ItemType < 2) AND (lower(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN (it.PaidPrice * it.Qty) ELSE 0 END) as StudLunchSales, 
	SUM(CASE WHEN ((c.isStudent = 1 OR c.id = -3) and (m.ItemType = 2) AND (lower(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN (it.PaidPrice * it.Qty) ELSE 0 END) as StudBreakSales, 
	SUM(CASE WHEN ((c.isStudent = 1 OR c.id = -3) and (lower(cat.name) like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN (it.PaidPrice * it.Qty) ELSE 0 END) as StudSnackSales, 
	SUM(CASE WHEN ((c.isStudent = 0 OR c.id = -2) and (lower(m.itemname) = 'adult lunch') AND (ct.CanFree = 0 OR ct.CanReduce = 0)) THEN (it.PaidPrice * it.Qty) ELSE 0 END) as AdultLunchSales, 
	SUM(CASE WHEN ((c.isStudent = 0 OR c.id = -2) and (lower(m.itemname) = 'adult breakfast') AND (ct.CanFree = 0 OR ct.CanReduce = 0)) THEN (it.PaidPrice * it.Qty) ELSE 0 END) as AdultBreakSales, 
	SUM(CASE WHEN (((lower(m.itemname) <> 'adult lunch') and (lower(m.itemname) <> 'adult breakfast') OR (m.id is null)) and ((ct.CanFree = 0 and ct.CanReduce = 0) OR ct.id is null)) THEN (it.PaidPrice * it.Qty) ELSE 0 END) as AlaCarteSales, 
	0.0 as OtherIncome, 
	0.0 as CashSubtotal, 
	0.0 as OverUnder, 
	0.0 as TotalDeposit 
FROM Items it 
	LEFT OUTER JOIN Orders o on o.Id = it.Order_Id
	LEFT OUTER JOIN Customers c on c.Id = o.Customer_Id
	LEFT OUTER JOIN Menu m on m.Id = it.Menu_Id
	LEFT OUTER JOIN Category cat on cat.Id = m.Category_Id
	LEFT OUTER JOIN CategoryTypes ct on ct.Id = cat.CategoryType_Id
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
WHERE o.isVoid = 0 AND it.isVoid = 0 AND o.Emp_Cashier_Id <> -99 
GROUP BY CONVERT(datetime, CAST(datepart(mm, o.orderdate) as VARCHAR) + '/' + CAST(datepart(dd, o.orderdate) as VARCHAR) + '/' + CAST(datepart(yyyy, o.orderdate) as VARCHAR)),
	DATEPART(mm, o.OrderDate),
	DATEPART(yyyy, o.OrderDate),
	o.School_Id
UNION ALL
SELECT 
	CONVERT(datetime, CAST(datepart(mm, o.orderdate) as VARCHAR) + '/' + CAST(datepart(dd, o.orderdate) as VARCHAR) + '/' + CAST(datepart(yyyy, o.orderdate) as VARCHAR)) as ORDERDATE,  
	DATEPART(mm, o.OrderDate),
	DATEPART(yyyy, o.OrderDate),
	o.School_Id as SCHID,
	0.0 as StudLunchSales, 
	0.0 as StudBreakSales, 
	0.0 as StudSnackSales, 
	0.0 as AdultLunchSales, 
	0.0 as AdultBreakSales, 
	0.0 as AlaCarteSales, 
	SUM(CASE
		WHEN substring(CAST(o.transtype as varchar),1,1) <> '4' AND substring(CAST(o.transtype as varchar),2,1) <> '3'
				AND substring(CAST(o.transtype as varchar),2,1) <> '5' 
			THEN ((o.ADebit + o.MDebit) - (o.ACredit + o.MCredit))
		ELSE 0.0
	END) as OtherIncome, 
	SUM(CASE
		WHEN substring(CAST(o.transtype as varchar),1,1) <> '4' AND substring(CAST(o.transtype as varchar),2,1) <> '3'
				AND substring(CAST(o.transtype as varchar),2,1) <> '5' 
			THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END) as CashSubTotal, 
	SUM(CASE
		WHEN substring(CAST(o.transtype as varchar),1,1) <> '1' AND
				substring(CAST(o.transtype as varchar),1,1) <> '4' AND
				substring(CAST(o.transtype as varchar),1,2) <> '23' AND
				substring(CAST(o.transtype as varchar),2,1) <> '5' AND
				o.Customer_Id > 0 THEN -(o.ADebit + o.MDebit)
		ELSE 0.0
	END) as OverUnder, 
	SUM(CASE
		WHEN substring(CAST(o.transtype as varchar),1,1) = '1' AND substring(CAST(o.transtype as varchar),2,1) <> '5' 
			THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END) as TotalDeposit 
FROM Orders o 
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
WHERE o.isVoid = 0 AND o.Emp_Cashier_Id <> -99 
GROUP BY CONVERT(datetime, CAST(datepart(mm, o.orderdate) as VARCHAR) + '/' + CAST(datepart(dd, o.orderdate) as VARCHAR) + '/' + CAST(datepart(yyyy, o.orderdate) as VARCHAR)),
	DATEPART(mm, o.OrderDate),
	DATEPART(yyyy, o.OrderDate),
	o.School_Id
UNION ALL
SELECT 
	CONVERT(datetime, CAST(datepart(mm, cr.opendate) as VARCHAR) + '/' + CAST(datepart(dd, cr.opendate) as VARCHAR) + '/' + CAST(datepart(yyyy, cr.opendate) as VARCHAR)) as ORDERDATE, 
	DATEPART(mm, cr.opendate),
	DATEPART(yyyy, cr.opendate),
	ISNULL(p.School_Id,-3) as SCHID,
	0.0 as StudLunchSales, 
	0.0 as StudBreakSales, 
	0.0 as StudSnackSales, 
	0.0 as AdultLunchSales, 
	0.0 as AdultBreakSales, 
	0.0 as AlaCarteSales, 
	0.0 as OtherIncome, 
	0.0 as CashSubTotal, 
	sum(cr.closeamount - cr.openamount) as OverUnder, 
	SUM(cr.closeamount - cr.openamount) as TotalDeposit 
FROM CashResults cr 
	INNER JOIN POS p ON cr.Pos_Id = p.Id 
	LEFT OUTER JOIN Schools s ON s.Id = p.School_Id
WHERE cr.TotalCash <> 0.0 OR cr.Additional <> 0.0 OR cr.PaidOuts <> 0.0 OR cr.OverShort <> 0.0 OR cr.OpenAmount <> 0.0 OR cr.CloseAmount <> 0.0 OR cr.Sales <> 0.0
GROUP BY CONVERT(datetime, CAST(datepart(mm, cr.opendate) as VARCHAR) + '/' + CAST(datepart(dd, cr.opendate) as VARCHAR) + '/' + CAST(datepart(yyyy, cr.opendate) as VARCHAR)),
	DATEPART(mm, cr.opendate),
	DATEPART(yyyy, cr.opendate),
	ISNULL(p.School_Id,-3)
GO
