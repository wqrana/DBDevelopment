USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[OnlinePayments]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OnlinePayments]
AS
SELECT
	o.Id as ORDID,
	c.Id as CSTID,
	s.Id as SCHID,
	o.TransType,
	s.SchoolID,
	s.SchoolName,
	o.gdate as AuthorizedDate,
	o.orderdate as PostedDate,	
	c.UserID,
	c.LastName,
	c.FirstName,
	c.Middle,
	(o.mdebit + o.adebit) as PaymentTotal,
	CASE substring(CAST(o.TransType as varchar),2,3)
		WHEN '300' THEN ISNULL('Online CC Transaction: ' + CAST(o.checknumber as varchar), 'Online CC Transaction: Missing Trans ID')
		WHEN '600' THEN ISNULL('Online ACH Transaction: ' + CAST(o.checknumber as varchar), 'Online ACH Transaction: Missing Trans ID')
		WHEN '501' THEN ISNULL('Online Transfer (CREDIT): ' + CAST(o.checknumber as varchar), 'Online Transfer (CREDIT)')
		WHEN '502' THEN ISNULL('Online Transfer (DEBIT): ' + CAST(o.checknumber as varchar), 'Online Transfer (DEBIT)') 
		ELSE ISNULL('Transaction ID: ' + CAST(o.checknumber as varchar), '----')
	END as Comments
FROM Orders o
	LEFT OUTER JOIN Schools s ON s.Id = o.School_Id
	LEFT OUTER JOIN Customers c ON c.Id = o.Customer_Id
WHERE SUBSTRING(CAST(o.TransType as varchar),1,1) = '4'
GO
