USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [Stage].[ProcessStagedData]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: March 24, 2015
-- Description:	Inserts Bulk Orders and Items into the POS Database.
-- =============================================
CREATE PROCEDURE [Stage].[ProcessStagedData]
	@RowsToProcess INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SUCCESS int = 1
		,@STARTTIMER datetime2(7)
		,@ENDTIMER datetime2(7)
		,@RunStatus int
		,@JobID int 
		,@LastRecordLoaded int
		,@RowCount int
		,@ErrorMessage varchar(4000)
		,@minTempOrderId int
		,@maxTempOrderId int
		,@orderCount int
		,@minTempItemId int
		,@maxTempItemId int
		,@itemCount int

	-- Drop existing Temp Table if exists.
	IF (OBJECT_ID('tempdb..#TempOrders') IS NOT NULL) DROP TABLE #TempOrders
	IF (OBJECT_ID('tempdb..#TempItems') IS NOT NULL) DROP TABLE #TempItems

	-- Check that Job is not already running.
	DECLARE @Count INT
	SELECT @Count = COUNT(1) FROM Stage.JobControl WHERE JobName IN ('ProcessStagedData')
	IF @Count = 0
	BEGIN
		INSERT INTO Stage.JobControl (JobName, JobStatus)
		VALUES ('ProcessStagedData', 'Running')
	END
	ELSE
	BEGIN
		SELECT @Count = COUNT(1) FROM Stage.JobControl WHERE JobName IN ('ProcessStagedData') and JobStatus = 'Running'
		IF @Count <> 0
		BEGIN
			SET @SUCCESS = 0 -- Job Already Running

			-- Return number of Rows left and the result of the Stored Procedure
			SELECT SUM(row_count) as RemainingRowCount, @SUCCESS as RunStatus
			FROM sys.dm_db_partition_stats
			WHERE object_id = OBJECT_ID('Stage.TempOrders') AND (index_id < 2)

			RETURN
		END
	END
	
	--Set status in LoadControl to running
	SET @LastRecordLoaded = COALESCE((SELECT LastRecordLoaded FROM Stage.JobControl where JobName = 'ProcessStagedData'),-1)
	SET @JobID = (SELECT COALESCE(MAX(JobID),0)+1 FROM Stage.JobControl);
	UPDATE Stage.JobControl
	set JobID = @JobID
	   ,StartTime = GETUTCDATE()
	   ,JobStatus = 'Running'
	   ,EndTime = Null
	WHERE JobName = 'ProcessStagedData'

	SET @STARTTIMER = GETUTCDATE()

	-- Load from TempOrders
	select top (@RowsToProcess) * 
		,CAST(0 as Bit) as Inserted
	into #TempOrders 
	from Stage.TempOrders
	order by Id desc

	SET @OrderCount = @@ROWCOUNT
	SET @ENDTIMER = GETUTCDATE()

	-- Metrics Entry
	INSERT INTO Stage.MetricsLog select 'Load TempOrders', @OrderCount, @STARTTIMER, @ENDTIMER

	SET @STARTTIMER = GETUTCDATE()
	-- Load from TempItems (Items associated with TempOrders already picked)
	select ti.*
		,CAST(0 as Bit) as Inserted
	into #TempItems 
	from Stage.TempItems ti
		 join #TempOrders tmpOrd on tmpOrd.Id = ti.Order_Id

	SET @itemCount = @@ROWCOUNT
	SET @ENDTIMER = GETUTCDATE()

	INSERT INTO Stage.MetricsLog select 'Load TempItems', @itemCount, @STARTTIMER, @ENDTIMER

	SET @STARTTIMER = GETUTCDATE()

	CREATE UNIQUE INDEX [#IDX_TempOrders_ID]
    ON #TempOrders ([ID] ASC);

	CREATE UNIQUE INDEX [#IDX_TempItems_ID]
    ON #TempItems ([ID] ASC);
	CREATE NONCLUSTERED INDEX [#IDX_TempItems_OrderID]
    ON #TempItems ([Order_Id] ASC);

	SET @ENDTIMER = GETUTCDATE()
	INSERT INTO Stage.MetricsLog select 'Create indexes', null, @STARTTIMER, @ENDTIMER

	-- Output Tables for New ID values
	DECLARE @OrderIds TABLE(OrigOrderId BIGINT, InsertedOrderId BIGINT)
	DECLARE @ItemIds TABLE(OrigItemId BIGINT, InsertedOrderId BIGINT)
	DECLARE @STARTTRANTIMER datetime2(7), @ENDTRANTIMER datetime2(7)

	SET @STARTTRANTIMER = GETUTCDATE()
	BEGIN TRANSACTION
	BEGIN TRY
		SET @STARTTIMER = GETUTCDATE()
		-- Merge TempOrders into the Main Database Table
		MERGE Orders o
		USING (select top (@orderCount) * from #TempOrders) tmpOrd
		ON 1=0
		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, Customer_Pr_School_Id, POS_Id, School_Id, Emp_Cashier_Id, Customer_Id, OrdersLog_Id, OrderDate, OrderDateLocal, 
				LunchType, MDebit, MCredit, CheckNumber, OverRide, isVoid, GDate, ADebit, ACredit, TransType, 
				BCredit, CreditAuth_Id)
			VALUES
				(tmpOrd.ClientID, tmpOrd.Customer_Pr_School_Id, tmpOrd.POS_Id, tmpOrd.School_Id, tmpOrd.Emp_Cashier_Id, tmpOrd.Customer_Id, tmpOrd.OrdersLog_Id, tmpOrd.OrderDate, tmpOrd.OrderDate,
				tmpOrd.LunchType, tmpOrd.MDebit, tmpOrd.MCredit, tmpOrd.CheckNumber, tmpOrd.OverRide, tmpOrd.isVoid, 
				CASE WHEN tmpOrd.GDate is null then (cast(tmpOrd.OrderDate as date)) else tmpOrd.GDate end, tmpOrd.ADebit, tmpord.ACredit, tmpOrd.TransType,
				tmpOrd.BCredit, tmpOrd.CreditAuth_Id)
		OUTPUT
			tmpOrd.Id, inserted.Id INTO @OrderIds;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Save Orders', @RowCount, @STARTTIMER, @ENDTIMER

		SET @STARTTIMER = GETUTCDATE()
		-- Insert TempItems into the Main Database Table
		MERGE Items it
		USING (select top (@itemCount) * 
				 from #TempItems ti 
					  inner join @OrderIds oi on oi.OrigOrderId = ti.Order_Id
			  ) tmpIt
		ON 1 = 0
		WHEN NOT MATCHED THEN
			INSERT 
				(ClientID, Order_Id, Menu_Id, Qty, FullPrice, PaidPrice, TaxPrice, isVoid, SoldType, PreOrderItem_Id) 
			VALUES
				(tmpIt.ClientID, tmpIt.InsertedOrderId, tmpIt.Menu_Id, tmpIt.Qty, tmpIt.FullPrice, tmpIt.PaidPrice, tmpIt.TaxPrice, tmpIt.isVoid, tmpIt.SoldType, tmpIt.PreOrderItem_Id)
		OUTPUT
			tmpIt.Id, inserted.Id INTO @ItemIds;

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Save Items', @RowCount, @STARTTIMER, @ENDTIMER

		SET @STARTTIMER = GETUTCDATE()
		-- Create Transactions for all of the Orders that were inserted.
		INSERT INTO Transactions (ClientID, Order_Id, OrderType, CashRes_Id)
		select tmp.ClientID, ids.InsertedOrderId, 0, NULL
		from #TempOrders tmp	-- NULL for cashres_Id will change when cashresult_id is passed.
			 join @OrderIds ids on ids.OrigOrderId = tmp.Id

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()
		INSERT INTO Stage.MetricsLog select 'Create Transactions', @RowCount, @STARTTIMER, @ENDTIMER

		--SET @STARTTIMER = GETUTCDATE()
		----Update Inserted Column to 1 after order has be written
		--Update #TempOrders set inserted = 1 from #TempOrders tmpOrd inner join @OrderIds oi on oi.OrigOrderId = tmpOrd.Id	
		--Update #TempItems set inserted = 1 from #TempItems tmpIt inner join @ItemIds ii on ii.OrigItemId = tmpIt.Id
		--SET @ENDTIMER = GETUTCDATE()

		--INSERT INTO Stage.MetricsLog select 'Mark_Inserted', NULL, @STARTTIMER, @ENDTIMER

		SET @STARTTIMER = GETUTCDATE()

		select @minTempOrderId = MIN(Id), @maxTempOrderId = MAX(Id)
		from #TempOrders

		delete top (@orderCount) TempOrders
		from Stage.TempOrders
		where Id between @minTempOrderId and @maxTempOrderId
			--join #TempOrders on #TempOrders.Id = TempOrders.Id
		--where #TempOrders.inserted = '1'

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Delete TempOrders', @RowCount, @STARTTIMER, @ENDTIMER

		SET @STARTTIMER = GETUTCDATE()

		select @minTempItemId = MIN(Id), @maxTempItemId = MaX(Id)
		from #TempItems

		delete top (@itemCount) TempItems
		from Stage.TempItems
		where Order_Id between @minTempOrderId and @maxTempOrderId
		--where Id between @minTempItemId and @maxTempItemId
			--join #TempItems on #TempItems.Id = TempItems.Id
		--where #TempItems.inserted = '1'

		SET @RowCount = @@ROWCOUNT
		SET @ENDTIMER = GETUTCDATE()

		INSERT INTO Stage.MetricsLog select 'Delete TempItems', @RowCount, @STARTTIMER, @ENDTIMER

		COMMIT TRAN
		
		-- Capture LastRecordLoaded
		SET @LastRecordLoaded = COALESCE((SELECT MAX(Id) FROM dbo.Orders),@LastRecordLoaded);

		UPDATE Stage.JobControl
		SET EndTime = GETUTCDATE()
		   ,JobStatus = 'Complete'
		   ,LastRecordLoaded = @LastRecordLoaded
		WHERE JobName = 'ProcessStagedData'

	END TRY
	BEGIN CATCH
		-- What to do with failed orders here.
		ROLLBACK TRAN

		UPDATE Stage.JobControl
		SET EndTime = GETUTCDATE()
		   ,JobStatus = 'Failed'
		   ,LastRecordLoaded = @LastRecordLoaded
		WHERE JobName = 'ProcessStagedData'

		SELECT @ErrorMessage = 'Line ' + CAST(ERROR_LINE() as varchar) + ': ' + ERROR_MESSAGE()

		SET @SUCCESS = -1
	END CATCH

	SET @ENDTRANTIMER = GETUTCDATE()
	INSERT INTO Stage.MetricsLog select 'Total Transaction', @OrderCount, @STARTTRANTIMER, @ENDTRANTIMER

	--Insert Into JobHistory table
	INSERT INTO Stage.JobHistory (JobID, JobName, StartTime, EndTime, LastRecordLoaded, JobStatus, Notes)
		select JobId, JobName, StartTime, EndTime, LastRecordLoaded, JobStatus, @ErrorMessage
		from Stage.JobControl 
		where JobName = 'ProcessStagedData';

	--Clean up old JobHistory records if there are over 10,000 records
	WITH OrderedLogs AS
	(
		SELECT JobHistoryID
			, ROW_NUMBER() OVER(ORDER BY JobHistoryID DESC) AS RowNumber
		FROM Stage.JobHistory
		WHERE JobName = 'ProcessStagedData'
	)
	DELETE history
	FROM Stage.JobHistory history
		 JOIN OrderedLogs logs ON history.JobHistoryID = logs.JobHistoryID
	WHERE logs.RowNumber > 10000

	-- Drop existing Temp Table if exists.
	IF (OBJECT_ID('tempdb..#TempOrders') IS NOT NULL) DROP TABLE #TempOrders
	IF (OBJECT_ID('tempdb..#TempItems') IS NOT NULL) DROP TABLE #TempItems

	-- Return number of Rows left and the result of the Stored Procedure
	SELECT SUM(row_count) as RemainingRowCount
		, @SUCCESS as RunStatus
	FROM sys.dm_db_partition_stats
	WHERE object_id = OBJECT_ID('Stage.TempOrders') AND 
		(index_id < 2)

END
GO
