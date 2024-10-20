USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserPayChecks]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[spPay_Create_UserPayChecks]    Script Date: 11/15/2017 11:55:12 AM ******/
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2017
-- Description:	Creates a user Pay Check 
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_UserPayChecks]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@USERID int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN


	declare @UserBatchProcessedCode as int
	declare @Payroll_Company as nvarchar(50)
	declare @NetPay as decimal
	DECLARE @BatchPayMethodType int --For batches that already include what type of payment it is
	DECLARE @PayMethodType int

	--	The User Batch must not exist in order to process
	select @UserBatchProcessedCode = intUserBatchStatus, @Payroll_Company = strCompanyName, @NetPay = decBatchNetPay, @BatchPayMethodType = intPayMethodType from viewPay_UserBatchStatus where strBatchID =  @BATCHID and intUserID = @USERID
	
	declare @BatchCount as int

	--Process only if the batch exists and has not been processed
	IF  @UserBatchProcessedCode >= 0
		BEGIN TRY
			BEGIN TRAN
			DECLARE @RC int
			
			DECLARE @CheckCount as int
		--CHECK IF THIS IS A TEMPLATE PAYROLL
		IF @BatchPayMethodType = 0  --Payroll does not indicate what type of payment it is
			BEGIN
			SELECT @PayMethodType = intPayMethodType FROM tblUserPayChecks WHERE strBatchID =   @BATCHID and intUserID = @USERID 
				if @PayMethodType is null --New User Pay Check
					BEGIN
					SELECT @PayMethodType = intPayMethodType from tblUserCompanyPayroll where intUserID = @USERID
					SET @CheckCount = 0
					END
			ELSE
				BEGIN
					SELECT @CheckCount = count(intuserid) FROM tblUserPayChecks WHERE strBatchID =   @BATCHID and intUserID = @USERID 
				END
			END
		ELSE
			BEGIN
				SET @PayMethodType = @BatchPayMethodType
			END	

	IF @PayMethodType = 1  --CHECK PAYMENT
			BEGIN			
				DECLARE @CHECKNUMBER int = 0
				SELECT top(1) @CheckCount = count(intUserID) FROM tblUserPayChecks WHERE strBatchID =   @BATCHID and intUserID = @USERID 
				SELECT top(1) @CHECKNUMBER = intCheckNumber FROM tblUserPayChecks WHERE strBatchID =   @BATCHID and intUserID = @USERID 
			--CURRENTLY WORKS ONLY ONE CHECK PER EMPLOYEE
			IF @CheckCount = 1  --Check Already Exists
				BEGIN
						IF @CHECKNUMBER = 0 
						BEGIN
							IF @NetPay > 0
								SET @CHECKNUMBER =	[dbo].[fnPay_GetNextPayCheck] (@Payroll_Company,@BATCHID) 
						END
					UPDATE [dbo].[tblUserPayChecks] SET decCheckAmount = round(ubs.decBatchNetPay,2), decDepositPercent =100,decDepositAmount = 0 ,intPayMethodType = @PayMethodType, intCheckNumber = @CHECKNUMBER
					FROM viewPay_UserBatchStatus ubs inner join tblUserPayChecks upc ON ubs.strBatchID = upc.strBatchID AND ubs.intUserID = upc.intUserID
					WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID 
				END
			ELSE
				BEGIN
				if @CheckCount > 1  --Happens when changing from direct deposit to checks
				BEGIN
					DELETE FROM [tblUserPayChecks] WHERE strBatchID = @BATCHID and intUserID = @USERID 
				END
					IF @CHECKNUMBER = 0 
						BEGIN
							IF @NetPay > 0
								SET @CHECKNUMBER =	[dbo].[fnPay_GetNextPayCheck] (@Payroll_Company,@BATCHID) 
						END
					INSERT INTO [dbo].[tblUserPayChecks]
					(strBatchID, intUserID, dtPayDate, decCheckAmount, intPayCheckStatus, intCheckNumber, intPayMethodType, 
					intAccountType, strBankAccountNumber, strBankRoutingNumber, strBankName, decDepositPercent, decDepositAmount)
					SELECT ubs.strBatchID, ubs.intUserID, ubs.dtPayDate, round(ubs.decBatchNetPay,2)  as decCheckAmount, 0 as intPayCheckStatus,
					@CHECKNUMBER as intCheckNumber,@PayMethodType, 
						'', '', '',  '', 0, 0 
					FROM viewPay_UserBatchStatus ubs inner join tblUserCompanyPayroll ucp on ubs.intUserID = ucp.intUserID
					WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID 
				END
			END
	ELSE --DIRECT DEPOSIT
		BEGIN

		--DELETE ANY EXISTING PAYCHECKS before computing
		DELETE FROM [tblUserPayChecks] WHERE strBatchID = @BATCHID AND intUserID = @USERID
	
		--SELECT THE PAY AMOUNT
		DECLARE @decNetPay decimal(18,2)
		DECLARE @decCashAmount decimal(18,2)
		DECLARE @decPercentAmount decimal(18,2)
	
		--GET THE NET PAY TO VERIFY AMOUNTS
		SELECT @decNetPay = round(ubs.decBatchNetPay,2)  
		FROM viewPay_UserBatchStatus ubs inner join  tblUserDirectDeposit udd  on udd.intUserID = ubs.intUserID  inner join tblUserCompanyPayroll ucp on udd.intUserID = ucp.intUserID
		WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID
	
		--GET THE CASH AMOUNT TO DEDUCT
		SELECT @decCashAmount = sum(udd.decDepositAmount)
		FROM viewPay_UserBatchStatus ubs inner join  tblUserDirectDeposit udd  on udd.intUserID = ubs.intUserID  inner join tblUserCompanyPayroll ucp on udd.intUserID = ucp.intUserID
		WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID and udd.decDepositAmount > 0
		GROUP BY ubs.strBatchID, ubs.intUserID 
		
		--IF NET PAY COVERS ALL CASH DEDUCTIONS, THEN DO CASH PAYCHECKS	
		IF @decCashAmount <= @decNetPay
		BEGIN
			INSERT INTO [dbo].[tblUserPayChecks]
			(strBatchID, intUserID, dtPayDate, decCheckAmount, intPayCheckStatus, intCheckNumber, intPayMethodType, 
			intAccountType, strBankAccountNumber, strBankRoutingNumber, strBankName, decDepositPercent, decDepositAmount)
			SELECT ubs.strBatchID, ubs.intUserID, ubs.dtPayDate, round(udd.decDepositAmount,2)  as decCheckAmount, 0 as intPayCheckStatus, [dbo].[fnPay_GetNextDirectDeposit](@Payroll_Company) as intCheckNumber,ucp.intPayMethodType, 
				udd.intAccountType, udd.strBankAccountNumber, udd.strBankRoutingNumber,  udd.strBankName, udd.decDepositPercent, udd.decDepositAmount 
			FROM viewPay_UserBatchStatus ubs inner join  tblUserDirectDeposit udd  on udd.intUserID = ubs.intUserID  inner join tblUserCompanyPayroll ucp on udd.intUserID = ucp.intUserID
			WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID and udd.decDepositAmount > 0
		END
		ELSE 
		BEGIN
		--NOT ENOUGH MONEY, SET CASH AMOUNT TO 0
		SET @decCashAmount  = 0 
		END

		--COMPUTE AND DIVIDE THE PERCENT AMOUNTS
		SET @decPercentAmount = @decNetPay - @decCashAmount
		
		INSERT INTO [dbo].[tblUserPayChecks]
			(strBatchID, intUserID, dtPayDate, decCheckAmount, intPayCheckStatus, intCheckNumber, intPayMethodType, 
			intAccountType, strBankAccountNumber, strBankRoutingNumber, strBankName, decDepositPercent, decDepositAmount)
		SELECT ubs.strBatchID, ubs.intUserID, ubs.dtPayDate,  (@decPercentAmount * udd.decDepositPercent / 100)  as decCheckAmount, 0 as intPayCheckStatus,[dbo].[fnPay_GetNextDirectDeposit](@Payroll_Company) as intCheckNumber,ucp.intPayMethodType, 
			udd.intAccountType, udd.strBankAccountNumber, udd.strBankRoutingNumber,  udd.strBankName, udd.decDepositPercent, udd.decDepositAmount 
		FROM viewPay_UserBatchStatus ubs inner join  tblUserDirectDeposit udd  on udd.intUserID = ubs.intUserID  inner join tblUserCompanyPayroll ucp on udd.intUserID = ucp.intUserID
		WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID and udd.decDepositPercent > 0

		--CHECK THE AMOUNT THAT WAS DIVIDED BETWEEN CHECKS.  IF NOT THE SAME, THEN ADJUST ONE CHECK WITH THE ROUNDING DIFFERENCE
		DECLARE @decPercentPayChecks decimal(18,2)
		SELECT @decPercentPayChecks = sum(decCheckAmount) 
		FROM tblUserPayChecks 
		WHERE strBatchID =   @BATCHID and intUserID = @USERID and decDepositPercent > 0
		GROUP BY strBatchID, intUserID

		--ADJUST THE FIRST PERCENT CHECK WITH ANY DIFFERENCES IN PAY
		IF @decPercentPayChecks - @decPercentAmount <> 0
			BEGIN
			UPDATE top(1) tblUserPayChecks SET decCheckAmount = decCheckAmount + (@decPercentAmount -@decPercentPayChecks)
			WHERE strBatchID =   @BATCHID and intUserID = @USERID and decDepositPercent > 0
		END
	END	
		--update tblUserBatch set intUserBatchStatus = 4 where strBatchID = @BATCHID and intUserID = @USERID
		set @BatchCount = @@ROWCOUNT
			--Commit the transaction
		COMMIT
		END TRY
		BEGIN CATCH
		ROLLBACK ;
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 
		set @BatchCount = 0
		END CATCH
	ELSE
		BEGIN;
			THROW 100000, 'Batch Not Ready To Create Pay Checks.',1
			set @BatchCount = 0
		END
		return @Batchcount
	END
	
GO
