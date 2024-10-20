USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[StatementDetailItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[StatementDetailItems]
AS
SELECT
	o.ClientID,
	o.Customer_Id as CSTID,
	ISNULL(s.Id,-3) as SCHID,
	o.Id as ORDID,
	o.GDate,
	o.OrderDate,
	o.TransType,
	'' as OrderTypeName,
	0 as OrderType,
	CASE 
		WHEN (it.PreOrderItem_Id IS NOT NULL AND poi.PreOrder_Id IS NULL) THEN '** (' + CONVERT(varchar,o.OrderDate,101) + ') ' + ISNULL(m.ItemName, 'Misc Item $' + LTRIM(STR(it.PaidPrice,15,2)))
		WHEN it.PreOrderItem_Id IS NOT NULL THEN '** (' + CONVERT(varchar,pre.PurchasedDate,101) + ') ' + ISNULL(m.ItemName, 'Misc Item $' + LTRIM(STR(it.PaidPrice,15,2)))
		ELSE ISNULL(m.ItemName, 'Misc Item $' + LTRIM(STR(it.PaidPrice,15,2)))
	END as ItemName,
	it.PaidPrice as PaidPrice,
	it.Qty as Qty,
	(it.PaidPrice * it.Qty) as ExtendedPrice
FROM Orders o
	INNER JOIN Items it ON (it.ClientID = o.ClientID and it.Order_Id = o.Id)
	LEFT OUTER JOIN PreOrderItems poi ON (poi.ClientID = it.ClientID and poi.Id = it.PreOrderItem_Id)
	LEFT OUTER JOIN PreOrders pre ON (pre.ClientID = poi.ClientID and pre.Id = poi.PreOrder_Id)
	LEFT OUTER JOIN Menu m ON (m.ClientID = it.ClientID and m.Id = it.Menu_Id)
	LEFT OUTER JOIN Customer_School cs ON (cs.ClientID = o.ClientID) and ((cs.Customer_Id = o.Customer_Id) AND (cs.isPrimary = 1))
	LEFT OUTER JOIN Schools s ON (s.ClientID = cs.ClientID and s.Id = cs.School_Id)
WHERE (o.isVoid = 0 OR (SUBSTRING(CAST(o.TransType as varchar),2,1) = '5' AND SUBSTRING(CAST(o.TransType as varchar),4,1) = '0')) AND o.Emp_Cashier_Id <> -99 AND o.TransType <> 1700 AND o.Customer_Id > 0 AND it.isVoid = 0
UNION ALL
SELECT
	pre.ClientID,
	pre.Customer_Id as CSTID,
	ISNULL(s.Id,-3) as SCHID,
	pre.Id,
	CAST(CONVERT(varchar,pre.PurchasedDate,101) as datetime) as GDate,
	pre.PurchasedDate,
	pre.Transtype,
	' - (PreOrder)' as OrderTypeName,
	1 as OrderType,
	ISNULL(m.ItemName, 'Misc Item $' + LTRIM(STR(poi.PaidPrice,15,2))) as ItemName,
	poi.PaidPrice as PaidPrice,
	poi.Qty as Qty,
	(poi.PaidPrice * poi.Qty) as ExtendedPrice
FROM PreOrders pre
	INNER JOIN PreOrderItems poi ON (poi.ClientID = pre.ClientID and poi.PreOrder_Id = pre.Id)
	LEFT OUTER JOIN Menu m ON (m.ClientID = poi.ClientID and m.Id = poi.Menu_Id)
	LEFT OUTER JOIN Customer_School cs ON (cs.ClientID = pre.ClientID) and ((cs.Customer_Id = pre.Customer_Id) AND (cs.isPrimary = 1))
	LEFT OUTER JOIN Schools s ON (s.ClientID = cs.ClientID and s.Id = cs.School_Id)
WHERE pre.isVoid = 0 AND poi.isVoid = 0 AND pre.Customer_Id > 0
GO
