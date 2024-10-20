USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CNReportCommon]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CNReportCommon]
AS
SELECT
	s.Id as SCHID,
	s.SchoolID as SchoolID,
	s.SchoolName as SchoolName,
	d.Id as DISTID,
	d.districtName as DistrictName,
	CAST(DATENAME(mm,e.[Date]) as varchar) as [Month],
	DATEPART(mm,e.[Date]) as NumMonth,
	DATEPART(yy,e.[Date]) as [Year],
	CAST(CAST(DATEPART(yy,e.[Date]) as varchar) + CAST(DATEPART(mm,e.[Date]) as varchar) as int) as SortDate,
	MAX(CASE WHEN DATEPART(dd,e.Date) = ds.FirstDate THEN e.PaidElig ELSE 0 END) as EnrollPd,
	MAX(CASE WHEN DATEPART(dd,e.Date) = ds.FirstDate THEN e.RedElig ELSE 0 END) as EnrollRed,
	MAX(CASE WHEN DATEPART(dd,e.Date) = ds.FirstDate THEN e.FreeElig ELSE 0 END) as EnrollFr,
	MAX(CASE WHEN DATEPART(dd,e.Date) = ds.FirstDate THEN e.PaidElig ELSE 0 END) + MAX(CASE WHEN DATEPART(dd,e.Date) = ds.FirstDate THEN e.RedElig ELSE 0 END) + MAX(CASE WHEN DATEPART(dd,e.Date) = ds.FirstDate THEN e.FreeElig ELSE 0 END) as EnrollTot
FROM Schools s
	LEFT OUTER JOIN (
		select 
			DATEPART(YY,e.[Date]) as [Year], 
			DATEPART(mm,e.[Date]) as NumMonth, 
			MIN(DATEPART(dd,e.[Date])) as FirstDate, 
			e.School_Id 
		FROM EditCheckElig e
		GROUP BY e.School_Id, DATEPART(YY,e.[Date]), DATEPART(mm,e.[Date])
	) ds on ds.School_Id = s.Id
	LEFT OUTER JOIN EditCheckElig e ON e.School_Id = s.Id
	LEFT OUTER JOIN District d ON d.Id = s.District_Id
WHERE s.Id > 0
GROUP BY s.Id, s.SchoolID, s.SchoolName, d.Id, d.districtName, CAST(DATENAME(mm,e.[Date]) as varchar), DATEPART(yy,e.[Date]), DATEPART(mm,e.[Date]), DATEPART(yy,e.[Date]), CAST(CAST(DATEPART(yy,e.[Date]) as varchar) + CAST(DATEPART(mm,e.[Date]) as varchar) as int)
GO
