USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Orders_GetRecentPosClientPreOrders]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Orders_GetRecentPosClientPreOrders] --'44','2016-01-11 14:09:14.7530000',10
    @ClientID bigint,
    @LastUpdatedUTC datetime2,
    @MaxRows int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DefaultMaxRows int = 1000

	IF (@MaxRows IS NULL OR @MaxRows < 0)
BEGIN
    SET @MaxRows = @DefaultMaxRows
END

	SELECT TOP (@MaxRows) 
	
	o.ClientID,
    o.Id,
    o.PreSaleTrans_Id ,
    o.Customer_Id ,
    o.OrdersLog_Id ,
    o.PurchasedDate,
    o.PurchasedDateLocal,
    o.TransferDate,
    o.TransferDateLocal,
    o.LunchType,
    o.MCredit,
    o.ACredit,
    o.BCredit,
    o.TotalSale,
    o.isVoid,
    o.ItemCount,
    o.Transtype,
    o.LastUpdatedUTC,
	o.Local_ID
    	
	  INTO #TempOrders
	  FROM [dbo].[PreOrders]  AS o
	 WHERE 
    o.ClientID = @ClientID
	--AND ISNULL(o.UpdatedBySync,0)=0
	-- AND (o.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(o.CloudIDSync,0)=0)
	AND (ISNULL(o.UpdatedBySync,0) = 0 OR o.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(o.CloudIDSync,0) = 0)
	 ORDER BY Id

	-- Return the result sets
	SELECT *
	  FROM #TempOrders

	SELECT [Items].[ClientID]
		  ,[Items].[Id]
		  ,[Items].[PreSale_Id] 
		  ,[Items].[ServingDate]
		  ,[Items].[PickupDate]
		  ,[Items].[Disposition]
		  ,[Items].[PreOrder_Id] 
		  ,[Items].[Menu_Id] 
		  ,[Items].[Qty]
		  ,[Items].[FullPrice]
		  ,[Items].[PaidPrice]
		  ,[Items].[TaxPrice]
		  ,[Items].[isVoid]
		  ,[Items].[SoldType]
		  ,[Items].[PickupCount]
		  ,[Items].[LastUpdatedUTC]
		  ,[Items].Local_ID

	  FROM [dbo].[PreOrderItems] as Items
	  JOIN #TempOrders on #TempOrders.Id = Items.preorder_id
	  WHERE 
	  --ISNULL(Items.UpdatedBySync,0)=0
   --   AND (Items.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(Items.CloudIDSync,0)=0)
		ISNULL(Items.UpdatedBySync,0) = 0 OR Items.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(Items.CloudIDSync,0) = 0

	SELECT [OrdersLog].[Id]
		  ,[OrdersLog].[Employee_Id] as [EmployeeId]
		  ,[OrdersLog].[ChangedDate]
		  ,[OrdersLog].[Notes]
		  ,[OrdersLog].LastUpdatedUTC
		  ,[OrdersLog].Local_ID
      FROM [dbo].[OrdersLog]
	  JOIN #TempOrders on #TempOrders.OrdersLog_Id = OrdersLog.Id
	  WHERE 
	  
       (OrdersLog.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(OrdersLog.CloudIDSync,0)=0)
	  

	SELECT [SalesTax].[Id]
		  ,[SalesTax].[TaxEntity_Id] as [TaxEntityId]
		  ,[SalesTax].[TaxEntityName]
		  ,[SalesTax].[Order_Id] as [OrderId]
		  ,[SalesTax].[TaxRate]
		  ,[SalesTax].[SalesTax]
		  ,[SalesTax].LastUpdatedUTC
		  ,[SalesTax].Local_ID
	  FROM [dbo].[SalesTax]
	  JOIN #TempOrders on #TempOrders.Id = [SalesTax].Order_Id
	  WHERE 
	  --ISNULL(SalesTax.UpdatedBySync,0)=0
		-- AND (SalesTax.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(SalesTax.CloudIDSync,0)=0)
		ISNULL(SalesTax.UpdatedBySync,0) = 0 OR SalesTax.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(SalesTax.CloudIDSync,0) = 0

	
	SELECT [Transactions].[Id]
		  ,[Transactions].Order_Id as [OrderId]
		  ,[Transactions].OrderType
		  ,[Transactions].CashRes_Id as CashResId
		  ,[Transactions].LastUpdatedUTC
		  ,[Transactions].Local_ID
	  FROM [dbo].[Transactions]
	  JOIN #TempOrders on #TempOrders.Id = [Transactions].Order_Id
	  WHERE 
	  --ISNULL(Transactions.UpdatedBySync,0)=0
	  -- AND (Transactions.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(Transactions.CloudIDSync,0)=0)
		ISNULL(Transactions.UpdatedBySync,0) = 0 OR Transactions.LastUpdatedUTC >= @LastUpdatedUTC OR ISNULL(Transactions.CloudIDSync,0) = 0
END
GO
