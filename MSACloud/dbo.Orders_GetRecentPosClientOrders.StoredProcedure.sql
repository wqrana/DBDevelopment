USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Orders_GetRecentPosClientOrders]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Parameters to pass in Stored Procedure */

CREATE PROCEDURE [dbo].[Orders_GetRecentPosClientOrders] --'44','2016-01-11 14:09:14.7530000',10
    @ClientID bigint,
    @LastUpdatedUTC datetime2,
    @MaxRows int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DefaultMaxRows int = 5000

	IF (@MaxRows IS NULL OR @MaxRows < 0)
	BEGIN
		SET @MaxRows = @DefaultMaxRows
	END

--SET @ClientID = 19
--SET @MaxRows = 2
--SET @LastUpdatedUTC = GETUTCDATE()

/* Stored Procedure Start Here */
DECLARE 
	@CashResultRows INT
	,@OrderRows INT
	,@PreOrderRows INT
	,@SalesTaxRows INT
	,@BonusPaymentRows INT
	,@OrderLogRows INT
	,@ItemRows INT
	,@PreOrderItemRows INT

/* Make sure Temp Tables do not exist */
IF OBJECT_ID('tempdb..#TransRecords') IS NOT NULL
	DROP TABLE #TransRecords

IF OBJECT_ID('tempdb..#CashResultRecords') IS NOT NULL
	DROP TABLE #CashResultRecords

IF OBJECT_ID('tempdb..#OrderRecords') IS NOT NULL
	DROP TABLE #OrderRecords

IF OBJECT_ID('tempdb..#PreOrderRecords') IS NOT NULL
	DROP TABLE #PreOrderRecords

IF OBJECT_ID('tempdb..#BonusPaymentRecords') IS NOT NULL
	DROP TABLE #BonusPaymentRecords

IF OBJECT_ID('tempdb..#OrderLogRecords') IS NOT NULL
	DROP TABLE #OrderLogRecords

IF OBJECT_ID('tempdb..#SalesTaxRecords') IS NOT NULL
	DROP TABLE #SalesTaxRecords

IF OBJECT_ID('tempdb..#ItemRecords') IS NOT NULL
	DROP TABLE #ItemRecords

IF OBJECT_ID('tempdb..#PreOrderItemRecords') IS NOT NULL
	DROP TABLE #PreOrderItemRecords

/* Get Transactions that have been altered */
SELECT TOP (@MaxRows) *
INTO #TransRecords
FROM Transactions
WHERE (
		LastUpdatedUTC >= @LastUpdatedUTC
		OR UpdatedBySync = 0
		OR CloudIDSync = 0
		--OR Local_Id IS NULL
		)
ORDER BY Id

/* Get related CashResult records and then any other Cashresult records modified */
SELECT TOP 100 PERCENT cr.*
INTO #CashResultRecords
FROM CashResults cr
INNER JOIN #TransRecords t ON t.CashRes_Id = cr.Id
ORDER BY cr.Id

SELECT @CashResultRows = count(*) from #CashResultRecords

IF (@CashResultRows < @MaxRows) BEGIN
	INSERT INTO #CashResultRecords 
		SELECT TOP (@MaxRows - @CashResultRows) cr.*
		FROM CashResults cr
		WHERE (
				cr.LastUpdatedUTC >= @LastUpdatedUTC
				OR cr.UpdatedBySync = 0
				OR cr.CloudIDSync = 0
				--OR cr.Local_Id IS NULL
				)
				AND cr.Id not in (select Id from #CashResultRecords)
		ORDER BY cr.Id
END

/* Get Orders related to Transactions and then Orders that have been changed */
SELECT TOP 100 PERCENT o.*
INTO #OrderRecords
FROM Orders o
INNER JOIN #TransRecords t ON t.Order_Id = o.Id AND t.OrderType = 0
ORDER BY o.Id

SELECT @OrderRows = count(*) from #OrderRecords

IF (@OrderRows < @MaxRows) BEGIN
	INSERT INTO #OrderRecords
		SELECT TOP (@MaxRows - @OrderRows) o.*
		FROM Orders o
		WHERE (
				o.LastUpdatedUTC >= @LastUpdatedUTC
				OR o.UpdatedBySync = 0
				OR o.CloudIDSync = 0
				--OR o.Local_Id IS NULL
				)
				AND o.Id not in (select id from #OrderRecords)
		ORDER BY o.Id
END

/* Get Preorders related to Transactions modified and then any Preorders that have been modified */
SELECT TOP 100 PERCENT po.*
INTO #PreOrderRecords
FROM PreOrders po
INNER JOIN #TransRecords t ON t.Order_Id = po.Id AND t.OrderType = 1
ORDER BY po.Id

SELECT @PreOrderRows = count(*) from #PreOrderRecords

IF (@PreOrderRows < @MaxRows) BEGIN
	INSERT INTO #PreOrderRecords
	SELECT TOP (@MaxRows - @PreOrderRows) po.*
	FROM PreOrders po
	LEFT OUTER JOIN #PreOrderRecords por on por.Id = po.Id
	WHERE (
				po.LastUpdatedUTC >= @LastUpdatedUTC
				OR po.UpdatedBySync = 0
				OR po.CloudIDSync = 0
				--OR o.Local_Id IS NULL
			)
			AND po.Id not in (select id from #PreOrderRecords)
	ORDER BY po.Id
END

/* Get related Sales tax records and then any other Sales Tax records modified */
SELECT TOP 100 PERCENT st.*
INTO #SalesTaxRecords
FROM SalesTax st
INNER JOIN #OrderRecords o ON o.Id = st.Order_Id
ORDER BY st.Id

SELECT @SalesTaxRows = count(*) from #SalesTaxRecords

IF (@SalesTaxRows < @MaxRows) BEGIN
	INSERT INTO #SalesTaxRecords
		SELECT TOP (@MaxRows - @SalesTaxRows) st.*
		FROM SalesTax st
		WHERE (
				st.LastUpdatedUTC >= @LastUpdatedUTC
				OR st.UpdatedBySync = 0
				OR st.CloudIDSync = 0
				--OR st.Local_Id IS NULL
				)
				and st.Id not in (select id from #SalesTaxRecords)
		ORDER BY st.Id
END

/* Get related BonusPayment records and any other BonusPayments modified */
SELECT TOP 100 PERCENT bp.*
INTO #BonusPaymentRecords
FROM BonusPayments bp
INNER JOIN #OrderRecords o ON o.Id = bp.Order_Id
ORDER BY bp.Id

INSERT INTO #BonusPaymentRecords
SELECT TOP 100 PERCENT bp.*
FROM BonusPayments bp
INNER JOIN #TransRecords t ON t.Order_Id = bp.Id AND t.OrderType = 2
ORDER BY bp.Id

SELECT @BonusPaymentRows = count(*) from #BonusPaymentRecords

IF (@BonusPaymentRows < @MaxRows) BEGIN
	INSERT INTO #BonusPaymentRecords
		SELECT TOP (@MaxRows - @BonusPaymentRows) bp.*
		FROM BonusPayments bp
		WHERE (
				bp.LastUpdatedUTC >= @LastUpdatedUTC
				OR bp.UpdatedBySync = 0
				OR bp.CloudIDSync = 0
				--OR bp.Local_Id IS NULL
				)
				and bp.Id not in (select id from #BonusPaymentRecords)
		ORDER BY bp.Id
END

/* Get related OrderLog records and then any other Order Log records modified */
SELECT TOP 100 PERCENT ol.*
INTO #OrderLogRecords
FROM OrdersLog ol
INNER JOIN #OrderRecords o ON o.OrdersLog_Id = ol.Id
ORDER BY ol.Id

INSERT INTO #OrderLogRecords
SELECT TOP 100 PERCENT ol.*
FROM OrdersLog ol
INNER JOIN #PreOrderRecords po ON po.OrdersLog_Id = ol.Id
ORDER BY ol.Id

SELECT @OrderLogRows = count(*) from #OrderLogRecords

IF (@OrderLogRows < @MaxRows) BEGIN
	INSERT INTO #OrderLogRecords
		SELECT TOP (@MaxRows - @OrderLogRows) ol.*
		FROM OrdersLog ol
		WHERE (
				ol.LastUpdatedUTC >= @LastUpdatedUTC
				OR ol.UpdatedBySync = 0
				OR ol.CloudIDSync = 0
				--OR ol.Local_Id IS NULL
				)
				and ol.id not in (select Id from #OrderLogRecords)
		ORDER BY ol.Id
END

/* Get Items related to gathered Orders and any Items that have been modified */
SELECT TOP 100 PERCENT i.*
INTO #ItemRecords
FROM Items i
INNER JOIN #OrderRecords o ON o.Id = i.Order_Id
ORDER BY i.Id

SELECT @ItemRows = count(*) from #ItemRecords

IF (@ItemRows < @MaxRows) BEGIN
	INSERT INTO #ItemRecords
		SELECT TOP (@MaxRows - @ItemRows) i.*
		FROM Items i
		WHERE (
				i.LastUpdatedUTC >= @LastUpdatedUTC
				OR i.UpdatedBySync = 0
				OR i.CloudIDSync = 0
				--OR i.Local_Id IS NULL
				)
				and i.id not in (select id from #ItemRecords)
		ORDER BY i.Id
END

/* Get PreorderItems related to gathered PreOrders and any PreOrderItems that have been modified */
SELECT TOP 100 PERCENT poi.*
INTO #PreOrderItemRecords
FROM PreOrderItems poi
INNER JOIN #PreOrderRecords po ON po.Id = poi.PreOrder_Id
ORDER BY poi.Id

SELECT @PreOrderItemRows = count(*) from #PreOrderItemRecords

IF (@PreOrderItemRows < @MaxRows) BEGIN
	INSERT INTO #PreOrderItemRecords
		SELECT TOP (@MaxRows - @PreOrderItemRows) poi.*
		FROM PreOrderItems poi
		WHERE (
				poi.LastUpdatedUTC >= @LastUpdatedUTC
				OR poi.UpdatedBySync = 0
				OR poi.CloudIDSync = 0
				--OR poi.Local_Id IS NULL
				)
				and poi.id not in (select id from #PreOrderItemRecords)
		ORDER BY poi.Id
END

/* Return Records as needed for code */
SELECT ClientID
	,Id
	,Customer_Pr_School_Id
	,POS_Id
	,School_Id
	,Emp_Cashier_Id
	,Customer_Id
	,OrdersLog_Id
	,GDate
	,OrderDate
	,OrderDateLocal
	,LunchType
	,ADebit
	,MDebit
	,ACredit
	,BCredit
	,MCredit
	,CheckNumber
	,OverRide
	,isVoid AS IsVoid
	,TransType
	,CreditAuth_Id
	,PartitionId
	,PartitionOffset
	,LastUpdatedUTC
	,Local_ID
FROM #OrderRecords o

SELECT Id
	,Order_Id AS OrderId
	,Menu_Id AS MenuId
	,Qty
	,FullPrice
	,PaidPrice
	,TaxPrice
	,isVoid
	,SoldType
	,PreOrderItem_Id AS PreOrderItemId
	,LastUpdatedUTC
	,Local_ID
FROM #ItemRecords

SELECT DISTINCT Id
	,Employee_Id AS EmployeeId
	,ChangedDate
	,Notes
	,LastUpdatedUTC
	,Local_ID
FROM #OrderLogRecords

SELECT Id
	,TaxEntity_Id AS TaxEntityId
	,TaxEntityName
	,Order_Id AS OrderId
	,TaxRate
	,SalesTax
	,LastUpdatedUTC
	,Local_ID
FROM #SalesTaxRecords

SELECT DISTINCT Id
	,Emp_Cashier_Id AS EmpCashierId
	,POS_Id as PosId
	,OpenDate
	,CloseDate
	,TotalCash
	,OverShort
	,Additional
	,PaidOuts
	,OpenAmount
	,CloseAmount
	,Sales
	,Finished
	,OpenBlob
	,CloseBlob
	,CashDrawer_Id AS CashDrawerId
	,LastUpdatedUTC
	,Local_ID
FROM #CashResultRecords

SELECT Id
	,Order_Id AS OrderId
	,OrderType
	,CashRes_Id AS CashResId
	,LastUpdatedUTC
	,Local_ID
FROM #TransRecords

SELECT Id
	,Customer_Id
	,BonusDate
	,MealPlan
	,BonusPaid
	,PriorBal
	,Order_Id
	,BonusDateLocal
	,LastUpdatedUTC
	,UpdatedBySync
	,Local_ID
	,CloudIDSync
FROM #BonusPaymentRecords

SELECT ClientID
	,Id
	,PreSaleTrans_Id
	,Customer_Id
	,OrdersLog_Id
	,PurchasedDate
	,PurchasedDateLocal
	,TransferDate
	,TransferDateLocal
	,LunchType
	,MCredit
	,ACredit
	,BCredit
	,TotalSale
	,isVoid
	,ItemCount
	,Transtype
	,LastUpdatedUTC
	,Local_ID
FROM #PreOrderRecords

SELECT ClientID
	,Id
	,PreSale_Id
	,ServingDate
	,PickupDate
	,Disposition
	,PreOrder_Id
	,Menu_Id
	,Qty
	,FullPrice
	,PaidPrice
	,TaxPrice
	,isVoid
	,SoldType
	,PickupCount
	,LastUpdatedUTC
	,Local_ID
FROM #PreOrderItemRecords

/* Remove Temp tables from memory */
IF OBJECT_ID('tempdb..#TransRecords') IS NOT NULL
	DROP TABLE #TransRecords

IF OBJECT_ID('tempdb..#CashResultRecords') IS NOT NULL
	DROP TABLE #CashResultRecords

IF OBJECT_ID('tempdb..#OrderRecords') IS NOT NULL
	DROP TABLE #OrderRecords

IF OBJECT_ID('tempdb..#PreOrderRecords') IS NOT NULL
	DROP TABLE #PreOrderRecords

IF OBJECT_ID('tempdb..#BonusPaymentRecords') IS NOT NULL
	DROP TABLE #BonusPaymentRecords

IF OBJECT_ID('tempdb..#OrderLogRecords') IS NOT NULL
	DROP TABLE #OrderLogRecords

IF OBJECT_ID('tempdb..#SalesTaxRecords') IS NOT NULL
	DROP TABLE #SalesTaxRecords

IF OBJECT_ID('tempdb..#ItemRecords') IS NOT NULL
	DROP TABLE #ItemRecords

IF OBJECT_ID('tempdb..#PreOrderItemRecords') IS NOT NULL
	DROP TABLE #PreOrderItemRecords

End
GO
