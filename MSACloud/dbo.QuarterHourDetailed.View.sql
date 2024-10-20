USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[QuarterHourDetailed]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QuarterHourDetailed]
AS
SELECT 
	sc.Id as SCHID, 
	o.Pos_Id as POSID, 
	o.Id as ORDID, 
	it.Menu_Id as MENUID, 
	sc.SchoolName, 
	CASE
		WHEN o.Emp_Cashier_Id = -98 THEN 'Vending: ' + cat.Name
		WHEN p.Name IS NULL THEN 'Point of Sale'
		ELSE p.Name
	END as PosName, 
	o.OrderDate, 
	ISNULL(cat.name, 'Misc') as CategoryName,
	ISNULL(m.ItemName,'Misc') as ItemName, 
	it.Qty, 
	it.PaidPrice, 
	it.Qty * it.PaidPrice as NetPrice,
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
	LEFT OUTER JOIN Items it ON (o.id = it.Order_Id) 
	LEFT OUTER JOIN Schools sc ON (sc.id = o.school_Id) 
	LEFT OUTER JOIN Menu m ON (it.Menu_Id = m.Id)
	LEFT OUTER JOIN Category cat ON (cat.Id = m.Category_Id)
	LEFT OUTER JOIN Pos p ON (o.Pos_Id = p.Id)
WHERE it.isVoid = 0 AND o.isVoid = 0
GO
