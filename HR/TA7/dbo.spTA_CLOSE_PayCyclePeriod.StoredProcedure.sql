USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spTA_CLOSE_PayCyclePeriod]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 08/02/2019
-- Description:	Closes a PayCyclePeriod.  Takes into acccount the Payroll Schedule ID
-- =============================================
CREATE PROCEDURE [dbo].[spTA_CLOSE_PayCyclePeriod]
	@PAYWEEKNUM INT,
	@PAYROLL_SCHEDULEID INT
-- WITH ENCRYPTION
AS

BEGIN
		DECLARE @PayCycleStatus  as nvarchar(50)

	--Get the paycycle status
		SELECT @PayCycleStatus = sStatus from tblPayCycleLog 
		WHERE  nPayWeekNum = @PAYWEEKNUM AND intPayrollScheduleID = @PAYROLL_SCHEDULEID
		if @PayCycleStatus = 'LOCKED'
		BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	    -- CREATE copy of tRportWeek to tReportWeekPaycycle
		INSERT INTO [dbo].[tReportWeekPayCycle]
           ([e_id] ,[e_idno],[e_name],[nPayRuleID],[sPayRuleName],[nPayWeekNum],[DTStartDate],[DTEndDate],[dblREGULAR],[dblONEHALF],[dblDOUBLE],[sHoursSummary]
           ,[sWeekID],[nDept],[sDeptName],[nCompID],[sCompanyName],[nEmployeeType],[sEmployeeTypeName],[nJobTitleID],[sJobTitleName],[nScheduleID],[sScheduleName],[nPayPeriod],[nReviewStatus])
		SELECT	
			[e_id],[e_idno],[e_name],[nPayRuleID],[sPayRuleName],[nPayWeekNum] ,[DTStartDate] ,[DTEndDate] ,[dblREGULAR] ,[dblONEHALF] ,[dblDOUBLE] ,[sHoursSummary]
			,[sWeekID] ,[nDept] ,[sDeptName] ,[nCompID] ,[sCompanyName] ,[nEmployeeType]  ,[sEmployeeTypeName] ,[nJobTitleID] ,[sJobTitleName] ,[nScheduleID] ,[sScheduleName] ,[nPayPeriod] ,[nReviewStatus] 
		FROM tReportWeek
		WHERE  [nPayWeekNum] = @PAYWEEKNUM AND nPayRuleID IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)  
	
	    -- CREATE copy of tPunchDate to tPunchDateDetail
		INSERT INTO [dbo].[tPunchDatePayCycle]
			(e_id, e_idno, e_name, e_group, nSchedID, DayID, DTPunchDate, dblPunchHrs, sType, b_Processed, 
			sPunchSummary, sExceptions, sDaySchedule, sHoursSummary, bLocked, dblREGULAR, dblONEHALF, dblDOUBLE, sWeekID, 
			nCompanyID, nDeptID, nEmployeeTypeID, nPayWeekNum)
		SELECT
			pdt.e_id, pdt.e_idno, pdt.e_name, pdt.e_group, pdt.nSchedID, pdt.DayID, pdt.DTPunchDate, pdt.dblPunchHrs, pdt.sType,pdt.b_Processed, 
			pdt.sPunchSummary, pdt.sExceptions, pdt.sDaySchedule, pdt.sHoursSummary, pdt.bLocked, pdt.dblREGULAR, pdt.dblONEHALF, pdt.dblDOUBLE, pdt.sWeekID, 
			pdt.nCompanyID, pdt.nDeptID, pdt.nEmployeeTypeID, rw.nPayWeekNum
		FROM tPunchDate pdt inner join tReportWeek rw on pdt.nWeekID = rw.nWeekID
		WHERE  rw.[nPayWeekNum] = @PAYWEEKNUM AND nPayRuleID IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)  

	    -- CREATE copy of tPunchDateDetail to tPunchDateDetailPayCycle
		INSERT iNTO tPunchDateDetailPayCycle
			(e_id, DTPunchDate, dblHours, sType, sExportCode, nPayWeekNum, nPayCycleType)
		SELECT 
			pdd.e_id, pdd.DTPunchDate, pdd.dblHours, pdd.sType, pdd.sExportCode, rw.nPayWeekNum, 0
		FROM tPunchDateDetail pdd inner join tReportWeek rw on pdd.nWeekID = rw.nWeekID
		WHERE  rw.[nPayWeekNum] = @PAYWEEKNUM AND nPayRuleID IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)  
		
		--Update PayCycleLog Status to Closed
		UPDATE tblPayCycleLog SET sStatus = 'CLOSED'
		WHERE  nPayWeekNum = @PAYWEEKNUM AND intPayrollScheduleID = @PAYROLL_SCHEDULEID

		COMMIT
	END TRY
		BEGIN CATCH
			ROLLBACK ;
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH
	END
	ELSE
		BEGIN;
		THROW 100000, 'Pay Cycle Period has not been Locked yet.  Please lock Pay Cycle first.',1
		END
END


GO
