USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetFaildOrdersForSync]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetFaildOrdersForSync] 
	@maxBatchSize INT,
	@ClientID bigint
AS
BEGIN

	DECLARE @DefaultMaxRows int = 1000
	DECLARE @MaxRows INT = NULL
	SET @MaxRows = @maxBatchSize

	IF (@MaxRows IS NULL OR @MaxRows < 0)
	BEGIN
		SET @MaxRows = @DefaultMaxRows
	END

	DECLARE @CashResultRows INT
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
	FROM [queue].Transactions
	WHERE ISNULL(IsPosted, 0) = 0
	ORDER BY Id

	/* Get related CashResult records and then any other Cashresult records modified */
	SELECT TOP 100 PERCENT cr.*
	INTO #CashResultRecords
	FROM [queue].CashResults cr
	INNER JOIN #TransRecords t ON t.CashResId = cr.Id
	WHERE ISNULL(cr.IsPosted, 0) = 0
	ORDER BY cr.Id

	SELECT @CashResultRows = count(*) from #CashResultRecords

	IF (@CashResultRows < @MaxRows) BEGIN
		INSERT INTO #CashResultRecords 
			SELECT TOP (@MaxRows - @CashResultRows) cr.*
			FROM [queue].CashResults cr
			WHERE cr.Id not in (select Id from #CashResultRecords)
			AND ISNULL(cr.IsPosted, 0) = 0
			ORDER BY cr.Id
	END

	/* Get Orders related to Transactions and then Orders that have been changed */
	SELECT TOP 100 PERCENT o.*
	INTO #OrderRecords
	FROM [queue].Orders o
	INNER JOIN #TransRecords t ON t.OrderId = o.Id AND t.OrderType = 0
	WHERE ISNULL(o.IsPosted, 0) = 0
	ORDER BY o.Id

	SELECT @OrderRows = count(*) from #OrderRecords

	IF (@OrderRows < @MaxRows) BEGIN
		INSERT INTO #OrderRecords
			SELECT TOP (@MaxRows - @OrderRows) o.*
			FROM [queue].Orders o
			WHERE o.Id not in (select id from #OrderRecords)
			AND ISNULL(o.IsPosted, 0) = 0
			ORDER BY o.Id
	END

	/* Get Preorders related to Transactions modified and then any Preorders that have been modified */
	SELECT TOP 100 PERCENT po.*
	INTO #PreOrderRecords
	FROM [queue].PreOrders po
	INNER JOIN #TransRecords t ON t.OrderId = po.Id AND t.OrderType = 1
	WHERE ISNULL(po.IsPosted, 0) = 0
	ORDER BY po.Id

	SELECT @PreOrderRows = count(*) from #PreOrderRecords

	IF (@PreOrderRows < @MaxRows) BEGIN
		INSERT INTO #PreOrderRecords
		SELECT TOP (@MaxRows - @PreOrderRows) po.*
		FROM [queue].PreOrders po
		WHERE po.Id not in (select id from #PreOrderRecords)
		AND ISNULL(po.IsPosted, 0) = 0
		ORDER BY po.Id
	END

	/* Get related Sales tax records and then any other Sales Tax records modified */
	SELECT TOP 100 PERCENT st.*
	INTO #SalesTaxRecords
	FROM [queue].SalesTax st
	INNER JOIN #OrderRecords o ON o.Id = st.OrderId
	WHERE ISNULL(st.IsPosted, 0) = 0
	ORDER BY st.Id

	SELECT @SalesTaxRows = count(*) from #SalesTaxRecords

	IF (@SalesTaxRows < @MaxRows) BEGIN
		INSERT INTO #SalesTaxRecords
			SELECT TOP (@MaxRows - @SalesTaxRows) st.*
			FROM [queue].SalesTax st
			WHERE st.Id not in (select id from #SalesTaxRecords)
			AND ISNULL(st.IsPosted, 0) = 0
			ORDER BY st.Id
	END

	/* Get related BonusPayment records and any other BonusPayments modified */
	SELECT TOP 100 PERCENT bp.*
	INTO #BonusPaymentRecords
	FROM [queue].BonusPayments bp
	INNER JOIN #OrderRecords o ON o.Id = bp.Order_Id
	WHERE ISNULL(bp.IsPosted, 0) = 0
	ORDER BY bp.Id

	INSERT INTO #BonusPaymentRecords
	SELECT TOP 100 PERCENT bp.*
	FROM [queue].BonusPayments bp
	INNER JOIN #TransRecords t ON t.OrderId = bp.Id AND t.OrderType = 2
	WHERE ISNULL(bp.IsPosted, 0) = 0
	ORDER BY bp.Id

	SELECT @BonusPaymentRows = count(*) from #BonusPaymentRecords

	IF (@BonusPaymentRows < @MaxRows) BEGIN
		INSERT INTO #BonusPaymentRecords
			SELECT TOP (@MaxRows - @BonusPaymentRows) bp.*
			FROM [queue].BonusPayments bp
			WHERE bp.Id not in (select id from #BonusPaymentRecords)
			AND ISNULL(bp.IsPosted, 0) = 0
			ORDER BY bp.Id
	END

	/* Get related OrderLog records and then any other Order Log records modified */
	SELECT TOP 100 PERCENT ol.*
	INTO #OrderLogRecords
	FROM [queue].OrdersLog ol
	INNER JOIN #OrderRecords o ON o.OrdersLogId = ol.Id
	WHERE ISNULL(ol.IsPosted, 0) = 0
	ORDER BY ol.Id

	INSERT INTO #OrderLogRecords
	SELECT TOP 100 PERCENT ol.*
	FROM [queue].OrdersLog ol
	INNER JOIN #PreOrderRecords po ON po.OrdersLog_Id = ol.Id
	WHERE ISNULL(ol.IsPosted, 0) = 0
	ORDER BY ol.Id

	SELECT @OrderLogRows = count(*) from #OrderLogRecords

	IF (@OrderLogRows < @MaxRows) BEGIN
		INSERT INTO #OrderLogRecords
			SELECT TOP (@MaxRows - @OrderLogRows) ol.*
			FROM [queue].OrdersLog ol
			WHERE ol.id not in (select Id from #OrderLogRecords)
			AND ISNULL(ol.IsPosted, 0) = 0
			ORDER BY ol.Id
	END

	/* Get Items related to gathered Orders and any Items that have been modified */
	SELECT TOP 100 PERCENT i.*
	INTO #ItemRecords
	FROM [queue].Items i
	INNER JOIN #OrderRecords o ON o.Id = i.OrderId
	WHERE ISNULL(i.IsPosted, 0) = 0
	ORDER BY i.Id

	SELECT @ItemRows = count(*) from #ItemRecords

	IF (@ItemRows < @MaxRows) BEGIN
		INSERT INTO #ItemRecords
			SELECT TOP (@MaxRows - @ItemRows) i.*
			FROM [queue].Items i
			WHERE i.id not in (select id from #ItemRecords)
			AND ISNULL(i.IsPosted, 0) = 0
			ORDER BY i.Id
	END

	/* Get PreorderItems related to gathered PreOrders and any PreOrderItems that have been modified */
	SELECT TOP 100 PERCENT poi.*
	INTO #PreOrderItemRecords
	FROM [queue].PreOrderItems poi
	INNER JOIN #PreOrderRecords po ON po.Id = poi.PreOrder_Id
	WHERE ISNULL(poi.IsPosted, 0) = 0
	ORDER BY poi.Id

	SELECT @PreOrderItemRows = count(*) from #PreOrderItemRecords

	IF (@PreOrderItemRows < @MaxRows) BEGIN
		INSERT INTO #PreOrderItemRecords
			SELECT TOP (@MaxRows - @PreOrderItemRows) poi.*
			FROM [queue].PreOrderItems poi
			WHERE poi.id not in (select id from #PreOrderItemRecords)
			AND ISNULL(poi.IsPosted, 0) = 0
			ORDER BY poi.Id
	END

	/* Getting records from temp tables */
	/* Remove Temp tables from memory */
	SELECT	 [CustomerPrSchoolId] AS [Customer_Pr_School_Id]
			,[Id]
			,[POSId] AS [POS_Id]
			,[SchoolId] AS [School_Id]
			,[EmpCashierId] AS [Emp_Cashier_Id]
			,[CustomerId] AS [Customer_Id]
			,[OrdersLogId] AS [OrdersLog_Id]
			,[OrderDate]
			,[LunchType]
			,[MDebit]
			,[MCredit]
			,[CheckNumber]
			,[OverRide]
			,[isVoid]
			,[GDate]
			,[ADebit]
			,[ACredit]
			--,[PriorABal]
			--,[PriorMBal]
			--,[PriorBBal]
			,[TransType]
			,[BCredit]
			,[CreditAuthId] AS [CreditAuth_Id]
			,[LastUpdatedUTC]
			,Cloud_Id
	FROM #OrderRecords

	SELECT 
			 [Id]
			,[OrderId]
			,[MenuId]
			,[Qty]
			,[FullPrice]
			,[PaidPrice]
			,[TaxPrice]
			,[isVoid]
			,[SoldType]
			,[PreOrderItemId]
			,[LastUpdatedUTC]
			,Cloud_Id
	FROM #ItemRecords

	SELECT DISTINCT	 [Id]
			,[EmployeeId]
			,[ChangedDate]
			,[Notes]
			,[LastUpdatedUTC]
			,Cloud_Id
	FROM #OrderLogRecords

	SELECT   [Id]
			,[TaxEntityId]
			,[TaxEntityName]
			,[OrderId]
			,[TaxRate]
			,[SalesTax]
			,[LastUpdatedUTC]
			,Cloud_Id
	FROM #SalesTaxRecords

	SELECT   [Id]
			,[PreSaleTrans_Id]
			,[Customer_Id]
			,[OrdersLog_Id]
			,[PurchasedDate]
			,[TransferDate]
			,[LunchType]
			,[MCredit]
			,[ACredit]
			,[BCredit]
			,[TotalSale]
			,[isVoid]
			--,[PriorABal]
			--,[PriorMBal]
			--,[PriorBBal]
			,[ItemCount]
			,[Transtype]
			,[LastUpdatedUTC]
			,Cloud_Id
	FROM #PreOrderRecords

	SELECT	 [Id]
			,[PreSale_Id]
			,[ServingDate]
			,[PickupDate]
			,[Disposition]
			,[PreOrder_Id]
			,[Menu_Id]
			,[Qty]
			,[FullPrice]
			,[PaidPrice]
			,[TaxPrice]
			,[isVoid] as IsVoid
			,[SoldType]
			,[PickupCount]
			,[LastUpdatedUTC]
			,Cloud_Id
	FROM #PreOrderItemRecords

	SELECT DISTINCT  [Id]
					,[POSId]
					,[EmpCashierId]
					,[OpenDate]
					,[CloseDate]
					,[TotalCash]
					,[OverShort]
					,[Additional]
					,[PaidOuts]
					,[OpenAmount]
					,[CloseAmount]
					,[Sales]
					,[Finished]
					,[OpenBlob]
					,[CloseBlob]
					,[CashDrawerId]
					,[LastUpdatedUTC]
					,Cloud_Id
	FROM #CashResultRecords

	SELECT	 [Id]
			,[Customer_Id]
			,[BonusDate]
			,[MealPlan]
			,[BonusPaid]
			,[PriorBal]
			,[Order_Id]
			,[LastUpdatedUTC]
			,Cloud_Id
	FROM #BonusPaymentRecords

	SELECT   [Id]
			,[OrderId]
			,OrderType
			,CashResId
			,LastUpdatedUTC
			,Cloud_Id
	FROM #TransRecords

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

END
GO
