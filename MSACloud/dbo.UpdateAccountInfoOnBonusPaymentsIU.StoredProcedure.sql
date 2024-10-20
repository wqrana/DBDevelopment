USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAccountInfoOnBonusPaymentsIU]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 14-Sep-2017
-- Description:	This sp updates the BonusPayment in the AccountInfo table whenever any bonuspayment is
-- inserted or updated by the syncing services. However, this sp does not update AccountInfo if the bonuspayment
-- updated by sync was not changed.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAccountInfoOnBonusPaymentsIU]
	@ClientID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @Action as char(10);
	DECLARE  @Id INT
		,@BonusPaid FLOAT
		,@BonusBalance FLOAT
		,@CUST_ID INT
		,@SCHOOL_ID INT
		,@ACCTEXISTS BIT
		,@ABalance FLOAT
		,@MBalance FLOAT

	SET @Action = NULL
	SET @Id = 0
	SET @BonusPaid = 0.0
	SET @BonusBalance = 0.0
	SET @CUST_ID = 0
	SET @SCHOOL_ID = - 1
	SET @ACCTEXISTS = 0
	SET @ABalance = 0.0
	SET @MBalance = 0.0

	IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
	DROP TABLE #TempTable

	-- Insert records into #TempTable which were only Inserted or updated,
	-- but the updated record must be different from the orignal. Ignore those updated records, which were
	-- updated but there was no change because we do not update balance if there was no change at all.
	-- We sometimes update the LastUpdatedUTC of some records so that they are synced again by the sync services,
	-- but in this case we do not update balances.
	SELECT * INTO #TempTable FROM #TempResultTable3 AS table1 WHERE EXISTS (
	SELECT  [ClientID], [Id], [Customer_Id], [BonusDate], [MealPlan], [BonusPaid], [PriorBal], [Order_Id], [BonusDateLocal]
           ,[Local_ID]
			from #TempResultTable3 AS table2 WHERE table1.Id = table2.Id
			except 
			SELECT  [DEL_ClientID], [DEL_Id], [DEL_Customer_Id], [DEL_BonusDate], [DEL_MealPlan], [DEL_BonusPaid], [DEL_PriorBal], [DEL_Order_Id], [DEL_BonusDateLocal]
           ,[DEL_Local_ID]
			from #TempResultTable3 AS table3 WHERE table3.Id = table1.Id
	)

	PRINT 'BEFORE Cursor starting'
	DECLARE cur CURSOR READ_ONLY
	FOR 
	SELECT Customer_Id, SUM(ISNULL(BonusPaid, 0.0) - ISNULL(DEL_BonusPaid, 0.0))
	FROM #TempTable GROUP BY Customer_Id
	BEGIN TRY
		BEGIN TRANSACTION

			OPEN cur
			FETCH NEXT FROM cur INTO @CUST_ID, @BonusPaid
			PRINT 'cusrsor started'
			WHILE @@FETCH_STATUS = 0
			BEGIN
					SELECT @BonusBalance = ISNULL(BonusBalance, 0.0)
					FROM AccountInfo WITH (UPDLOCK)
					WHERE  ClientID = @ClientID
					AND Customer_id = @CUST_ID

					SET @BonusBalance = @BonusBalance + @BonusPaid

					IF (@CUST_ID > 0)
					BEGIN
						SELECT @ACCTEXISTS = COUNT(*) FROM AccountInfo WHERE ClientID = @ClientID and Customer_Id = @CUST_ID
						IF (@@ERROR <> 0)
						RAISERROR('Failed to see if account information exists for Customer ID: %d', 11, 12, @CUST_ID)

						SET @ABalance = ROUND(@ABalance, 2);
						SET @MBalance = ROUND(@MBalance, 2);
						SET @BonusBalance = ROUND(@BonusBalance, 2);

						IF (@ACCTEXISTS > 0)
						BEGIN
						PRINT 'Before updating blance in accountinfo'
							UPDATE AccountInfo
							SET BonusBalance = @BonusBalance
							WHERE ClientID = @ClientID
							AND Customer_Id = @CUST_ID

							IF (@@ERROR <> 0)
								RAISERROR ('Failed to update balance for Customer ID: %d', 11, 13, @CUST_ID)
								PRINT 'After updating blance in accountinfo'
						END
						ELSE
						BEGIN
							INSERT INTO AccountInfo (ClientID, Customer_Id, ABalance, MBalance, BonusBalance)
							VALUES (@ClientID, @CUST_ID, @ABalance, @MBalance, @BonusBalance)

							IF (@@ERROR <> 0)
								RAISERROR ('Failed to insert balance for Customer ID: %d', 11, 13, @CUST_ID)
						END
					END

				SET @Action = NULL
				SET @Id = 0
				SET @BonusPaid = 0.0
				SET @BonusBalance = 0.0
				SET @CUST_ID = 0
				SET @SCHOOL_ID = - 1
				SET @ACCTEXISTS = 0
				SET @ABalance = 0.0
				SET @MBalance = 0.0

				FETCH NEXT FROM cur INTO @CUST_ID, @BonusPaid
		
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

		INSERT INTO ErrorLog VALUES(@ClientID, GETDATE(), ERROR_STATE(), 'BonusPayments', ERROR_MESSAGE())

		CLOSE cur
		DEALLOCATE cur
		ROLLBACK TRANSACTION
		IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
		DROP TABLE #TempTable
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
END
GO
