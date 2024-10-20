USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DetailCafeSummary]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[DetailCafeSummary]
AS
SELECT
	o.ClientID as ClientID,
	o.Id as ORDID,
	-1 as CASHRESID,
	o.School_Id as SCHID,
	o.POS_Id as POSID,
	o.Emp_Cashier_Id as EMPID,
	o.Customer_Id as CUSTID,
	o.OrderDate as ReportDateTime,
	o.GDate as ReportDate,
	0.0 as CashSalesByItem,
	0.0 as AccountSalesByItem,
	0.0 as PreOrderSalesByItem,
	(CASE
		WHEN (o.isVoid = 0 and o.Customer_Id < 0) THEN dbo.SALESTAXTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as CashSalesByItemTotal,
	(CASE
		WHEN (o.isVoid = 0 and o.Customer_Id > 0) THEN dbo.SALESTAXTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as AccountSalesByItemTotal,
	0.0 as PreOrderSalesByItemTotal,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0)) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as PaymentsOnAccount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99)) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as TotalOnAccount,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as CashPayments,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as CashSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.Customer_Id > 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as AccountSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id = -98) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as VendingPayments,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id = -98) AND (o.Customer_Id > 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as VendingAcctSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id = -98) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as VendingCashSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id = -98) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as VendingSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Customer_Id > 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as TotalAccountSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as TotalCashSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as Refunds,
	/*
	(
		-(CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0)) THEN (o.MDebit + o.ADebit) ELSE 0.0 END)	-- POC
		- (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id)) ELSE 0.0 END) -- CS + TOCS
		+ (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4')) THEN -(o.MDebit + o.ADebit) ELSE 0.0 END) -- R
		+ (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,2) = '23')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- COC
		+ (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '4')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- OAP
	) as OverShort,
	*/
	-(CASE
		WHEN (o.isVoid = 0) AND (o.Emp_Cashier_Id not in (-99,-98)) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '2') AND (SUBSTRING(CAST(o.TransType as varchar),1,1) <> '3') THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as OverShort,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.PickupItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as TotalSales,
	0.0 as POSDeposit,
	(CASE
		WHEN ((o.isVoid = 0) AND ((o.Emp_Cashier_Id = -98) OR (SUBSTRING(CAST(o.TransType as varchar),1,1) = '6')) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		ELSE 0.0
	END) as VendingDeposit,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '1')) THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END) as AdminDeposit,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '4')) THEN (o.ADebit + o.MDebit)
		ELSE 0.0
	END) as OnlineDeposit,
	(CASE
		WHEN ((o.isVoid = 0) AND ((o.Emp_Cashier_Id = -98) OR (SUBSTRING(CAST(o.TransType as varchar),1,1) = '6')) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id))
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '1')) THEN (o.ADebit + o.MDebit)
		-- MUST Remove Credit Card Payments as it is not money that will be Deposited
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '3') AND (o.Customer_Id > 0)) THEN 0.00 --(o.ADebit + o.MDebit)
		ELSE 0.0
	END) as Deposit,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Customer_Id > 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.PickupItemTotal(o.ClientID, o.id))
		ELSE 0.0
	END) as ChargedOnAccount,
	(
		(CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.PickupItemTotal(o.ClientID, o.id)) ELSE 0.0 END) -- TS
		+ (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0)) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- POC
		- (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4')) THEN -(o.MDebit + o.ADebit) ELSE 0.0 END) -- R
		- (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,2) = '23')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- COC
		- (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '4')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- OAP
		+ (CASE WHEN (o.isVoid = 0) THEN dbo.SALESTAXTOTAL(o.ClientID, o.id) ELSE 0.0 END) -- TaxC
	) as TotalCredits,
	(
		(CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Customer_Id > 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.PickupItemTotal(o.ClientID, o.id)) ELSE 0.0 END) -- CoA
		--OS
		- (
			-(CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0)) THEN (o.MDebit + o.ADebit) ELSE 0.0 END)	-- POC
			- (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id)) ELSE 0.0 END) -- CS + TOCS
			+ (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4')) THEN -(o.MDebit + o.ADebit) ELSE 0.0 END) -- R
			+ (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,2) = '23')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- COC
			+ (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '4')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- OAP
		) 
	) as TotalDebits,
	(
		(CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0)) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- POC
		+ (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id)) ELSE 0.0 END) -- CS + TOCS
		- (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4')) THEN -(o.MDebit + o.ADebit) ELSE 0.0 END) -- R
	) as Revenue,
	(
		(CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0)) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- POC
		+ (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Customer_Id < 0)) THEN (dbo.ItemTotal(o.ClientID, o.id) + dbo.SALESTAXTOTAL(o.ClientID, o.id)) ELSE 0.0 END) -- CS + TOCS
		- (CASE WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),2,1) = '4')) THEN -(o.MDebit + o.ADebit) ELSE 0.0 END) -- R
		- (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,2) = '23')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- COC
		- (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '4')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- OAP
	) as ToAccountFor,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (c.isStudent = 0) AND ((o.MDebit + o.ADebit) > 0) AND 
					(SUBSTRING(CAST(o.TransType as varchar),1,2) <> '23') AND (SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as AdultPayments,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (c.isStudent = 1) AND ((o.MDebit + o.ADebit) > 0) AND 
					(SUBSTRING(CAST(o.TransType as varchar),1,2) <> '23') AND (SUBSTRING(CAST(o.TransType as varchar),1,1) <> '4')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as StudentPayments,
	(CASE
		WHEN ((o.isVoid = 0) AND (dbo.SALESTAXTOTAL(o.ClientID, o.id) > 0)) THEN dbo.TAXSUBTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as TaxableSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.customer_Id < 0) AND (dbo.SALESTAXTOTAL(o.ClientID, o.id) > 0)) THEN dbo.TAXSUBTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as TaxableCashSales,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.customer_Id > 0) AND (dbo.SALESTAXTOTAL(o.ClientID, o.id) > 0)) THEN dbo.TAXSUBTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as TaxableAcctSales,
	(CASE
		WHEN (o.isVoid = 0) THEN dbo.SALESTAXTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as TaxCollected,
	(CASE
		WHEN (o.isVoid = 0 and o.Customer_Id > 0) THEN dbo.SALESTAXTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as TaxOnAcctSales,
	(CASE
		WHEN (o.isVoid = 0 and o.Customer_Id < 0) THEN dbo.SALESTAXTOTAL(o.ClientID, o.id)
		ELSE 0.0
	END) as TaxOnCashSales,
	0.0 as TaxOnPOSales,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND 
				(SUBSTRING(CAST(o.TransType as varchar),1,2) = '23')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as CreditsOnAccount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND 
				(SUBSTRING(CAST(o.TransType as varchar),1,1) = '4')) THEN (o.MDebit + o.ADebit) 
		ELSE 0.0
	END) as OnlinePayments,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND 
				(SUBSTRING(CAST(o.TransType as varchar),1,2) = '43')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as OnlineCCPayments,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND 
				(SUBSTRING(CAST(o.TransType as varchar),1,2) = '46') AND (o.MDebit + o.ADebit > 0.0)) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as OnlineACHPayments,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND
				(SUBSTRING(CAST(o.TransType as varchar),1,1) = '4') AND (o.MDebit + o.ADebit < 0.0)) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as OnlineACHReturns,
	(
		(CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0)) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- POC
		- (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,1) = '4')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- OAP
		- (CASE WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND (SUBSTRING(CAST(o.TransType as varchar),1,2) = '23')) THEN (o.MDebit + o.ADebit) ELSE 0.0 END) -- COC
	) as AccountSubtotal,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND
				(SUBSTRING(CAST(o.TransType as varchar),1,1) = '2')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as POSPaymentsOnAccount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) > 0) AND 
				(SUBSTRING(CAST(o.TransType as varchar),1,1) = '1')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as AdminPaymentsOnAccount,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.isVoid = 1) AND (o.Emp_Cashier_Id <> -99) AND ((o.MDebit + o.ADebit) <> 0) AND 
				(SUBSTRING(CAST(o.TransType as varchar),1,1) = '1')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as AdminPaymentsVoided,
	(CASE
		WHEN ((o.isVoid = 0) AND (o.Emp_Cashier_Id <> -99) AND (SUBSTRING(CAST(o.TransType as varchar),1,2) = '14')) THEN (o.MDebit + o.ADebit)
		ELSE 0.0
	END) as AdminRefunds
FROM Orders o
	LEFT OUTER JOIN Customers c ON c.Id = o.Customer_Id
WHERE SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
UNION ALL
SELECT
	o.ClientID as ClientID,
	o.Id as ORDID,
	-1 as CASHRESID,
	o.School_Id as SCHID,
	o.POS_Id as POSID,
	o.Emp_Cashier_Id as EMPID,
	o.Customer_Id as CUSTID,
	o.OrderDate as ReportDateTime,
	o.GDate as ReportDate,
	(CASE
		WHEN ((o.Customer_Id < 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.isVoid = 0) AND (it.isVoid = 0) AND (it.PreOrderItem_Id IS NULL))
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END) as CashSalesByItem,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.isVoid = 0) AND (it.isVoid = 0) AND (it.PreOrderItem_Id IS NULL))
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END) as AccountSalesByItem,
	(CASE
		WHEN ((o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.isVoid = 0) AND (it.PreOrderItem_Id IS NOT NULL))
			THEN (poi.PaidPrice * poi.Qty)
		ELSE 0.0
	END) as PreOrderSalesByItem,
	(CASE
		WHEN ((o.Customer_Id < 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.isVoid = 0) AND (it.isVoid = 0) AND (it.PreOrderItem_Id IS NULL))
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END) as CashSalesByItemTotal,
	(CASE
		WHEN ((o.Customer_Id > 0) AND (o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.isVoid = 0) AND (it.isVoid = 0) AND (it.PreOrderItem_Id IS NULL))
			THEN (it.PaidPrice * it.Qty)
		ELSE 0.0
	END) as AccountSalesByItemTotal,
	(CASE
		WHEN ((o.Emp_Cashier_Id <> -99) AND (o.Emp_Cashier_Id <> -98) AND (o.isVoid = 0) AND (it.PreOrderItem_Id IS NOT NULL))
			THEN (poi.PaidPrice * poi.Qty)
		ELSE 0.0
	END) as PreOrderSalesByItemTotal,
	0.0 as PaymentsOnAccount,
	0.0 as TotalOnAccount,
	0.0 as CashPayments,
	0.0 as CashSales,
	0.0 as AccountSales,
	0.0 as VendingPayments,
	0.0 as VendingAcctSales,
	0.0 as VendingCashSales,
	0.0 as VendingSales,
	0.0 as TotalAccountSales,
	0.0 as TotalCashSales,
	0.0 as Refunds,
	0.0 as OverShort,
	0.0 as TotalSales,
	0.0 as POSDeposit,
	0.0 as VendingDeposit,
	0.0 as AdminDeposit,
	0.0 as OnlineDeposit,
	0.0 as Deposit,
	0.0 as ChargedOnAccount,
	0.0 as TotalCredits,
	0.0 as TotalDebits,
	0.0 as Revenue,
	0.0 as ToAccountFor,
	0.0 as AdultPayments,
	0.0 as StudentPayments,
	0.0 as TaxableSales,
	0.0 as TaxableCashSales,
	0.0 as TaxableAcctSales,
	0.0 as TaxCollected,
	0.0 as TaxOnAcctSales,
	0.0 as TaxOnCashSales,
	0.0 as TaxOnPOSales,
	0.0 as CreditsOnAccount,
	0.0 as OnlinePayments,
	0.0 as OnlineCCPayments,
	0.0 as OnlineACHPayments,
	0.0 as OnlineACHReturns,
	0.0 as AccountSubtotal,
	0.0 as POSPaymentsOnAccount,
	0.0 as AdminPaymentsOnAccount,
	0.0 as AdminPaymentsVoided,
	0.0 as AdminRefunds
FROM Items it
	INNER JOIN Orders o ON o.Id = it.Order_Id
	LEFT OUTER JOIN PreOrderItems poi ON poi.Id = it.PreOrderItem_Id
	LEFT OUTER JOIN Customers c ON c.Id = o.Customer_Id
WHERE SUBSTRING(CAST(o.TransType as varchar),2,1) <> '5'
UNION ALL
SELECT
	p.ClientID as ClientID,
	-1 as ORDID,
	cr.Id as CASHRESID,
	p.School_Id as SCHID,
	cr.Pos_Id as POSID,
	cr.Emp_Cashier_Id as EMPID,
	-1 as CUSTID,
	cr.OpenDate as ReportDateTime,
	CAST(CONVERT(varchar,cr.OpenDate,101) as datetime) as ReportDate,
	0.0 as CashSalesByItem,
	0.0 as AccountSalesByItem,
	0.0 as PreOrderSalesByItem,
	0.0 as CashSalesByItemTotal,
	0.0 as AccountSalesByItemTotal,
	0.0 as PreOrderSalesByItemTotal,
	0.0 as PaymentsOnAccount,
	0.0 as TotalOnAccount,
	0.0 as CashPayments,
	0.0 as CashSales,
	0.0 as AccountSales,
	0.0 as VendingPayments,
	0.0 as VendingAcctSales,
	0.0 as VendingCashSales,
	0.0 as VendingSales,
	0.0 as TotalAccountSales,
	0.0 as TotalCashSales,
	0.0 as Refunds,
	(
		(cr.CloseAmount - cr.OpenAmount)
	) as OverShort,
	0.0 as TotalSales,
	(cr.CloseAmount - cr.OpenAmount) as POSDeposit,
	0.0 as VendingDeposit,
	0.0 as AdminDeposit,
	0.0 as OnlineDeposit,
	(cr.CloseAmount - cr.OpenAmount) as Deposit,
	0.0 as ChargedOnAccount,
	0.0 as TotalCredits,
	(
		(cr.CloseAmount - cr.OpenAmount) -- D
		- (cr.CloseAmount - cr.OpenAmount) -- OS	
	) as TotalDebits,
	0.0 as Revenue,
	0.0 as ToAccountFor,
	0.0 as AdultPayments,
	0.0 as StudentPayments,
	0.0 as TaxableSales,
	0.0 as TaxableCashSales,
	0.0 as TaxableAcctSales,
	0.0 as TaxCollected,
	0.0 as TaxOnAcctSales,
	0.0 as TaxOnCashSales,
	0.0 as TaxOnPOSales,
	0.0 as CreditsOnAccount,
	0.0 as OnlinePayments,
	0.0 as OnlineCCPayments,
	0.0 as OnlineACHPayments,
	0.0 as OnlineACHReturns,
	0.0 as AccountSubtotal,
	0.0 as POSPaymentsOnAccount,
	0.0 as AdminPaymentsOnAccount,
	0.0 as AdminPaymentsVoided,
	0.0 as AdminRefunds
FROM CashResults cr
	LEFT OUTER JOIN Pos p ON p.Id = cr.Pos_Id
WHERE p.Id <> -3
GO
