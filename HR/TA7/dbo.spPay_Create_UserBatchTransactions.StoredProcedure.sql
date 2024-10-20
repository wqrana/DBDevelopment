USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserBatchTransactions]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Converts Punchdatedetail or punchpairs to Batch Transactions
--				Note: Each payweeknum will have its own associated batch.
--		@BATCHID nvarchar(50) -- Company Batch
--		@UserID int						--User to import transactions
--		@PAYWEEKNUM  int,				--PayWeek To import
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Create_UserBatchTransactions]
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
	declare @PayDate as date
	declare @PayrollCompany as nvarchar(50)
	--	strBatchDescription holds the payperiod for the batch.  The BatchID is a unique GUID
--	select @BatchProcessedCode = intUserBatchStatus from tblUserBatch where strBatchID =  @BATCHID and intUserID = @USERID

	select @BatchProcessedCode = intBatchStatus,@PayDate =dtPayDate, @PayrollCompany = strCompanyName from tblBatch where strBatchID =  @BATCHID 
	
	declare @BatchCount as int

	--Process only if the user batch exists and has not been processed
	IF @BatchProcessedCode IS NULL
		BEGIN
		set @BatchCount = 0;
		THROW 100000, 'Batch does not exist ', 1
		END
	ELSE IF @BatchProcessedCode >= 0
		BEGIN TRY
			BEGIN TRAN
			--DELETE tblUserBatchTransactions
			IF @USERID = 0 --All Employees
				DELETE FROM tblUserBatchTransactions where strBatchID = @BATCHID 
			ELSE --Single Employee
				DELETE FROM tblUserBatchTransactions where strBatchID = @BATCHID and (intUserID = @USERID )

			DECLARE @JobCodeUse as int
			select @JobCodeUse  = nConfigParam from tSoftwareConfiguration where nConfigID = 1000
	
		if @JobCodeUse = 0
			-- Use tPunchDateDetail for payroll transactions
			BEGIN
			IF @USERID = 0
				--Create Batch Transactions: the trasactions that are to be paid once converted to CompensationItems
				INSERT INTO tblUserBatchTransactions  (strBatchID, intUserID, dtPunchDate, strTransactionType, decHours, decPayRate, decMoneyValue, intJobCode, dtTimeStamp)
				SELECT  @BATCHID,[UserID] ,[PunchDate],[TransName],[TransHours] ,[HourlyRate] ,[GrossPay] ,0, GetDate()  FROM viewPay_GrossPayRW_PDD WHERE nPayWeekNum  = @PAYWEEKNUM
				AND UserID IN (select intUserID from tblUserBatch where strBatchID = @BATCHID)
			ELSE
				--Create Batch Transactions: the trasactions that are to be paid once converted to CompensationItems
				INSERT INTO tblUserBatchTransactions  (strBatchID, intUserID, dtPunchDate, strTransactionType, decHours, decPayRate, decMoneyValue, intJobCode, dtTimeStamp)
				SELECT  @BATCHID,[UserID] ,[PunchDate],[TransName],[TransHours] ,[HourlyRate] ,[GrossPay] ,0, GetDate()  FROM viewPay_GrossPayRW_PDD WHERE nPayWeekNum  = @PAYWEEKNUM
				AND (UserID = @USERID )
			END
		ELSE
			-- Uses Job Codes so use tPunchPair for payroll transactions
			--MARTINAL  REGULAR Does not use job code
			--Create Batch Transactions: the trasactions that are to be paid once converted to CompensationItems
		IF @PayrollCompany = 'Cooperativa de Ahorro y Credito Oriental'
			-- Uses Job Codes so use tPunchPair for payroll transactions
			BEGIN 
			IF @USERID = 0 --All Employees
				INSERT INTO tblUserBatchTransactions  (strBatchID, intUserID, dtPunchDate, strTransactionType, decHours, decPayRate, decMoneyValue, intJobCode, dtTimeStamp)
				SELECT  @BATCHID,pp.e_id [UserID] ,pp.DTPunchDate [PunchDate],pp.sType [TransName],pp.HoursWorked [TransHours], ut.decHourlyRate [HourlyRate], ut.[decGrossPay] [GrossPay],pp.nJobCodeID, GetDate()  FROM 
				tPunchPair pp inner join tReportWeek rw on pp.nWeekID = rw.nWeekID 
				 CROSS apply[dbo].[fnPay_UserTransaction_GrossPay](pp.e_id, pp.DTPunchDate, pp.sType, pp.HoursWorked, pp.nJobCodeID) AS ut
				WHERE nPayWeekNum  = @PAYWEEKNUM					
				AND intUserID IN (select intUserID from tblUserBatch where strBatchID = @BATCHID)
			ELSE --Single Employee
				INSERT INTO tblUserBatchTransactions  (strBatchID, intUserID, dtPunchDate, strTransactionType, decHours, decPayRate, decMoneyValue, intJobCode, dtTimeStamp)
				SELECT  @BATCHID,pp.e_id [UserID] ,pp.DTPunchDate [PunchDate],pp.sType [TransName],pp.HoursWorked [TransHours], ut.decHourlyRate [HourlyRate], ut.[decGrossPay] [GrossPay],pp.nJobCodeID, GetDate()  FROM 
				tPunchPair pp inner join tReportWeek rw on pp.nWeekID = rw.nWeekID 
				 CROSS apply[dbo].[fnPay_UserTransaction_GrossPay](pp.e_id, pp.DTPunchDate, pp.sType, pp.HoursWorked, pp.nJobCodeID) AS ut
				WHERE nPayWeekNum  = @PAYWEEKNUM	AND (pp.e_id = @USERID)
			END
		ELSE
			--MARTINAL  REGULAR Does not use job code
			BEGIN 
			IF @USERID = 0
				INSERT INTO tblUserBatchTransactions  (strBatchID, intUserID, dtPunchDate, strTransactionType, decHours, decPayRate, decMoneyValue, intJobCode, dtTimeStamp)
				SELECT  @BATCHID,[UserID] ,[PunchDate],[TransName],[TransHours] ,[HourlyRate] ,[GrossPay] ,0, GetDate()  FROM viewPay_GrossPayRW_PDD WHERE nPayWeekNum  = @PAYWEEKNUM
				AND UserID IN (select intUserID from tblUserBatch where strBatchID = @BATCHID)
			ELSE
				INSERT INTO tblUserBatchTransactions  (strBatchID, intUserID, dtPunchDate, strTransactionType, decHours, decPayRate, decMoneyValue, intJobCode, dtTimeStamp)
				SELECT  @BATCHID,[UserID] ,[PunchDate],[TransName],[TransHours] ,[HourlyRate] ,[GrossPay] ,0, GetDate()  FROM viewPay_GrossPayRW_PDD WHERE nPayWeekNum  = @PAYWEEKNUM
				AND (UserID = @USERID)
			END
			
			set @BatchCount = @@ROWCOUNT;
			
			--Employees that cross companies may have data from previous company that causes problems.  Need to delete by date, not week
			DECLARE @STARTDATE date
			DECLARE @ENDDATE date 
			SELECT top(1) @STARTDATE = DTStartDate, @ENDDATE= DTEndDate FROM tReportWeek  WHERE nPayWeekNum  = @PAYWEEKNUM and (e_id = @USERID OR @USERID = 0)
			
			-- DELETE FROM tblReportWeek before adding
			IF @USERID = 0 --	ALL Employees
				BEGIN
					DELETE FROM tblReportWeek  WHERE strBatchID = @BATCHID
					DELETE FROM tblReportWeek  WHERE nPayWeekNum  = @PAYWEEKNUM and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)

					INSERT INTO tblReportWeek (e_id, e_idno, e_name, nPayRuleID, sPayRuleName, nPayWeekNum, DTStartDate, DTEndDate, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sHoursSummary, sWeekID, nDept, sDeptName, nCompID, 
									sCompanyName, nEmployeeType, sEmployeeTypeName, nJobTitleID, sJobTitleName, nScheduleID, 
									sScheduleName, nPayPeriod, nReviewStatus, nReviewSupervisorID, sSupervisorName, nWeekID, 
									dblMEAL, dblOTHERS, nLocked, strBatchID,boolDeleted)
					SELECT  e_id, e_idno, e_name, nPayRuleID, sPayRuleName, nPayWeekNum, DTStartDate, DTEndDate, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sHoursSummary, sWeekID, nDept, sDeptName, nCompID, 
									sCompanyName, nEmployeeType, sEmployeeTypeName, nJobTitleID, sJobTitleName, nScheduleID, 
									sScheduleName, nPayPeriod, nReviewStatus, nReviewSupervisorID, sSupervisorName, nWeekID, dblMEAL, dblOTHERS, nLocked, @BATCHID, 0
					FROM tReportWeek 
					WHERE nPayWeekNum  = @PAYWEEKNUM and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)
				END
			ELSE --	Single Employee
				BEGIN
					DELETE FROM tblReportWeek  WHERE strBatchID = @BATCHID and e_id = @USERID 
					DELETE FROM tblReportWeek  WHERE nPayWeekNum  = @PAYWEEKNUM and e_id = @USERID 
					INSERT INTO tblReportWeek (e_id, e_idno, e_name, nPayRuleID, sPayRuleName, nPayWeekNum, DTStartDate, DTEndDate, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sHoursSummary, sWeekID, nDept, sDeptName, nCompID, 
									sCompanyName, nEmployeeType, sEmployeeTypeName, nJobTitleID, sJobTitleName, nScheduleID, 
									sScheduleName, nPayPeriod, nReviewStatus, nReviewSupervisorID, sSupervisorName, nWeekID, 
									dblMEAL, dblOTHERS, nLocked, strBatchID,boolDeleted)
					SELECT  e_id, e_idno, e_name, nPayRuleID, sPayRuleName, nPayWeekNum, DTStartDate, DTEndDate, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sHoursSummary, sWeekID, nDept, sDeptName, nCompID, 
									sCompanyName, nEmployeeType, sEmployeeTypeName, nJobTitleID, sJobTitleName, nScheduleID, 
									sScheduleName, nPayPeriod, nReviewStatus, nReviewSupervisorID, sSupervisorName, nWeekID, dblMEAL, dblOTHERS, nLocked, @BATCHID, 0
					FROM tReportWeek 
					WHERE nPayWeekNum  = @PAYWEEKNUM and (e_id = @USERID)
				END


			--DELETE FROM tblPunchDate before adding
			IF @USERID = 0 --All Employees
			BEGIN
				DELETE FROM tblPunchDate WHERE strBatchID= @BATCHID
				DELETE FROM tblPunchDate WHERE DtPunchDate BETWEEN @STARTDATE AND @ENDDATE and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)
				DELETE FROM tblPunchDate WHERE [intPayWeekNum] = @PAYWEEKNUM and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)

				INSERT INTO tblPunchDate (e_id, e_idno, e_name, e_group, nSchedID, DayID, DtPunchDate, dblPunchHrs, sType, 
									b_Processed, sPunchSummary, sExceptions, sDaySchedule, sHoursSummary, bLocked, 
									dblREGULAR, dblONEHALF, dblDOUBLE, sWeekID, nCompanyID, nDeptID, nEmployeeTypeID, 
									dblMEAL, dblOTHERS, nAbsentStatus, nJobTitleID, nWeekID, intPayWeekNum, strBatchID)
				SELECT					pdt.e_id, pdt.e_idno, pdt.e_name, e_group, nSchedID, DayID, DTPunchDate, dblPunchHrs, sType, 
									b_Processed, sPunchSummary, sExceptions, sDaySchedule, pdt.sHoursSummary, bLocked, 
									pdt.dblREGULAR, pdt.dblONEHALF, pdt.dblDOUBLE, pdt.sWeekID, nCompanyID, nDeptID, nEmployeeTypeID, 
									pdt.dblMEAL, pdt.dblOTHERS, nAbsentStatus, pdt.nJobTitleID, pdt.nWeekID, @PAYWEEKNUM, @BATCHID
				FROM tPunchDate pdt  INNER JOIN tReportWeek rw ON pdt.nWeekID = rw.nWeekID
				WHERE rw.nPayWeekNum  = @PAYWEEKNUM 				
				and pdt.e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)
			END
			ELSE --Single Employee
			BEGIN
				DELETE FROM tblPunchDate WHERE strBatchID= @BATCHID and e_id = @USERID
				DELETE FROM tblPunchDate WHERE DtPunchDate BETWEEN @STARTDATE AND @ENDDATE and (e_id = @USERID )
				DELETE FROM tblPunchDate WHERE [intPayWeekNum] = @PAYWEEKNUM and (e_id = @USERID )
			
				--Insert Punchdate
				INSERT INTO tblPunchDate (e_id, e_idno, e_name, e_group, nSchedID, DayID, DtPunchDate, dblPunchHrs, sType, 
										b_Processed, sPunchSummary, sExceptions, sDaySchedule, sHoursSummary, bLocked, 
										dblREGULAR, dblONEHALF, dblDOUBLE, sWeekID, nCompanyID, nDeptID, nEmployeeTypeID, 
										dblMEAL, dblOTHERS, nAbsentStatus, nJobTitleID, nWeekID, intPayWeekNum, strBatchID)
				SELECT					pdt.e_id, pdt.e_idno, pdt.e_name, e_group, nSchedID, DayID, DTPunchDate, dblPunchHrs, sType, 
										b_Processed, sPunchSummary, sExceptions, sDaySchedule, pdt.sHoursSummary, bLocked, 
										pdt.dblREGULAR, pdt.dblONEHALF, pdt.dblDOUBLE, pdt.sWeekID, nCompanyID, nDeptID, nEmployeeTypeID, 
										pdt.dblMEAL, pdt.dblOTHERS, nAbsentStatus, pdt.nJobTitleID, pdt.nWeekID, @PAYWEEKNUM, @BATCHID
				FROM tPunchDate pdt  INNER JOIN tReportWeek rw ON pdt.nWeekID = rw.nWeekID
				WHERE rw.nPayWeekNum  = @PAYWEEKNUM 
				AND (rw.e_id = @USERID)
			END


			IF @USERID = 0 --All Employees
			BEGIN
				--DELETE FROM tblPunchDateDetail before adding
				DELETE FROM tblPunchDateDetail WHERE strBatchID = @BATCHID
				DELETE FROM tblPunchDateDetail WHERE DtPunchDate BETWEEN @STARTDATE AND @ENDDATE and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)
				DELETE FROM tblPunchDateDetail WHERE intPayWeekNum = @PAYWEEKNUM and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)
				--ADD tblPunchDateDetail all employees
				INSERT INTO tblPunchDateDetail (e_id, DtPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, nWeekID, sNote, nCompensationStatus, 
										nAccrualStatus, dblHoursOriginal, nAttendanceLetterCode, nTardinessLetterCode, intPayWeekNum,strBatchID)
				SELECT 							pdd.e_id, DTPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, pdd.nWeekID, sNote, nCompensationStatus, 
										nAccrualStatus, dblHoursOriginal, nAttendanceLetterCode, nTardinessLetterCode, @PAYWEEKNUM ,@BATCHID
				FROM tPunchDateDetail pdd  INNER JOIN tReportWeek rw ON pdd.nWeekID = rw.nWeekID
				WHERE rw.nPayWeekNum  = @PAYWEEKNUM 
				and pdd.e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)

			END
			ELSE--Single Employee
			BEGIN
				--DELETE FROM tblPunchDateDetail before adding
				DELETE FROM tblPunchDateDetail WHERE strBatchID = @BATCHID and e_id = @USERID
				DELETE FROM tblPunchDateDetail WHERE DtPunchDate BETWEEN @STARTDATE AND @ENDDATE and (e_id = @USERID )
				DELETE FROM tblPunchDateDetail WHERE intPayWeekNum = @PAYWEEKNUM and (e_id = @USERID )
				--ADD tblPunchDateDetail  single employee
				INSERT INTO tblPunchDateDetail (e_id, DtPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, nWeekID, sNote, nCompensationStatus, 
										nAccrualStatus, dblHoursOriginal, nAttendanceLetterCode, nTardinessLetterCode, intPayWeekNum,strBatchID)
				SELECT 							pdd.e_id, DTPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, pdd.nWeekID, sNote, nCompensationStatus, 
										nAccrualStatus, dblHoursOriginal, nAttendanceLetterCode, nTardinessLetterCode, @PAYWEEKNUM ,@BATCHID
				FROM tPunchDateDetail pdd  INNER JOIN tReportWeek rw ON pdd.nWeekID = rw.nWeekID
				WHERE rw.nPayWeekNum  = @PAYWEEKNUM 
				AND (rw.e_id = @USERID)
			END



			--DELETE FROM tblPunchPair before adding
			IF @USERID = 0 --All Employees
			BEGIN
				DELETE FROM tblPunchPair  where strBatchID = @BATCHID
				DELETE FROM tblPunchPair WHERE DtPunchDate BETWEEN @STARTDATE AND @ENDDATE and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)
				DELETE FROM tblPunchPair WHERE intPayWeekNum = @PAYWEEKNUM and e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)

				INSERT INTO tblPunchPair (e_id, e_idno, e_name, DtPunchDate, DTimeIn, DTimeOut, HoursWorked, sType, pCode, b_Processed, 
											DayID, bTrans, sTCode, sTDesc, sTimeIn, sTimeOut, nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, 
											nHRProcessedCode, nHRReportCode, nJobCodeID , intPayWeekNum, strBatchID)
				SELECT							pp.e_id, pp.e_idno, pp.e_name, DTPunchDate, DTimeIn, DTimeOut, HoursWorked, sType, pCode, b_Processed, 
											DayID, bTrans, sTCode, sTDesc, sTimeIn, sTimeOut, pp.nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, 
											nHRProcessedCode, nHRReportCode, nJobCodeID,@PAYWEEKNUM, @BATCHID
				FROM tPunchPair  pp  INNER JOIN tReportWeek rw ON pp.nWeekID = rw.nWeekID
				WHERE rw.nPayWeekNum  = @PAYWEEKNUM 
				and pp.e_id in (select intuserid from tblUserBatch where strBatchID = @BATCHID)

			END
			ELSE--Single Employee
			BEGIN
				DELETE FROM tblPunchPair  where strBatchID = @BATCHID and e_id = @USERID
				DELETE FROM tblPunchPair WHERE DtPunchDate BETWEEN @STARTDATE AND @ENDDATE and (e_id = @USERID )
				DELETE FROM tblPunchPair WHERE intPayWeekNum = @PAYWEEKNUM and (e_id = @USERID )

				INSERT INTO tblPunchPair (e_id, e_idno, e_name, DtPunchDate, DTimeIn, DTimeOut, HoursWorked, sType, pCode, b_Processed, 
											DayID, bTrans, sTCode, sTDesc, sTimeIn, sTimeOut, nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, 
											nHRProcessedCode, nHRReportCode, nJobCodeID , intPayWeekNum, strBatchID)
				SELECT							pp.e_id, pp.e_idno, pp.e_name, DTPunchDate, DTimeIn, DTimeOut, HoursWorked, sType, pCode, b_Processed, 
											DayID, bTrans, sTCode, sTDesc, sTimeIn, sTimeOut, pp.nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, 
											nHRProcessedCode, nHRReportCode, nJobCodeID,@PAYWEEKNUM, @BATCHID
				FROM tPunchPair  pp  INNER JOIN tReportWeek rw ON pp.nWeekID = rw.nWeekID
				WHERE rw.nPayWeekNum  = @PAYWEEKNUM 
				AND (rw.e_id = @USERID )

			END


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
	THROW 100000, 'Batch is Closed.',1
	END
	return @Batchcount
END

GO
