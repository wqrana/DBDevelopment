USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CNReportPg1]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CNReportPg1]
AS
SELECT
	c.Id as CSTID,
	o.Id as ORDID,
	o.School_Id as SCHID,
	cs.School_Id as ASSSCHID,
	o.OrderDate,
	o.GDate,
	o.LunchType,
	o.TransType,
	c.isStudentWorker as STUDWORKER,
	it.Id as ITEMID,
	it.SoldType,
	m.Id as MENUID,
	ISNULL(m.ItemName,'Misc Item $' + STR(it.PaidPrice,10,2)) as MenuItem,
	m.ItemType,
	cat.Id as CATID,
	ISNULL(cat.Name,'Misc') as CategoryName,
	ct.Id as CTID,
	ISNULL(ct.Name,'Misc') as CategoryTypeName,
	/*** DONE BY CALLER ***
	0 as BreakPaidItem1,
	0.0 as BreakPaidItemPrice1,
	0 as BreakPaidItem2,
	0.0 as BreakPaidItemPrice2,
	0 as BreakPaidItem3,
	0.0 as BreakPaidItemPrice3,
	0 as BreakPaidItem4,
	0.0 as BreakPaidItemPrice4,
	***/
	CASE
		WHEN (c.isStudentWorker = 0 OR c.isStudentWorker IS Null) AND (o.lunchtype = 1) AND (LOWER(m.ItemName) <> 'student worker breakfast') AND (LOWER(m.ItemName) <> 'student worker lunch') THEN 1
		ELSE 0
	END as Paid,
	CASE
		WHEN o.lunchtype = 3 THEN 1
		ELSE 0
	END as NeedyFree,
	CASE
		WHEN o.lunchtype = 2 THEN 1
		ELSE 0
	END as NeedyRed,
	CASE
		WHEN (o.LunchType = 1) AND (c.isStudentWorker = 1 OR LOWER(m.ItemName) = 'student worker breakfast' OR LOWER(m.ItemName) = 'student worker lunch') THEN 1
		ELSE 0
	END as NonNeedyStuWrks,
	1 as TotalStuSrvd	
FROM Orders o
	INNER JOIN Items it ON it.Order_Id = o.Id
	INNER JOIN Customers c ON c.Id = o.Customer_Id
	INNER JOIN Schools s ON s.Id = o.School_Id
	INNER JOIN Customer_School cs on cs.Customer_Id = c.Id and cs.isPrimary = 1
	LEFT OUTER JOIN Menu m ON m.Id = it.Menu_Id
	LEFT OUTER JOIN Category cat ON cat.Id = m.Category_Id
	LEFT OUTER JOIN CategoryTypes ct ON ct.Id = cat.CategoryType_Id
WHERE o.isVoid = 0 AND it.isVoid = 0 AND (c.isStudent = 1 OR c.Id < 0 OR c.isStudentWorker = 1)
	AND (ct.canFree = 1 OR ct.canReduce = 1)
GO
