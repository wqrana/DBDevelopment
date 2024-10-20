USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Insert_UserBatch]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Inserts an employee into a batch
--		@BATCHDID nvarchar(50) -- Company Batch
--		@UserID int						--User to import transactions
--		@PAYWEEKNUM  int,				--PayWeek To import or 0
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
--		@@PAYMETHODTYPE smalldatetime			-- 0 for default
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Insert_UserBatch]
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
	select @UserBatchProcessedCode = intUserBatchStatus from tblUserBatch where strBatchID =  @BATCHID and intUserID = @USERID
	--Check if this is a paycycle payroll schedule or a regular schedule	
	select @PayCycleSchedule = intPayCycleSchedule from tblCompanyPayrollSchedules cps inner join tblUserCompanyPayroll ucp on cps.strCompanyName = ucp.strCompanyName where intUserID = @USERID
	
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
			DECLARE @StartDate as date
			DECLARE @EndDate as date			
			if @PAYWEEKNUM <> 0
				BEGIN
					select @StartDate= DTStartDate, @EndDate = DTEndDate from tReportWeek where e_id = @USERID and nPayWeekNum = @PAYWEEKNUM
				END
			ELSE
				BEGIN
					SET @StartDate = @PAYDATE
					SET @EndDate = @PAYDATE
				END
		
			--Delete the batch and create again to update the data
			DELETE FROM tblUserBatch WHERE strBatchID = @BATCHID and intUserID = @USERID

			--Create user Batch
			INSERT into tblUserBatch (intUserID, strBatchID, intPayWeekNum, intUserBatchStatus, dtStartDatePeriod, dtEndDatePeriod, intCompanyID, intDepartmentID, intSubdepartmentID, intEmployeeTypeID, intPayMethodType) --VALUES (@USERID,@BATCHID,@PAYWEEKNUM,0,@StartDate,@EndDate)
			SELECT @USERID,@BATCHID,@PAYWEEKNUM,0,@StartDate,@EndDate, nCompanyID, nDeptID,nJobTitleID,nEmployeeType,@PAYMETHODTYPE from tuser where id = @USERID
		
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
		BEGIN
		THROW 100000, 'Batch has already been processed',1
		set @BatchCount = 0
		END
		return @Batchcount
	END


GO
