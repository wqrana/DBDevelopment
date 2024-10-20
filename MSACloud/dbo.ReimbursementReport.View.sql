USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[ReimbursementReport]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ReimbursementReport]
AS
SELECT 
	0 as OperationDays,
	o.School_Id as SERVSCHID,
	NULL as ASSIGNSCHID,
	s.SchoolName,
	s.District_Id,
	CAST(DATENAME(m,o.GDate) as VARCHAR) as [Month],
	DATEPART(yy, o.GDate) as [Year],
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int) as SortDate,
	0 as EditCheckLunchADA,
	0 as EditCheckBreakADA,
	0 as EditCheckSevereADA,
	0 as EditCheckADPLunch,
	0 as EditCheckADPBreak,
	0 as EditCheckADPSevere,
	0 as ApprovedFree,
	0 as ApprovedRed,
	SUM(CASE
		WHEN (o.LunchType = 1) AND (LOWER(cat.Name) = 'lunch') THEN it.Qty
		ELSE 0
	END) as LunchClaimedPaid,
	SUM(CASE
		WHEN (o.LunchType = 2) AND (LOWER(cat.Name) = 'lunch') THEN it.Qty
		ELSE 0
	END) as LunchClaimedReduced,
	SUM(CASE
		WHEN (o.LunchType = 3) AND (LOWER(cat.Name) = 'lunch') THEN it.Qty
		ELSE 0
	END) as LunchClaimedFree,
	SUM(CASE
		WHEN (LOWER(cat.Name) = 'lunch') THEN it.Qty 
		ELSE 0
	END) as LunchClaimedQty, 
	SUM(CASE
		WHEN (o.LunchType = 1) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty
		ELSE 0
	END) as BreakClaimedPaid,
	SUM(CASE
		WHEN (o.LunchType = 2) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty
		ELSE 0
	END) as BreakClaimedReduced,
	SUM(CASE
		WHEN (o.LunchType = 3) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty
		ELSE 0
	END) as BreakClaimedFree,
	SUM(CASE
		WHEN (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty 
		ELSE 0
	END) as BreakClaimedQty,
	SUM(CASE
		WHEN (o.LunchType = 1) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty
		ELSE 0
	END) as SevereBrkClaimedPaid,
	SUM(CASE
		WHEN (o.LunchType = 2) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty
		ELSE 0
	END) as SevereBrkClaimedReduced,
	SUM(CASE
		WHEN (o.LunchType = 3) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty
		ELSE 0
	END) as SevereBrkClaimedFree,
	SUM(CASE
		WHEN (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty 
		ELSE 0
	END) as SevereBrkClaimedQty,
	SUM(CASE
		WHEN ((LOWER(cat.Name) = 'lunch') OR (LOWER(cat.Name) = 'breakfast')) THEN it.Qty 
		ELSE 0
	END) as TotalClaimedQty
FROM Items it 
	INNER JOIN Orders o ON (it.Order_Id = o.Id)
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id)
	LEFT OUTER JOIN Schools s ON (s.Id = o.School_Id)
	LEFT OUTER JOIN Menu m ON (m.Id = it.Menu_Id) 
	INNER JOIN Category cat ON cat.Id = m.Category_Id
	INNER JOIN CategoryTypes ct ON ct.Id = cat.CategoryType_Id
WHERE (o.isVoid = 0)  AND (o.Emp_Cashier_Id <> -99) AND (it.isVoid = 0)
	AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) 
	AND (ct.canFree = 1 OR ct.canReduce = 1)
GROUP BY o.School_Id, s.SchoolName, DATENAME(m,o.GDate), DATEPART(yy, o.GDate),
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int)
	, s.District_Id
UNION ALL
SELECT 
	0 as OperationDays,
	NULL as SERVSCHID,
	CASE
		WHEN o.Customer_Id < 0 THEN o.School_Id
		ELSE cs.School_Id
	END as ASSIGNSCHID,
	s.SchoolName,
	s.District_Id,
	CAST(DATENAME(m,o.GDate) as VARCHAR) as [Month],
	DATEPART(yy, o.GDate) as [Year],
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int) as SortDate,
	0 as EditCheckLunchADA,
	0 as EditCheckBreakADA,
	0 as EditCheckSevereADA,
	0 as EditCheckADPLunch,
	0 as EditCheckADPBreak,
	0 as EditCheckADPSevere,
	0 as ApprovedFree,
	0 as ApprovedRed,
	SUM(CASE
		WHEN (o.LunchType = 1) AND (LOWER(cat.Name) = 'lunch') THEN it.Qty
		ELSE 0
	END) as LunchClaimedPaid,
	SUM(CASE
		WHEN (o.LunchType = 2) AND (LOWER(cat.Name) = 'lunch') THEN it.Qty
		ELSE 0
	END) as LunchClaimedReduced,
	SUM(CASE
		WHEN (o.LunchType = 3) AND (LOWER(cat.Name) = 'lunch') THEN it.Qty
		ELSE 0
	END) as LunchClaimedFree,
	SUM(CASE
		WHEN (LOWER(cat.Name) = 'lunch') THEN it.Qty 
		ELSE 0
	END) as LunchClaimedQty, 
	SUM(CASE
		WHEN (o.LunchType = 1) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty
		ELSE 0
	END) as BreakClaimedPaid,
	SUM(CASE
		WHEN (o.LunchType = 2) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty
		ELSE 0
	END) as BreakClaimedReduced,
	SUM(CASE
		WHEN (o.LunchType = 3) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty
		ELSE 0
	END) as BreakClaimedFree,
	SUM(CASE
		WHEN (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 0) THEN it.Qty 
		ELSE 0
	END) as BreakClaimedQty,
	SUM(CASE
		WHEN (o.LunchType = 1) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty
		ELSE 0
	END) as SevereBrkClaimedPaid,
	SUM(CASE
		WHEN (o.LunchType = 2) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty
		ELSE 0
	END) as SevereBrkClaimedReduced,
	SUM(CASE
		WHEN (o.LunchType = 3) AND (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty
		ELSE 0
	END) as SevereBrkClaimedFree,
	SUM(CASE
		WHEN (LOWER(cat.Name) = 'breakfast') AND (s.isSevereNeed = 1) THEN it.Qty 
		ELSE 0
	END) as SevereBrkClaimedQty,
	SUM(CASE
		WHEN ((LOWER(cat.Name) = 'lunch') OR (LOWER(cat.Name) = 'breakfast')) THEN it.Qty 
		ELSE 0
	END) as TotalClaimedQty
FROM Items it 
	INNER JOIN Orders o ON (it.Order_Id = o.Id)
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id)
	LEFT OUTER JOIN Customer_School cs ON (cs.Customer_Id = c.Id) AND (cs.isPrimary = 1)
	LEFT OUTER JOIN Schools s ON (s.Id = CASE WHEN o.Customer_Id < 0 THEN o.School_Id ELSE cs.School_Id END)
	LEFT OUTER JOIN Menu m ON (m.Id = it.Menu_Id) 
	INNER JOIN Category cat ON cat.Id = m.Category_Id
	INNER JOIN CategoryTypes ct ON ct.Id = cat.CategoryType_Id
WHERE (o.isVoid = 0)  AND (o.Emp_Cashier_Id <> -99) AND (it.isVoid = 0)
	AND ((c.isStudent = 1) OR (o.Customer_Id = -3)) 
	AND (ct.canFree = 1 OR ct.canReduce = 1)
GROUP BY CASE
		WHEN o.Customer_Id < 0 THEN o.School_Id
		ELSE cs.School_Id
	END, s.SchoolName, DATENAME(m,o.GDate), DATEPART(yy, o.GDate),
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int)
	, s.District_Id
UNION ALL
SELECT
	count(DISTINCT o.GDate) as OperationDays,
	o.School_Id as SERVSCHID, 
	NULL as ASSIGNSCHID,
	s.SchoolName,
	s.District_Id,
	CAST(DATENAME(m,o.GDate) as VARCHAR) as [Month],
	DATEPART(yy, o.GDate) as [Year],
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int) as SortDate,
	0 as EditCheckLunchADA,
	0 as EditCheckBreakADA,
	0 as EditCheckSevereADA,
	0 as EditCheckADPLunch,
	0 as EditCheckADPBreak,
	0 as EditCheckADPSevere,
	0 as ApprovedFree,
	0 as ApprovedRed,
	0 as LunchClaimedPaid,
	0 as LunchClaimedReduced,
	0 as LunchClaimedFree,
	0 as LunchClaimedQty, 
	0 as BreakClaimedPaid,
	0 as BreakClaimedReduced,
	0 as BreakClaimedFree,
	0 as BreakClaimedQty,
	0 as SevereBrkClaimedPaid,
	0 as SevereBrkClaimedReduced,
	0 as SevereBrkClaimedFree,
	0 as SevereBrkClaimedQty,
	0 as TotalClaimedQty
FROM Items it
	LEFT OUTER JOIN Orders o ON o.Id = it.Order_Id
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
WHERE (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) and (o.TransType < 4000)
GROUP BY o.School_Id, s.SchoolName, DATENAME(m,o.GDate), DATEPART(yy, o.GDate),
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int)
	, s.District_Id
UNION ALL
SELECT
	count(DISTINCT o.GDate) as OperationDays,
	NULL as SERVSCHID,
	CASE WHEN o.Customer_Id < 0 THEN NULL ELSE o.Customer_Pr_School_Id END as ASSIGNSCHID, 
	s.SchoolName,
	s.District_Id,
	CAST(DATENAME(m,o.GDate) as VARCHAR) as [Month],
	DATEPART(yy, o.GDate) as [Year],
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int) as SortDate,
	0 as EditCheckLunchADA,
	0 as EditCheckBreakADA,
	0 as EditCheckSevereADA,
	0 as EditCheckADPLunch,
	0 as EditCheckADPBreak,
	0 as EditCheckADPSevere,
	0 as ApprovedFree,
	0 as ApprovedRed,
	0 as LunchClaimedPaid,
	0 as LunchClaimedReduced,
	0 as LunchClaimedFree,
	0 as LunchClaimedQty, 
	0 as BreakClaimedPaid,
	0 as BreakClaimedReduced,
	0 as BreakClaimedFree,
	0 as BreakClaimedQty,
	0 as SevereBrkClaimedPaid,
	0 as SevereBrkClaimedReduced,
	0 as SevereBrkClaimedFree,
	0 as SevereBrkClaimedQty,
	0 as TotalClaimedQty
FROM Items it
	LEFT OUTER JOIN Orders o ON o.Id = it.Order_Id
	LEFT OUTER JOIN Schools s ON s.Id = CASE WHEN o.Customer_Pr_School_Id IS NULL THEN o.School_Id ELSE o.Customer_Pr_School_Id END
WHERE (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) and (o.TransType < 4000)
GROUP BY CASE WHEN o.Customer_Id < 0 THEN NULL ELSE o.Customer_Pr_School_Id END, s.SchoolName, DATENAME(m,o.GDate), DATEPART(yy, o.GDate),
	CAST(CAST(DATEPART(yy,o.GDate) as varchar) + CAST(DATEPART(mm,o.GDate) as varchar) as int)
	, s.District_Id
UNION ALL
SELECT 
	0 as OperationDays,
	s.Id as SERVSCHID,
	s.Id as ASSIGNSCHID,
	s.SchoolName,
	s.District_Id,
	CAST(DATENAME(m,e.[Date]) as VARCHAR) as [Month],
	DATEPART(yy, e.[Date]) as [Year],
	CAST(CAST(DATEPART(yy,e.[Date]) as varchar) + CAST(DATEPART(mm,e.[Date]) as varchar) as int) as SortDate,
	sum(e.FreeElig + e.RedElig + e.PaidElig) / Count(DISTINCT e.[Date]) as EditCheckLunchADA,
	sum(case
		when s.isSevereNeed = 0 then e.FreeElig + e.RedElig + e.PaidElig
		else 0
	end) / COUNT(DISTINCT e.Date) as EditCheckBreakADA,
	sum(case
		when s.isSevereNeed = 1 then e.FreeElig + e.RedElig + e.PaidElig
		else 0
	end) / COUNT(DISTINCT e.Date) as EditCheckSevereADA,
	0 as EditCheckADPLunch,
	0 as EditCheckADPBreak,
	0 as EditCheckADPSevere,
	MAX(e.FreeElig) as ApprovedFree,
	MAX(e.RedElig) as ApprovedRed,
	0 as LunchClaimedPaid,
	0 as LunchClaimedReduced,
	0 as LunchClaimedFree,
	0 as LunchClaimedQty, 
	0 as BreakClaimedPaid,
	0 as BreakClaimedReduced,
	0 as BreakClaimedFree,
	0 as BreakClaimedQty,
	0 as SevereBrkClaimedPaid,
	0 as SevereBrkClaimedReduced,
	0 as SevereBrkClaimedFree,
	0 as SevereBrkClaimedQty,
	0 as TotalClaimedQty
FROM Schools s
	LEFT OUTER JOIN EditCheckElig e ON (e.School_Id = s.Id)
WHERE (e.FreeElig <> 0 OR e.RedElig <> 0 OR e.PaidElig <> 0)
GROUP BY s.Id, s.SchoolName, DATENAME(m,e.[Date]), DATEPART(yy,e.[Date]),
	CAST(CAST(DATEPART(yy,e.[Date]) as varchar) + CAST(DATEPART(mm,e.[Date]) as varchar) as int)
	, s.District_Id
GO
