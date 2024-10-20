USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [Stage].[InsertPendingData]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Stage].[InsertPendingData]
	@clientID		BIGINT,
	@orders			Stage.OrderType READONLY,
	@items			Stage.ItemType READONLY,
	@salesTax		Stage.SalesTaxType READONLY,
	@orderLog		Stage.OrderLogType READONLY,
	@cashResults	Stage.CashResultType READONLY,
	@transactions	Stage.TransactionType READONLY,
	@preorders	    Stage.PreOrdersType READONLY,
	@preorderItems	Stage.PreOrderItemsType READONLY,
	@bonusPayments  Stage.BonusPaymentType READONLY,
	@jobInfo VARCHAR(32)
AS
BEGIN
	DECLARE @StartTime DATETIME = GETUTCDATE();

	DECLARE @RunStatus int = 1
		,@STARTTIMER datetime2(7)
		,@ENDTIMER datetime2(7)
		,@JobID int 
		,@LastRecordLoaded int
		,@RowCount int
		,@ErrorCode int = 0
		,@ErrorMessage varchar(4000)
		,@minTempOrderId int
		,@maxTempOrderId int
		,@orderCount int
		,@minTempItemId int
		,@maxTempItemId int
		,@itemCount int
		,@JobName varchar(50) = 'InsertPendingData'

	BEGIN TRANSACTION
	-- Check that Job is not already running.
	DECLARE @Count INT
	SELECT @Count = COUNT(1) FROM Stage.JobControl WITH (TABLOCKX) WHERE JobName IN (@JobName)
	IF @Count = 0
	BEGIN
		INSERT INTO Stage.JobControl (JobName, JobStatus)
		VALUES (@JobName, 'Running')
	END
	ELSE
	BEGIN
		SELECT @Count = COUNT(1) FROM Stage.JobControl WHERE JobName IN (@JobName) and JobStatus = 'Running'
		IF @Count <> 0
		BEGIN
			-- Return number of Rows left and the result of the Stored Procedure
			SELECT CAST(0 as bigint) RemainingRowCount, 0 as RunStatus
			COMMIT TRAN
			RETURN
		END
	END
	
	--Set status in LoadControl to running
	SET @LastRecordLoaded = COALESCE((SELECT LastRecordLoaded FROM Stage.JobControl where JobName = @JobName),-1)
	SET @JobID = (SELECT COALESCE(MAX(JobID),0)+1 FROM Stage.JobControl);
	UPDATE Stage.JobControl
	set JobID = @JobID
	   ,StartTime = GETUTCDATE()
	   ,JobStatus = 'Running'
	   ,EndTime = Null
	WHERE JobName = @JobName
	
	COMMIT TRAN

	-- Output Tables for New ID values
	DECLARE @OrderIds TABLE(OrigOrderId BIGINT, InsertedOrderId BIGINT,orderlogid BIGINT)
	--DECLARE @OrderIds TABLE(InsertedOrderId BIGINT)
	DECLARE @CashResultIds TABLE(OrigCashResId BIGINT, InsertedCashResId BIGINT)
	DECLARE @STARTTRANTIMER datetime2(7), @ENDTRANTIMER datetime2(7)

	--output Tables for new ID for Preorder
	DECLARE @PreOrderIds TABLE(OrigOrderId BIGINT, InsertedOrderId BIGINT,orderlogid BIGINT)

	-- [Inayat][28-Nov-2016]
	-- We need to update the foreign keys before merging, but we cannot update the parameters tables due to sql restrictions.
	-- Therefore, we need to copy data into temporary tables and then update its foreign keys.
	DECLARE @temp_Orders Stage.OrderType;
	DECLARE @temp_Items Stage.ItemType;
	DECLARE @temp_SalesTax Stage.SalesTaxType;
	DECLARE @temp_OrderLog Stage.OrderLogType;
	DECLARE @temp_CashResults Stage.CashResultType;
	DECLARE @temp_Transactions Stage.TransactionType;
	DECLARE @temp_Preorders Stage.PreOrdersType;
	DECLARE @temp_Preorderitems	Stage.PreOrderItemsType;
	DECLARE @temp_BonusPayments Stage.BonusPaymentType;

	SET @STARTTRANTIMER = GETUTCDATE()

	BEGIN TRANSACTION
	BEGIN TRY
	
		--Update the Local_Id of orderLog table before merging
		--------------------------------------------------------------------------
		ALTER TABLE OrdersLog DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM OrdersLog AS T
		INNER JOIN @orderLog AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE OrdersLog ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE CashResults DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM CashResults AS T
		INNER JOIN @cashResults AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE CashResults ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE Orders DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM Orders AS T
		INNER JOIN @orders AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE Orders ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE PreOrders DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM PreOrders AS T
		INNER JOIN @preorders AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE PreOrders ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE SalesTax DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM SalesTax AS T
		INNER JOIN @salesTax AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE SalesTax ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE PreOrderItems DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM PreOrderItems AS T
		INNER JOIN @preorderItems AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE PreOrderItems ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE Items DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM Items AS T
		INNER JOIN @items AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE Items ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE BonusPayments DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM BonusPayments AS T
		INNER JOIN @bonusPayments AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE BonusPayments ENABLE TRIGGER ALL;
		--------------------------------------------------------------
		ALTER TABLE Transactions DISABLE TRIGGER ALL;
		UPDATE T WITH (HOLDLOCk)
		SET T.Local_ID = S.Local_ID
		FROM Transactions AS T
		INNER JOIN @transactions AS S
		ON T.ID = S.Cloud_ID
		--WHERE T.Local_Id IS NULL
		ALTER TABLE Transactions ENABLE TRIGGER ALL;
	---------------------------------OrdersLog------------------------------------
	INSERT INTO @temp_OrderLog
		SELECT * FROM @orderLog
	
		SET @STARTTIMER = GETUTCDATE()

		-- Get those records whose any parent Id is missing into a temporary table.
		-- Any record in temp table which has neither null value in respective column nor it exists in parent table should go to queue
		SELECT *
		INTO #queueTemp_OrderLogs
		FROM @temp_OrderLog AS temp
		WHERE (ISNULL(temp.EmployeeId, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			Customers
			WHERE Customers.Local_Id = temp.EmployeeId
		))

		-- Add these incomplete records into queue table, we use merge to avoid duplicates.
		MERGE [queue].[OrdersLog] WITH (HOLDLOCK) AS T
		USING #queueTemp_OrderLogs AS S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.ClientID=S.ClientID,T.EmployeeId=S.EmployeeId,T.ChangedDate=S.ChangedDate,T.ChangedDateLocal=S.ChangedDateLocal,T.Notes=S.Notes, T.[IsPosted] = NULL, T.LastUpdatedUTC = S.LastUpdatedUTC
		WHEN NOT MATCHED THEN
		INSERT 
		([ClientID], [Id] ,[EmployeeId] ,[ChangedDate], [ChangedDateLocal] ,[Notes] ,[Local_ID] ,[LastUpdatedUTC], Cloud_ID)
		VALUES
		(S.[ClientID], S.[Id] ,S.[EmployeeId] ,S.[ChangedDate], S.[ChangedDateLocal] ,S.[Notes] ,S.[Id] ,S.[LastUpdatedUTC], S.Cloud_Id);
		
		-- Delete those incomplete records from temp table after moving them to queue table. 
		DELETE a FROM @temp_OrderLog AS a WHERE EXISTS( SELECT NULL FROM #queueTemp_OrderLogs AS b WHERE a.Id = b.Id )

		-- Now update the foreign keys and let the records merge with actual table.
		UPDATE temp
		SET temp.EmployeeId = parent.ID
		FROM @temp_OrderLog AS temp
		INNER JOIN Customers AS parent
		ON parent.Local_Id = temp.EmployeeId

		ALTER TABLE OrdersLog DISABLE TRIGGER ALL;
		
		MERGE OrdersLog WITH (HOLDLOCK) T
		USING @temp_OrderLog S
		ON T.Local_Id = S.ID
		
		WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		UPDATE SET T.ClientID=S.ClientID,T.Employee_Id=S.EmployeeId,T.ChangedDate=S.ChangedDate,T.ChangedDateLocal=S.ChangedDateLocal,T.Notes=S.Notes, T.LastUpdatedUTC = S.LastUpdatedUTC
		WHEN NOT MATCHED THEN
		
			INSERT 
				(ClientID, Employee_Id, ChangedDate, ChangedDateLocal, Notes, LastUpdatedUTC, UpdatedBySync, Local_ID, CloudIDSync) 
			VALUES
				(S.ClientID, S.EmployeeId, S.ChangedDate, S.ChangedDateLocal, S.Notes, S.LastUpdatedUTC, 1, S.ID, 0);
		
		ALTER TABLE OrdersLog ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()
		INSERT INTO Stage.MetricsLog select 'Save OrdersLog', @RowCount, @STARTTIMER, @ENDTIMER

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[OrdersLog] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_OrderLog)

		--------------------------------Cash Results----------------------------------------

		INSERT INTO @temp_CashResults
			SELECT * FROM @cashResults

		SET @STARTTIMER = GETUTCDATE()
		
		SELECT *
		INTO #queueTemp_CashResults
		FROM @temp_CashResults AS temp
		WHERE (ISNULL(temp.POSId, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			POS
			WHERE POS.Local_Id = temp.POSId
		))
		OR (ISNULL(temp.EmpCashierId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Customers
			WHERE Customers.Local_Id = temp.EmpCashierId
		))

		MERGE [queue].[CashResults] WITH (HOLDLOCK) T
		USING #queueTemp_CashResults S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[POSId] = S.[POSId], T.[EmpCashierId] = S.[EmpCashierId], T.[OpenDate] = S.[OpenDate],
		T.[OpenDateLocal] = S.[OpenDateLocal], T.[CloseDate] = S.[CloseDate], T.[CloseDateLocal] = S.[CloseDateLocal],
		T.[TotalCash] = S.[TotalCash], T.[OverShort] = S.[OverShort], T.[Additional] = S.[Additional], T.[PaidOuts] = S.[PaidOuts],
		T.[OpenAmount] = S.[OpenAmount], T.[CloseAmount] = S.[CloseAmount], T.[Sales] = S.[Sales], T.[Finished] = S.[Finished],
		T.[OpenBlob] = S.[OpenBlob], T.[CloseBlob] = S.[CloseBlob], T.[CashDrawerId] = S.[CashDrawerId], T.[PartitionId] = S.[PartitionId],
		T.[PartitionOffset] = S.[PartitionOffset], T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT
		([ClientID], [Id], [POSId], [EmpCashierId], [OpenDate], [OpenDateLocal], [CloseDate], [CloseDateLocal],
		[TotalCash], [OverShort], [Additional], [PaidOuts], [OpenAmount], [CloseAmount], [Sales], [Finished],
		[OpenBlob], [CloseBlob], [CashDrawerId], [PartitionId], [PartitionOffset], [Local_ID], [LastUpdatedUTC], Cloud_ID)
		VALUES
		(S.[ClientID], S.[Id], S.[POSId], S.[EmpCashierId], S.[OpenDate], S.[OpenDateLocal], S.[CloseDate], S.[CloseDateLocal],
		S.[TotalCash], S.[OverShort], S.[Additional], S.[PaidOuts], S.[OpenAmount], S.[CloseAmount], S.[Sales], S.[Finished],
		S.[OpenBlob], S.[CloseBlob], S.[CashDrawerId], S.[PartitionId], S.[PartitionOffset], S.[Id], S.[LastUpdatedUTC], S.Cloud_ID);

		DELETE a FROM @temp_CashResults AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_CashResults AS b WHERE b.Id = a.Id)

		UPDATE temp
		SET temp.POSId = parent.ID
		FROM @temp_CashResults AS temp
		INNER JOIN POS AS parent
		ON parent.Local_Id = temp.POSId

		UPDATE temp
		SET temp.EmpCashierId = parent.ID
		FROM @temp_CashResults AS temp
		INNER JOIN Customers AS parent
		ON parent.Local_Id = temp.EmpCashierId

		ALTER TABLE CashResults DISABLE TRIGGER ALL

		MERGE CashResults WITH (HOLDLOCK) T
		USING @temp_CashResults S
			  
		ON T.Local_Id = S.ID
		   
		WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		UPDATE SET
				 T.ClientID=S.ClientID,T.POS_Id=S.POSId,T.Emp_Cashier_Id=S.EmpCashierId,T.OpenDate=S.OpenDate, 
				 T.OpenDateLocal=S.OpenDateLocal,T.CloseDate=S.CloseDate,T.CloseDateLocal=S.CloseDateLocal, 
				 T.TotalCash=S.TotalCash,T.OverShort=S.OverShort,T.Additional=S.Additional,T.PaidOuts=S.PaidOuts,T.OpenAmount=S.OpenAmount, T.CloseAmount=S.CloseAmount,T.Sales=S.Sales,T.Finished=S.Finished,
				 T.OpenBlob=S.OpenBlob,T.CloseBlob=S.CloseBlob,T.CashDrawer_Id=S.CashDrawerId,T.PartitionId= S.PartitionId,T.PartitionOffset=S.PartitionOffset
				 
		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, POS_Id, Emp_Cashier_Id, OpenDate, OpenDateLocal, CloseDate, CloseDateLocal, 
				 TotalCash, OverShort, Additional, PaidOuts, OpenAmount, CloseAmount, Sales, Finished,
				 OpenBlob, CloseBlob, CashDrawer_Id, PartitionId, PartitionOffset, LastUpdatedUTC, UpdatedBySync,
				 Local_ID, CloudIDSync) 
			VALUES
				(S.ClientID, S.POSId, S.EmpCashierId, S.OpenDate, S.OpenDateLocal, S.CloseDate, S.CloseDateLocal, 
				 S.TotalCash, S.OverShort, S.Additional, S.PaidOuts, S.OpenAmount, S.CloseAmount, S.Sales, S.Finished,
				 S.OpenBlob, S.CloseBlob, S.CashDrawerId, S.PartitionId, S.PartitionOffset, S.LastUpdatedUTC,
				 1, S.ID, 0)
		OUTPUT
			0, inserted.Id INTO @CashResultIds;

		ALTER TABLE CashResults ENABLE TRIGGER ALL

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()
		INSERT INTO Stage.MetricsLog select 'Save CashResults', @RowCount, @STARTTIMER, @ENDTIMER

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[CashResults] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_CashResults)

		----------------------------------Orders-----------------------------------------
		
		INSERT INTO @temp_Orders
			SELECT * FROM @orders

		SET @STARTTIMER = GETUTCDATE()
		SELECT @orderCount = COUNT(*) FROM @temp_Orders

		SELECT *
		INTO #queueTemp_Orders
		FROM @temp_Orders AS temp
		WHERE (ISNULL(temp.CustomerPrSchoolId, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			Schools
			WHERE Schools.Local_Id = temp.CustomerPrSchoolId
		))
		OR (ISNULL(temp.POSId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			POS
			WHERE POS.Local_Id = temp.POSId
		))
		OR (ISNULL(temp.SchoolId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Schools
			WHERE Schools.Local_Id = temp.SchoolId
		))
		OR (ISNULL(temp.EmpCashierId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Customers
			WHERE Customers.Local_Id = temp.EmpCashierId
		))
		OR (ISNULL(temp.CustomerId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Customers
			WHERE Customers.Local_Id = temp.CustomerId
		))
		OR (ISNULL(temp.OrdersLogId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			OrdersLog
			WHERE OrdersLog.Local_Id = temp.OrdersLogId
		))

		MERGE [queue].[Orders] WITH (HOLDLOCK) T
		USING #queueTemp_Orders S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[CustomerPrSchoolId] = S.[CustomerPrSchoolId], T.[POSId] = S.[POSId],
		T.[SchoolId] = S.[SchoolId], T.[EmpCashierId] = S.[EmpCashierId], T.[CustomerId] = S.[CustomerId],
		T.[OrdersLogId] = S.[OrdersLogId], T.[GDate] = S.[GDate], T.[OrderDate] = S.[OrderDate], T.[OrderDateLocal] = S.[OrderDateLocal],
		T.[LunchType] = S.[LunchType], T.[ADebit] = S.[ADebit], T.[ACredit] = S.[ACredit], T.[BCredit] = S.[BCredit],
		T.[MDebit] = S.[MDebit], T.[MCredit] = S.[MCredit], T.[CheckNumber] = S.[CheckNumber], T.[OverRide] = S.[OverRide],
		T.[isVoid] = S.[isVoid], T.[TransType] = S.[TransType], T.[CreditAuthId] = S.[CreditAuthId], T.[PartitionId] = S.[PartitionId],
		T.[PartitionOffset] = S.[PartitionOffset], T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT ([ClientID], [Id], [CustomerPrSchoolId], [POSId], [SchoolId], [EmpCashierId], [CustomerId], [OrdersLogId],
		[GDate], [OrderDate], [OrderDateLocal], [LunchType], [ADebit], [ACredit], [BCredit], [MDebit], [MCredit],
		[CheckNumber], [OverRide], [isVoid], [TransType], [CreditAuthId], [PartitionId], [PartitionOffset],
        [Local_Id], [LastUpdatedUTC], Cloud_ID)
		VALUES (
		S.[ClientID], S.[Id], S.[CustomerPrSchoolId], S.[POSId], S.[SchoolId], S.[EmpCashierId], S.[CustomerId], S.[OrdersLogId],
		S.[GDate], S.[OrderDate], S.[OrderDateLocal], S.[LunchType], S.[ADebit], S.[ACredit], S.[BCredit], S.[MDebit], S.[MCredit],
		S.[CheckNumber], S.[OverRide], S.[isVoid], S.[TransType], S.[CreditAuthId], S.[PartitionId], S.[PartitionOffset],
        S.[Id], S.[LastUpdatedUTC], S.Cloud_ID);

		DELETE a FROM @temp_Orders AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_Orders AS b WHERE b.Id = a.Id)

		UPDATE temp
		SET temp.CustomerPrSchoolId = parent.ID
		FROM @temp_Orders AS temp
		INNER JOIN Schools AS parent
		ON parent.Local_Id = temp.CustomerPrSchoolId

		UPDATE temp
		SET temp.POSId = parent.ID
		FROM @temp_Orders AS temp
		INNER JOIN POS AS parent
		ON parent.Local_Id = temp.POSId

		UPDATE temp
		SET temp.SchoolId = parent.ID
		FROM @temp_Orders AS temp
		INNER JOIN Schools AS parent
		ON parent.Local_Id = temp.SchoolId

		UPDATE temp
		SET temp.EmpCashierId = parent.ID
		FROM @temp_Orders AS temp
		INNER JOIN Customers AS parent
		ON parent.Local_Id = temp.EmpCashierId

		UPDATE temp
		SET temp.CustomerId = parent.ID
		FROM @temp_Orders AS temp
		INNER JOIN Customers AS parent
		ON parent.Local_Id = temp.CustomerId

		UPDATE temp
		SET temp.OrdersLogId = parent.ID
		FROM @temp_Orders AS temp
		INNER JOIN OrdersLog AS parent
		ON parent.Local_Id = temp.OrdersLogId
		
		---------------- Temp table to store the output result of Orders merging------------------
		IF OBJECT_ID('tempdb..#TempResultTable1') IS NOT NULL
		DROP TABLE #TempResultTable1
		CREATE TABLE #TempResultTable1 ([Action] nvarchar(10), [ClientID] [bigint] NOT NULL,
		[Id] [bigint] NOT NULL, [Customer_Pr_School_Id] [bigint] NULL, [POS_Id] [bigint] NOT NULL, [School_Id] [bigint] NULL,
		[Emp_Cashier_Id] [bigint] NULL, [Customer_Id] [bigint] NOT NULL, [OrdersLog_Id] [bigint] NULL, [GDate] [smalldatetime] NOT NULL,
		[OrderDate] [datetime2](7) NOT NULL, [OrderDateLocal] [datetime2](7) NULL, [LunchType] [int] NULL, [ADebit] [float] NULL,
		[MDebit] [float] NULL, [ACredit] [float] NULL, [BCredit] [float] NULL, [MCredit] [float] NULL, [CheckNumber] [int] NULL,
		[OverRide] [bit] NULL, [isVoid] [bit] NULL, [TransType] [int] NULL, [CreditAuth_Id] [bigint] NULL, [PartitionId] [varchar](32) NULL,
		[PartitionOffset] [varchar](32) NULL, [LastUpdatedUTC] [datetime2](7) NULL, [UpdatedBySync] [bit] NULL, [Local_ID] [int] NULL,
		[CloudIDSync] [bit] NOT NULL,

		[DEL_ClientID] [bigint] NULL,
		[DEL_Id] [bigint] NULL, [DEL_Customer_Pr_School_Id] [bigint] NULL, [DEL_POS_Id] [bigint] NULL, [DEL_School_Id] [bigint] NULL,
		[DEL_Emp_Cashier_Id] [bigint] NULL, [DEL_Customer_Id] [bigint] NULL, [DEL_OrdersLog_Id] [bigint] NULL, [DEL_GDate] [smalldatetime] NULL,
		[DEL_OrderDate] [datetime2](7) NULL, [DEL_OrderDateLocal] [datetime2](7) NULL, [DEL_LunchType] [int] NULL, [DEL_ADebit] [float] NULL,
		[DEL_MDebit] [float] NULL, [DEL_ACredit] [float] NULL, [DEL_BCredit] [float] NULL, [DEL_MCredit] [float] NULL, [DEL_CheckNumber] [int] NULL,
		[DEL_OverRide] [bit] NULL, [DEL_isVoid] [bit] NULL, [DEL_TransType] [int] NULL, [DEL_CreditAuth_Id] [bigint] NULL, [DEL_PartitionId] [varchar](32) NULL,
		[DEL_PartitionOffset] [varchar](32) NULL, [DEL_LastUpdatedUTC] [datetime2](7) NULL, [DEL_UpdatedBySync] [bit] NULL, [DEL_Local_ID] [int] NULL,
		[DEL_CloudIDSync] [bit] NULL)
		-------------------------------------------------------------------------
		
		ALTER TABLE Orders DISABLE TRIGGER ALL;

		-- Merge @orders into the Main Database Table
		MERGE Orders WITH (HOLDLOCK) T
		USING  @temp_Orders S
		ON T.Local_Id = S.ID
		   
		   WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		    UPDATE SET T.ClientID=S.ClientID, T.Customer_Pr_School_Id=S.CustomerPrSchoolId, T.POS_Id=S.POSId, T.School_Id=S.SchoolId, 
				T.Emp_Cashier_Id=S.EmpCashierId, T.Customer_Id=S.CustomerId, T.OrdersLog_Id=S.OrdersLogId, T.OrderDate=S.OrderDate, 
				T.OrderDateLocal=S.OrderDateLocal,T.LunchType=S.LunchType, T.MDebit=S.MDebit, T.MCredit=S.MCredit, T.CheckNumber=S.CheckNumber, 
				T.OverRide=S.OverRide, T.isVoid=S.isVoid, 
				T.ADebit=S.ADebit, T.ACredit=S.ACredit, T.TransType=S.TransType,T.BCredit=S.BCredit, 
				T.CreditAuth_Id=S.CreditAuthId, T.PartitionId=S.PartitionId, T.PartitionOffset=S.PartitionOffset
		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, Customer_Pr_School_Id, POS_Id, School_Id, Emp_Cashier_Id, Customer_Id, OrdersLog_Id, OrderDate, OrderDateLocal, 
				LunchType, MDebit, MCredit, CheckNumber, OverRide, isVoid, GDate, ADebit, ACredit, TransType, 
				BCredit, CreditAuth_Id, PartitionId, PartitionOffset, LastUpdatedUTC, UpdatedBySync,
				local_ID, CloudIDSync)
			VALUES
				(S.ClientID, S.CustomerPrSchoolId, S.POSId, S.SchoolId, S.EmpCashierId, S.CustomerId, S.OrdersLogId, S.OrderDate, S.OrderDateLocal,
				S.LunchType, S.MDebit, S.MCredit, S.CheckNumber, S.OverRide, S.isVoid, 
				CASE WHEN S.GDate is null then (cast(S.OrderDate as date)) else S.GDate end, S.ADebit, S.ACredit, S.TransType,
				S.BCredit, S.CreditAuthId, S.PartitionId, S.PartitionOffset, S.LastUpdatedUTC, 1,  S.ID, 0)
		OUTPUT $action as [Action], INSERTED.[ClientID], INSERTED.[Id], INSERTED.[Customer_Pr_School_Id], INSERTED.[POS_Id], INSERTED.[School_Id], INSERTED.[Emp_Cashier_Id], INSERTED.[Customer_Id], INSERTED.[OrdersLog_Id], INSERTED.[GDate], INSERTED.[OrderDate], INSERTED.[OrderDateLocal], INSERTED.[LunchType], INSERTED.[ADebit], INSERTED.[MDebit], INSERTED.[ACredit], INSERTED.[BCredit], INSERTED.[MCredit], INSERTED.[CheckNumber], INSERTED.[OverRide], INSERTED.[isVoid], INSERTED.[TransType], INSERTED.[CreditAuth_Id], INSERTED.[PartitionId], INSERTED.[PartitionOffset], INSERTED.[LastUpdatedUTC], INSERTED.[UpdatedBySync], INSERTED.[Local_ID], INSERTED.[CloudIDSync],
				DELETED.[ClientID], DELETED.[Id], DELETED.[Customer_Pr_School_Id], DELETED.[POS_Id], DELETED.[School_Id], DELETED.[Emp_Cashier_Id], DELETED.[Customer_Id], DELETED.[OrdersLog_Id], DELETED.[GDate], DELETED.[OrderDate], DELETED.[OrderDateLocal], DELETED.[LunchType], DELETED.[ADebit], DELETED.[MDebit], DELETED.[ACredit], DELETED.[BCredit], DELETED.[MCredit], DELETED.[CheckNumber], DELETED.[OverRide], DELETED.[isVoid], DELETED.[TransType], DELETED.[CreditAuth_Id], DELETED.[PartitionId], DELETED.[PartitionOffset], DELETED.[LastUpdatedUTC], DELETED.[UpdatedBySync], DELETED.[Local_ID], DELETED.[CloudIDSync]
				INTO #TempResultTable1;
		
		ALTER TABLE Orders ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Save Orders', @RowCount, @STARTTIMER, @ENDTIMER
		EXEC UpdateAccountInfoOnOrdersIU @clientID
		
		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[Orders] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_Orders)
		----------------------------------PreOrders----------------------------------------------------
		
		INSERT INTO @temp_Preorders
			SELECT * FROM @preorders

		SELECT *
		INTO #queueTemp_Preorders
		FROM @temp_Preorders AS temp
		WHERE (ISNULL(temp.Customer_Id, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			Customers
			WHERE Customers.Local_Id = temp.Customer_Id
		))
		OR (ISNULL(temp.OrdersLog_Id, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			OrdersLog
			WHERE OrdersLog.Local_Id = temp.OrdersLog_Id
		))

		MERGE [queue].[PreOrders] WITH (HOLDLOCK) T
		USING #queueTemp_Preorders S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[PreSaleTrans_Id] = S.[PreSaleTrans_Id], T.[Customer_Id] = S.[Customer_Id],
		T.[OrdersLog_Id] = S.[OrdersLog_Id], T.[PurchasedDate] = S.[PurchasedDate], T.[PurchasedDateLocal] = S.[PurchasedDateLocal],
		T.[TransferDate] = S.[TransferDate], T.[TransferDateLocal] = S.[TransferDateLocal], T.[LunchType] = S.[LunchType],
		T.[MCredit] = S.[MCredit], T.[ACredit] = S.[ACredit], T.[BCredit] = S.[BCredit], T.[TotalSale] = S.[TotalSale],
		T.[isVoid] = S.[isVoid], T.[ItemCount] = S.[ItemCount], T.[Transtype] = S.[Transtype], T.[PartitionId] = S.[PartitionId],
		T.[PartitionOffset] = S.[PartitionOffset], T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT ([ClientID], [Id], [PreSaleTrans_Id], [Customer_Id], [OrdersLog_Id], [PurchasedDate], [PurchasedDateLocal],
		[TransferDate], [TransferDateLocal], [LunchType], [MCredit], [ACredit], [BCredit], [TotalSale], [isVoid],
        [ItemCount], [Transtype], [PartitionId], [PartitionOffset], [LastUpdatedUTC], [UpdatedBySync], [Local_ID],
		[CloudIDSync], Cloud_ID)
		VALUES (S.[ClientID], S.[Id], S.[PreSaleTrans_Id], S.[Customer_Id], S.[OrdersLog_Id], S.[PurchasedDate], S.[PurchasedDateLocal],
		S.[TransferDate], S.[TransferDateLocal], S.[LunchType], S.[MCredit], S.[ACredit], S.[BCredit], S.[TotalSale], S.[isVoid],
        S.[ItemCount], S.[Transtype], S.[PartitionId], S.[PartitionOffset], S.[LastUpdatedUTC], S.[UpdatedBySync], S.[ID],
		S.[CloudIDSync], S.Cloud_ID);

		DELETE a FROM @temp_Preorders AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_Preorders AS b WHERE b.Id = a.Id)

		SET @STARTTIMER = GETUTCDATE()
		SELECT @orderCount = COUNT(*) FROM @temp_Preorders

		UPDATE temp
		SET temp.Customer_Id = parent.ID
		FROM @temp_Preorders AS temp
		INNER JOIN Customers AS parent
		ON parent.Local_Id = temp.Customer_Id

		UPDATE temp
		SET temp.OrdersLog_Id = parent.ID
		FROM @temp_Preorders AS temp
		INNER JOIN OrdersLog AS parent
		ON parent.Local_Id = temp.OrdersLog_Id

		---------------- Temp table to store the output result of Orders merging------------------
		IF OBJECT_ID('tempdb..#TempResultTable2') IS NOT NULL
		DROP TABLE #TempResultTable2
		CREATE TABLE #TempResultTable2 ([Action] nvarchar(10),
	     [ClientID] [bigint] NOT NULL, [ID] [bigint] NOT NULL, [PreSaleTrans_Id] [int] NOT NULL, [Customer_Id] [bigint] NOT NULL,
		 [OrdersLog_Id] [bigint] NULL, [PurchasedDate] [datetime2](7) NOT NULL, [PurchasedDateLocal] [datetime2](7) NOT NULL,
		 [TransferDate] [datetime2](7) NOT NULL, [TransferDateLocal] [datetime2](7) NOT NULL, [LunchType] [int] NOT NULL,
		 [MCredit] [float] NOT NULL, [ACredit] [float] NOT NULL, [BCredit] [float] NOT NULL, [TotalSale] [float] NOT NULL,
		 [isVoid] [bit] NOT NULL, [ItemCount] [int] NOT NULL, [Transtype] [int] NULL, [PartitionId] [varchar](32) NULL,
	     [PartitionOffset] [varchar](32) NULL, [LastUpdatedUTC] [datetime2](7) NULL, [UpdatedBySync] [bit] NULL,
		 [Local_ID] [int] NULL, [CloudIDSync] [bit] NOT NULL,

		 [DEL_ClientID] [bigint] NULL, [DEL_ID] [bigint] NULL, [DEL_PreSaleTrans_Id] [int] NULL, [DEL_Customer_Id] [bigint] NULL,
		 [DEL_OrdersLog_Id] [bigint] NULL, [DEL_PurchasedDate] [datetime2](7) NULL, [DEL_PurchasedDateLocal] [datetime2](7) NULL,
		 [DEL_TransferDate] [datetime2](7) NULL, [DEL_TransferDateLocal] [datetime2](7) NULL, [DEL_LunchType] [int] NULL,
		 [DEL_MCredit] [float] NULL, [DEL_ACredit] [float] NULL, [DEL_BCredit] [float] NULL, [DEL_TotalSale] [float] NULL,
		 [DEL_isVoid] [bit] NULL, [DEL_ItemCount] [int] NULL, [DEL_Transtype] [int] NULL, [DEL_PartitionId] [varchar](32) NULL,
	     [DEL_PartitionOffset] [varchar](32) NULL, [DEL_LastUpdatedUTC] [datetime2](7) NULL, [DEL_UpdatedBySync] [bit] NULL,
		 [DEL_Local_ID] [int] NULL, [DEL_CloudIDSync] [bit] NULL)
		------------------------------------------------------------------------------------------

		ALTER TABLE PreOrders DISABLE TRIGGER ALL;

		-- Merge @preorders into the Main Database Table
		MERGE PreOrders WITH (HOLDLOCK) T
		USING @temp_Preorders S
		ON T.Local_ID = S.ID
	    WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
	    UPDATE SET   
			  T.ClientID=S.ClientID
			 ,T.PreSaleTrans_Id=S.PreSaleTrans_Id
			 ,T.Customer_Id=S.Customer_Id
			 ,T.OrdersLog_Id=S.OrdersLog_Id
			 ,T.PurchasedDate=S.PurchasedDate
			 ,T.PurchasedDateLocal=S.PurchasedDateLocal
			 ,T.TransferDate=S.TransferDate
			 ,T.TransferDateLocal=S.TransferDateLocal
			 ,T.LunchType=S.LunchType
			 ,T.MCredit=S.MCredit
			 ,T.ACredit=S.ACredit
			 ,T.BCredit=S.BCredit
			 ,T.TotalSale=S.TotalSale
			 ,T.isVoid=S.isVoid
			 ,T.ItemCount=S.ItemCount
			 ,T.Transtype=S.Transtype
		WHEN NOT MATCHED THEN
			INSERT 
			(
			ClientID ,PreSaleTrans_Id ,Customer_Id ,OrdersLog_Id ,PurchasedDate ,
			PurchasedDateLocal ,TransferDate ,TransferDateLocal , LunchType ,
			MCredit , ACredit , BCredit , TotalSale , isVoid , ItemCount ,
			Transtype, LastUpdatedUTC, UpdatedBySync, Local_ID, CloudIDSync
			)
		    VALUES
			(
			S.ClientID,S.PreSaleTrans_Id,S.Customer_Id,S.OrdersLog_Id,S.PurchasedDate
			,S.PurchasedDateLocal,S.TransferDate,S.TransferDateLocal,S.LunchType
			,S.MCredit,S.ACredit,S.BCredit,S.TotalSale ,S.isVoid,S.ItemCount
			,S.Transtype, S.LastUpdatedUTC, 1, S.ID, 0)
		OUTPUT $action as [Action], INSERTED.[ClientID], INSERTED.[ID], INSERTED.[PreSaleTrans_Id], INSERTED.[Customer_Id], INSERTED.[OrdersLog_Id], INSERTED.[PurchasedDate], INSERTED.[PurchasedDateLocal], INSERTED.[TransferDate], INSERTED.[TransferDateLocal], INSERTED.[LunchType], INSERTED.[MCredit], INSERTED.[ACredit], INSERTED.[BCredit], INSERTED.[TotalSale], INSERTED.[isVoid], INSERTED.[ItemCount], INSERTED.[Transtype], INSERTED.[PartitionId], INSERTED.[PartitionOffset], INSERTED.[LastUpdatedUTC], INSERTED.[UpdatedBySync], INSERTED.[Local_ID], INSERTED.[CloudIDSync],
			 DELETED.[ClientID], DELETED.[ID], DELETED.[PreSaleTrans_Id], DELETED.[Customer_Id], DELETED.[OrdersLog_Id], DELETED.[PurchasedDate], DELETED.[PurchasedDateLocal], DELETED.[TransferDate], DELETED.[TransferDateLocal], DELETED.[LunchType], DELETED.[MCredit], DELETED.[ACredit], DELETED.[BCredit], DELETED.[TotalSale], DELETED.[isVoid], DELETED.[ItemCount], DELETED.[Transtype], DELETED.[PartitionId], DELETED.[PartitionOffset], DELETED.[LastUpdatedUTC], DELETED.[UpdatedBySync], DELETED.[Local_ID], DELETED.[CloudIDSync]
			 INTO #TempResultTable2;

		ALTER TABLE PreOrders ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Save PreOrders', @RowCount, @STARTTIMER, @ENDTIMER
		EXEC UpdateAccountInfoOnPreordersIU @clientID

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[PreOrders] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_Preorders)
		---------------------------------------------SalesTax----------------------------------------------
		
		INSERT INTO @temp_SalesTax
			SELECT * FROM @salesTax

		SELECT *
		INTO #queueTemp_SalesTax
		FROM @temp_SalesTax AS temp
		WHERE (ISNULL(temp.TaxEntityId, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			TaxEntities
			WHERE TaxEntities.Local_Id = temp.TaxEntityId
		))
		OR (ISNULL(temp.OrderId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Orders
			WHERE Orders.Local_Id = temp.OrderId
		))

		MERGE [queue].[SalesTax] WITH (HOLDLOCK) T
		USING #queueTemp_SalesTax S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[OrderId] = S.[OrderId], T.[TaxEntityId] = S.[TaxEntityId], T.[TaxEntityName] = S.[TaxEntityName],
		T.[TaxRate] = S.[TaxRate], T.[SalesTax] = S.[SalesTax], T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT ([ClientID], [Id], [OrderId], [TaxEntityId], [TaxEntityName], [TaxRate], [SalesTax], [Local_ID], [LastUpdatedUTC], Cloud_ID)
		VALUES (S.[ClientID], S.[Id], S.[OrderId], S.[TaxEntityId], S.[TaxEntityName], S.[TaxRate], S.[SalesTax], S.[ID], S.[LastUpdatedUTC], S.Cloud_ID);

		DELETE a FROM @temp_SalesTax AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_SalesTax AS b WHERE b.Id = a.Id)

		SET @STARTTIMER = GETUTCDATE()

		UPDATE temp
		SET temp.TaxEntityId = parent.ID
		FROM @temp_SalesTax AS temp
		INNER JOIN TaxEntities AS parent
		ON parent.Local_Id = temp.TaxEntityId

		UPDATE temp
		SET temp.OrderId = parent.ID
		FROM @temp_SalesTax AS temp
		INNER JOIN Orders AS parent
		ON parent.Local_Id = temp.OrderId

		ALTER TABLE SalesTax DISABLE TRIGGER ALL;

		MERGE SalesTax WITH (HOLDLOCK) AS T
		USING @temp_SalesTax S
		ON T.Local_Id = S.ID

		WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		UPDATE SET T.ClientID=S.ClientID, T.Order_Id=S.OrderId,T.TaxEntity_Id=S.TaxEntityId, 
		T.TaxEntityName=S.TaxEntityName, T.TaxRate=S.TaxRate,T.SalesTax=S.SalesTax

		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, Order_Id, TaxEntity_Id, TaxEntityName, TaxRate, SalesTax, LastUpdatedUTC, UpdatedBySync, Local_ID, CloudIDSync) 
			VALUES
				(S.ClientID, S.OrderId, S.TaxEntityId, S.TaxEntityName, S.TaxRate, S.SalesTax, S.LastUpdatedUTC, 1, S.ID, 0);

		ALTER TABLE SalesTax ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()
		INSERT INTO Stage.MetricsLog select 'Save SalesTax', @RowCount, @STARTTIMER, @ENDTIMER

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[SalesTax] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_SalesTax)

		----------------------------------------PreorderItems--------------------------------------------
		
		INSERT INTO @temp_Preorderitems
			SELECT * FROM @preorderItems

		SELECT *
		INTO #queueTemp_Preorderitems
		FROM @temp_Preorderitems AS temp
		WHERE (ISNULL(temp.PreOrder_Id, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			PreOrders
			WHERE PreOrders.Local_Id = temp.PreOrder_Id
		))
		OR (ISNULL(temp.Menu_Id, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Menu
			WHERE Menu.Local_Id = temp.Menu_Id
		))

		MERGE [queue].[PreOrderItems] WITH (HOLDLOCK) AS T
		USING #queueTemp_Preorderitems S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[PreSale_Id] = S.[PreSale_Id], T.[ServingDate] = S.[ServingDate],
		T.[PickupDate] = S.[PickupDate], T.[Disposition] = S.[Disposition], T.[PreOrder_Id] = S.[PreOrder_Id],
		T.[Menu_Id] = S.[Menu_Id], T.[Qty] = S.[Qty], T.[FullPrice] = S.[FullPrice], T.[PaidPrice] = S.[PaidPrice],
		T.[TaxPrice] = S.[TaxPrice], T.[isVoid] = S.[isVoid], T.[SoldType] = S.[SoldType], T.[PickupCount] = S.[PickupCount],
		T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT ([ClientID], [Id], [PreSale_Id], [ServingDate], [PickupDate], [Disposition], [PreOrder_Id],
		[Menu_Id], [Qty], [FullPrice], [PaidPrice], [TaxPrice], [isVoid], [SoldType], [PickupCount], [LastUpdatedUTC],
		[CloudIDSync], [UpdatedBySync], [Local_ID], Cloud_ID)
		VALUES(S.[ClientID], S.[Id], S.[PreSale_Id], S.[ServingDate], S.[PickupDate], S.[Disposition], S.[PreOrder_Id],
		S.[Menu_Id], S.[Qty], S.[FullPrice], S.[PaidPrice], S.[TaxPrice], S.[isVoid], S.[SoldType], S.[PickupCount], S.[LastUpdatedUTC],
		S.[CloudIDSync], S.[UpdatedBySync], S.[ID], S.Cloud_ID);

		DELETE a FROM @temp_Preorderitems AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_Preorderitems AS b WHERE b.Id = a.Id)

		UPDATE temp
		SET temp.PreOrder_Id = parent.ID
		FROM @temp_Preorderitems AS temp
		INNER JOIN PreOrders AS parent
		ON parent.Local_Id = temp.PreOrder_Id

		UPDATE temp
		SET temp.Menu_Id = parent.ID
		FROM @temp_Preorderitems AS temp
		INNER JOIN Menu AS parent
		ON parent.Local_Id = temp.Menu_Id

		SET @STARTTIMER = GETUTCDATE()
		SELECT @itemCount = COUNT(*) FROM @temp_Preorderitems

		ALTER TABLE PreOrderItems DISABLE TRIGGER ALL;

		-- Insert @preorderItems into the Main Database Table
		MERGE dbo.PreOrderItems WITH (HOLDLOCK) AS T
		USING @temp_Preorderitems S
		ON T.Local_Id = S.ID
		
		WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		UPDATE SET T.ClientID=S.ClientID,T.PreSale_Id=S.PreSale_Id,
		           T.ServingDate=S.ServingDate,T.PickupDate=S.PickupDate,T.Disposition=S.Disposition,
				   T.PreOrder_Id=S.PreOrder_Id,T.Menu_Id=S.Menu_Id, T.FullPrice=S.FullPrice, T.PaidPrice=S.PaidPrice,
				   T.TaxPrice=S.TaxPrice,T.isVoid=S.isVoid,T.SoldType=S.SoldType,T.PickupCount=S.PickupCount

		WHEN NOT MATCHED THEN
			INSERT 
			(
			ClientID ,PreSale_Id , ServingDate , PickupDate , Disposition , PreOrder_Id , Menu_Id ,
			Qty , FullPrice , PaidPrice ,TaxPrice , isVoid , SoldType , PickupCount,
			LastUpdatedUTC, UpdatedBySync, Local_ID, CloudIDSync
			)
			VALUES
			(
			S.ClientID ,S.PreSale_Id , S.ServingDate , S.PickupDate , S.Disposition ,  S.PreOrder_Id , S.Menu_Id ,
			S.Qty , S.FullPrice , S.PaidPrice ,S.TaxPrice , S.isVoid , S.SoldType , S.PickupCount,
			S.LastUpdatedUTC, 1, S.ID, 0 );

		ALTER TABLE PreOrderItems ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Save PreOrderItems', @RowCount, @STARTTIMER, @ENDTIMER

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[PreOrderItems] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_Preorderitems)

		---------------------------------------Items----------------------------------------------------------
		
		INSERT INTO @temp_Items
			SELECT * FROM @items

		SELECT *
		INTO #queueTemp_Items
		FROM @temp_Items AS temp
		WHERE (ISNULL(temp.OrderId, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			Orders
			WHERE Orders.Local_Id = temp.OrderId
		))
		OR (ISNULL(temp.MenuId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Menu
			WHERE Menu.Local_Id = temp.MenuId
		))
		OR (ISNULL(temp.PreOrderItemId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			PreOrderItems
			WHERE PreOrderItems.Local_Id = temp.PreOrderItemId
		))

		MERGE [queue].[Items] WITH (HOLDLOCK) AS T
		USING #queueTemp_Items S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[OrderId] = S.[OrderId], T.[MenuId] = S.[MenuId], T.[Qty] = S.[Qty],
		T.[FullPrice] = S.[FullPrice], T.[PaidPrice] = S.[PaidPrice], T.[TaxPrice] = S.[TaxPrice], T.[isVoid] = S.[isVoid],
		T.[SoldType] = S.[SoldType], T.[PreOrderItemId] = S.[PreOrderItemId], T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT ([ClientID], [Id], [OrderId], [MenuId], [Qty], [FullPrice], [PaidPrice], [TaxPrice], [isVoid], [SoldType],
		[PreOrderItemId], [Local_ID], [LastUpdatedUTC], Cloud_ID)
		VALUES (S.[ClientID], S.[Id], S.[OrderId], S.[MenuId], S.[Qty], S.[FullPrice], S.[PaidPrice], S.[TaxPrice], S.[isVoid],
		S.[SoldType], S.[PreOrderItemId], S.[ID], S.[LastUpdatedUTC], S.Cloud_ID);

		DELETE a FROM @temp_Items AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_Items AS b WHERE b.Id = a.Id)

		UPDATE temp
		SET temp.OrderId = parent.ID
		FROM @temp_Items AS temp
		INNER JOIN Orders AS parent
		ON parent.Local_Id = temp.OrderId

		UPDATE temp
		SET temp.MenuId = parent.ID
		FROM @temp_Items AS temp
		INNER JOIN Menu AS parent
		ON parent.Local_Id = temp.MenuId

		UPDATE temp
		SET temp.PreOrderItemId = parent.ID
		FROM @temp_Items AS temp
		INNER JOIN PreOrderItems AS parent
		ON parent.Local_Id = temp.PreOrderItemId

		SET @STARTTIMER = GETUTCDATE()
		SELECT @itemCount = COUNT(*) FROM @temp_Items

		ALTER TABLE Items DISABLE TRIGGER ALL;

		-- Insert @items into the Main Database Table
		MERGE Items WITH (HOLDLOCK) AS T
		USING @temp_Items S
		ON T.Local_Id = S.ID
		
		WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		UPDATE SET T.ClientID=S.ClientID,T.Order_Id=S.OrderId, T.Menu_Id=S.MenuId, T.Qty=S.Qty,T.FullPrice=S.FullPrice,
		 T.PaidPrice=S.PaidPrice, T.TaxPrice=S.TaxPrice, T.isVoid=S.isVoid, T.SoldType=S.SoldType, T.PreOrderItem_Id=S.PreOrderItemId

		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, Order_Id, Menu_Id, Qty, FullPrice, PaidPrice, TaxPrice, isVoid, SoldType, PreOrderItem_Id,
				 LastUpdatedUTC, UpdatedBySync, Local_ID, CloudIDSync) 
			VALUES
				(S.ClientID, S.OrderId, S.MenuId, S.Qty, S.FullPrice, S.PaidPrice, S.TaxPrice, S.isVoid, S.SoldType, S.PreOrderItemId,
				S.LastUpdatedUTC, 1, S.ID, 0);

		ALTER TABLE Items ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Save Items', @RowCount, @STARTTIMER, @ENDTIMER

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[Items] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_Items)

		-------------------------------------Bonus Payments---------------------------------------------------

		INSERT INTO @temp_BonusPayments
			SELECT * FROM @bonusPayments

		SELECT *
		INTO #queueTemp_BonusPayments
		FROM @temp_BonusPayments AS temp
		WHERE (ISNULL(temp.Customer_Id, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			Customers
			WHERE Customers.Local_Id = temp.Customer_Id
		))
		OR (ISNULL(temp.Order_Id, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			Orders
			WHERE Orders.Local_Id = temp.Order_Id
		))

		MERGE [queue].[BonusPayments] WITH (HOLDLOCK) AS T
		USING #queueTemp_BonusPayments S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[Customer_Id] = S.[Customer_Id], T.[BonusDate] = S.[BonusDate],
		T.[BonusDateLocal] = S.[BonusDateLocal], T.[MealPlan] = S.[MealPlan], T.[BonusPaid] = S.[BonusPaid], T.[PriorBal] = S.[PriorBal],
		T.[Order_Id] = S.[Order_Id], T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT ([ClientID], [Id], [Customer_Id], [BonusDate], [BonusDateLocal], [MealPlan], [BonusPaid], [PriorBal],
		[Order_Id], [PartitionId], [PartitionOffset], [LastUpdatedUTC], [Local_ID], Cloud_ID)
		VALUES (S.[ClientID], S.[Id], S.[Customer_Id], S.[BonusDate], S.[BonusDateLocal], S.[MealPlan], S.[BonusPaid], S.[PriorBal],
		S.[Order_Id], S.[PartitionId], S.[PartitionOffset], S.[LastUpdatedUTC], S.[ID], S.Cloud_ID);

		DELETE a FROM @temp_BonusPayments AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_BonusPayments AS b WHERE b.Id = a.Id)

		UPDATE temp
		SET temp.Customer_Id = parent.ID
		FROM @temp_BonusPayments AS temp
		INNER JOIN Customers AS parent
		ON parent.Local_Id = temp.Customer_Id

		UPDATE temp
		SET temp.Order_Id = parent.ID
		FROM @temp_BonusPayments AS temp
		INNER JOIN Orders AS parent
		ON parent.Local_Id = temp.Order_Id

		SET @STARTTIMER = GETUTCDATE();

		---------------- Temp table to store the output result of Orders merging------------------
		IF OBJECT_ID('tempdb..#TempResultTable3') IS NOT NULL
		DROP TABLE #TempResultTable3
		CREATE TABLE #TempResultTable3 ([Action] nvarchar(10),
		[ClientID] [bigint] NOT NULL, [Id] [bigint] NOT NULL, [Customer_Id] [bigint] NOT NULL,
		[BonusDate] [datetime2](7) NOT NULL, [MealPlan] [bigint] NULL, [BonusPaid] [float] NULL,
		[PriorBal] [float] NULL, [Order_Id] [bigint] NULL, [BonusDateLocal] [datetime2](7) NOT NULL,
		[LastUpdatedUTC] [datetime2](7) NULL, [UpdatedBySync] [bit] NULL, [Local_ID] [int] NULL,
		[CloudIDSync] [bit] NOT NULL,

		[DEL_ClientID] [bigint] NULL, [DEL_Id] [bigint] NULL, [DEL_Customer_Id] [bigint] NULL,
		[DEL_BonusDate] [datetime2](7) NULL, [DEL_MealPlan] [bigint] NULL, [DEL_BonusPaid] [float] NULL,
		[DEL_PriorBal] [float] NULL, [DEL_Order_Id] [bigint] NULL, [DEL_BonusDateLocal] [datetime2](7) NULL,
		[DEL_LastUpdatedUTC] [datetime2](7) NULL, [DEL_UpdatedBySync] [bit] NULL, [DEL_Local_ID] [int] NULL,
		[DEL_CloudIDSync] [bit] NULL)
		-------------------------------------------------------------------------------------------
		ALTER TABLE BonusPayments DISABLE TRIGGER ALL;

		MERGE BonusPayments WITH (HOLDLOCK) AS T
		USING @temp_BonusPayments S
		ON T.Local_Id = S.ID

		WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		UPDATE SET
		T.ClientID = S.ClientID, T.Customer_Id = S.Customer_Id, T.BonusDate = S.BonusDate, T.MealPlan = S.MealPlan,
		T.BonusPaid = S.BonusPaid, T.PriorBal = S.PriorBal, T.Order_Id = S.Order_Id, T.BonusDateLocal = S.BonusDateLocal

		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, Customer_Id, BonusDate, MealPlan, BonusPaid, PriorBal, Order_Id, BonusDateLocal, LastUpdatedUTC,
				 UpdatedBySync, Local_ID, CloudIDSync)
			VALUES
				(S.ClientID, S.Customer_Id, S.BonusDate, S.MealPlan, S.BonusPaid, S.PriorBal, S.Order_Id,
				 S.BonusDateLocal, S.LastUpdatedUTC, 1, S.ID, 0)
		OUTPUT $action as [Action], INSERTED.[ClientID], INSERTED.[Id], INSERTED.[Customer_Id], INSERTED.[BonusDate], INSERTED.[MealPlan], INSERTED.[BonusPaid], INSERTED.[PriorBal], INSERTED.[Order_Id], INSERTED.[BonusDateLocal], INSERTED.[LastUpdatedUTC], INSERTED.[UpdatedBySync], INSERTED.[Local_ID], INSERTED.[CloudIDSync],
			 DELETED.[ClientID], DELETED.[Id], DELETED.[Customer_Id], DELETED.[BonusDate], DELETED.[MealPlan], DELETED.[BonusPaid], DELETED.[PriorBal], DELETED.[Order_Id], DELETED.[BonusDateLocal], DELETED.[LastUpdatedUTC], DELETED.[UpdatedBySync], DELETED.[Local_ID], DELETED.[CloudIDSync]
		INTO #TempResultTable3;
		ALTER TABLE BonusPayments ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()
		INSERT INTO Stage.MetricsLog select 'Save BonysPayments', @RowCount, @STARTTIMER, @ENDTIMER
		EXEC UpdateAccountInfoOnBonusPaymentsIU @clientID

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[BonusPayments] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_BonusPayments)
		-------------------------------Transactions------------------------------------------

		INSERT INTO @temp_Transactions
			SELECT * FROM @transactions

		SELECT *
		INTO #queueTemp_Transactions
		FROM @temp_Transactions AS temp
		WHERE (ISNULL(temp.OrderId, -1) > 0 AND
		NOT Exists
		(
			SELECT NULL FROM
			Orders
			WHERE (Orders.Local_Id = temp.OrderId AND temp.OrderType = 0)
			UNION ALL
			SELECT NULL FROM 
			PreOrders
			WHERE (PreOrders.Local_Id = temp.OrderId AND temp.OrderType = 1)
			UNION ALL
			SELECT NULL FROM
			BonusPayments
			WHERE (BonusPayments.Local_Id = temp.OrderId AND temp.OrderType = 2)
		))
		OR (ISNULL(temp.CashResId, -1) > 0 AND
		NOT EXISTS
		(
			SELECT NULL FROM
			CashResults
			WHERE CashResults.Local_Id = temp.CashResId
		))

		MERGE [queue].[Transactions] WITH (HOLDLOCK) AS T
		USING #queueTemp_Transactions S
		ON T.Id = S.Id
		WHEN MATCHED AND T.LastUpdatedUTC <= S.LastUpdatedUTC THEN
		UPDATE SET T.[ClientID] = S.[ClientID], T.[OrderId] = S.[OrderId], T.[OrderType] = S.[OrderType],
		T.[CashResId] = S.[CashResId], T.[IsPosted] = NULL, T.[LastUpdatedUTC] = S.[LastUpdatedUTC]
		WHEN NOT MATCHED THEN
		INSERT ([ClientID], [Id], [OrderId], [OrderType], [CashResId], [PartitionId], [PartitionOffset], [Local_ID],
		[LastUpdatedUTC], Cloud_ID)
		VALUES (S.[ClientID], S.[Id], S.[OrderId], S.[OrderType], S.[CashResId], S.[PartitionId], S.[PartitionOffset], S.[ID],
		S.[LastUpdatedUTC], S.Cloud_ID);

		DELETE a FROM @temp_Transactions AS a WHERE EXISTS (SELECT NULL FROM #queueTemp_Transactions AS b WHERE b.Id = a.Id)

		UPDATE temp
		SET temp.OrderId = parent.ID
		FROM @temp_Transactions AS temp
		INNER JOIN Orders AS parent
		ON parent.Local_Id = temp.OrderId
		WHERE temp.OrderType = 0

		UPDATE temp
		SET temp.OrderId = parent.ID
		FROM @temp_Transactions AS temp
		INNER JOIN PreOrders AS parent
		ON parent.Local_Id = temp.OrderId
		WHERE temp.OrderType = 1

		UPDATE temp
		SET temp.OrderId = parent.ID
		FROM @temp_Transactions AS temp
		INNER JOIN BonusPayments AS parent
		ON parent.Local_Id = temp.OrderId
		WHERE temp.OrderType = 2

		UPDATE temp
		SET temp.CashResId = parent.ID
		FROM @temp_Transactions AS temp
		INNER JOIN CashResults AS parent
		ON parent.Local_Id = temp.CashResId

			-- Create Transactions for all of the Orders that were inserted.
		SET @STARTTIMER = GETUTCDATE()

		ALTER TABLE Transactions DISABLE TRIGGER ALL;

		MERGE Transactions WITH (HOLDLOCK) AS T
		USING @temp_Transactions S
		ON T.Local_Id = S.ID
		 
		WHEN MATCHED AND T.LastUpdatedUTC < S.LastUpdatedUTC THEN
		UPDATE SET
		t.ClientID=S.ClientID,t.Order_Id=S.OrderId,t.OrderType=S.OrderType,t.CashRes_Id=S.CashResId

		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, Order_Id, OrderType, CashRes_Id, LastUpdatedUTC, UpdatedBySync, Local_Id, CloudIDSync)
			VALUES
				(S.ClientID, S.OrderId, S.OrderType, S.CashResId, S.LastUpdatedUTC, 1, S.ID, 0);

		ALTER TABLE Transactions ENABLE TRIGGER ALL;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()
		INSERT INTO Stage.MetricsLog select 'Save Transactions', @RowCount, @STARTTIMER, @ENDTIMER

		-- Removes records that were reprocessed successfully
		DELETE FROM [queue].[Transactions] WHERE IsPosted = 1 AND Local_Id in (select Id from @temp_Transactions)

		--RAISERROR ('Error raised For Testing....', -- Message text.
  --             11, -- Severity.
  --             1 -- State.
  --             );

		---------------------------------End--------------------------------------------

		COMMIT TRAN
		-- Capture LastRecordLoaded
		SET @LastRecordLoaded = COALESCE((SELECT MAX(Id) FROM dbo.Orders),@LastRecordLoaded);

		UPDATE Stage.JobControl
		SET EndTime = GETUTCDATE()
		   ,JobStatus = 'Complete'
		   ,LastRecordLoaded = @LastRecordLoaded
		WHERE JobName = @JobName
		IF OBJECT_ID('tempdb..#TempResultTable1') IS NOT NULL
		DROP TABLE #TempResultTable1
		IF OBJECT_ID('tempdb..#TempResultTable2') IS NOT NULL
		DROP TABLE #TempResultTable2
		IF OBJECT_ID('tempdb..#TempResultTable3') IS NOT NULL
		DROP TABLE #TempResultTable3
	END TRY
	BEGIN CATCH
		-- What to do with failed orders here.
		IF @@TRANCOUNT > 0
		ROLLBACK TRAN

		IF OBJECT_ID('tempdb..#TempResultTable1') IS NOT NULL
		DROP TABLE #TempResultTable1
		IF OBJECT_ID('tempdb..#TempResultTable2') IS NOT NULL
		DROP TABLE #TempResultTable2
		IF OBJECT_ID('tempdb..#TempResultTable3') IS NOT NULL
		DROP TABLE #TempResultTable3

		UPDATE Stage.JobControl
		SET EndTime = GETUTCDATE()
		   ,JobStatus = 'Failed'
		   ,LastRecordLoaded = @LastRecordLoaded
		WHERE JobName = @JobName

		SELECT @ErrorMessage = 'Line ' + CAST(ERROR_LINE() as varchar) + ': ' + ERROR_MESSAGE()
		SET @ErrorCode = ERROR_NUMBER();
		print @ErrorMessage

		INSERT INTO ErrorLog VALUES(@clientID, GETDATE(), ERROR_STATE(), 'SyncPendingData', @ErrorMessage)

		SET @RunStatus = -1
	END CATCH

	SET @ENDTRANTIMER = GETUTCDATE()
	INSERT INTO Stage.MetricsLog select 'Total Transaction', @OrderCount, @STARTTRANTIMER, @ENDTRANTIMER

	--Insert Into JobHistory table
	INSERT INTO Stage.JobHistory (JobID, JobName, StartTime, EndTime, LastRecordLoaded, JobStatus, Notes)
		select JobId, JobName, StartTime, EndTime, LastRecordLoaded, JobStatus, @ErrorMessage
		from Stage.JobControl 
		where JobName = @JobName;

	--Clean up old JobHistory records if there are over 10,000 records
	WITH OrderedLogs AS
	(
		SELECT JobHistoryID
			, ROW_NUMBER() OVER(ORDER BY JobHistoryID DESC) AS RowNumber
		FROM Stage.JobHistory
		WHERE JobName = @JobName
	)
	DELETE history
	FROM Stage.JobHistory history
		 JOIN OrderedLogs logs ON history.JobHistoryID = logs.JobHistoryID
	WHERE logs.RowNumber > 10000

	-- Return number of Rows left and the result of the Stored Procedure
	SELECT CAST(0 as bigint) as RemainingRowCount, @RunStatus as RunStatus, @ErrorCode as ErrorCode, @ErrorMessage as ErrorMessage
END
GO
