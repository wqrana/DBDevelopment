USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Reporting_DetailedTransactions]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat	
-- Create date: 25-Jan-2017
-- Description:	This functions returns data for Detailed Transaction report.
-- Modification History
-- Author:		Waqar	
-- Modification date: 9-aug-2017
-- Description:	Payment Description logic is updated against  bug 955 ( Detail Transaction Report). 
-- Author:		Waqar	
-- Modification date: 13-Mar-2019
-- Description:	@DetailedTransactions table is updated (Decimal to (18,2) against  bug 3037 ( Detail Transaction Report). 
--              fixed duplicate order records 
-- =============================================
-- Modification date: 29-Mar-2019
-- Description:	online order select is commented against bug 3037
--              
-- =============================================
CREATE FUNCTION [dbo].[Reporting_DetailedTransactions]
(
	@ClientID bigint,
	@SCHLIST varchar(2048) = '',
	@StartDate datetime = '1/1/1900',
	@EndDate datetime  = '1/1/2050'
)
RETURNS 
@DetailedTransactions TABLE 
(
	SchoolID BIGINT,
	SchoolName VARCHAR(60),
	DistrictID BIGINT,
	DistrictName VARCHAR(30),
	EmpCashierID BIGINT,
	EmployeeName VARCHAR(200),
	CustomerID BIGINT,
	LastName VARCHAR(24),
	FirstName VARCHAR(16),
	Middle VARCHAR(1),
	OrderID BIGINT,
	OrderDate Datetime2,
	TransType INT,
	PaymentType VARCHAR(200),
	Payment DECIMAL(18,2),
	AccountSales DECIMAL(18,2),
	CashSales DECIMAL(18,2),
	ItemName VARCHAR(200),
	PaidPrice DECIMAL(18,2),
	Qty INT,
	SalesTax DECIMAL(18,2),
	OnlineACHPayment DECIMAL(18,2)
)
AS
BEGIN
	
	WITH CTE AS
	(
			SELECT distinct
			ISNULL(o.Customer_Id, -2) as CSTID,
			o.School_Id as SCHID,
			s.SchoolID,
			s.SchoolName,
			d.Id as DISTID,
			d.DistrictName,
			o.Id as ORDID,
			o.Emp_Cashier_Id as EMPCASHID,
			CASE o.Emp_Cashier_Id
				WHEN -2 THEN 'Administrator'
				WHEN -98 THEN 'Vending'
				WHEN -9 THEN 'Online Order'
				ELSE RTRIM(Emp.LastName) + ', ' + RTRIM(Emp.FirstName) + ' ' + ISNULL(Emp.Middle,' ')
			END as EmployeeName,
			c.LastName,
			c.FirstName,
			c.Middle,
			o.GDate,
			o.OrderDate,
			o.TransType,
			'' as OrderTypeName,
			0 as OrderType,
			CASE
				WHEN SUBSTRING(CAST(o.TransType as varchar),2,1)	= '2' AND o.checknumber = 0 THEN 'Check Payment'
				WHEN SUBSTRING(CAST(o.TransType as varchar),2,1)	= '2'  THEN ISNULL('Check Payment (# ' + CAST(o.checknumber as varchar) + ')', 'Check Payment')
				--WHEN SUBSTRING(CAST(o.TransType as varchar),1,2)	= '43' THEN ISNULL('Online CC Payment (' + CAST(-o.checknumber as varchar) + ')', 'Online CC Payment')
				--WHEN SUBSTRING(CAST(o.TransType as varchar),2,1)	= '3' THEN ISNULL('POS CC Payment (' + CAST(-o.checknumber as varchar) + ')', 'POS CC Payment') 
				WHEN SUBSTRING(CAST(o.TransType as varchar),1,2)	= '43' THEN ISNULL('Online CC Payment (' + CAST((Case When ca.AuthNumber is null then o.checknumber else ca.AuthNumber end) as varchar) + ')', 'Online CC Payment')
				WHEN SUBSTRING(CAST(o.TransType as varchar),2,1)	= '3'  THEN  ISNULL('POS CC Payment (' + CAST((Case When ca.AuthNumber is null then o.checknumber else ca.AuthNumber end) as varchar) + ')', 'POS CC Payment')
				WHEN SUBSTRING(CAST(o.TransType as varchar),1,2)	= '46' THEN 'Online ACH Payment'
				WHEN SUBSTRING(CAST(o.TransType as varchar),2,1)	= '6' THEN 'ACH Payment'
				WHEN SUBSTRING(CAST(o.TransType as varchar),2,1)	= '4' THEN 'Refund'
				WHEN (SUBSTRING(CAST(o.TransType as varchar),2,1)	= '5' AND SUBSTRING(CAST(o.TransType as varchar),4,1) = '0') THEN 'Adjustment'
				WHEN o.TransType = 4501 THEN 'Online Transfer OUT'
				WHEN o.TransType = 4502 THEN 'Online Transfer IN'
				WHEN o.TransType = 1501 THEN 'Transfer OUT'
				WHEN o.TransType = 1502 THEN 'Transfer IN'

				WHEN o.TransType = 1503 AND (o.ADebit + o.MDebit) < 0 THEN 'Graduate Senior Refund'
				WHEN o.TransType = 1503 AND (o.ADebit + o.MDebit) > 0 THEN 'Graduate Senior Payment'
				WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) = '0' THEN ''
				WHEN SUBSTRING(CAST(o.TransType as varchar),2,1) <> '1' THEN ISNULL('Unknown Payment (' + CAST(o.CheckNumber as varchar) + ')', 'Unknown Payment')
				ELSE 'Cash Payment'
			END as PaymentType,
			CASE 
				WHEN (o.ADebit + o.MDebit) = 0.0 THEN NULL
				ELSE (o.ADebit + o.MDebit)
			END as Payment,
			it.TaxPrice as SalesTax,
			--dbo.ItemTotal(o.id) as SubTotal,
			--dbo.SALESTAXTOTAL(o.id) as SalesTax,
			--dbo.ItemTotal(o.id) + dbo.SalesTaxTotal(o.id) as OrderTotal,
			CASE
				WHEN o.Customer_Id > 0 THEN (o.MCredit + o.ACredit + o.BCredit)
				ELSE 0.0
			END as AccountSales,
			CASE
				WHEN o.Customer_Id > 0 THEN 0.0
				ELSE (o.MCredit + o.ACredit + o.BCredit)
			END as CashSales,
			CASE 
				WHEN it.PreOrderItem_Id IS NOT NULL THEN '** (' + CONVERT(varchar,pre.PurchasedDate,101) + ') ' + ISNULL(m.ItemName, 'Misc Item $' + LTRIM(STR(it.PaidPrice,15,2)))
				ELSE ISNULL(m.ItemName, 'Misc Item $' + LTRIM(STR(it.PaidPrice,15,2)))
			END as ItemName,
			it.PaidPrice as PaidPrice,
			it.Qty as Qty,
			(it.PaidPrice * it.Qty) as ExtendedPrice,
			CASE
				WHEN SUBSTRING(CAST(o.TransType as varchar), 1, 2) = '46' THEN (o.ADebit + o.MDebit)
				ELSE NULL
			END as OnlineACHPayment
		FROM Orders o
			LEFT JOIN Items it ON (it.Order_Id = o.Id)
			LEFT OUTER JOIN PreOrderItems poi ON (poi.Id = it.PreOrderItem_Id)
			LEFT OUTER JOIN PreOrders pre ON (pre.Id = poi.PreOrder_Id)
			LEFT OUTER JOIN Menu m ON (m.Id = it.Menu_Id)
			LEFT OUTER JOIN Customer_School cs ON ((cs.Customer_Id = o.Customer_Id) AND (cs.isPrimary = 1))
			LEFT OUTER JOIN Schools s ON (s.Id = o.School_Id)
			LEFT OUTER JOIN District d ON (d.Id = s.District_Id)
			LEFT OUTER JOIN Customers Emp ON Emp.Id = o.Emp_Cashier_Id
			LEFT OUTER JOIN Customers c ON c.Id = o.Customer_Id
			LEFT OUTER JOIN CreditAuthorization ca on o.id = ca.order_id

		WHERE (it.isVoid = 0 or it.isVoid is null) AND (o.isVoid = 0 OR (SUBSTRING(CAST(o.TransType as varchar),2,1) = '5' AND SUBSTRING(CAST(o.TransType as varchar),4,1) = '0')) AND o.Emp_Cashier_Id <> -99 AND o.TransType <> 1700
		AND o.ClientID = @ClientID
		AND ((s.ID IN (SELECT Value FROM Reporting_fn_Split(@SCHLIST, ',')) AND @SCHLIST <> '') OR (@SCHLIST = ''))
		AND o.OrderDate BETWEEN  @StartDate AND @EndDate
		
		UNION ALL
		SELECT
			pre.Customer_Id as CSTID,
			ISNULL(s.Id,-3) as SCHID,
			s.SchoolID,
			s.SchoolName,
			d.Id as DISTID,
			d.DistrictName,
			pre.Id,
			-9 as EMPCASHID,
			'Online PreOrder' as EmployeeName,
			c.LastName,
			c.FirstName,
			c.Middle,
			CAST(CONVERT(varchar,pre.PurchasedDate,101) as datetime) as GDate,
			pre.PurchasedDate,
			pre.TransType,
			' - (PreOrder)' as OrderTypeName,
			1 as OrderType,
			'' as PaymentType,
			NULL as Payment,
			--dbo.PreOrderItemTotal(pre.id) as SubTotal,
			poi.TaxPrice as SalesTax,
			--dbo.PreOrderItemTotal(pre.id) as OrderTotal,
			(pre.ACredit + pre.MCredit + pre.BCredit) as AccountSales,
			0.0 as CashSales,
			ISNULL(m.ItemName, 'Misc Item $' + LTRIM(STR(poi.PaidPrice,15,2))) as ItemName,
			poi.PaidPrice as PaidPrice,
			poi.Qty as Qty,
			(poi.PaidPrice * poi.Qty) as ExtendedPrice,
			NULL as OnlineACHPayment
		FROM PreOrders pre
			INNER JOIN PreOrderItems poi ON (poi.PreOrder_Id = pre.Id)
			LEFT OUTER JOIN Menu m ON (m.Id = poi.Menu_Id)
			LEFT OUTER JOIN Customer_School cs ON ((cs.Customer_Id = pre.Customer_Id) AND (cs.isPrimary = 1))
			LEFT OUTER JOIN Schools s ON (s.Id = cs.School_Id)
			LEFT OUTER JOIN District d ON (d.Id = s.District_Id)
			LEFT OUTER JOIN Customers c ON (c.Id = pre.Customer_Id)
		WHERE poi.isVoid = 0 AND pre.isVoid = 0 AND pre.Customer_Id > 0
		AND pre.ClientID = @ClientID
		AND s.ID IN (SELECT Value FROM Reporting_fn_Split(@SCHLIST, ','))
		AND pre.PurchasedDate BETWEEN  @StartDate AND @EndDate 
		
	)

	INSERT INTO @DetailedTransactions
	SELECT --distinct
				SCHID,
				SchoolName,
				DISTID,
				DistrictName,
				EMPCASHID,
				EmployeeName,
				CSTID,
				LastName,
				FirstName,
				Middle,
				ORDID,
				OrderDate,
				TransType,
				PaymentType,
				Payment,
				AccountSales,
				CashSales,
				ItemName,
				PaidPrice,
				Qty,
				SalesTax,
				OnlineACHPayment

		FROM CTE
	
	
	RETURN 
END
GO
