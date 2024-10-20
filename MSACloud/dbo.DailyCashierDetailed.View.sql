USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DailyCashierDetailed]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DailyCashierDetailed]
AS
SELECT 
	cr.Id as CASHRESID,
	cr.POS_Id as POSID,
	CASE
		WHEN cr.POS_Id = -3 THEN -3
		ELSE ISNULL(p.School_Id,-3)
	END as SCHID,
	ISNULL(s.SchoolID, '') as SchoolID,
	CASE
		WHEN cr.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(s.SchoolName,'**MISSING SCHOOL')
	END as SchoolName,
	CASE
		WHEN cr.Id IS NULL THEN '*NO CASHIER SESSION'
		WHEN cr.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(p.Name,'**MISSING POS')
	END as POSName,
	Emp.UserID,
	e.LoginName,
	Emp.LastName,
	Emp.FirstName,
	Emp.Middle,
	cr.OpenDate,
	cr.CloseDate,
	o.OrderDate,
	o.GDate,
	cr.Finished,
	cr.OpenAmount,
	cr.CloseAmount,
	(cr.CloseAmount - cr.OpenAmount) as Deposit,
	cr.Additional,
	cr.PaidOuts,
	cr.OverShort,
	(CASE
		WHEN (o.Customer_Id < 0) THEN 1
		ELSE 0
	END) as CashSalesCount,
	(CASE
		WHEN (o.Customer_Id < 0) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as CashSales,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = 0) AND ((o.MCredit + o.ACredit) > 0)) THEN 1
		ELSE 0
	END) as AccountSalesChargedCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = 0) AND ((o.MCredit + o.ACredit) > 0)) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesCharged,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) < (o.MCredit + o.ACredit)) AND ((o.MDebit + o.ADebit) > 0)) THEN 1
		ELSE 0
	END) as AccountSalesPartialCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) < (o.MCredit + o.ACredit)) AND ((o.MDebit + o.ADebit) > 0)) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesPartial,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = (o.MCredit + o.ACredit))) THEN 1
		ELSE 0
	END) as AccountSalesFullCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = (o.MCredit + o.ACredit))) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesFull,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) > (o.MCredit + o.ACredit)) AND ((o.MCredit + o.ACredit) <> 0)) THEN 1
		ELSE 0
	END) as AccountSalesAboveCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) > (o.MCredit + o.ACredit)) AND ((o.MCredit + o.ACredit) <> 0)) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesAbove,
	dbo.SalesTaxTotal(o.ClientID, o.id) as TaxCollected,
	CASE
		WHEN ((o.MCredit + o.ACredit) > 0) THEN 1
		WHEN (dbo.ItemCount(o.ClientID, o.id) > 0 AND o.LunchType = 3) THEN 1
		ELSE 0
	END as TotalSalesCount,
	dbo.ItemTotal(o.ClientID, o.id) as TotalSales,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '1') THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as CashTaken,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '2') THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as ChecksTaken,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '3') THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as CreditTaken,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4') THEN -(o.MDebit + o.ADebit)
		ELSE 0.0
	END) as Refunds,
	(CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN (o.MDebit + o.ADebit)
		WHEN '2' THEN (o.MDebit + o.ADebit)
		WHEN '3' THEN (o.MDebit + o.ADebit)
		WHEN '4' THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as TotalTaken	
FROM Transactions t
	INNER JOIN CashResults cr ON cr.Id = t.CashRes_Id
	INNER JOIN Orders o ON (o.Id = t.Order_Id AND t.OrderType = 0)
	LEFT OUTER JOIN POS p ON p.Id = cr.POS_Id
	LEFT OUTER JOIN Schools s ON s.Id = p.School_Id
	LEFT OUTER JOIN Customers Emp ON Emp.Id = cr.Emp_Cashier_Id
	LEFT OUTER JOIN Employee e ON e.Customer_Id = Emp.Id
WHERE cr.Finished = 1 AND o.isVoid = 0 AND o.Emp_Cashier_Id <> -99 AND o.Emp_Cashier_Id <> -98 AND SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4'
	AND SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
UNION ALL
SELECT 
	cr.Id as CASHRESID,
	o.POS_Id as POSID,
	o.School_Id as SCHID,
	ISNULL(s.SchoolID,'') as SchoolID,
	CASE
		WHEN o.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(s.SchoolName,'**MISSING SCHOOL')
	END as SchoolName,
	CASE
		WHEN cr.Id IS NULL THEN '*NO CASHIER SESSION'
		WHEN o.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(p.Name, '**MISSING POS')
	END as POSName,
	Emp.UserID,
	e.LoginName,
	Emp.LastName,
	Emp.FirstName,
	Emp.Middle,
	cr.OpenDate,
	cr.CloseDate,
	o.OrderDate,
	o.GDate,
	cr.Finished,
	ISNULL(cr.OpenAmount,0.0) as OpenAmount,
	ISNULL(cr.CloseAmount,0.0) as CloseAmount,
	ISNULL((cr.CloseAmount - cr.OpenAmount),0.0) as Deposit,
	ISNULL(cr.Additional,0.0) as Additional,
	ISNULL(cr.PaidOuts,0.0) as PaidOuts,
	ISNULL(cr.OverShort,0.0) as OverShort,
	(CASE
		WHEN (o.Customer_Id < 0) THEN 1
		ELSE 0
	END) as CashSalesCount,
	(CASE
		WHEN (o.Customer_Id < 0) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as CashSales,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = 0) AND ((o.MCredit + o.ACredit) > 0)) THEN 1
		ELSE 0
	END) as AccountSalesChargedCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = 0) AND ((o.MCredit + o.ACredit) > 0)) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesCharged,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) < (o.MCredit + o.ACredit))) THEN 1
		ELSE 0
	END) as AccountSalesPartialCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) < (o.MCredit + o.ACredit))) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesPartial,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = (o.MCredit + o.ACredit))) THEN 1
		ELSE 0
	END) as AccountSalesFullCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) = (o.MCredit + o.ACredit))) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesFull,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) > (o.MCredit + o.ACredit)) AND ((o.MCredit + o.ACredit) <> 0)) THEN 1
		ELSE 0
	END) as AccountSalesAboveCount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND ((o.MDebit + o.ADebit) > (o.MCredit + o.ACredit)) AND ((o.MCredit + o.ACredit) <> 0)) THEN dbo.ItemTotal(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesAbove,
	dbo.SalesTaxTotal(o.ClientID, o.id) as TaxCollected,
	CASE 
		WHEN SUBSTRING(CAST(o.TransType as varchar),3,1) = '1' THEN 1
		WHEN SUBSTRING(CAST(o.TransType as varchar),3,1) = '2' THEN 1
		WHEN SUBSTRING(CAST(o.TransType as varchar),3,1) = '3' AND (o.ACredit + o.MCredit) > 0 THEN 1
		WHEN SUBSTRING(CAST(o.TransType as varchar),3,1) = '3' AND (o.ACredit + o.MCredit) = 0.0 AND o.LunchType = 3 AND dbo.ItemCount(o.ClientID, o.id) > 0 THEN 1
		WHEN SUBSTRING(CAST(o.TransType as varchar),3,1) = '4' AND (o.ACredit + o.MCredit) > 0 THEN 1
		ELSE 0
	END as TotalSalesCount,
	dbo.ItemTotal(o.ClientID, o.id) as TotalSales,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '1') THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as CashTaken,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '2') THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as ChecksTaken,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '3') THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as CreditTaken,
	(CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4') THEN -(o.MDebit + o.ADebit)
		ELSE 0.0
	END) as Refunds,
	(CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN (o.MDebit + o.ADebit)
		WHEN '2' THEN (o.MDebit + o.ADebit)
		WHEN '3' THEN (o.MDebit + o.ADebit)
		WHEN '4' THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as TotalTaken		
FROM Orders o
	LEFT OUTER JOIN Transactions t ON t.Order_Id = o.Id
	LEFT OUTER JOIN CashResults cr ON (cr.Pos_Id = o.Pos_Id AND o.OrderDate >= cr.OpenDate AND o.OrderDate <= cr.CloseDate AND cr.Finished = 1)
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
	LEFT OUTER JOIN POS p ON p.Id = o.POS_Id
	LEFT OUTER JOIN Customers Emp ON Emp.Id = o.Emp_Cashier_Id
	LEFT OUTER JOIN Employee e ON e.Customer_Id = Emp.Id
WHERE t.CashRes_Id IS NULL AND o.isVoid = 0 AND o.Emp_Cashier_Id <> -99 AND o.Emp_Cashier_Id <> -98 AND SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4' 
	AND SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
GO
