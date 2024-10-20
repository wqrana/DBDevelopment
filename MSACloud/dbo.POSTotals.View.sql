USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[POSTotals]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[POSTotals]
AS
SELECT 
	o.Id as ORDID,
	o.POS_Id as POSID,
	o.Customer_Id as CSTID,
	o.School_Id as SCHID,
	o.GDate,
	o.OrderDate,
	ISNULL(s.SchoolID,'') as SchoolID,
	CASE
		WHEN o.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(s.SchoolName,'**MISSING SCHOOL')
	END as SchoolName,
	CASE
		WHEN o.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(d.DistrictName,'**MISSING DISTRICT')
	END as DistrictName,
	CASE 
		WHEN o.POS_Id = -3 THEN 'Admin'
		WHEN o.POS_Id = -9 THEN 'Online'
		ELSE ISNULL(p.Name, '**MISSING POS')
	END as POSName,
	o.BCredit as BonusBucks,
	CASE o.LunchType
		WHEN 5 THEN (o.ACredit + o.MCredit)
		ELSE o.ACredit
	END as AlaCarteSales,
	CASE o.LunchType
		WHEN 5 THEN 0.0
		ELSE o.MCredit
	END as MealPlanSales,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as CashPayments, 
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '2' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as CheckPayments, 
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '3' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as CreditPayments, 
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '4' THEN -(o.ADebit + o.MDebit)
		ELSE 0.0
	END as Refunds, 
	(o.ADebit + o.MDebit) as TotalPayments,
	CASE SUBSTRING(CAST(o.TransType as varchar),3,1)
		WHEN '1' THEN (o.ACredit + o.MCredit)
		WHEN '2' THEN (o.ACredit + o.MCredit)
		ELSE 0.0
	END as CashSales,
	CASE SUBSTRING(CAST(o.TransType as varchar),3,1)
		WHEN '3' THEN (o.ACredit + o.MCredit + o.BCredit)
		WHEN '4' THEN (o.ACredit + o.MCredit + o.BCredit)
		ELSE 0.0
	END as AcctSales,
	(o.ACredit + o.MCredit + o.BCredit) as TotalSales,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN 1
		ELSE 0
	END as CashPaymentsCount, 
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '2' THEN 1
		ELSE 0
	END as CheckPaymentsCount,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '3' THEN 1
		ELSE 0
	END as CreditPaymentsCount,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '4' THEN 1
		ELSE 0
	END as RefundsCount,
	CASE SUBSTRING(CAST(o.TransType as varchar),3,1)
		WHEN '1' THEN 1
		WHEN '2' THEN 1
		ELSE 0
	END as CashSalesCount,
	CASE SUBSTRING(CAST(o.TransType as varchar),3,1)
		WHEN '3' THEN 1
		WHEN '4' THEN 1
		ELSE 0
	END as AcctSalesCount,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '0' THEN 0
		WHEN '5' THEN 0
		WHEN '7' THEN 0
		ELSE 1
	END as TotalPaymentCount, 
	CASE SUBSTRING(CAST(o.TransType as varchar),3,1)
		WHEN '0' THEN 0
		ELSE 1
	END as TotalSalesCount,
	0 as MealCount 
FROM Orders o 
	LEFT OUTER JOIN Schools s on (s.Id = o.School_Id) 
	LEFT OUTER JOIN District d on (d.Id = s.District_Id)
	LEFT OUTER JOIN POS p on (o.POS_Id = p.Id) 
WHERE (o.isVoid = 0) and (o.Transtype <> 1500) and (o.Emp_Cashier_Id <> -99)
	AND SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
UNION
SELECT 
	o.Id as ORDID,
	o.POS_Id as POSID,
	o.Customer_Id as CSTID,
	o.School_Id as SCHID,
	o.GDate,
	o.OrderDate,
	ISNULL(s.SchoolID,'') as SchoolID,
	CASE
		WHEN o.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(s.SchoolName,'**MISSING SCHOOL')
	END as SchoolName,
	CASE
		WHEN o.POS_Id = -3 THEN 'Admin'
		ELSE ISNULL(d.DistrictName,'**MISSING DISTRICT')
	END as DistrictName,
	CASE 
		WHEN o.POS_Id = -3 THEN 'Admin'
		WHEN o.POS_Id = -9 THEN 'Online'
		ELSE ISNULL(p.Name, '**MISSING POS')
	END as POSName,
	0.0 as BonusBucks,
	0.0 as AlaCarteSales,
	0.0 as MealPlanSales,
	0.0 as CashPayments, 
	0.0 as CheckPayments, 
	0.0 as CreditPayments, 
	0.0 as Refunds, 
	0.0 as TotalPayments,
	0.0 as CashSales,
	0.0 as AcctSales,
	0.0 as TotalSales,
	0 as CashPaymentsCount, 
	0 as CheckPaymentsCount,
	0 as CreditPaymentsCount,
	0 as RefundsCount,
	0 as CashSalesCount,
	0 as AcctSalesCount,
	0 as TotalPaymentCount, 
	0 as TotalSalesCount,
	CASE it.SoldType
		WHEN 30 THEN 1
		ELSE 0
	END as MealCount 
FROM Orders o 
	LEFT OUTER JOIN Items it ON it.Order_Id = o.Id
	LEFT OUTER JOIN Schools s on (s.Id = o.School_Id) 
	LEFT OUTER JOIN District d ON (d.Id = s.District_Id)
	LEFT OUTER JOIN POS p on (o.POS_Id = p.Id) 
WHERE (o.isVoid = 0) and (o.Transtype <> 1500) and (o.Emp_Cashier_Id <> -99)
	AND SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
GO
