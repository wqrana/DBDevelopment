USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Recalculation_Process]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Main_Recalculation_Process]
	@ClientID bigint,
	@CustID bigint, 
	@UseBonus BIT = 0,
	@ReturnDataSet BIT = 1,
	@ErrorMessage varchar(1024) = '' OUTPUT
AS
	DECLARE @CUSTORDCUR CURSOR,
            @LastOrderDate datetime,
            @CurrentOrderDate datetime,
            @BonusPayments float,
            @MBalance float,
            @ABalance float,
            @BonusBalance float,
            @MDebit float,
            @MCredit float,
            @ADebit float,
            @ACredit float,
            @BCredit float,
			@TransactionID int,
			@OrderType int,
            @TransType int,
            @OrderID int,
            @LunchType int,
            @Adjustment bit,
            @IsVoid bit,
            @AccountInfoExists int,
            @Result int
BEGIN
	BEGIN TRAN
	
	BEGIN TRY
		SET @CUSTORDCUR = CURSOR LOCAL FOR
				SELECT
					t.Id as TRANSID,
					t.Order_Id,
					t.OrderType,
					o.LunchType,
					o.MDebit,
					o.MCredit,
					o.ADebit,
					o.ACredit,
					ISNULL(o.BCredit,0.0) as BCredit,
					o.OrderDate as TRANSDATE,
					o.isVoid,
					o.TransType
				FROM Orders o
					LEFT OUTER JOIN Transactions t ON (t.Order_Id = o.id and t.OrderType = 0)
				WHERE o.Customer_Id = @CustID
				UNION ALL
				SELECT
					t.Id,
					t.Order_Id,
					t.OrderType,
					pre.LunchType,
					0.0 as MDebit,
					pre.MCredit,
					0.0 as ADebit,
					pre.ACredit,
					ISNULL(pre.BCredit, 0.0) as BCredit,
					pre.TransferDate TRANSDATE,
					pre.isVoid,
					pre.TransType
				FROM PreOrders pre
					LEFT OUTER JOIN Transactions t ON t.Order_Id = pre.Id and t.OrderType = 1
				WHERE pre.Customer_Id = @CustID			
				ORDER BY TRANSDATE
				
		SET @Result = 0
		SET @MBalance = 0.0
		SET @ABalance = 0.0
		SET @BonusBalance = 0.0
		SET @LastOrderDate = NULL
		
		OPEN @CUSTORDCUR
		FETCH NEXT FROM @CUSTORDCUR INTO @TransactionID, @OrderID, @OrderType, @LunchType, @MDebit, @MCredit, @ADebit, @ACredit, @BCredit, @CurrentOrderDate, @IsVoid, @TransType

		WHILE (@@FETCH_STATUS = 0) BEGIN			
			SET @Adjustment = 0

			-- Recalculate Bonus Payments since last order
			IF (@UseBonus = 1) BEGIN
				IF (@LastOrderDate IS NULL) SET @LastOrderDate = '1/1/1900'
				EXEC @Result = Main_Recalculation_BonusPayments @ClientID, @CustID, @BonusBalance OUTPUT, @LastOrderDate, @CurrentOrderDate, DEFAULT
				IF (@Result <> 0) BEGIN
					DECLARE @MSG1 varchar(255)
					SET @MSG1 = 'Failed to get Bonus Payments for Customer ID: %d between ' + CONVERT(varchar, @LastOrderDate, 120) + ' and ' + CONVERT(varchar, @CurrentOrderDate, 120) 
					RAISERROR(@MSG1, 11, 1, @CustID)	
				END
			END

			-- mark if adjustment
			IF (@IsVoid = 1) BEGIN
				IF (SUBSTRING(CAST(@TransType as varchar),2,1) = '5' AND SUBSTRING(CAST(@TransType as varchar),4,1) = '0') SET @Adjustment = 1
				ELSE SET @Adjustment = 0
			END
			ELSE SET @Adjustment = 0

			-- This order needs to be recalculated
			IF (@IsVoid = 0 OR @Adjustment = 1) BEGIN				
				-- Calculate new balance
				exec dbo.BalanceAfterOrder @MDebit, @MCredit, @ADebit, @ACredit, @BCredit, @UseBonus, @LunchType, @MBalance OUTPUT, @ABalance OUTPUT, @BonusBalance OUTPUT
			END

			-- Recalculate Bonus Payments related to this order
			IF (@UseBonus = 1 AND @OrderType = 0) BEGIN
				EXEC @Result = Main_Recalculation_BonusPayments @ClientID, @CustID, @BonusBalance OUTPUT, DEFAULT, DEFAULT, @OrderID
				IF (@Result <> 0)
					RAISERROR('Failed to get Bonus Payments for Customer ID: %d with order ID: %d', 11, 3, @CustID, @OrderID)
			END

			SET @LastOrderDate = @CurrentOrderDate
			SET @BonusPayments = 0.0
			FETCH NEXT FROM @CUSTORDCUR INTO @TransactionID, @OrderID, @OrderType, @LunchType, @MDebit, @MCredit, @ADebit, @ACredit, @BCredit, @CurrentOrderDate, @IsVoid, @TransType
		END -- END OF ORDER LOOP

		CLOSE @CUSTORDCUR
		DEALLOCATE @CUSTORDCUR
		
		-- Recalculate Bonus Payments since last order date to today
		IF (@UseBonus = 1) BEGIN
			IF (@LastOrderDate IS NULL) SET @LastOrderDate = '1/1/1900'

			DECLARE @Today datetime
			SET @Today = GETDATE()

			EXEC @Result = Main_Recalculation_BonusPayments @ClientID, @CustID, @BonusBalance OUTPUT, @LastOrderDate, @Today, DEFAULT
			IF (@Result <> 0) BEGIN
				DECLARE @MSG4 varchar(255)
				SET @MSG4 = 'Failed to get Bonus Payments for Customer ID: %d between ' + CONVERT(varchar, @LastOrderDate, 120) + ' and ' + CONVERT(varchar, @Today, 120) 
				RAISERROR(@MSG4, 11, 4, @CustID)
			END
		END

		-- Archive Account Info before update.
		DECLARE @PREVABAL float, @PREVMBAL float, @PREVBBAL float
		SELECT @PREVABAL = ABalance, @PREVMBAL = MBalance, @PREVBBAL = BonusBalance FROM AccountInfo WHERE Customer_Id = @CustID
		IF (@@ERROR <> 0) 
			RAISERROR('Failed to get Balance from Account Info for Customer ID: %d', 11, 5, @CustID)
			
		IF ( (@PREVABAL <> @ABalance) OR (@PREVMBAL <> @MBalance) OR (@PREVBBAL <> @BonusBalance) ) BEGIN
			exec Main_Recalculation_Log @ClientID, @CustID, @PREVABAL, @PREVMBAL, @PREVBBAL, @ABalance, @MBalance, @BonusBalance, DEFAULT
			IF (@@ERROR <> 0)
				RAISERROR('Failed to archive account information for Customer ID: %d', 11, 5, @CustID)
		END
		
		-- Update Account Information
		SELECT @AccountInfoExists = COUNT(*) FROM AccountInfo WHERE Customer_Id = @CustID
		IF (@@ERROR <> 0)
			RAISERROR('Failed to see if Customer ID: %d has an account', 11, 5, @CustID)
			
		IF (@AccountInfoExists > 0) BEGIN
			IF (@UseBonus = 1) BEGIN
				UPDATE AccountInfo SET ABALANCE = @ABalance, MBALANCE = @MBalance, BONUSBALANCE = @BonusBalance
				WHERE Customer_Id = @CustID
			END
			ELSE BEGIN
				UPDATE AccountInfo SET ABALANCE = @ABalance, MBALANCE = @MBalance
				WHERE Customer_Id = @CustID
			END
		END
		ELSE BEGIN
			IF (@UseBonus = 1) BEGIN
				INSERT INTO AccountInfo (ClientID, Customer_Id, ABalance, MBalance, BonusBalance)
					VALUES (@ClientID, @CustID, @ABalance, @MBalance, @BonusBalance)
			END
			ELSE BEGIN
				INSERT INTO AccountInfo (ClientID, Customer_Id, ABalance, MBalance)
					VALUES (@ClientID, @CustID, @ABalance, @MBalance)
			END
		END
		
		IF (@@ERROR <> 0)
			RAISERROR('Failed to update balance for Customer ID: %d', 11, 6, @CustID)

		COMMIT TRAN
		IF (@ReturnDataSet = 1) SELECT 0 as Result, '' as ErrorMessage
		ELSE RETURN(0)
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		IF (CURSOR_STATUS('variable', '@CUSTORDCUR') >= 0) BEGIN
			CLOSE @CUSTORDCUR
			DEALLOCATE @CUSTORDCUR
		END
		IF (@ReturnDataSet = 1) SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
		ELSE BEGIN
			SET @ErrorMessage = ERROR_MESSAGE()
			RETURN(ERROR_STATE())
		END
	END CATCH
END
GO
