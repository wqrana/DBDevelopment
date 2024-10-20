USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[StatementOrders]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[StatementOrders]
AS
SELECT
	o.clientid,
	o.Customer_Id as CSTID,
	ISNULL(s.Id,-3) as SCHID,
	o.Id as ORDID,
	0 as OrderType,
	o.GDate,
	o.OrderDate,
	(o.ACredit + o.MCredit + o.BCredit) as TotalAccount,
	CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5' OR SUBSTRING(CAST(o.TransType as varchar),4,1) <> '0') THEN (o.ADebit + o.MDebit) 
		ELSE 0.0
	END as TotalPaid,
	CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '5' AND SUBSTRING(CAST(o.TransType as varchar),4,1) = '0') THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as Adjustment,
	CASE
		WHEN o.TransType = 4501 OR o.TransType = 4502 THEN '**'
		ELSE '' 
	END as OnlineTransfer,
	((o.ADebit + o.MDebit) - (o.ACredit + o.MCredit + o.BCredit)) as BalanceChange
FROM Orders o
	LEFT OUTER JOIN Customers c ON ((c.Id = o.Customer_Id) AND (c.clientid = o.clientid))
	LEFT OUTER JOIN Customer_School cs ON ((cs.Customer_Id = c.Id) AND (cs.isPrimary = 1) AND (cs.clientid = c.clientid))
	LEFT OUTER JOIN Schools s ON ((s.Id = cs.School_Id) and (s.clientid = cs.clientid))
WHERE (o.isVoid = 0 OR o.TransType = 1500) AND o.Emp_Cashier_Id <> -99 AND o.TransType <> 1700 AND o.Customer_Id > 0
UNION
SELECT
	pre.clientid,
	pre.Customer_Id as CSTID,
	ISNULL(s.Id,-3) as SCHID,
	pre.Id,
	1 as OrderType,
	CAST(CONVERT(varchar, pre.PurchasedDate, 101) as datetime) as GDate,
	pre.PurchasedDate,
	(pre.ACredit + pre.MCredit + pre.BCredit) as TotalAccount,
	0.0 as TotalPaid,
	0.0 as Adjustment,
	'' as OnlineTransfer,
	-(pre.ACredit + pre.MCredit + pre.BCredit) as BalanceChange
FROM PreOrders pre
	LEFT OUTER JOIN Customers c ON ((c.Id = pre.Customer_Id) AND (c.clientId = pre.clientid))
	LEFT OUTER JOIN Customer_School cs ON ((cs.Customer_Id = c.Id) AND (cs.isPrimary = 1) AND (cs.clientid = c.clientid))
	LEFT OUTER JOIN Schools s ON ((s.Id = cs.School_Id) AND (s.clientid = cs.clientid))
WHERE pre.isVoid = 0 AND pre.Customer_Id > 0
GO
