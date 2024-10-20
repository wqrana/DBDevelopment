USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CNReportPg2]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CNReportPg2]
AS
SELECT
	o.Id as ORDID,
	NULL as CASHRESID,
	o.POS_Id as POSID,
	o.School_Id as SCHID,
	ISNULL(cs.School_Id,-3) as ASSSCHID,
	o.OrderDate,
	o.GDate,
	NULL as OpenDate,
	NULL as CloseDate,
	o.LunchType,
	o.TransType,
	it.Id as ITEMID,
	it.SoldType,
	m.Id as MENUID,
	ISNULL(m.ItemName,'Misc Item $' + STR(it.PaidPrice,10,2)) as MenuItem,
	ISNULL(m.ItemType,0) as ItemType,
	cat.Id as CATID,
	ISNULL(cat.Name,'Misc') as CategoryName,
	ct.Id as CTID,
	CASE
		WHEN (ct.canFree = 1 OR ct.canReduce = 1) THEN 1
		ELSE 2
	END as QualifiedType,
	ISNULL(ct.Name,'Misc') as CategoryTypeName,
	CASE
		WHEN (ct.canFree = 1 OR ct.canReduce = 1) 
				AND ((LOWER(cat.name) like 'breakfast')
					OR (LOWER(cat.Name) like 'lunch')
					OR (LOWER(m.ItemName) like 'student worker breakfast')
					OR (LOWER(m.ItemName) like 'student worker lunch'))
				AND (c.isStudent = 1 OR c.Id = -3)
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END as QualifiedReceipts,
	CASE
		WHEN (LOWER(cat.Name) = 'milk') 
				AND (LOWER(m.ItemName) <> 'student worker breakfast')
				AND (LOWER(m.ItemName) <> 'student worker lunch')
				AND (c.isStudent = 1 OR c.Id = -3)
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END as ExtraMilkReceipts,
	CASE
		WHEN ((it.menu_id <= -2) AND (c.isStudent = 1 OR o.Customer_Id = -3)) THEN (it.PaidPrice * it.Qty)
		WHEN (ct.canFree = 0 AND ct.canReduce = 0)
				AND (c.isStudent = 1 OR o.Customer_Id = -3)
				AND (LOWER(cat.Name) <> 'milk')
				AND (LOWER(cat.name) <> 'breakfast')
				AND (LOWER(cat.Name) <> 'lunch')
				AND (LOWER(m.ItemName) <> 'student worker breakfast')
				AND (LOWER(m.ItemName) <> 'student worker lunch') 
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END as StudAlaCarteReceipts,
	CASE
		WHEN ((it.Menu_Id <= -2) AND (c.isStudent = 0 OR o.Customer_Id = -2) AND (o.Customer_Id <> -3)) THEN (it.PaidPrice * it.Qty)
		WHEN (((c.isStudent = 0) AND (c.id > 0)) OR (o.Customer_Id = -2))
				AND (LOWER(m.ItemName) <> 'student worker breakfast')
				AND (LOWER(m.ItemName) <> 'student worker lunch') 
				AND (LOWER(cat.name) <> 'breakfast')
				AND (LOWER(cat.Name) <> 'lunch')
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END as AdultReceipts,
	(it.PaidPrice * it.Qty) as TotalReceipts,
	0.0 as ReceivedOnAccount,
	0.0 as TotalDeposit 
FROM Orders o
	INNER JOIN Items it ON it.Order_Id = o.Id
	LEFT OUTER JOIN Customers c ON c.Id = o.Customer_Id
	LEFT OUTER JOIN Customer_School cs on cs.Customer_Id = c.Id and cs.isPrimary = 1
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
	LEFT OUTER JOIN Menu m ON m.Id = it.Menu_Id
	LEFT OUTER JOIN Category cat ON cat.Id = m.Category_Id
	LEFT OUTER JOIN CategoryTypes ct ON ct.Id = cat.CategoryType_Id
WHERE o.isVoid = 0 AND it.isVoid = 0
UNION ALL
SELECT
	o.Id as ORDID,
	NULL as CASHRESID,
	o.POS_Id as POSID,
	o.School_Id as SCHID,
	cs.School_Id as ASSSCHID,
	o.OrderDate,
	o.GDate,
	NULL as OpenDate,
	NULL as CloseDate,
	o.LunchType,
	o.TransType,
	NULL as ITEMID,
	NULL as SoldType,
	NULL as MENUID,
	'Received On Account' as MenuItem,
	NULL as ItemType,
	NULL as CATID,
	'Received On Account' as CategoryName,
	NULL as CTID,
	NULL as QualifiedType,
	'Received On Account' as CategoryTypeName,
	0.0 as QualifiedReceipts,
	0.0 as ExtraMilkReceipts,
	0.0 as StudAlaCarteReceipts,
	0.0 as AdultReceipts,
	0.0 as TotalReceipts,
	((o.adebit + o.mdebit) - (o.acredit + o.mcredit)) as ReceivedOnAccount,
	0.0 as TotalDeposit 
FROM Orders o
	INNER JOIN Customers c ON c.Id = o.Customer_Id
	INNER JOIN Customer_School cs ON cs.Customer_Id = c.Id and cs.isPrimary = 1
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
WHERE o.isVoid = 0 AND o.Emp_Cashier_Id <> -99 AND o.Emp_Cashier_Id <> -98 AND SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4'
	AND SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
UNION ALL
SELECT
	NULL as ORDID,
	cr.Id as CASHRESID,
	cr.POS_Id as POSID,
	p.School_Id as SCHID,
	p.School_Id as ASSSCHID,
	NULL as OrderDate,
	CAST(CONVERT(varchar,cr.CloseDate,101) as datetime) as GDate,
	cr.OpenDate,
	cr.CloseDate,
	NULL as LunchType,
	NULL as TransType,
	NULL as ITEMID,
	NULL as SoldType,
	NULL as MENUID,
	'Deposit' as MenuItem,
	NULL as ItemType,
	NULL as CATID,
	'Deposit' as CategoryName,
	NULL as CTID,
	NULL as QualifiedType,
	'Deposit' as CategoryTypeName,
	0.0 as QualifiedReceipts,
	0.0 as ExtraMilkReceipts,
	0.0 as StudAlaCarteReceipts,
	0.0 as AdultReceipts,
	0.0 as TotalReceipts,
	0.0 as ReceivedOnAccount,
	(cr.CloseAmount - cr.OpenAmount) as TotalDeposit 
FROM CashResults cr
	INNER JOIN POS p ON p.Id = cr.POS_Id
	LEFT OUTER JOIN Schools s ON s.Id = p.School_Id
WHERE cr.Finished = 1
UNION ALL
SELECT
	o.Id as ORDID,
	NULL as CASHRESID,
	o.POS_Id as POSID,
	o.School_Id as SCHID,
	ISNULL(o.Customer_Pr_School_Id,o.School_Id) as ASSSCHID,
	o.OrderDate,
	o.GDate,
	NULL as OpenDate,
	NULL as CloseDate,
	o.LunchType,
	o.TransType,
	NULL as ITEMID,
	NULL as SoldType,
	NULL as MENUID,
	'Admin Payment' as MenuItem,
	NULL as ItemType,
	NULL as CATID,
	'Admin Payment' as CategoryName,
	NULL as CTID,
	NULL as QualifiedType,
	'Admin Payment' as CategoryTypeName,
	0.0 as QualifiedReceipts,
	0.0 as ExtraMilkReceipts,
	0.0 as StudAlaCarteReceipts,
	0.0 as AdultReceipts,
	0.0 as TotalReceipts,
	0.0 as ReceivedOnAccount,
	(o.adebit + o.mdebit) as TotalDeposit 
FROM Orders o
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
WHERE o.POS_Id = -3 AND o.isVoid = 0 AND o.Emp_Cashier_Id <> -99 AND o.Emp_Cashier_Id <> -98 
	AND SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
GO
