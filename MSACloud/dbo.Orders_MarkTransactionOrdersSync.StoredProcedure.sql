USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Orders_MarkTransactionOrdersSync]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Orders_MarkTransactionOrdersSync]
	@ClientID bigint,
    @LastUpdatedUTC datetime2,
	@Transactions dbo.TransactionRecordsId READONLY,
	@Orders dbo.TransactionRecordsId READONLY,
	@PreOrders dbo.TransactionRecordsId READONLY,
	@OrdersLog dbo.TransactionRecordsId READONLY,
	@SalesTax dbo.TransactionRecordsId READONLY,
	@CashResults dbo.TransactionRecordsId READONLY,
	@BonusPayments dbo.TransactionRecordsId READONLY,
	@Items dbo.TransactionRecordsId READONLY,
	@PreOrderItems dbo.TransactionRecordsId READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/* Orders */ 
	ALTER TABLE [dbo].[Orders] DISABLE TRIGGER ALL
	Update [dbo].[Orders] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @Orders)
	ALTER TABLE [dbo].[Orders] ENABLE TRIGGER ALL

	/* Items */ 
	ALTER TABLE [dbo].[Items] DISABLE TRIGGER ALL
	Update [dbo].[Items] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @Items)
	ALTER TABLE [dbo].[Items] ENABLE TRIGGER ALL

	/* OrdersLog */ 
	ALTER TABLE [dbo].[OrdersLog] DISABLE TRIGGER ALL
	Update [dbo].[OrdersLog] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @OrdersLog)
	ALTER TABLE [dbo].[OrdersLog] ENABLE TRIGGER ALL

	/* SalesTax */ 
	ALTER TABLE [dbo].[SalesTax] DISABLE TRIGGER ALL
	Update [dbo].[SalesTax] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @SalesTax)
	ALTER TABLE [dbo].[SalesTax] ENABLE TRIGGER ALL

	/* CashResults */ 
	ALTER TABLE [dbo].[CashResults] DISABLE TRIGGER ALL
	Update [dbo].[CashResults] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @CashResults)
	ALTER TABLE [dbo].[CashResults] ENABLE TRIGGER ALL

	/* Transactions */ 
	ALTER TABLE [dbo].[Transactions] DISABLE TRIGGER ALL
	Update [dbo].[Transactions] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @Transactions)
	ALTER TABLE [dbo].[Transactions] ENABLE TRIGGER ALL

	/* PreOrders */
	ALTER TABLE [dbo].[PreOrders] DISABLE TRIGGER ALL
	Update [dbo].[PreOrders] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @PreOrders)
	ALTER TABLE [dbo].[PreOrders] ENABLE TRIGGER ALL

	/* PreOrderItems */
	ALTER TABLE [dbo].[PreOrderItems] DISABLE TRIGGER ALL
	Update [dbo].[PreOrderItems] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @PreOrderItems)
	ALTER TABLE [dbo].[PreOrderItems] ENABLE TRIGGER ALL

	/* BonusPayments */
	ALTER TABLE [dbo].[BonusPayments] DISABLE TRIGGER ALL
	Update [dbo].[BonusPayments] Set UpdatedBySync = 1, CloudIDSync = 1
	WHERE  ClientID = @ClientID
	--AND (ISNULL(UpdatedBySync, 0) = 0) AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND (ISNULL(CloudIDSync, 0) = 0)
	--AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) AND ((ISNULL(UpdatedBySync, 0) = 0) OR (ISNULL(CloudIDSync, 0) = 0))
	AND (ISNULL(LastUpdatedUTC, '1/1/1900') < @LastUpdatedUTC) and Id in (select Id from @BonusPayments)
	ALTER TABLE [dbo].[BonusPayments] ENABLE TRIGGER ALL
    
END
GO
