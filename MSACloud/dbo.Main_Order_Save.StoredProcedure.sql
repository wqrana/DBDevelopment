USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Order_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Neil Heverly
-- Create date: 3/14/2016
-- Description:	Saves an Order
-- =============================================
/*
	Revisions:
	03/18/2015 - NAH - Added @LocalTime for storing local time offset along with UTC time.
	12/23/2013- Munawar- @SchoolID is By passed as ID is identity in School 
	03/14/2016 - NAH - Rmeove references to Index Generator
	05/10/2016 - NAH - Fixed getting lunchtype so that it would return a non-zero value
*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_Order_Save]
	@ClientID bigint, 
	@ORDID int OUTPUT,					-- Pass -1 for new, otherwise pass order to be updated
	@POS_ID int,
	@EMP_CASH_ID int,
	@CUST_ID int,
	@TRANSTYPE int,
	@MDEBIT float,
	@ADEBIT float,
	@MCREDIT float,
	@ACREDIT float,
	@BCREDIT float,
	@LocalTime datetime2(7),			-- Local Time with offset
	@ORDLOG_ID int OUTPUT,				-- Pass -1 for new, Pass NULL for no log, Pass >0 for update
	@ABalance float OUTPUT,
	@MBalance float OUTPUT,
	@BonusBalance float OUTPUT,
	@Result int OUTPUT,
	@ErrorMsg nvarchar(4000) OUTPUT,
	@MEALPLANID int = -1,
	@CASHRESID int = NULL,
	@LUNCHTYPE int = -1,
	@SCHOOL_ID int = -1,
	@ORDERDATE datetime = NULL,
	@CREDITAUTH int = NULL,
	@CHECKNUM int = NULL,
	@OVERRIDE bit = 0,
	@VOID bit = 0,
	@ORDLOGNOTE varchar(255) = NULL
AS
DECLARE
	@CUST_PR_ID int,
	@BONUSPMTID int,
	@GDATE datetime,
	@PRIORBBAL float,
	@BONUSPMT float,
	@PMTAMOUNT float,
	@ACCTEXISTS bit,
	@ACCTTRANSSUCCESS bit
BEGIN
	SET @ABalance = 0.0
	SET @MBalance = 0.0
	SET @BonusBalance = 0.0
	SET @PRIORBBAL = 0.0
	SET @Result = 0
	SET @ErrorMsg = N''

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET XACT_ABORT ON;
	SET NOCOUNT ON;

	SET @CUST_PR_ID = NULL
	SET @BONUSPMTID = NULL
	SET @ACCTEXISTS = 0
	SET @BONUSPMT = 0.0
	SET @PMTAMOUNT = 0.0
	SET @ACCTTRANSSUCCESS = 0
	
	BEGIN TRY
		-- Check Client ID
		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID %d',11,1,@ClientID)
			
		-- Take care of any null values here before inserting order
		IF ((@CUST_ID <> -3 AND @CUST_ID <> -2 AND @CUST_ID <= 0) OR (@ORDID = 0))
			RAISERROR('Invalid Customer or OrderID provided', 11, 1)

		/*
		-- Check Order ID
		IF (@ORDID = -1) BEGIN
			EXEC Main_IndexGenerator_GetIndex @ClientID, 2, 1, @ORDID OUTPUT
			IF ((@@ERROR <> 0) OR (@ORDID IS NULL OR @ORDID = 0 OR @ORDID = -1))
				RAISERROR('Failed to get an Order Index', 11, 2)
		END
		
		-- Check for Order Log
		IF (@ORDLOG_ID = -1) BEGIN
			EXEC Main_IndexGenerator_GetIndex @ClientID, 21, 1, @ORDLOG_ID OUTPUT
			IF ((@@ERROR <> 0) OR (@ORDLOG_ID IS NULL OR @ORDLOG_ID = 0 OR @ORDLOG_ID = -1))
				RAISERROR('Failed to get an OrderLog Index', 11, 2)
		END
		*/

		SET @ADEBIT = ROUND(@ADEBIT, 2);
		SET @ACREDIT = ROUND(@ACREDIT, 2);

		-- Get Lunch Status if not already Assigned
		IF (@LUNCHTYPE = -1) BEGIN
			SELECT 
				@LUNCHTYPE = CASE WHEN LunchType IS NULL OR LunchType = 0 THEN 4 ELSE LunchType END
			FROM Customers
			WHERE ClientID = @ClientID
				and Id = @CUST_ID
			IF (@@ERROR <> 0 OR (@LUNCHTYPE <= 0 AND @LUNCHTYPE IS NOT NULL))
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
					INNER JOIN Customer_School cs on (cs.Customer_Id = c.id and cs.isPrimary = 1 and cs.ClientID = c.ClientID)
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
					and c.id = @CUST_ID
				IF (@@ERROR <> 0 OR @CUST_PR_ID = 0)
					RAISERROR('Failed to get Primary School Assignment for Customer ID: %d', 11, 3, @CUST_ID)
			END -- Get Primary School
		END
		
		-- Get the UTC Datetime for recording
		IF (@ORDERDATE IS NULL) BEGIN
			SET @ORDERDATE = GETUTCDATE()
		END

		-- Set the GDate
		SET @GDATE = CAST(CONVERT(varchar, @ORDERDATE, 101) as datetime)

		-- Void an Adjustment (only for 1500, other x5xx are used for non voided transactions)
		IF (@TRANSTYPE = 1500) SET @VOID = 1
		
		--PRINT 'ORDER - BEFORE TRAN'
		
		BEGIN TRY
		BEGIN TRAN
			-- Get the customer's balance
			IF (@CUST_ID > 0) BEGIN
				SELECT 
					@ABalance = ISNULL(ABalance, 0.0), 
					@MBalance = ISNULL(MBalance, 0.0), 
					@BonusBalance = ISNULL(BonusBalance, 0.0) 
				FROM AccountInfo  WITH (UPDLOCK) 
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
			
			--PRINT 'AFTER BALANCE'

			SET @PRIORBBAL = @BonusBalance
		
			-- Call Account Transaction
			exec dbo.AccountTransaction @ClientID, @SCHOOL_ID, @ADEBIT OUTPUT, @ACREDIT OUTPUT, @MDEBIT OUTPUT, @MCREDIT OUTPUT, @ABalance OUTPUT, @MBalance OUTPUT, @BCREDIT OUTPUT, @BonusBalance OUTPUT, @PRIORBBAL, @BONUSPMT OUTPUT, @PMTAMOUNT OUTPUT, @LUNCHTYPE, @MEALPLANID, @ACCTTRANSSUCCESS OUTPUT
			IF (@ACCTTRANSSUCCESS = 0)
				RAISERROR('Failed to Run Account Transaction', 11, 5)
			
			IF (@ORDLOG_ID IS NULL OR @ORDLOG_ID = 0) BEGIN
				SET @ORDLOG_ID = NULL
			END
			ELSE BEGIN
				-- Insert Orders Log
				INSERT INTO OrdersLog (ClientID, Employee_Id, ChangedDate, Notes, ChangedDateLocal)
					VALUES (@ClientID, @EMP_CASH_ID, @ORDERDATE, @ORDLOGNOTE, @LocalTime)
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Insert new OrdersLog', 11, 6)

				SELECT @ORDLOG_ID = SCOPE_IDENTITY()
			END

			--PRINT 'BEFORE INSERT ORDER'
			-- Insert Order
			INSERT INTO Orders (ClientID, Customer_Pr_School_Id, POS_Id, School_Id, Emp_Cashier_Id, Customer_Id, OrdersLog_Id, OrderDate, LunchType, MDebit, MCredit, 
				CheckNumber, [OverRide], isVoid, GDate, ADebit, ACredit, TransType, BCredit, CreditAuth_Id, OrderDateLocal)
			VALUES (@ClientID, @CUST_PR_ID, @POS_ID, @SCHOOL_ID, @EMP_CASH_ID, @CUST_ID, @ORDLOG_ID, @ORDERDATE, @LUNCHTYPE, @MDEBIT, @MCREDIT,
				@CHECKNUM, @OVERRIDE, @VOID, @GDATE, @ADEBIT, @ACREDIT, @TRANSTYPE, @BCREDIT, @CREDITAUTH, @LocalTime)
			
			IF (@@ERROR <> 0) RAISERROR('Failed to Insert new Order', 11, 7)

			SET @ORDID = SCOPE_IDENTITY()

			--PRINT 'BEFORE ADD TRANSACTION'
			-- Insert new Transaction
			INSERT INTO Transactions (ClientID, Order_Id, OrderType, CashRes_Id, LastUpdatedUTC)
				VALUES (@ClientID, @ORDID, 0, @CASHRESID, GETUTCDATE())
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Insert Transaction for Order ID: %d', 11, 8, @ORDID)
				
			IF (@BONUSPMT > 0.0) BEGIN
				/*
				EXEC Main_IndexGenerator_GetIndex @ClientID, 54, 1, @BONUSPMTID OUTPUT, 0
				IF ((@@ERROR <> 0) OR (@BONUSPMTID IS NULL OR @BONUSPMTID = 0 OR @BONUSPMTID = -1))
					RAISERROR('Failed to get a Bonus Payment Index', 11, 9)
				*/

				INSERT INTO BonusPayments (ClientID, Customer_Id, BonusDate, MealPlan, BonusPaid, PriorBal, Order_Id)
					VALUES (@ClientID, @CUST_ID, @ORDERDATE, @MEALPLANID, @BONUSPMT, @PRIORBBAL, @ORDID)
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Create Bonus Payment', 11, 10)

				SELECT @BONUSPMTID = SCOPE_IDENTITY()
					
				INSERT INTO Transactions (ClientID, Order_Id, OrderType, CashRes_Id, LastUpdatedUTC)
					VALUES (@ClientID, @BONUSPMTID, 2, NULL, GETUTCDATE())
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Insert Transaction for Bonus Payment ID: %d', 11, 11)
			END
			
			--PRINT 'BEFORE ACCT INFO UPDATE'
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
			
			--PRINT 'BEFORE COMMIT'
			COMMIT TRAN
			SET @Result = 0
			SET @ErrorMsg = N''
			--SELECT @ORDID as OrderID, @ORDLOG_ID as OrdersLogID, @CUST_ID as Customer_Id, @ABalance as ABal, @MBalance as MBal, @BonusBalance as BBal, 0 as Result, '' as ErrorMessage
		END TRY
		BEGIN CATCH
		
			--PRINT 'ORDER - INNER CATCH'
			
			SET @ORDID = 0
			SET @ORDLOG_ID = 0
			SET @ABalance = 0.0
			SET @MBalance = 0.0
			SET @BonusBalance = 0.0
			SET @Result = ERROR_STATE()
			SET @ErrorMsg = ERROR_MESSAGE()
			ROLLBACK TRAN
			--SELECT 0 as OrderID, 0 as OrdersLogID, @CUST_ID as Customer_Id, 0.0 as ABal, 0.0 as MBal, 0.0 as BBal, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage	
		END CATCH
		
	END TRY
	BEGIN CATCH
	
		--PRINT 'ORDER - OUTER CATCH'
		SET @ORDID = 0
		SET @ORDLOG_ID = 0
		SET @ABalance = 0.0
		SET @MBalance = 0.0
		SET @BonusBalance = 0.0
		SET @Result = ERROR_STATE()
		SET @ErrorMsg = ERROR_MESSAGE()
		--SELECT 0 as OrderID, 0 as OrdersLogID, @CUST_ID as Customer_Id, 0.0 as ABal, 0.0 as MBal, 0.0 as BBal, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage			
		
	END CATCH
	
END
GO
