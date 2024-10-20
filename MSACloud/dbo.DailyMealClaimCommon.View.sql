USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DailyMealClaimCommon]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DailyMealClaimCommon]
AS
SELECT 
	o.GDate,
	o.School_Id as SCHID,
	d.Id as DISTID,
	--s.SchoolID,
	--s.SchoolName,
	DATENAME(mm,o.GDate) as NameMonth,
	DATEPART(yy,o.GDate) as DigitYear,
	DATEPART(mm,o.GDate) as MonthSort,
	0 as FreeElig, 
	0 as RedElig, 
	0 as PaidElig, 
	--0 as SNPTotalMember, 
	--0.0 as AttendFactor, 
	--0 as SNPUNumber, 
	--0.0 as AttendAdjElig, 
	sum(DISTINCT CASE 
		WHEN (m.ItemType < 2) AND (lower(cat.name) not like 'snack%') THEN 1 
		ELSE 0 
	END) as LunchServDays, 
	sum(DISTINCT CASE
		WHEN (m.ItemType = 2) AND (lower(cat.name) not like 'snack%') THEN 1
		ELSE 0
	END) as BreakServDays, 
	sum(DISTINCT CASE
		WHEN (lower(cat.name) like 'snack%') THEN 1
		ELSE 0
	END) as SnackServDays 
FROM Orders o 
	LEFT OUTER JOIN items it on it.order_id = o.id 
	LEFT OUTER JOIN menu m on m.id = it.menu_id 
	LEFT OUTER JOIN Category cat on cat.id = m.category_Id 
	LEFT OUTER JOIN CategoryTypes ct on ct.id = cat.categorytype_id 
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
	LEFT OUTER JOIN District d ON d.Id = s.District_Id
WHERE o.isVoid = 0 AND it.isVoid = 0 AND o.Emp_Cashier_Id <> -99 
AND (ct.CanFree = 1 OR ct.CanReduce = 1) 
GROUP BY o.gdate, o.School_Id, d.Id, DATENAME(mm,o.GDate), DATEPART(yy,o.GDate), DATEPART(mm,o.GDate)
UNION ALL
SELECT 
	ece.[Date],
	ece.School_Id as SCHID,
	d.Id as DISTID,
	--s.SchoolID,
	--s.SchoolName,
	DATENAME(mm,ece.[Date]), 
	DATEPART(yy,ece.[Date]),
	DATEPART(mm,ece.[Date]),
	ece.FreeElig as FreeElig, 
	ece.RedElig as RedElig, 
	ece.PaidElig as PaidElig,
	--0 as SNPTotalMember, 
	--0.0 as AttendFactor, 
	--0 as SNPUNumber, 
	--0.0 as AttendAdjElig, 
	0 as LunchServDays, 
	0 as BreakServDays, 
	0 as SnackServDays 
FROM editcheckelig ece 
	LEFT OUTER JOIN Schools s on s.id = ece.school_id 
	LEFT OUTER JOIN District d ON d.id = s.District_id
GO
