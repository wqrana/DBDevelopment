USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DailyMealClaims]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DailyMealClaims]
AS
SELECT 
	o.GDate,
	o.OrderDate as ORDERDATE,
	DATEPART(mm, o.OrderDate) as Month,
	DATEPART(yyyy, o.OrderDate) as Year,
	o.School_Id as SCHID,
	0 as PaidElig, 
	0 as RedElig, 
	0 as FreeElig, 
	(CASE WHEN ((ISNULL(o.lunchtype,1) = 1) AND (c.isStudent = 1 OR c.Id = -3) AND (m.ItemType < 2) AND (LOWER(cat.Name) not like 'snack%') AND (ct.canFree = 1 OR ct.canReduce = 1)) THEN 1 ELSE 0 END) as PaidLunchClaim, 
	(CASE WHEN ((o.lunchtype = 2) AND (c.isStudent = 1 OR c.Id = -3) AND (m.ItemType < 2) AND (LOWER(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as RedLunchClaim, 
	(CASE WHEN ((o.lunchtype = 3) AND (c.isStudent = 1 OR c.Id = -3) AND (m.ItemType < 2) AND (LOWER(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as FreeLunchClaim, 
	(CASE WHEN ((o.lunchtype = 1) AND (c.isStudent = 1 OR c.Id = -3) AND (m.ItemType = 2) AND (LOWER(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as PaidBreakClaim, 
	(CASE WHEN ((o.lunchtype = 2) AND (c.isStudent = 1 OR c.Id = -3) AND (m.ItemType = 2) AND (LOWER(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as RedBreakClaim, 
	(CASE WHEN ((o.lunchtype = 3) AND (c.isStudent = 1 OR c.Id = -3) AND (m.ItemType = 2) AND (LOWER(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as FreeBreakClaim, 
	(CASE WHEN ((o.lunchtype = 1) AND (c.isStudent = 1 OR c.Id = -3) AND (LOWER(cat.name) like 'snack%') AND (ct.canFree = 1 OR ct.canReduce = 1)) THEN 1 ELSE 0 END) as PaidSnackClaim, 
	(CASE WHEN ((o.lunchtype = 2) AND (c.isStudent = 1 OR c.Id = -3) AND (LOWER(cat.name) like 'snack%') AND (ct.canFree = 1 OR ct.canReduce = 1)) THEN 1 ELSE 0 END) as RedSnackClaim, 
	(CASE WHEN ((o.lunchtype = 3) AND (c.isStudent = 1 OR c.Id = -3) AND (LOWER(cat.name) like 'snack%') AND (ct.canFree = 1 OR ct.canReduce = 1)) THEN 1 ELSE 0 END) as FreeSnackClaim, 
	(CASE WHEN ((o.lunchtype = 1 OR o.lunchtype = 2 OR o.lunchtype = 3) AND (c.isStudent = 1 OR c.id = -3) AND (m.ItemType < 2) AND (lower(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as TotalLunchClaim, 
	(CASE WHEN ((o.lunchtype = 1 OR o.lunchtype = 2 OR o.lunchtype = 3) AND (c.isStudent = 1 OR c.id = -3) AND (m.ItemType = 2) AND (lower(cat.name) not like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as TotalBreakClaim, 
	(CASE WHEN ((o.lunchtype = 1 OR o.lunchtype = 2 OR o.lunchtype = 3) AND (c.isStudent = 1 OR c.id = -3) AND (lower(cat.name) like 'snack%') AND (ct.CanFree = 1 OR ct.CanReduce = 1)) THEN 1 ELSE 0 END) as TotalSnackClaim, 
	(CASE WHEN (LOWER(cat.name) = 'adult lunch') THEN 1 ELSE 0 END) as AdultLunchPaid, 
	(CASE WHEN (LOWER(cat.name) = 'adult breakfast') THEN 1 ELSE 0 END) as AdultBreakPaid, 
	0 as EmployeeMeals 
FROM orders o 
	INNER JOIN Customers c on (c.Id = o.Customer_Id) 
	LEFT OUTER JOIN Items it on (it.Order_Id = o.Id)
	LEFT OUTER JOIN Menu m on m.Id = it.Menu_Id
	LEFT OUTER JOIN Category cat on cat.Id = m.Category_Id
	LEFT OUTER JOIN CategoryTypes ct on ct.Id = cat.CategoryType_Id
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
WHERE o.isVoid = 0 AND it.isVoid = 0 AND o.Emp_Cashier_Id <> -99
GO
