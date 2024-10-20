USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[StatementDetailOrders]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[StatementDetailOrders]
AS
SELECT
	o.ClientID,
	o.Customer_Id as CSTID,
	ISNULL(s.Id,-3) as SCHID,
	o.Id as ORDID,
	'' as OrderTypeName,
	0 as OrderType,
	o.GDate,
	o.OrderDate,
	o.TransType,
	CASE
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' AND o.CheckNumber = 0 THEN 'Check Payment'
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' THEN ISNULL('Check Payment (# ' + CAST(o.CheckNumber as varchar) + ')', 'Check Payment')
		WHEN SUBSTRING(CAST(o.TransType as varchar),1,2) = '43' THEN ISNULL('Online Credit Card Payment (Trans ID: ' + CAST(-o.CheckNumber as varchar) + ')', 'Online CC Payment')
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '3' THEN ISNULL('Credit Card Payment (Trans ID: ' + CAST(-o.CheckNumber as varchar) + ')', 'Credit Card Payment') 
		WHEN SUBSTRING(CAST(o.TransType as varchar),1,2) = '46' THEN 'Online ACH Payment'
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '6' THEN 'ACH Payment'
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '4' THEN 'Refund'
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '5' AND SUBSTRING(CAST(o.TransType as varchar),4,1) = '0') THEN 'Adjustment'
		WHEN o.TransType = 4501 THEN 'Online Transfer OUT'
		WHEN o.TransType = 4502 THEN 'Online Transfer IN'
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '0' THEN ''
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) <> '1' THEN ISNULL('Unknown Payment (Trans ID: ' + CAST(o.CheckNumber as varchar) + ')', 'Unknown Payment')
		ELSE 'Cash Payment'
	END as PaymentType,
	(o.ACredit + o.MCredit + o.BCredit) as TotalAccount,
	CASE 
		WHEN (o.ADebit + o.MDebit) = 0.0 THEN NULL
		ELSE (o.ADebit + o.MDebit)
	END as TotalPaid,
	dbo.SalesTaxTotal(o.ClientID, o.Id) as SalesTax,
	((o.ADebit + o.MDebit) - (o.ACredit + o.MCredit + o.BCredit)) as BalanceChange,
	isnull(sum(i.qty),0) as TotalItemQTY
FROM Orders o
	LEFT OUTER JOIN Customers c ON (o.ClientID = c.ClientID AND c.Id = o.Customer_Id)
	LEFT OUTER JOIN Customer_School cs ON (cs.ClientID = c.ClientID) AND ((cs.Customer_Id = c.Id) AND (cs.isPrimary = 1))
	LEFT OUTER JOIN Schools s ON (s.ClientID = cs.ClientID AND s.Id = cs.School_Id)
	LEFT OUTER JOIN Items i on (i.ClientID = o.clientID AND i.order_id = o.id)
WHERE (o.isVoid = 0 OR (SUBSTRING(CAST(o.TransType as varchar),2,1) = '5' AND SUBSTRING(CAST(o.TransType as varchar),4,1) = '0')) AND o.Emp_Cashier_Id <> -99 AND o.TransType <> 1700 AND o.Customer_Id > 0
GROUP BY o.CLientID, o.Customer_ID, s.Id, o.id, o.gdate, o.orderdate, o.transtype, o.checknumber, (o.acredit + o.mcredit + o.bcredit), (o.adebit + o.mdebit), ((o.adebit + o.mdebit) - (o.Acredit + o.mcredit + o.bcredit))
UNION ALL
SELECT
	pre.ClientID,
	pre.Customer_Id as CSTID,
	ISNULL(s.Id,-3) as SCHID,
	pre.Id,
	' - (PreOrder) ' as OrderTypeName,
	1 as OrderType,
	CAST(CONVERT(varchar, pre.PurchasedDate, 101) as datetime) as GDate,
	pre.PurchasedDate,
	pre.Transtype,
	'' as PaymentType,
	(pre.ACredit + pre.MCredit + pre.BCredit) as TotalAccount,
	NULL as TotalPaid,
	0.0 as SalesTax,
	-(pre.ACredit + pre.MCredit + pre.BCredit) as BalanceChange,
	isnull(sum(poi.qty),0) as TotalItemQTY
FROM PreOrders pre
	LEFT OUTER JOIN Customers c ON (c.ClientID = pre.ClientID AND c.Id = pre.Customer_Id)
	LEFT OUTER JOIN Customer_School cs ON (cs.ClientID = c.ClientID) AND ((cs.Customer_Id = c.Id) AND (cs.isPrimary = 1))
	LEFT OUTER JOIN Schools s ON (s.ClientID = cs.ClientID and s.Id = cs.School_Id)
	LEFT OUTER JOIN PreOrderItems poi on (poi.ClientID = pre.ClientID and poi.PreOrder_id = pre.Id)
WHERE pre.isVoid = 0 AND pre.Customer_Id > 0
GROUP BY pre.ClientID, pre.Customer_Id, s.Id, pre.Id, pre.purchaseddate, pre.transtype, (pre.acredit + pre.mcredit + pre.bcredit)
GO
