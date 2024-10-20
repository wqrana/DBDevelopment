USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[EditCheckWorksheet]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[EditCheckWorksheet]
AS
SELECT 
	o.GDate, 
	o.OrderDate,
	o.Customer_Id as CSTID,
	CAST(DATENAME(mm,o.GDate) as VARCHAR) as [Month],
	DATEPART(yyyy,o.GDate) as [Year],
	d.Id as DistrictID,
	d.DistrictName,
	o.School_Id as SERVESCHID,
	NULL as ASSIGNSCHID,
	s.SchoolId as SchoolID, 
	s.SchoolName as SchoolName,
	s.Phone1 as SchoolPhone,
	it.Menu_Id as MENUID,
	cat.Id as CATID,
	ISNULL(cat.Name,'Misc') as CategoryName,
	CASE
		WHEN o.LunchType = 3 AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty
		ELSE 0 
	END as ClaimedFree, 
	CASE
		WHEN o.LunchType = 1 AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty
		ELSE 0 
	END as ClaimedPaid, 
	CASE
		WHEN o.LunchType = 2 AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty
		ELSE 0 
	END as ClaimedReduced, 
	CASE
		WHEN ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty 
		ELSE 0
	END as ClaimedQty, 
	e.FreeElig as EligFree, 
	e.PaidElig as EligPaid, 
	e.RedElig as EligReduced, 
	e.FreeElig + e.RedElig + e.PaidElig as EligQty
FROM Items it 
	INNER JOIN Orders o ON (it.Order_Id = o.Id) 
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id)
	LEFT OUTER JOIN EditCheckElig e ON (o.GDate = e.[Date] AND e.School_Id = o.School_Id)
	LEFT OUTER JOIN Schools s on (o.School_Id = s.Id) 
	LEFT OUTER JOIN District d on (d.Id = s.District_Id)
	LEFT OUTER JOIN Menu m ON (m.Id = it.Menu_Id)
	LEFT OUTER JOIN Category cat ON (cat.Id = m.Category_Id)
	LEFT OUTER JOIN CategoryTypes ct ON (ct.Id = cat.CategoryType_Id)
WHERE (o.isVoid = 0) and (it.isVoid = 0) AND (o.Emp_Cashier_Id <> -99)
UNION ALL
SELECT 
	o.GDate, 
	o.OrderDate,
	o.Customer_id as CSTID,
	CAST(DATENAME(mm,o.GDate) as VARCHAR) as [Month],
	DATEPART(yyyy,o.GDate) as [Year],
	d.id as DistrictID,
	d.DistrictName,
	NULL as SERVESCHID,
	ISNULL(o.Customer_Pr_School_Id,o.School_Id) as ASSIGNSCHID,
	s.SchoolId as SchoolID, 
	s.SchoolName as SchoolName,
	s.Phone1 as SchoolPhone,
	it.Menu_Id as MENUID,
	cat.Id as CATID,
	ISNULL(cat.Name,'Misc') as CategoryName,
	CASE
		WHEN o.LunchType = 3 AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty
		ELSE 0 
	END as ClaimedFree, 
	CASE
		WHEN o.LunchType = 1 AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty
		ELSE 0 
	END as ClaimedPaid, 
	CASE
		WHEN o.LunchType = 2 AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty
		ELSE 0 
	END as ClaimedReduced, 
	CASE
		WHEN ((c.isStudent = 1) OR (o.Customer_Id = -3)) AND ((ct.canFree = 1) OR (ct.canReduce = 1)) THEN it.Qty 
		ELSE 0
	END as ClaimedQty,
	e.FreeElig as EligFree,  
	e.PaidElig as EligPaid, 
	e.RedElig as EligReduced, 
	e.FreeElig + e.RedElig + e.PaidElig as EligQty
FROM Items it 
	INNER JOIN Orders o ON (it.Order_Id = o.Id)
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id)
	LEFT OUTER JOIN EditCheckElig e ON (o.GDate = e.[Date] AND e.School_Id = ISNULL(o.Customer_Pr_School_Id, o.School_Id))
	LEFT OUTER JOIN Schools s on (s.Id = ISNULL(o.Customer_Pr_School_Id, o.School_Id)) 
	LEFT OUTER JOIN District d on (d.Id = s.District_Id)
	LEFT OUTER JOIN Menu m ON (m.Id = it.Menu_Id)
	LEFT OUTER JOIN Category cat ON (cat.Id = m.Category_Id)
	LEFT OUTER JOIN CategoryTypes ct ON (ct.Id = cat.CategoryType_Id)
WHERE (o.isVoid = 0) and (it.isVoid = 0) AND (o.Emp_Cashier_Id <> -99)
GO
