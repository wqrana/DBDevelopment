USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CashierPayments]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CashierPayments]
AS
SELECT
	o.ClientID,
	d.Id as DISTID,
	s.Id as SCHID,
	c.Id as CSTID,
	Emp.Id as EMPID,
	o.POS_Id as POSID,
	d.DistrictName,
	s.SchoolID,
	s.SchoolName,
	ISNULL(Emp.UserID,'N/A') as EmpUserID,
	CASE o.Emp_Cashier_Id
		WHEN -9 THEN 'Online Payments'
		WHEN -2 THEN 'Administrator'
		WHEN -98 THEN 'Vending'
		ELSE UPPER(RTRIM(Emp.LastName)) + ', ' + UPPER(RTRIM(Emp.FirstName)) + ' ' + UPPER(ISNULL(Emp.Middle,' '))
	END as CashierName,
	o.OrderDate,
	o.gdate as PaymentDate,
	c.UserID as CustUserID,
	CASE
		WHEN c.Id < 0 THEN 'Cash'
		ELSE c.LastName
	END as LastName,
	CASE
		WHEN c.Id < 0 THEN 'Sale'
		ELSE c.FirstName
	END as FirstName,
	CASE 
		WHEN c.Id < 0 THEN ' '
		ELSE ISNULL(c.Middle,' ')
	END as Middle,
	o.TransType,
	(o.mdebit + o.adebit) as PaymentAmount,
	CASE 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' THEN ISNULL('Check # ' + CAST(o.checknumber as varchar), 'Check (No Number)')
		WHEN SUBSTRING(CAST(o.TransType as varchar),1,2) = '43' THEN ISNULL('Online CC Transaction: ' + CAST(-o.checknumber as varchar), 'Online CC Transaction')
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '3' THEN ISNULL('Credit Trans ID: ' + CAST(-o.checknumber as varchar), 'Credit Transaction') 
		--WHEN SUBSTRING(CAST(o.TransType as varchar),1,2) = '46' THEN 'Online ACH Transaction'
		WHEN (SUBSTRING(CAST(o.TransType as varchar),1,2) = '46') AND ((o.MDebit + o.ADebit) >= 0.0) THEN 'Online ACH Payment'
		WHEN (SUBSTRING(CAST(o.TransType as varchar),1,2) = '46') AND ((o.MDebit + o.ADebit) < 0.0) THEN 'Online ACH Return'
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '6' THEN 'ACH Transaction'
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '4' THEN 'Refund'
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) <> '1' THEN ISNULL('Unknown Transaction ID: ' + CAST(o.CheckNumber as varchar), 'Unknown Transaction Type')
		ELSE '----'
	END as Comments, 
	CASE 
		WHEN (o.TransType IS NULL) THEN (o.mdebit + o.adebit)
		WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1) = '1' and SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4') THEN (o.mdebit + o.adebit) 
		ELSE 0.0 
	END as TotalCashPayments,
	CASE 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' and SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4' THEN (o.mdebit + o.adebit) 
		ELSE 0.0 
	END as TotalChecks, 
	CASE 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '3' and SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4' THEN (o.mdebit + o.adebit) 
		ELSE 0.0 
	END as TotalCredits, 
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2) 
		WHEN '43' THEN (o.mdebit + o.adebit) 
		ELSE (0.0) 
	END as OnlineCreditPayments, 
	CASE 
		WHEN (SUBSTRING(CAST(o.TransType as varchar),1,2) = '46') AND ((o.MDebit + o.ADebit) >= 0.0) THEN (o.mdebit + o.adebit) 
		ELSE (0.0) 
	END as OnlineACHPayments, 
	CASE
		WHEN (SUBSTRING(CAST(o.TransType as varchar),1,2) = '46') AND ((o.MDebit + o.ADebit) < 0.0) THEN (o.MDebit + o.ADebit)
		ELSE (0.0)
	END as OnlineACHReturns,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1) 
		WHEN '4' THEN (o.mdebit + o.adebit) 
		ELSE 0.0 
	END as Refunds, 
	CASE
		WHEN (o.Customer_Id > 0) THEN (o.mdebit + o.adebit)
		ELSE 0.0
	END as AccountPayments,
	0.0 as CashSaleMonies,
	CASE  
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' then (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '1' then (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '4' then (o.mdebit + o.adebit)
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '3' then (o.mdebit + o.adebit)
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '6' THEN (o.mdebit + o.adebit)
		WHEN o.TransType IS NULL THEN (o.mdebit + o.adebit) 
		ELSE 0.0 
	END as TotalMonies,
	CASE  
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' then (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '1' then (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '4' then (o.mdebit + o.adebit)
		WHEN o.Transtype IS NULL THEN (o.mdebit + o.adebit) 
		ELSE 0.0 
	END as TotalDeposit,
	1 as LineCount,
	0 as GroupType,
	'' as FullName
FROM Orders o
	LEFT OUTER JOIN Schools s ON (s.Id = o.School_Id AND s.ClientID = o.ClientID)
	LEFT OUTER JOIN District d ON (d.Id = s.District_Id AND d.ClientID = s.ClientID)
	LEFT OUTER JOIN Customers Emp ON (Emp.Id = o.Emp_Cashier_Id AND Emp.ClientID = o.ClientID)
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id AND c.ClientID = o.ClientID)
WHERE (o.isVoid = 0 AND o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) <> 0) 
	AND ((o.Customer_Id > 0) OR ((o.Customer_Id < 0) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '3')))
	AND (SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5') AND (SUBSTRING(CAST(o.TransType as varchar),1,1) <> '6')
	
UNION ALL

SELECT
	o.ClientID,
	d.Id as DISTID,
	s.Id as SCHID,
	c.Id as CSTID,
	Emp.Id as EMPID,
	o.POS_Id as POSID,
	d.DistrictName,
	s.SchoolID,
	s.SchoolName,
	ISNULL(Emp.UserID,'N/A') as EmpUserID,
	CASE o.Emp_Cashier_Id
		WHEN -9 THEN 'Online Payments'
		WHEN -2 THEN 'Administrator'
		WHEN -98 THEN 'Vending'
		ELSE UPPER(RTRIM(Emp.LastName)) + ', ' + UPPER(RTRIM(Emp.FirstName)) + ' ' + UPPER(ISNULL(Emp.Middle,' '))
	END as CashierName,
	o.gdate as OrderDate,
	o.gdate as PaymentDate,
	c.UserID as CustUserID,
	CASE
		WHEN c.Id < 0 THEN 'Cash'
		ELSE c.LastName
	END as LastName,
	CASE
		WHEN c.Id < 0 THEN 'Sale'
		ELSE c.FirstName
	END as FirstName,
	CASE 
		WHEN c.Id < 0 THEN ' '
		ELSE ISNULL(c.Middle,' ')
	END as Middle,
	NULL as TransType,
	SUM(o.mdebit + o.adebit) as PaymentAmount,
	'----' as Comments, 
	0.0 as TotalCashPayments,
	0.0 as TotalChecks, 
	0.0 as TotalCredits, 
	0.0 as OnlineCreditPayments, 
	0.0 as OnlineACHPayments, 
	0.0 as OnlineACHReturns,
	0.0 as Refunds, 
	0.0 as AccountPayments,
	SUM(o.mdebit + o.adebit) as CashSaleMonies,
	SUM(CASE 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' THEN (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '1' THEN (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '4' THEN (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '3' THEN (o.mdebit + o.adebit)
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '0' THEN (o.mdebit + o.adebit)
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '6' THEN (o.mdebit + o.adebit)
		WHEN o.TransType IS NULL THEN (o.mdebit + o.adebit)
		ELSE 0.0 
	END) as TotalMonies,
	SUM(CASE
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '2' THEN (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '1' THEN (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '4' THEN (o.mdebit + o.adebit) 
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '0' THEN (o.mdebit + o.adebit)
		WHEN o.Transtype IS NULL THEN (o.mdebit + o.adebit)
		ELSE 0.0 
	END) as TotalDeposit,
	COUNT(o.id) as LineCount,
	1 as GroupType,
	'' as FullName	
FROM Orders o
	LEFT OUTER JOIN Schools s ON (s.Id = o.School_Id AND s.ClientID = o.ClientID)
	LEFT OUTER JOIN District d ON (d.Id = s.District_Id AND d.ClientID = s.ClientID)
	LEFT OUTER JOIN Customers Emp ON (Emp.Id = o.Emp_Cashier_Id AND Emp.ClientID = o.ClientID)
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id AND c.ClientID = o.ClientID)
WHERE (o.isVoid = 0 AND o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) <> 0) 
	AND (o.Customer_Id < 0) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) <> '3')
	AND (SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5') AND (SUBSTRING(CAST(o.TransType as varchar),1,1) <> '6')
GROUP BY o.ClientID, d.Id, s.Id, c.Id, Emp.Id, o.POS_Id, d.DistrictName, s.SchoolID, s.SchoolName, ISNULL(Emp.UserID,'N/A'),
	CASE o.Emp_Cashier_Id
		WHEN -9 THEN 'Online Payments'
		WHEN -2 THEN 'Administrator'
		WHEN -98 THEN 'Vending'
		ELSE UPPER(RTRIM(Emp.LastName)) + ', ' + UPPER(RTRIM(Emp.FirstName)) + ' ' + UPPER(ISNULL(Emp.Middle,' '))
	END, c.UserID, c.LastName, c.FirstName, ISNULL(c.Middle,' '), o.gdate
GO
