USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Compute_UserBatch]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Computes a full batch for a USEID, PAYWEEKNUM
-- Description:	UserBatch must have been created already.  It computes the batch made.
--		@BATCHDID nvarchar(50) -- Company Batch
--		@UserID int						--User to import transactions
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Compute_UserBatch]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@USERID int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
	DECLARE @SQL_SCRIPT NVARCHAR(MAX) --USED TO BE ABLE TO CHANGE THE DATABASE NAME
	DECLARE	@COMPANYNAME  nvarchar(50)
	DECLARE	@PAYDATE datetime
	DECLARE	@PAYWEEKNUM  int
	--DECLARE	@PAYMETHODTYPE int

	--Check that the Payweek batch has not already been created.  If it has, then it cannot be paid in order to overwrite
	declare @BatchProcessedCode as int
	declare @UserBatchProcessedCode as int
	declare @PayCycleSchedule as int

	--	The User Batch must  exist in order to process
	select top(1) @COMPANYNAME = strCompanyName, @PAYDATE = dtPayDate ,@BatchProcessedCode = intBatchStatus , @UserBatchProcessedCode = intUserBatchStatus, @PAYWEEKNUM = intPayWeekNum 
	from viewPay_UserBatchStatus where strBatchID =  @BATCHID and (intUserID = @USERID OR @USERID =0)
			
	declare @BatchCount as int
	if @UserBatchProcessedCode is null 
		SET @UserBatchProcessedCode = -1
	
	--Process only if the batch exists and has not been processed
	IF not @BatchProcessedCode is null and @UserBatchProcessedCode >= 0
		BEGIN TRY
			BEGIN TRAN
			DECLARE @RC int
		
		--Import Transactions
		EXECUTE @RC = [dbo].[spPay_Create_UserBatchTransactions] @BATCHID ,@USERID, @PAYWEEKNUM	,@SUPERVISORID		,@SUPERVISORNAME

		--Compute Compensations
		EXECUTE @RC = [dbo].[spPay_Create_UserBatchCompensations]  @BATCHID,@USERID,@PAYDATE
			
		--Compute Withholdings
		EXECUTE	@RC = [dbo].[spPay_Create_UserBatchWithholdings] @BATCHID,@USERID,@PAYDATE 
			
		--Compute any GL Accounts, if necesary
		EXECUTE [dbo].[spPay_Adjust_GLAccounts]@BATCHID  ,@USERID  
		--Create Pay Checks
		IF @USERID = 0
		BEGIN
				--Compute the PayChecks for all UserIDs
				DECLARE @LoopUserID int = 0
				WHILE(1 = 1)
				BEGIN
				SELECT @LoopUserID = MIN(ub.intUserID)
				FROM dbo.tblUserBatch ub 
				WHERE ub.strBatchID = @BATCHID and  ub.intUserID > @LoopUserID 
				IF @LoopUserID IS NULL BREAK
					EXEC	  [dbo].[spPay_Create_UserPayChecks]@BATCHID  ,@LoopUserID ,@SUPERVISORID  ,@SUPERVISORNAME
				END
		END
		ELSE
			EXECUTE [dbo].[spPay_Create_UserPayChecks]@BATCHID  ,@USERID  ,@SUPERVISORID  ,@SUPERVISORNAME

		
		--Mark User batch as processed
		UPDATE tblUserBatch set [intUserBatchStatus] = 1   where strBatchID =  @BATCHID and (intUserID = @USERID OR @USERID = 0)

		--Mark Batch as processed
		IF @USERID = 0
			UPDATE tblBatch set [intBatchStatus] = 1   where strBatchID =  @BATCHID 

	--Commit the transaction
		COMMIT
		 SELECT 0 AS ErrorNumber,'' AS ErrorMessage
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
		THROW 100000, 'User Batch does not exist.',1
		set @BatchCount = 0
		END
		return @Batchcount
	END


GO
