USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DetailCafeNetChange]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DetailCafeNetChange]
AS
SELECT 
	c.ClientID as ClientID,
	c.Id as CSTID,
	o.School_Id as SCHID,
	o.OrderDate,
	o.GDate as ReportDate,
	(
		--POA
		(CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99)) THEN (o.MDebit + o.ADebit) ELSE 0.0 END)
		--COA
		- (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0)) THEN (o.MCredit + o.ACredit) ELSE 0.0 END)
	) as NetChange
FROM Orders o
	LEFT OUTER JOIN Customers c ON c.Id = o.Customer_Id
GO
