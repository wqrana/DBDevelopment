USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[Voids]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Voids]
AS
SELECT
	o.ClientID,
	s.Id as SCHID,
	Emp.Id as ORDEMPID,
	c.Id as CSTID,
	Ech.Id as MODEMPID,
	o.OrderDate,
	o.GDate,
	s.SchoolName,
	s.SchoolID,
	s.Address1,
	s.Address2,
	s.City,
	s.State,
	s.Zip,
	c.LastName,
	c.FirstName,
	c.Middle,
	CASE Ech.Id
		WHEN -2 THEN 'Administrator'
		ELSE RTRIM(Ech.LastName) + ', ' + RTRIM(Ech.FirstName) + ' ' + ISNULL(Ech.Middle,' ')
	END as ChangedBy,
	ol.ChangedDate as VoidTime,
	o.isVoid as VoidOrder,
	it.isVoid as VoidItem,
	o.TransType,
	o.ACredit,
	0.0 as ADebit,
	o.MCredit,
	0.0 as MDebit,
	m.ItemName,
	it.Qty,
	it.PaidPrice as Price,
	ROUND(it.TaxPrice,2) as TaxPrice,
	(it.Qty * it.PaidPrice) + ROUND(it.TaxPrice,2) as Total,
	CASE Emp.Id
		WHEN -2 THEN 'Administrator'
		ELSE RTRIM(Emp.LastName) + ', ' + RTRIM(Emp.FirstName) + ' ' + ISNULL(Emp.Middle,' ')
	END as Cashier,
	ISNULL(ol.Notes,'N/A') as Notes
FROM Orders o
	INNER JOIN Items it ON it.ClientID = o.ClientID and it.Order_Id = o.Id
	LEFT OUTER JOIN Menu m ON m.ClientID = it.ClientID and m.Id = it.Menu_Id
	LEFT OUTER JOIN Customers Emp ON Emp.ClientID = o.ClientID and Emp.Id = o.Emp_Cashier_Id
	LEFT OUTER JOIN Customers c ON c.ClientID = o.ClientID and c.Id = o.Customer_Id
	LEFT OUTER JOIN Schools s ON s.ClientID = o.ClientID and s.Id = o.School_Id
	LEFT OUTER JOIN OrdersLog ol ON ol.ClientID = o.ClientID and ol.Id = o.OrdersLog_Id
	LEFT OUTER JOIN Customers Ech ON Ech.ClientID = ol.ClientID and Ech.Id = ol.Employee_Id
WHERE (o.isVoid = 1 OR it.isVoid = 1)

UNION ALL

SELECT
	o.ClientID,
	s.Id as SCHID,
	Emp.Id as ORDEMPID,
	c.Id as CSTID,
	Ech.Id as MODEMPID,
	o.OrderDate,
	o.GDate,
	s.SchoolName,
	s.SchoolID,
	s.Address1,
	s.Address2,
	s.City,
	s.[State],
	s.Zip,
	c.LastName,
	c.FirstName,
	c.Middle,
	CASE Ech.Id
		WHEN -2 THEN 'Administrator'
		ELSE RTRIM(Ech.LastName) + ', ' + RTRIM(Ech.FirstName) + ' ' + ISNULL(Ech.Middle,' ')
	END as ChangedBy,
	ol.ChangedDate as VoidTime,
	o.isVoid as VoidOrder,
	0 as VoidItem,
	o.TransType,
	0.0 as ACredit,
	o.ADebit,
	0.0 as MCredit,
	o.MDebit,
	CASE CAST(SUBSTRING(CAST(o.TransType as varchar),2,1) as int)
		WHEN 1 THEN 'VOIDED Cash Payment'
		WHEN 2 THEN 'VOIDED Check Payment'
		WHEN 3 THEN 'VOIDED Credit Payment'
		WHEN 4 THEN 'VOIDED Refund'
		WHEN 5 THEN 'ADJUSTMENT'
		WHEN 6 THEN 'VOIDED ACH Payment'
		WHEN 7 THEN 'VOIDED Beginning Balance'
		WHEN 8 THEN 'VOIDED Meal Plan Payment'
		ELSE ''
	END as ItemName,
	0 as Qty,
	0.0 as Price,
	0.0 as TaxPrice,
	(0.0) as Total,
	CASE Emp.Id
		WHEN -2 THEN 'Administrator'
		ELSE RTRIM(Emp.LastName) + ', ' + RTRIM(Emp.FirstName) + ' ' + ISNULL(Emp.Middle,' ')
	END as Cashier,
	ISNULL(ol.Notes,'N/A') as Notes
FROM Orders o
	LEFT OUTER JOIN Customers Emp ON Emp.ClientID = o.ClientID and Emp.Id = o.Emp_Cashier_Id
	LEFT OUTER JOIN Customers c ON c.ClientID = o.ClientID and c.Id = o.Customer_Id
	LEFT OUTER JOIN Schools s ON s.ClientID = o.ClientID and s.Id = o.School_Id
	LEFT OUTER JOIN OrdersLog ol ON ol.ClientID = o.ClientID and ol.Id = o.OrdersLog_Id
	LEFT OUTER JOIN Customers Ech ON Ech.ClientID = ol.ClientID and Ech.Id = ol.Employee_Id
WHERE (o.isVoid = 1)

UNION ALL

SELECT
	pre.ClientID,
	s.Id as SCHID,
	-9 as ORDEMPID,
	c.Id as CSTID,
	Ech.Id as MODEMPID,
	pre.PurchasedDate,
	CAST(CONVERT(varchar,pre.PurchasedDate,101) as datetime) as GDate,
	s.SchoolName,
	s.SchoolID,
	s.Address1,
	s.Address2,
	s.City,
	s.State,
	s.Zip,
	c.LastName,
	c.FirstName,
	c.Middle,
	CASE Ech.Id
		WHEN -2 THEN 'Administrator'
		ELSE RTRIM(Ech.LastName) + ', ' + RTRIM(Ech.FirstName) + ' ' + ISNULL(Ech.Middle,' ')
	END as ChangedBy,
	ol.ChangedDate as VoidTime,
	pre.isVoid as VoidOrder,
	poi.isVoid as VoidItem,
	pre.TransType,
	pre.ACredit,
	0.0 as ADebit,
	pre.MCredit,
	0.0 as MDebit,
	m.ItemName,
	poi.Qty,
	poi.PaidPrice as Price,
	0.0 as TaxPrice,
	(poi.Qty * poi.PaidPrice) as Total,
	'PreOrder' as Cashier,
	ISNULL(ol.Notes,'N/A') as Notes
FROM PreOrders pre
	INNER JOIN PreOrderItems poi ON poi.ClientID = pre.ClientID and poi.PreOrder_Id = pre.Id
	LEFT OUTER JOIN Menu m ON m.ClientID = poi.ClientID and m.Id = poi.Menu_Id
	LEFT OUTER JOIN Customers c ON c.ClientID = pre.ClientID and c.Id = pre.Customer_Id
	LEFT OUTER JOIN Customer_School cs ON cs.ClientID = c.ClientID and (cs.Customer_Id = c.Id AND cs.isPrimary = 1)
	LEFT OUTER JOIN Schools s ON s.ClientID = cs.ClientID and s.Id = cs.School_Id
	LEFT OUTER JOIN OrdersLog ol ON ol.ClientID = pre.ClientID and ol.Id = pre.OrdersLog_Id
	LEFT OUTER JOIN Customers Ech ON Ech.ClientID = ol.ClientID and Ech.Id = ol.Employee_Id
WHERE (pre.isVoid = 1 OR poi.isVoid = 1)
GO
