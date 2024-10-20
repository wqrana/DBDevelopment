USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DetailCafeCashiers]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[DetailCafeCashiers]
AS
SELECT 
	cr.ClientID as ClientID,
	cr.Id as CASHRESID,
	p.Id as POSID,
	p.School_Id as SCHID,
	cr.Finished,
	RTRIM(ISNULL(p.Name, 'Admin')) as POSName,
	RTRIM(c.LastName) as LastName, RTRIM(c.FirstName) as FirstName, RTRIM(ISNULL(c.Middle, '')) as Middle, cr.Emp_Cashier_Id,
	cr.OpenDate,
	cr.CloseDate,
	CONVERT(VARCHAR, cr.OpenDate, 100) as OpenMessage,
	CASE
		WHEN cr.CloseDate IS NULL THEN 'Not Closed'
		ELSE CONVERT(VARCHAR, cr.CloseDate, 100)
	END AS CloseMessage
FROM CashResults cr 
	LEFT OUTER JOIN Customers c on c.Id = cr.Emp_Cashier_Id 
	LEFT OUTER JOIN POS p ON p.Id = cr.POS_Id
WHERE	CONVERT(varchar(100), cr.OpenDate, 101) <> CONVERT(varchar(100), ISNULL(cr.CloseDate,''), 101)
GO
