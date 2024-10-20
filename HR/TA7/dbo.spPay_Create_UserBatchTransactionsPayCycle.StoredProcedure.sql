USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserBatchTransactionsPayCycle]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Imports a PayweekNum from TimeAide PayCycle and creates a Batch
--				Note: Each payweeknum will have its own associated batch.
--		@BATCHID nvarchar(50) -- Company Batch
--		@COMPANYNAME  nvarchar(50),		--CompanyName
--		@BATCHDESCRIPTION  nvarchar(50),
--		@PAYWEEKNUM  int,				--PayWeek To import
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
--		@PAYDATE smalldatetime			--Pay Date
--		@UserID int						--User to import transactions
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Create_UserBatchTransactionsPayCycle]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@USERID int,
		@PAYWEEKNUM  int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
	DECLARE @SQL_SCRIPT NVARCHAR(MAX) --USED TO BE ABLE TO CHANGE THE DATABASE NAME

	--Check that the Payweek batch has not already been created.  If it has, then it cannot be paid in order to overwrite
	declare @BatchProcessedCode as int
	--	strBatchDescription holds the payperiod for the batch.  The BatchID is a unique GUID
	select @BatchProcessedCode = intUserBatchStatus from tblUserBatch where strBatchID =  @BATCHID and intUserID = @USERID
	
	declare @BatchCount as int

	--Process only if the user batch exists and has not been processed
	IF @BatchProcessedCode IS NULL
		BEGIN
		set @BatchCount = 0;
		THROW 100000, 'Batch does not exist ', 1
		END
	ELSE IF @BatchProcessedCode = 0
		BEGIN TRY
			BEGIN TRAN
			--Create Batch Transactions: the trasactions that are to be paid once converted to CompensationItems
			INSERT INTO tblUserBatchTransactions  (strBatchID, intUserID, dtPunchDate, strTransactionType, decHours, decPayRate, decMoneyValue, intJobCode, dtTimeStamp)
			SELECT  @BATCHID,[UserID] ,[PunchDate],[TransName],[TransHours] ,[HourlyRate] ,[GrossPay] ,0, GetDate()  FROM viewPay_GrossPayRW_PDD_PayCycle WHERE nPayWeekNum  = @PAYWEEKNUM
			AND UserID = @USERID
			set @BatchCount = @@ROWCOUNT;

			INSERT INTO tblReportWeek (e_id, e_idno, e_name, nPayRuleID, sPayRuleName, nPayWeekNum, DTStartDate, DTEndDate, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sHoursSummary, sWeekID, nDept, sDeptName, nCompID, 
									sCompanyName, nEmployeeType, sEmployeeTypeName, nJobTitleID, sJobTitleName, nScheduleID, 
									sScheduleName, nPayPeriod, nReviewStatus, nReviewSupervisorID, sSupervisorName, nWeekID, 
									dblMEAL, dblOTHERS, nLocked, strBatchID,boolDeleted)
			SELECT  e_id, e_idno, e_name, nPayRuleID, sPayRuleName, nPayWeekNum, DTStartDate, DTEndDate, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sHoursSummary, sWeekID, nDept, sDeptName, nCompID, 
									sCompanyName, nEmployeeType, sEmployeeTypeName, nJobTitleID, sJobTitleName, nScheduleID, 
									sScheduleName, nPayPeriod, nReviewStatus, 0, '', sWeekID, 0, 0, 0, @BATCHID, 0
			FROM tReportWeekPayCycle
			WHERE nPayWeekNum  = @PAYWEEKNUM and e_id = @USERID

			INSERT INTO tblPunchDate (e_id, e_idno, e_name, e_group, nSchedID, DayID, DtPunchDate, dblPunchHrs, sType, 
									b_Processed, sPunchSummary, sExceptions, sDaySchedule, sHoursSummary, bLocked, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sWeekID, nCompanyID, nDeptID, nEmployeeTypeID, 
									dblMEAL, dblOTHERS, nAbsentStatus, nJobTitleID, nWeekID, intPayWeekNum, strBatchID)
			SELECT					pdt.e_id, pdt.e_idno, pdt.e_name, e_group, nSchedID, DayID, DTPunchDate, dblPunchHrs, sType, 
									b_Processed, sPunchSummary, sExceptions, sDaySchedule, pdt.sHoursSummary, bLocked, 
									pdt.dblREGULAR, pdt.dblONEHALF, pdt.dblDOUBLE, pdt.sWeekID, nCompanyID, nDeptID, nEmployeeTypeID, 
									0, 0, 0, 0, pdt.sWeekID, @PAYWEEKNUM, @BATCHID
			FROM tPunchDatePayCycle pdt  INNER JOIN tReportWeekPayCycle rw ON pdt.sWeekID = rw.sWeekID
			WHERE rw.nPayWeekNum  = @PAYWEEKNUM and rw.e_id = @USERID

			INSERT INTO tblPunchDateDetail (e_id, DtPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, nWeekID, sNote, nCompensationStatus, 
										nAccrualStatus, dblHoursOriginal, nAttendanceLetterCode, nTardinessLetterCode, intPayWeekNum,strBatchID)
			SELECT 							pdd.e_id, pdd.DTPunchDate, pdd.dblHours, pdd.sType, sExportCode, 0, pdt.sWeekID, '', 0, 
										0, 0, 0, 0, @PAYWEEKNUM ,@BATCHID
			FROM tPunchDateDetailPayCycle pdd  INNER JOIN tPunchDatePayCycle pdt ON pdd.e_id= pdt.e_id and pdd.DTPunchDate = pdt.DTPunchDate 
			inner join tReportWeekPayCycle rw on pdt.sWeekID = rw.sWeekID
			WHERE rw.nPayWeekNum  = @PAYWEEKNUM and rw.e_id = @USERID

			INSERT INTO tblPunchPair (e_id, e_idno, e_name, DtPunchDate, DTimeIn, DTimeOut, HoursWorked, sType, pCode, b_Processed, 
										DayID, bTrans, sTCode, sTDesc, sTimeIn, sTimeOut, nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, 
										nHRProcessedCode, nHRReportCode, nJobCodeID , intPayWeekNum, strBatchID)
			SELECT							pp.e_id, pp.e_idno, pp.e_name, DTPunchDate, DTimeIn, DTimeOut, HoursWorked, sType, pCode, b_Processed, 
										DayID, bTrans, sTCode, sTDesc, sTimeIn, sTimeOut, pp.nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, 
										nHRProcessedCode, nHRReportCode, nJobCodeID,@PAYWEEKNUM, @BATCHID
			FROM tPunchPair  pp  INNER JOIN tReportWeekPayCycle rw ON pp.nWeekID = rw.sWeekID
			WHERE rw.nPayWeekNum  = @PAYWEEKNUM and rw.e_id = @USERID

			--Update Batch to indicate where processed		
			--UPDATE tblUserBatch SET intUserBatchStatus = 1 where strBatchID =  @BATCHID AND intUserID = @USERID

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
	set @BatchCount = 0;
	THROW 100000, 'Batch has already been processed',1
	END
	return @Batchcount
END


GO
