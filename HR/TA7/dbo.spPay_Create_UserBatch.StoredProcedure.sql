USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserBatch]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Computes a full batch for a USEID, PAYWEEKNUM
-- Description:	Imports a PayweekNum from TimeAide and creates a Batch
--				Note: Each payweeknum will have its own associated batch.
--		@BATCHDID nvarchar(50) -- Company Batch
--		@COMPANYNAME  nvarchar(50),		--CompanyName
--		@BATCHDESCRIPTION  nvarchar(50),
--		@PAYWEEKNUM  int,				--PayWeek To import
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
--		@PAYDATE smalldatetime			--Pay Date
--		@UserID int						--User to import transactions
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Create_UserBatch]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@USERID int,
		@PAYWEEKNUM  int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50),
		@PAYMETHODTYPE int
-- WITH ENCRYPTION
AS

BEGIN
	DECLARE @SQL_SCRIPT NVARCHAR(MAX) --USED TO BE ABLE TO CHANGE THE DATABASE NAME
	DECLARE	@COMPANYNAME  nvarchar(50)
	DECLARE	@PAYDATE datetime

	--Check that the Payweek batch has not already been created.  If it has, then it cannot be paid in order to overwrite
	declare @BatchProcessedCode as int
	declare @UserBatchProcessedCode as int
	declare @PayCycleSchedule as int

	--	The batch must exist in order to process
	select @COMPANYNAME = strCompanyName, @PAYDATE = dtPayDate ,@BatchProcessedCode = intBatchStatus from tblBatch where strBatchID =  @BATCHID
	--	The User Batch must not exist in order to process
	select TOP(1) @UserBatchProcessedCode = intUserBatchStatus from tblUserBatch where strBatchID =  @BATCHID and (intUserID = @USERID  OR @USERID = 0)
	--Check if this is a paycycle payroll schedule or a regular schedule	
	select @PayCycleSchedule = intPayCycleSchedule from tblCompanyPayrollSchedules cps where strCompanyName = @COMPANYNAME
	
	--NO LONGER USED
	SET @PayCycleSchedule = 0

	declare @BatchCount as int
	if @UserBatchProcessedCode is null 
		SET @UserBatchProcessedCode = 0
	--Process only if the batch exists and has not been processed
	IF not @BatchProcessedCode is null and @UserBatchProcessedCode >= 0
		BEGIN TRY
			BEGIN TRAN
			DECLARE @RC int
				
		
		set @BatchCount = @@ROWCOUNT

		EXEC [dbo].[spPay_Compute_UserBatch] @BATCHID ,@USERID, @SUPERVISORID		,@SUPERVISORNAME

		----Import Transactions
		--EXECUTE @RC = [dbo].[spPay_Create_UserBatchTransactions] @BATCHID ,@USERID, @PAYWEEKNUM	,@SUPERVISORID		,@SUPERVISORNAME

		----Compute Compensations
		--EXECUTE @RC = [dbo].[spPay_Create_UserBatchCompensations]  @BATCHID,@USERID,@PAYDATE
			
		----Compute Withholdings
		--EXECUTE	@RC = [dbo].[spPay_Create_UserBatchWithholdings] @BATCHID,@USERID,@PAYDATE 
			
		----Create Pay Checks
		--IF @USERID = 0
		--BEGIN
		--		--Compute the PayChecks for all UserIDs
		--		DECLARE @LoopUserID int = 0
		--		WHILE(1 = 1)
		--		BEGIN
		--		SELECT @LoopUserID = MIN(ub.intUserID)
		--		FROM dbo.tblUserBatch ub 
		--		WHERE ub.strBatchID = @BATCHID and  ub.intUserID > @LoopUserID 
		--		IF @LoopUserID IS NULL BREAK
		--			EXEC	  [dbo].[spPay_Create_UserPayChecks]@BATCHID  ,@LoopUserID ,@SUPERVISORID  ,@SUPERVISORNAME
		--		END
		--END
		--ELSE
		--	EXECUTE [dbo].[spPay_Create_UserPayChecks]@BATCHID  ,@USERID  ,@SUPERVISORID  ,@SUPERVISORNAME

		----Mark UserBAtch as processed
		--UPDATE ub set  intUserBatchStatus = 1,intCompanyID =u.nCompanyID, intDepartmentID = u.nDeptID, intSubdepartmentID = u.nJobTitleID, intEmployeeTypeID = u.nEmployeeType from tblUserBatch ub inner join tuser u on ub.intUserID =u.id where strBatchID = @BATCHID AND (ub.intUserID = @USERID OR @USERID = 0)
	
		----Mark Batch as processed
		--IF @USERID = 0
		--	UPDATE tblBatch set [intBatchStatus] = 1   where strBatchID =  @BATCHID 

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
		THROW 100000, 'Batch has already been processed',1
		set @BatchCount = 0
		END
		return @Batchcount
	END


GO
