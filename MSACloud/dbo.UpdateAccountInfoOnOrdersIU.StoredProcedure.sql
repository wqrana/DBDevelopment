USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAccountInfoOnOrdersIU]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 14-Sep-2017
-- Description:	Updates the accountInfo table on the cloud in case of orders are inserted or updated by the sync services.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAccountInfoOnOrdersIU] 
	@ClientID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @Action as char(10);
	DECLARE  @Id INT
		,@CUST_ID INT
		,@SCHOOL_ID INT
		,@MEALPLANID INT
		,@ADEBIT FLOAT
		,@LUNCHTYPE INT
		,@ACREDIT FLOAT
		,@MDEBIT FLOAT
		,@MCREDIT FLOAT
		,@BCREDIT FLOAT

	SET @Id = 0
	SET @CUST_ID = 0
	SET @SCHOOL_ID = - 1
	SET @MEALPLANID = - 1
	SET @ADEBIT = 0.0
	SET @LUNCHTYPE = -1
	SET @ACREDIT = 0.0
	SET @MDEBIT = 0.0
	SET @MCREDIT = 0.0
	SET @BCREDIT = 0.0

	IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
	DROP TABLE #TempTable

	-- Insert records into #TempTable which were only Inserted or updated by sync,
	-- but the updated record must be different from the orignal. Ignore those updated records, which were
	-- updated but there was no change because we do not update balances if there was no change at all.
	-- We sometimes update the LastUpdatedUTC of some records so that they are synced again by the sync services,
	-- but in this case we do not update balances.
	SELECT * INTO #TempTable FROM #TempResultTable1 AS table1 WHERE EXISTS (
	select [ClientID], [Id], [Customer_Pr_School_Id], [POS_Id], [School_Id], [Emp_Cashier_Id], [Customer_Id]
			,[OrdersLog_Id], [GDate], [OrderDate], [OrderDateLocal], [LunchType], [ADebit], [MDebit], [ACredit]
			,[BCredit], [MCredit], [CheckNumber], [OverRide], [isVoid], [TransType], [CreditAuth_Id], [Local_ID]
			from #TempResultTable1 AS table2 WHERE table1.Id = table2.Id
			except 
			select [DEL_ClientID], [DEL_Id], [DEL_Customer_Pr_School_Id], [DEL_POS_Id], [DEL_School_Id], [DEL_Emp_Cashier_Id], [DEL_Customer_Id]
			,[DEL_OrdersLog_Id], [DEL_GDate], [DEL_OrderDate], [DEL_OrderDateLocal], [DEL_LunchType], [DEL_ADebit], [DEL_MDebit], [DEL_ACredit]
			,[DEL_BCredit], [DEL_MCredit], [DEL_CheckNumber], [DEL_OverRide], [DEL_isVoid], [DEL_TransType], [DEL_CreditAuth_Id], [DEL_Local_ID]
			from #TempResultTable1 AS table3 WHERE table3.Id = table1.Id
	)

	PRINT 'BEFORE Cursor starting'
	DECLARE cur CURSOR READ_ONLY
	FOR 
	SELECT Customer_Id, MAX(ISNULL(School_Id, -1)),
	SUM((CASE WHEN IsVoid = 1 AND Transtype <> 1500 THEN 0.0 ELSE ISNULL(ADebit, 0.0) END) - (CASE WHEN DEL_isVoid = 1 AND DEL_Transtype <> 1500 THEN 0.0 ELSE ISNULL(DEL_ADebit, 0.0) END)),
	SUM((CASE WHEN IsVoid = 1 AND Transtype <> 1500 THEN 0.0 ELSE ISNULL(ACredit, 0.0) END) - (CASE WHEN DEL_isVoid = 1 AND DEL_Transtype <> 1500 THEN 0.0 ELSE ISNULL(DEL_ACredit, 0.0) END)),
	SUM((CASE WHEN IsVoid = 1 AND Transtype <> 1500 THEN 0.0 ELSE ISNULL(MDebit, 0.0) END) - (CASE WHEN DEL_isVoid = 1 AND DEL_Transtype <> 1500 THEN 0.0 ELSE ISNULL(DEL_MDebit, 0.0) END)),
	SUM((CASE WHEN IsVoid = 1 AND Transtype <> 1500 THEN 0.0 ELSE ISNULL(MCredit, 0.0) END) - (CASE WHEN DEL_isVoid = 1 AND DEL_Transtype <> 1500 THEN 0.0 ELSE ISNULL(DEL_MCredit, 0.0) END)),
	SUM((CASE WHEN IsVoid = 1 AND Transtype <> 1500 THEN 0.0 ELSE ISNULL(BCredit, 0.0) END) - (CASE WHEN DEL_isVoid = 1 AND DEL_Transtype <> 1500 THEN 0.0 ELSE ISNULL(DEL_BCredit, 0.0) END)),
	MAX(ISNULL(LunchType, -1))
	FROM #TempTable GROUP BY Customer_Id
	BEGIN TRY
		BEGIN TRANSACTION

			OPEN cur
			FETCH NEXT FROM cur INTO @CUST_ID, @SCHOOL_ID, @ADEBIT, @ACREDIT, @MDEBIT, @MCREDIT, @BCREDIT, @LUNCHTYPE
			PRINT 'cusrsor started'
			WHILE @@FETCH_STATUS = 0
			BEGIN

				EXEC UpdateAccountInfo @ClientID, @CUST_ID, @SCHOOL_ID, @MEALPLANID, @ADEBIT, @LUNCHTYPE, @ACREDIT, @MDEBIT, @MCREDIT,
				@BCREDIT, 'Orders'

				SET @Action = NULL
				SET @Id = 0
				SET @CUST_ID = 0
				SET @SCHOOL_ID = - 1
				SET @MEALPLANID = - 1
				SET @ADEBIT = 0.0
				SET @LUNCHTYPE = -1
				SET @ACREDIT = 0.0
				SET @MDEBIT = 0.0
				SET @MCREDIT = 0.0
				SET @BCREDIT = 0.0

				FETCH NEXT FROM cur INTO @CUST_ID, @SCHOOL_ID, @ADEBIT, @ACREDIT, @MDEBIT, @MCREDIT, @BCREDIT, @LUNCHTYPE
		
			END

		COMMIT TRANSACTION
		CLOSE cur
		DEALLOCATE cur
		IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
		DROP TABLE #TempTable
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

		INSERT INTO ErrorLog VALUES(@ClientID, GETDATE(), ERROR_STATE(), 'Orders', ERROR_MESSAGE())

		CLOSE cur
		DEALLOCATE cur
		ROLLBACK TRANSACTION
		IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
		DROP TABLE #TempTable
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END
GO
