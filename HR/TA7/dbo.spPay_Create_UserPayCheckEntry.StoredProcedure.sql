USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserPayCheckEntry]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserPayCheckEntry]    Script Date: 10/9/2017 11:50:59 AM ******/

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2017
-- Description:	Creates a user Pay Check for additional payrolls.
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_UserPayCheckEntry]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@USERID int,
		@PAYMETHODTYPE int,
		@CHECKNUMBER int,
		@DIRECT_DEPOSIT_SEQUENCE_NUMBER int
-- WITH ENCRYPTION
AS
	BEGIN

	declare @UserBatchProcessedCode as int
	declare @Payroll_Company as nvarchar(50)
	declare @NetPay as decimal
	--	The User Batch must not be closed in order to process
	select @UserBatchProcessedCode = intUserBatchStatus, @Payroll_Company = strCompanyName, @NetPay = decBatchNetPay from viewPay_UserBatchStatus where strBatchID =  @BATCHID and intUserID = @USERID
	
	declare @BatchCount as int

	--Process only if the batch exists and has not been processed
	IF  @PAYMETHODTYPE >= 0
		BEGIN TRY
			BEGIN TRAN
			DECLARE @RC int
			
		--DELETE ANY EXISTING PAYCHECKS before computing
		DELETE FROM [tblUserPayChecks] WHERE strBatchID = @BATCHID AND intUserID = @USERID

	IF @PAYMETHODTYPE = 1  --CHECK PAYMENT
			BEGIN			
			--NEW CHECKS ONLY
			IF @CHECKNUMBER = 0 
			BEGIN
				IF @NetPay > 0  --ASSIGN A CHECK NUMBER ONLY IF GREATER THAN 0
					SELECT @CHECKNUMBER = [dbo].[fnPay_GetNextPayCheck] (@Payroll_Company ,@BATCHID)
			END
			INSERT INTO [dbo].[tblUserPayChecks]
			(strBatchID, intUserID, dtPayDate, decCheckAmount, intPayCheckStatus, intCheckNumber, intPayMethodType, 
			intAccountType, strBankAccountNumber, strBankRoutingNumber, strBankName, decDepositPercent, decDepositAmount)
			SELECT ubs.strBatchID, ubs.intUserID, ubs.dtPayDate, round(ubs.decBatchNetPay,2)  as decCheckAmount, 0 as intPayCheckStatus,
			@CHECKNUMBER as intCheckNumber,@PAYMETHODTYPE as intPayMethodType, 
				'', '', '',  '', 0, 0 
			FROM viewPay_UserBatchStatus ubs inner join tblUserCompanyPayroll ucp on ubs.intUserID = ucp.intUserID
			WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID 
		END
	ELSE --DIRECT DEPOSIT
		BEGIN
		--SELECT THE PAY AMOUNT
		DECLARE @decNetPay decimal(18,2)
	
		--GET THE NET PAY TO VERIFY AMOUNTS
		SELECT @decNetPay = round(ubs.decBatchNetPay,2)  
		FROM viewPay_UserBatchStatus ubs inner join  tblUserDirectDeposit udd  on udd.intUserID = ubs.intUserID  inner join tblUserCompanyPayroll ucp on udd.intUserID = ucp.intUserID
		WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID
	

		--COMPUTE AND DIVIDE THE PERCENT AMOUNTS
		
		INSERT INTO [dbo].[tblUserPayChecks]
			(strBatchID, intUserID, dtPayDate, decCheckAmount, intPayCheckStatus, intCheckNumber, intPayMethodType, 
			intAccountType, strBankAccountNumber, strBankRoutingNumber, strBankName, decDepositPercent, decDepositAmount)
		SELECT ubs.strBatchID, ubs.intUserID, ubs.dtPayDate,  @decNetPay  as decCheckAmount, 0 as intPayCheckStatus,[dbo].[fnPay_GetNextDirectDeposit](@Payroll_Company) as intCheckNumber,ucp.intPayMethodType, 
			udd.intAccountType, udd.strBankAccountNumber, udd.strBankRoutingNumber,  udd.strBankName, udd.decDepositPercent, udd.decDepositAmount 
		FROM viewPay_UserBatchStatus ubs inner join  tblUserDirectDeposit udd  on udd.intUserID = ubs.intUserID  inner join tblUserCompanyPayroll ucp on udd.intUserID = ucp.intUserID
		WHERE ubs.strBatchID =   @BATCHID and ubs.intUserID = @USERID and udd.intSequenceNumber = @DIRECT_DEPOSIT_SEQUENCE_NUMBER
	
		END	
		--Mark the user batch as Check Created
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
			THROW 100000, 'Batch Not Ready To Create Pay Check.',1
			set @BatchCount = 0
		END
		return @Batchcount
	END
	
GO
