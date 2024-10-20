USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAccountInfo]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 14-Sep-2017
-- Description:	Updates the AccountInfo table on inserting or updating orders, preorders and bonuspayments
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAccountInfo]
	 @ClientID BIGINT
	,@CUST_ID INT
	,@SCHOOL_ID INT
	,@MEALPLANID INT
	,@ADEBIT FLOAT
	,@LUNCHTYPE INT
	,@ACREDIT FLOAT
	,@MDEBIT FLOAT
	,@MCREDIT FLOAT
	,@BCREDIT FLOAT
	,@ObjectName VARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    DECLARE @PRIORBBAL FLOAT
	,@ABalance FLOAT
	,@MBalance FLOAT
	,@BonusBalance FLOAT
	,@BONUSPMT FLOAT
	,@PMTAMOUNT FLOAT
	,@ACCTEXISTS BIT
	,@ACCTTRANSSUCCESS BIT

	SET @ACCTEXISTS = 0
	SET @PRIORBBAL = 0.0
	SET @ABalance = 0.0
	SET @MBalance = 0.0
	SET @BonusBalance = 0.0
	SET @BONUSPMT = 0.0
	SET @PMTAMOUNT = 0.0
	SET @ACCTTRANSSUCCESS = 0
	
	BEGIN TRY	
			-- Check Client ID
			IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID %I64d',11,1, @ClientID)
			
			IF (@CUST_ID > 0)
			BEGIN
				-- Get Lunch Status if not already Assigned
				IF (@LUNCHTYPE = -1) BEGIN
					SELECT 
						@LUNCHTYPE = CASE WHEN LunchType IS NULL THEN 4 ELSE LunchType END
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
				END -- Get School ID

				SELECT 
					@ABalance = ISNULL(ABalance, 0.0), 
					@MBalance = ISNULL(MBalance, 0.0), 
					@BonusBalance = ISNULL(BonusBalance, 0.0) 
				FROM AccountInfo  WITH (UPDLOCK) 
				WHERE ClientID = @ClientID
					and Customer_Id = @CUST_ID
				IF (@@ERROR <> 0)
					RAISERROR('Failed to get Balance for Customer ID: %d', 11, 4, @CUST_ID)
				PRINT 'After Getting balances from account Info'
			END
			ELSE
			BEGIN
				SET @ABalance = 0.0
				SET @MBalance = 0.0
				SET @BonusBalance = 0.0
			END

				SET @PRIORBBAL = @BonusBalance

				PRINT 'Before executing AccountTransaction sp'
				-- Call Account Transaction
				exec dbo.AccountTransaction @ClientID, @SCHOOL_ID, @ADEBIT OUTPUT, @ACREDIT OUTPUT, @MDEBIT OUTPUT, @MCREDIT OUTPUT, @ABalance OUTPUT, @MBalance OUTPUT, @BCREDIT OUTPUT, @BonusBalance OUTPUT, @PRIORBBAL, @BONUSPMT OUTPUT, @PMTAMOUNT OUTPUT, @MEALPLANID, @LUNCHTYPE, @ACCTTRANSSUCCESS OUTPUT
				IF (@ACCTTRANSSUCCESS = 0)
					RAISERROR('Failed to Run Account Transaction', 11, 5)

				PRINT 'After executing AccountTransaction sp'

			SET @ABalance = ROUND(@ABalance, 2);
			SET @MBalance = ROUND(@MBalance, 2);
			SET @BonusBalance = ROUND(@BonusBalance, 2);
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
			PRINT 'Successfully balance updated'
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	END CATCH
    
END
GO
