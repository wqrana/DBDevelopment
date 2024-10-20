USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DailyCashier]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[DailyCashier]
AS
SELECT 
	-- Ids
	cr.ClientID,
	cr.Id as CASHRESID, 
	cst.Id as CUSTID,
	cr.POS_Id as POSID,
	p.School_Id as SCHID,
	-- Names
	P.Name as POSName, 
	sc.SchoolID, 
	sc.SchoolName, 
	e.LoginName,
	cst.LastName, 
	cst.FirstName, 
	cst.Middle, 
	cst.UserID as UserId, 
	-- Cash Result Details
	cr.OpenDate, 
	cr.CloseDate, 
	cr.OpenAmount, 
	cr.CloseAmount, 
	(cr.CloseAmount  - cr.OpenAmount) as Deposit, 
	cr.PaidOuts, 
	cr.Additional, 
	cr.TotalCash, 
	cr.OverShort, 
	cr.Sales, 
	-- Taxes Calculated Later
	0.0 as Tax 
FROM CashResults cr 
	LEFT OUTER JOIN Customers cst ON (cst.Id = cr.Emp_Cashier_Id AND cst.ClientID = cr.ClientID)
	LEFT OUTER JOIN POS p ON (p.Id = cr.POS_Id AND p.ClientID = cr.ClientID)
	LEFT OUTER JOIN Schools sc ON (sc.Id = p.School_Id  AND sc.ClientID = p.ClientID)
	LEFT OUTER JOIN Employee e on (e.Customer_Id = cr.Emp_Cashier_Id AND e.ClientID = cr.ClientID)
WHERE
	-- Only Cashed Out Sessions 
	(cr.Finished = 1) 
	-- Only POS Sessions
	AND cr.POS_Id <> -3 
	-- Only Sessions with Data ( No cash in and out with no activity )
	-- Commented by farrukh m (allshore) to fix JIRA item PA-520
	--AND (cr.OpenAmount <> 0 OR cr.CloseAmount <> 0 OR cr.PaidOuts <> 0 OR cr.Additional <> 0 OR cr.TotalCash <> 0 OR cr.Sales <> 0)

UNION ALL 
	
SELECT 
	-- Ids
	cr.ClientID,
	-3 as CASHRESID, 
	cst.Id as CUSTID,
	cr.POS_Id as POSID,
	p.School_Id as SCHID,
	-- Names
	'Admin' as POSName,
	sc.SchoolID, 
	'Admin Payments' as SchoolName, 
	e.LoginName,
	cst.LastName,
	cst.FirstName,
	cst.Middle,
	cst.UserID,
	cr.OpenDate as OpenDate,
	cr.CloseDate as CloseDate,
	cr.OpenAmount as OpenAmount, 
	cr.CloseAmount as CloseAmount, 
	(cr.CloseAmount  - cr.OpenAmount) as Deposit, 
	cr.PaidOuts as PaidOuts, 
	cr.Additional as Additional, 
	cr.TotalCash as TotalCash, 
	cr.OverShort as OverShort, 
	cr.Sales as Sales, 
	0.0 as Tax 
FROM CashResults cr 
	LEFT OUTER JOIN Customers cst ON (cst.Id = cr.Emp_Cashier_Id AND cst.ClientID = cr.ClientID)
	LEFT OUTER JOIN POS p ON (p.Id = cr.POS_Id AND p.ClientID = cr.ClientID)
	LEFT OUTER JOIN Schools sc ON (sc.Id = p.School_Id AND sc.ClientID = p.ClientID)
	LEFT OUTER JOIN Employee e ON (e.Customer_Id = cr.Emp_Cashier_Id AND e.ClientID = cr.ClientID)
WHERE
	-- Only Closed Sessions 
	(cr.Finished = 1) 
	-- Only Admin Sessions (Admin Payments)
	AND cr.POS_Id = -3 

--GROUP BY cst.UserID, sc.SchoolID, cr.POS_Id, p.School_Id, sc.SchoolName, p.Name, e.LoginName, cst.LastName, cst.FirstName, cst.Middle, cst.Id 

UNION ALL

SELECT 
	-- Ids
	cr.ClientID,
	cr.Id as CASHRESID, 
	cst.Id as CUSTID,
	cr.POS_Id as POSID,
	p.School_Id as SCHID,
	-- Names
	p.Name as POSName, 
	sc.SchoolID, 
	sc.SchoolName, 
	e.LoginName,
	cst.LastName, 
	cst.FirstName, 
	cst.Middle, 
	cst.UserID as UserId, 
	-- Cash Result Details
	NULL as OpenDate, 
	NULL as CloseDate, 
	0.0 as OpenAmount, 
	0.0 as CloseAmount, 
	0.0 as Deposit, 
	0.0 as PaidOuts, 
	0.0 as Additional, 
	0.0 as TotalCash, 
	0.0 as OverShort, 
	0.0 as Sales, 
	-- Taxes 
	dbo.SalesTaxTotal(o.ClientID, o.id) as Tax 
FROM CashResults cr 
	LEFT OUTER JOIN Orders o on (o.POS_Id = cr.Id AND o.ClientID = cr.ClientID)
	LEFT OUTER JOIN Transactions t on (((t.Order_Id = o.Id) AND (t.OrderType = 0)) AND (t.ClientID = o.ClientID))
	LEFT OUTER JOIN Customers cst on (cst.Id = o.Emp_Cashier_Id AND cst.ClientID = o.ClientID)
	LEFT OUTER JOIN POS p ON (p.Id = cr.POS_Id AND p.ClientID = cr.ClientID)
	LEFT OUTER JOIN Schools sc ON (sc.Id = o.School_Id AND sc.ClientID = o.ClientID)
	LEFT OUTER JOIN Employee e ON (e.Customer_Id = o.Emp_Cashier_Id and e.ClientID = o.ClientID)
WHERE
	-- Only Orders in this session
	((t.CashRes_Id = cr.Id) OR ((t.CashRes_Id IS NULL) AND (o.OrderDate BETWEEN cr.OpenDate AND cr.CloseDate)))
	-- Only for Finished Sessions
	AND (cr.Finished = 1) 
	-- Non Voided Orders
	AND (o.isVoid = 0)
GO
