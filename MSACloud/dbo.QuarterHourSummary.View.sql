USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[QuarterHourSummary]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QuarterHourSummary]
AS
SELECT 
	o.Customer_Id as CSTID,
	o.School_Id as SCHID,
	o.Id as ORID,
	o.Emp_Cashier_Id as EMPCASHID,
	o.pos_Id as POSID,
	sc.SchoolName, 
	CASE
		WHEN o.Emp_Cashier_Id = -98 THEN 'Vending'
		WHEN p.Name IS NULL THEN 'Point of Sale'
		ELSE p.Name
	END as PosName, 
	o.OrderDate, 
	o.GDate,
	1 as Qty, 
	(o.ACredit + o.MCredit + o.BCredit) as TotalSales,
	--DATEPART(hh, CAST(CONVERT(varchar,o.OrderDate,108) as datetime)) as HourInterval,
	CASE (DATEPART(n,CAST(CONVERT(varchar,o.OrderDate,108) as datetime)) / 15)
		WHEN 1 THEN 
			CAST(CONVERT(varchar,o.OrderDate,101) + ' ' + 
			CAST(DATEPART(hh, CAST(CONVERT(varchar,o.OrderDate,108) as datetime)) as varchar) + ':15:00' as datetime)
		WHEN 2 THEN 
			CAST(CONVERT(varchar,o.OrderDate,101) + ' ' + 
			CAST(DATEPART(hh, CAST(CONVERT(varchar,o.OrderDate,108) as datetime)) as varchar) + ':30:00' as datetime)
		WHEN 3 THEN
			CAST(CONVERT(varchar,o.OrderDate,101) + ' ' + 
			CAST(DATEPART(hh, CAST(CONVERT(varchar,o.OrderDate,108) as datetime)) as varchar) + ':45:00' as datetime)
		ELSE 
			CAST(CONVERT(varchar,o.OrderDate,101) + ' ' + 
			CAST(DATEPART(hh, CAST(CONVERT(varchar,o.OrderDate,108) as datetime)) as varchar) + ':00:00' as datetime)
	END as Interval
FROM Orders o
	LEFT OUTER JOIN Schools sc ON (sc.id = o.school_Id) 
	LEFT OUTER JOIN Pos p ON (o.Pos_Id = p.Id)
WHERE o.isVoid = 0
GO
