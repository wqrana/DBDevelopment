USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CustomerActivity]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[CustomerActivity]
AS
SELECT 
	o.ClientID,
	o.Id,
	o.Customer_Pr_School_Id,
	o.POS_Id,
	o.School_Id,
	o.Emp_Cashier_Id,
	o.Customer_Id,
	o.OrdersLog_Id,
	o.GDate,
	o.OrderDate,
	o.OrderDateLocal,
	o.LunchType,
	o.ADebit,
	o.MDebit,
	o.ACredit,
	o.BCredit,
	o.MCredit,
	o.CheckNumber,
	o.OverRide,
	o.isVoid,
	o.TransType,
	o.CreditAuth_Id,
	case TransType
	WHEN 4000 THEN 'Online Payment'
	ELSE RTRIM(c.LastName) + ', ' + RTRIM(c.FirstName) 
	END AS CashierName,
	(o.ADebit + o.MDebit) AS Debit, 
	(o.ACredit + o.BCredit + o.MCredit) AS Credit, 
	isnull(dbo.ItemTotal(o.ClientID, o.Id), 0.0) as Items, 
	isnull(dbo.SalesTaxTotal(o.ClientID, o.Id), 0.0) as SalesTax,
	0 as OrderType
FROM Orders o 
   LEFT OUTER JOIN Customers c ON (c.Id = o.Emp_Cashier_Id AND c.ClientID = o.ClientID)

UNION ALL

SELECT
	po.ClientID,
	po.Id,
    cs.School_Id as Customer_Pr_School_Id,
    -9 as POS_Id,
	cs.School_Id as School_Id,
    -9 as Emp_Cashier_Id,
    po.Customer_Id,
	po.OrdersLog_Id,
	CAST(po.TransferDate as smalldatetime) as GDate,
    po.TransferDate as OrderDate,
	po.TransferDateLocal as OrderDateLocal,
	po.LunchType,
	0.0 as ADebit,
	0.0 as MDebit,
    po.ACredit,
	po.BCredit,
	po.MCredit,
	po.PreSaleTrans_Id as CheckNumber,
	0 as [override],
	po.isVoid,
	po.Transtype,
	NULL as CreditAuth_Id,
	'PREORDER' as CashierName,
	0.0 as Debit,
	(po.MCredit + po.ACredit + po.BCredit) as Credit,
	isnull(dbo.PreorderItemTotal(po.ClientID, po.Id), 0.0) as Items,
	0.0 as SalesTax,
	1 as OrderType
FROM PreOrders po
	LEFT OUTER JOIN Customers c ON (c.Id = po.Customer_Id and c.ClientID = po.ClientID)
	LEFT OUTER JOIN Customer_School cs ON ((cs.Customer_Id = c.Id) AND (cs.isPrimary = 1) AND (cs.ClientID = c.ClientID))
GO
