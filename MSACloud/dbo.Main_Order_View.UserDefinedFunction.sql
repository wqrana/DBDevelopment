USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Main_Order_View]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Neil Heverly
-- Create date: 05/09/2014
-- Description:	Function to get an Order
-- =============================================
CREATE FUNCTION [dbo].[Main_Order_View] 
(
	@ClientID bigint, 
	@OrderID int, 
	@OrderType int	-- 0 - Order, 1 - Preorder, 2 - BonusPayment
)
RETURNS TABLE
AS
	RETURN (
	SELECT 
		o.Id as OrderNumber,
		o.OrderDate,
		o.OrderDateLocal,
		(o.ACredit + o.MCredit + o.BCredit) as OrderTotal,
		(o.ADebit + o.MDebit) as Payment,
		CASE
			WHEN o.POS_Id = -3 THEN 'ADMIN'
			ELSE p.Name
		END as POSName,
		CASE
			WHEN o.Emp_Cashier_Id = -2 THEN 'Administrator'
			ELSE (e.FirstName + ISNULL(' ' + e.Middle,' ') + ' ' +  e.LastName) 
		END as CashierName,
		o.Customer_Id as CustomerID,
		o.POS_Id as POSID,
		o.Emp_Cashier_Id as CashierID,
		o.School_Id as SchoolID,
		o.Customer_Pr_School_Id as PrimarySchoolID,
		o.OrdersLog_Id as OrdersLogID,
		CASE WHEN ol.Id is null THEN null ELSE ol.Notes END as OrderNote
	FROM Orders o
		LEFT OUTER JOIN Transactions t on t.ClientID = o.ClientID AND t.Order_Id = o.Id and t.OrderType = 0
		LEFT OUTER JOIN POS p on p.ClientID = o.ClientID and p.Id = o.POS_Id
		LEFT OUTER JOIN Customers e on e.ClientID = o.ClientID and e.Id = o.Emp_Cashier_Id
		LEFT OUTER JOIN OrdersLog ol on ol.ClientID = o.ClientID and ol.Id = o.OrdersLog_Id
	WHERE o.ClientID = @ClientID and o.Id = @OrderID and ISNULL(t.OrderType,0) = @OrderType
	UNION ALL
	SELECT 
		po.Id as OrderNumber,
		po.PurchasedDate,
		po.PurchasedDate as OrderDateLocal,
		(po.ACredit + po.MCredit + po.BCredit) as OrderTotal,
		0.0 as Payment,
		'PREORDER' as POSName,
		'MSA' as CashierName,
		po.Customer_Id as CustomerID,
		-9 as POSID,
		-9 as CashierID,
		cs.School_Id as SchoolID,
		cs.School_Id as PrimarySchoolID,
		po.OrdersLog_Id as OrdresLogID,
		CASE WHEN ol.Id is null THEN null ELSE ol.Notes END as OrderNote
	FROM PreOrders po
		LEFT OUTER JOIN Transactions t on t.ClientID = po.ClientID AND t.Order_Id = po.Id and t.OrderType = 1
		LEFT OUTER JOIN Customer_School cs on cs.ClientID = po.ClientID AND cs.Customer_Id = po.Customer_Id and cs.isPrimary = 1
		LEFT OUTER JOIN OrdersLog ol on ol.ClientID = po.ClientID AND ol.Id = po.OrdersLog_Id
	WHERE po.ClientID = @ClientID and po.Id = @OrderID and t.OrderType = @OrderType)
GO
