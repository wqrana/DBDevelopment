USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[SaveOrder]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SaveOrder]
	@ClientID bigint, 
	@ORDID int,
	@POS_ID int,
	@EMP_CASH_ID int,
	@CUST_ID int,
	@TRANSTYPE int,
	@MDEBIT float,
	@ADEBIT float,
	@MCREDIT float,
	@ACREDIT float,
	@BCREDIT float,
	@MEALPLANID int = -1,
	@CASHRESID int = NULL,
	@LUNCHTYPE int = -1,
	@SCHOOL_ID int = -1,
	@ORDERDATE datetime = NULL,
	@CREDITAUTH int = NULL,
	@CHECKNUM int = NULL,
	@OVERRIDE bit = 0,
	@VOID bit = 0,
	@ORDLOG_ID int = NULL,
	@ORDLOGNOTE varchar(255) = NULL
AS
DECLARE
	@CUST_PR_ID int,
	@BONUSPMTID int,
	@GDATE datetime,
	@PRIORABAL float,
	@PRIORMBAL float,
	@PRIORBBAL float,
	@ABalance float,
	@MBalance float,
	@BonusBalance float,
	@BONUSPMT float,
	@PMTAMOUNT float,
	@ACCTEXISTS bit,
	@ACCTTRANSSUCCESS bit
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @CUST_PR_ID = NULL
	SET @BONUSPMTID = NULL
	SET @ACCTEXISTS = 0
	SET @PRIORABAL = 0.0
	SET @PRIORMBAL = 0.0
	SET @PRIORBBAL = 0.0
	SET @ABalance = 0.0
	SET @MBalance = 0.0
	SET @BonusBalance = 0.0
	SET @BONUSPMT = 0.0
	SET @PMTAMOUNT = 0.0
	SET @ACCTTRANSSUCCESS = 0
	
	BEGIN TRY
		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID %d',11,1,@ClientID)
			
		-- Take care of any null values here before inserting order
		IF ((@CUST_ID <> -3 AND @CUST_ID <> -2 AND @CUST_ID <= 0))
			RAISERROR('Invalid Customer Id %d provided', 11, 1, @CUST_ID)

		IF (@ORDID = 0 OR @ORDID < -1) RAISERROR('Invalid Order ID %d passed.', 11, 1, @ORDID)
/* NAH - 20160314 - Re
		IF (@ORDID = -1) BEGIN
			EXEC Main_IndexGenerator_GetIndex @ClientID, 2, 1, @ORDID OUTPUT
			IF ((@@ERROR <> 0) OR (@ORDID IS NULL OR @ORDID = 0 OR @ORDID = -1))
				RAISERROR('Failed to get an Order Index', 11, 2)
		END
*/
		
		IF (@ORDLOG_ID = 0 OR @ORDLOG_ID < -1) RAISERROR('Invalid Order Log ID %d passed.', 11, 1, @ORDLOG_ID)
/*
		IF (@ORDLOG_ID = -1) BEGIN
			EXEC Main_IndexGenerator_GetIndex @ClientID, 21, 1, @ORDLOG_ID OUTPUT
			IF ((@@ERROR <> 0) OR (@ORDLOG_ID IS NULL OR @ORDLOG_ID = 0 OR @ORDLOG_ID = -1))
				RAISERROR('Failed to get an OrderLog Index', 11, 2)
		END
*/

		-- Get Lunch Status if not already Assigned
		IF (@LUNCHTYPE = -1) BEGIN
			SELECT 
				@LUNCHTYPE = ISNULL(LunchType, CASE isStudent WHEN 0 THEN 4 ELSE 0 END)
			FROM Customers
			WHERE 
				ClientID = @ClientID and 
				Id = @CUST_ID
			IF (@@ERROR <> 0 OR @LUNCHTYPE <= 0)
				RAISERROR('Failed to get lunchtype for Customer ID: %d', 11, 5, @CUST_ID)
		END

		-- Change Adult status to 1 for writing to orders table
		IF (@LUNCHTYPE = 4) BEGIN
			SET @LUNCHTYPE = 1
		END

		IF (@CUST_ID > 0) BEGIN
			-- Get Meal Plan ID of Meal Plan Customers if not passed.
			IF ((@LUNCHTYPE = 5) AND (@MEALPLANID IS NULL OR @MEALPLANID = 0 OR @MEALPLANID = -1)) BEGIN
				SELECT @MEALPLANID = c.MealPlan_Id FROM Customers c WHERE c.ClientID = @ClientID and c.Id = @CUST_ID
			END
			
			IF (@SCHOOL_ID = -1) BEGIN
				SELECT 
					@SCHOOL_ID = ISNULL(cs.School_Id, 0)
				FROM Customers c 
					INNER JOIN Customer_School cs on (cs.Customer_Id = c.Id and cs.isPrimary = 1 and cs.ClientID = c.ClientID)
				WHERE c.ClientID = @ClientID 
					and c.id = @CUST_ID
				IF (@@ERROR <> 0 OR @SCHOOL_ID = 0)
					RAISERROR('Failed to get Primary School Assignment for Customer ID: %d', 11, 3, @CUST_ID)

				SET @CUST_PR_ID = @SCHOOL_ID
			END -- Get School ID

			IF ((@CUST_PR_ID IS NULL) AND (@SCHOOL_ID <> -1)) BEGIN
				SELECT 
					@CUST_PR_ID = ISNULL(cs.School_Id, 0)
				FROM Customers c 
					INNER JOIN Customer_School cs on (cs.Customer_Id = c.id and cs.isPrimary = 1 and cs.ClientID = c.ClientID)
				WHERE c.ClientID = @ClientID 
					and c.Id = @CUST_ID
				IF (@@ERROR <> 0 OR @CUST_PR_ID = 0)
					RAISERROR('Failed to get Primary School Assignment for Customer ID: %d', 11, 3, @CUST_ID)
			END -- Get Primary School
		END

		IF (@ORDERDATE IS NULL) BEGIN
			SET @ORDERDATE = GETDATE()
		END

		SET @GDATE = CAST(CONVERT(varchar, @ORDERDATE, 101) as datetime)

		BEGIN TRY
		BEGIN TRAN
			IF (@CUST_ID > 0) BEGIN
				SELECT 
					@ABalance = ISNULL(ABalance, 0.0), 
					@MBalance = ISNULL(MBalance, 0.0), 
					@BonusBalance = ISNULL(BonusBalance, 0.0) 
				FROM AccountInfo WITH (UPDLOCK)
				WHERE ClientID = @ClientID
					and Customer_Id = @CUST_ID
				IF (@@ERROR <> 0)
					RAISERROR('Failed to get Balance for Customer ID: %d', 11, 4, @CUST_ID)
			END
			ELSE BEGIN
				SET @ABalance = 0.0
				SET @MBalance = 0.0
				SET @BonusBalance = 0.0
			END
			
			SET @PRIORABAL = @ABalance
			SET @PRIORMBAL = @MBalance
			SET @PRIORBBAL = @BonusBalance
		
			-- Call Account Transaction
			exec dbo.AccountTransaction @ClientID, @SCHOOL_ID, @ADEBIT OUTPUT, @ACREDIT OUTPUT, @MDEBIT OUTPUT, @MCREDIT OUTPUT, @ABalance OUTPUT, @MBalance OUTPUT, @BCREDIT OUTPUT, @BonusBalance OUTPUT, @PRIORBBAL, @BONUSPMT OUTPUT, @PMTAMOUNT OUTPUT, @LUNCHTYPE, @MEALPLANID, @ACCTTRANSSUCCESS OUTPUT
			IF (@ACCTTRANSSUCCESS = 0)
				RAISERROR('Failed to Run Account Transaction', 11, 5)
			
			IF (@ORDLOG_ID IS NULL OR @ORDLOG_ID = 0 OR @ORDLOG_ID = -1) BEGIN
				SET @ORDLOG_ID = NULL
			END
			ELSE BEGIN
				-- Insert Orders Log
				IF (@ORDLOG_ID = -1) BEGIN
					INSERT INTO OrdersLog (ClientID, Employee_Id, ChangedDate, Notes)
						VALUES (@ClientID, @EMP_CASH_ID, @ORDERDATE, @ORDLOGNOTE)
					IF (@@ERROR <> 0)
						RAISERROR('Failed to Insert new OrdersLog', 11, 6)

					SELECT @ORDLOG_ID = SCOPE_IDENTITY()
				END
				ELSE BEGIN
					Update OrdersLog SET
						Employee_Id = @EMP_CASH_ID,
						ChangedDate = @ORDERDATE,
						Notes = @ORDLOGNOTE
					WHERE
						ClientID = @ClientID and
						Id = @ORDLOG_ID

					IF (@@ERROR <> 0)
						RAISERROR('Failed to Update OrdersLog ID: %d.', 11, 6, @ORDLOG_ID)
				END
			END

			-- Insert Order
			INSERT INTO Orders (ClientID, Customer_Pr_School_Id, POS_Id, School_Id, Emp_Cashier_Id, Customer_Id, OrdersLog_Id, OrderDate, LunchType, MDebit, MCredit, 
				CheckNumber, [OverRide], isVoid, GDate, ADebit, ACredit, 
				--PriorABal, PriorMBal, 
				TransType, 
				--PriorBBal, 
				BCredit, CreditAuth_Id, OrderDateLocal)
			VALUES (@ClientID, @CUST_PR_ID, @POS_ID, @SCHOOL_ID, @EMP_CASH_ID, @CUST_ID, @ORDLOG_ID, GETUTCDATE(), @LUNCHTYPE, @MDEBIT, @MCREDIT,
				@CHECKNUM, @OVERRIDE, @VOID, @GDATE, @ADEBIT, @ACREDIT, 
				--@PRIORABAL, @PRIORMBAL, 
				@TRANSTYPE, 
				--@PRIORBBAL, 
				@BCREDIT, @CREDITAUTH, @ORDERDATE)
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Insert new Order.', 11, 7)

			SELECT @ORDID = SCOPE_IDENTITY()

			-- Insert new Transaction
			INSERT INTO Transactions (ClientID, Order_Id, OrderType, CashRes_Id)
				VALUES (@ClientID, @ORDID, 0, @CASHRESID)
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Insert Transaction for Order ID: %d', 11, 8, @ORDID)

			IF (@BONUSPMT > 0.0) BEGIN
				/*
				EXEC Main_IndexGenerator_GetIndex @ClientID, 54, 1, @BONUSPMTID OUTPUT, 0
				IF ((@@ERROR <> 0) OR (@BONUSPMTID IS NULL OR @BONUSPMTID = 0 OR @BONUSPMTID = -1))
					RAISERROR('Failed to get a Bonus Payment Index', 11, 9)
				*/

				INSERT INTO BonusPayments (ClientID, Customer_Id, BonusDate, MealPlan, BonusPaid, PriorBal, Order_Id, BonusDateLocal)
					VALUES (@ClientID, @CUST_ID, GETUTCDATE(), @MEALPLANID, @BONUSPMT, @PRIORBBAL, @ORDID, @ORDERDATE)
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Create Bonus Payment.', 11, 10)

				SELECT @BONUSPMTID = SCOPE_IDENTITY()
					
				INSERT INTO Transactions (ClientID, Order_Id, OrderType, CashRes_Id)
					VALUES (@ClientID, @BONUSPMTID, 2, NULL)
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Insert Transaction for Bonus Payment ID: %d', 11, 11, @BONUSPMTID)
			END
			
			-- Update Customer's Balance
			IF (@CUST_ID > 0) BEGIN
				SELECT @ACCTEXISTS = COUNT(*) FROM AccountInfo WHERE ClientID = @ClientID and Customer_Id = @CUST_ID
				IF (@@ERROR <> 0)
					RAISERROR('Failed to see if account information exists for Customer ID: %d', 11, 12, @CUST_ID)

				IF (@ACCTEXISTS > 0) BEGIN
					UPDATE AccountInfo SET
						ABalance = @ABalance,
						MBalance = @MBalance,
						BonusBalance = @BonusBalance
					WHERE ClientID = @ClientID
						and Customer_Id = @CUST_ID
					IF (@@ERROR <> 0)
						RAISERROR('Failed to update balance for Customer ID: %d', 11, 13, @CUST_ID)
				END
				ELSE BEGIN
					INSERT INTO AccountInfo (ClientID, Customer_Id, ABalance, MBalance, BonusBalance)
						VALUES (@ClientID, @CUST_ID, @ABalance, @MBalance, @BonusBalance)
					IF (@@ERROR <> 0)
						RAISERROR('Failed to insert balance for Customer ID: %d', 11, 13, @CUST_ID)
				END
			END
			
			COMMIT TRAN
			SELECT @ORDID as OrderID, @ORDLOG_ID as OrdersLogID, @CUST_ID as Customer_Id, @ABalance as ABal, @MBalance as MBal, @BonusBalance as BBal, 0 as Result, '' as ErrorMessage
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			SELECT 0 as OrderID, 0 as OrdersLogID, @CUST_ID as Customer_Id, 0.0 as ABal, 0.0 as MBal, 0.0 as BBal, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage	
		END CATCH
	END TRY
	BEGIN CATCH
		SELECT 0 as OrderID, 0 as OrdersLogID, @CUST_ID as Customer_Id, 0.0 as ABal, 0.0 as MBal, 0.0 as BBal, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage			
	END CATCH
END
GO
