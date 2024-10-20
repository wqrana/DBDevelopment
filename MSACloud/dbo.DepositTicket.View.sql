USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DepositTicket]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[DepositTicket]
AS
SELECT 
	o.ClientID,
	0 as CASHRESID,
	o.Id as ORDID,
	0 as CSTID,
	o.POS_Id as POSID,
	d.Id as DISTID,
	s.Id as SCHID,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,1)
		WHEN '1' THEN 1
		WHEN '2' THEN 0
		ELSE 2
	END as DepositType,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '2' THEN 0
		WHEN '3' THEN 1
		ELSE 2
	END as PaymentType,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1) 
		WHEN '2' THEN 'Check'
		WHEN '3' THEN 'Credit'
		ELSE 'Cash Received' 
	END as PaymentTypeName,

	/* Added isnull condition by Abid */

	isnull(o.OrderDate, '1/1/1900') as OrderDate,

	isnull(o.GDate, '1/1/1900') as ReportDate,
	
	d.DistrictName as DistrictName,
	d.Address1 as DistAddress1,
	d.Address2 as DistAddress2,
	d.City as DistCity,
	d.[State] as DistState,
	d.Zip as DistZip,
	d.BankName as DistBankName,
	d.BankAddr1 as DistBankAddress1,
	d.BankAddr2 as DistBankAddress2,
	d.BankCity as DistBankCity,
	d.BankState as DistBankState,
	d.BankZip as DistBankZip,
	/*
	NULL as BankMICR,
	*/
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN NULL
		WHEN '4' THEN NULL
		ELSE c.LastName
	END as LastName,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN NULL
		WHEN '4' THEN NULL
		ELSE c.FirstName
	END as FirstName,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN NULL
		WHEN '4' THEN NULL
		ELSE c.Middle
	END as Middle,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '2' THEN o.CheckNumber
		WHEN '3' THEN -o.CheckNumber
		ELSE NULL
	END as CheckNumber,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '2' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as CheckAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '22' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as POSCheckAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '12' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as AdminCheckAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '3' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as CreditAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '23' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as POSCreditAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '13' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as AdminCreditAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),2,1)
		WHEN '1' THEN (o.ADebit + o.MDebit)
		WHEN '4' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as CashAmount,
	CASE 
		WHEN SUBSTRING(CAST(o.TransType as varchar),1,2) = '11' THEN 0.0
		WHEN SUBSTRING(CAST(o.TransType as varchar),1,2) = '14' THEN 0.0
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '1' THEN (o.ADebit + o.MDebit)
		WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '4' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as MiscCashAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '21' THEN (o.ADebit + o.MDebit)
		WHEN '24' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as POSCashAmount,		
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '11' THEN (o.ADebit + o.MDebit)
		WHEN '14' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as AdminCashAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '21' THEN (o.ADebit + o.MDebit)
		WHEN '22' THEN (o.ADebit + o.MDebit)
		WHEN '23' THEN (o.ADebit + o.MDebit)
		WHEN '24' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as POSTotalAmount,
	CASE SUBSTRING(CAST(o.TransType as varchar),1,2)
		WHEN '11' THEN (o.ADebit + o.MDebit)
		WHEN '12' THEN (o.ADebit + o.MDebit)
		WHEN '13' THEN (o.ADebit + o.MDebit)
		WHEN '14' THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END as AdminTotalAmount,
	0.0 as CashOutAmount,
	(o.ADebit + o.MDebit) as Amount
FROM Orders o 
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id AND c.ClientID = o.ClientID)
	LEFT OUTER JOIN Schools s ON (s.Id = o.School_Id AND s.ClientID = o.ClientID)
	LEFT OUTER JOIN District d ON (d.Id = s.District_Id AND d.ClientID = s.ClientID)
WHERE o.isVoid = 0 AND (o.TransType < 4000 OR o.TransType > 4999) AND ((o.ADebit + o.MDebit) <> 0) --AND SUBSTRING(CAST(o.TransType as varchar),1,2) = '11'
UNION ALL
SELECT
	cr.ClientID,
	cr.Id as CASHRESID,
	0 as ORDID,
	0 as CSTID,
	cr.POS_Id as POSID,
	pd.Id as DISTID,
	ps.Id as SCHID,
	CASE
		WHEN cr.POS_Id = -3 THEN 1
		WHEN cr.POS_Id <> -3 THEN 0
		ELSE 2
	END as DepositType,
	2 as PaymentType,
	'Cash Received' as PaymentTypeName,
	cr.CloseDate,
	CAST(CONVERT(varchar,cr.CloseDate,101) as datetime),
	pd.DistrictName,
	pd.Address1 as DistAddress1,
	pd.Address2 as DistAddress2,
	pd.City as DistCity,
	pd.State as DistState,
	pd.Zip as DistZip,
	pd.BankName,
	pd.BankAddr1 as DistBankAddress1,
	pd.BankAddr2 as DistBankAddress2,
	pd.BankCity as DistBankCity,
	pd.BankState as DistBankState,
	pd.BankZip as DistBankZip,
	NULL as LastName,
	NULL as FirstName,
	NULL as Middle,
	0 as CheckNumber, 
	0.0 as CheckAmount,
	0.0 as POSCheckAmount,
	0.0 as AdminCheckAmount,
	0.0 as CreditAmount,
	0.0 as POSCreditAmount,
	0.0 as AdminCreditAmount,
	0.0 as CashAmount,
	0.0 as POSCashAmount,
	0.0 as MiscCashAmount,
	0.0 as AdminCashAmount,
	0.0 as POSTotalAmount,
	0.0 as AdminTotalAmount,
	(cr.CloseAmount - cr.OpenAmount) as CashOutAmount,
	0.0 as Amount
FROM CashResults cr 
	INNER JOIN POS p ON (p.id = cr.POS_Id AND p.ClientID = cr.ClientID)
	LEFT OUTER JOIN Schools ps ON (ps.Id = p.School_Id AND ps.ClientID = p.ClientID)
	LEFT OUTER JOIN District pd ON (pd.Id = ps.District_Id AND pd.ClientID = ps.ClientID)
WHERE cr.Finished = 1 AND (cr.OpenAmount <> 0.0 OR cr.CloseAmount <> 0.0) and cr.POS_Id <> -3
UNION ALL
SELECT
	cr.ClientID,
	cr.Id as CASHRESID,
	0 as ORDID,
	0 as CSTID,
	cr.POS_Id as POSID,
	od.Id as DISTID,
	os.Id as SCHID,
	CASE
		WHEN cr.POS_Id = -3 THEN 1
		WHEN cr.POS_Id <> -3 THEN 0
		ELSE 2
	END as DepositType,
	2 as PaymentType,
	'Cash Received' as PaymentTypeName,
	cr.CloseDate,
	CAST(CONVERT(varchar,cr.CloseDate,101) as datetime),
	od.DistrictName,
	od.Address1 as DistAddress1,
	od.Address2 as DistAddress2,
	od.City as DistCity,
	od.State as DistState,
	od.Zip as DistZip,
	od.BankName,
	od.BankAddr1 as DistBankAddress1,
	od.BankAddr2 as DistBankAddress2,
	od.BankCity as DistBankCity,
	od.BankState as DistBankState,
	od.BankZip as DistBankZip,
	NULL as LastName,
	NULL as FirstName,
	NULL as Middle,
	0 as CheckNumber, 
	0.0 as CheckAmount,
	0.0 as POSCheckAmount,
	0.0 as AdminCheckAmount,
	0.0 as CreditAmount,
	0.0 as POSCreditAmount,
	0.0 as AdminCreditAmount,
	0.0 as CashAmount,
	0.0 as POSCashAmount,
	0.0 as MiscCashAmount,
	0.0 as AdminCashAmount,
	0.0 as POSTotalAmount,
	0.0 as AdminTotalAmount,
	(cr.CloseAmount - cr.OpenAmount) as CashOutAmount,
	0.0 as Amount
FROM CashResults cr 
	LEFT OUTER JOIN Transactions t on (t.CashRes_Id = cr.Id AND t.ClientID = cr.ClientID)
	LEFT OUTER JOIN Orders o on ((o.Id = t.Order_Id and t.OrderType = 0) AND o.ClientID = t.ClientID)
	LEFT OUTER JOIN Schools os on (os.Id = o.School_Id AND os.ClientID = o.ClientID)
	LEFT OUTER JOIN District od on (od.Id = os.District_Id AND od.ClientID = os.ClientID)
WHERE cr.Finished = 1 AND (cr.OpenAmount <> 0.0 OR cr.CloseAmount <> 0.0) and cr.POS_Id = -3
GO
