USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[procChangeUserID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procChangeUserID]
(
@OldUserID as int,
@NewUserID as int)
AS
IF NOT (SELECT COUNT(id) FROM tuser WHERE id = @NewUserID) > 0
BEGIN
	UPDATE tAuditInfo SET nUserIDAffected = @NewUserID WHERE nUserIDAffected = @OldUserID
	UPDATE tAuditInfo SET nAdminID = @NewUserID WHERE nAdminID = @OldUserID
	UPDATE tblGeoTerminalUsers SET intUserID = @NewUserID WHERE intUserID = @OldUserID
	UPDATE tBultosWeekEntry SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tSchedDailyDetail SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tSchedModDailyDetail SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tSchedModDailyDetail SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tSchedModDailyTempl SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tSchedModPeriodSumm SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tSchedModPeriodSumm SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tScheduleSched SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tScheduleSched SET nAdminID = @NewUserID WHERE nAdminID = @OldUserID
	UPDATE tUserAccrual SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tuserCF SET id = @NewUserID WHERE id = @OldUserID
	UPDATE tUserCompanyRestriction SET nUserID = @NewUserID WHERE nuserid = @OldUserID
	UPDATE tUserExtended SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tUserInternetAccess SET nUserID = @NewUserID WHERE nuserid = @OldUserID
	UPDATE tUserSchedules SET nUserid = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tUserSupervisors SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tUserSupervisors SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	-- Punches Data
	UPDATE tEnter SET e_id = @NewUserID WHERE e_id = @OldUserID
	UPDATE tPayCycleLog SET nAdminID = @NewUserID WHERE nAdminID = @OldUserID
	UPDATE tPunchData SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tPunchData SET nAdminID = @NewUserID WHERE nAdminID = @OldUserID
	UPDATE tPunchDate SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tPunchDateDetail SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tPunchDateDetailPayCycle SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tPunchDatePayCycle SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tPunchPair SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tPunchWeek SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tReportWeek SET e_id= @NewUserID WHERE e_id = @OldUserID
	UPDATE tReportWeek SET nReviewSupervisorID = @NewUserID WHERE nReviewSupervisorID = @OldUserID
	UPDATE tReportWeekPayCycle SET e_id= @NewUserID WHERE e_id = @OldUserID
	-- Compensation Tables
	UPDATE tAccrualsComputationLog SET intUserID = @NewUserID WHERE intUserID = @OldUserID
	UPDATE tAccrualsComputationLog SET intAdminID = @NewUserID WHERE intAdminID = @OldUserID
	UPDATE tAccrualsComputationLog_Prev SET intUserID = @NewUserID WHERE intUserID = @OldUserID
	UPDATE tAccrualsComputationLog_Prev SET intAdminID = @NewUserID WHERE intAdminID = @OldUserID
	UPDATE tCompensationComputationLog SET intUserID = @NewUserID WHERE intUserID = @OldUserID
	UPDATE tCompensationComputationLog SET intAdminID = @NewUserID WHERE intAdminID = @OldUserID
	UPDATE tUserCompensation SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tUserCompensationAdjust SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tUserCompensationAdjust SET nDonorUserID = @NewUserID WHERE nDonorUserID = @OldUserID
	UPDATE tUserCompensationMonthly SET nUserID = @NewUserID WHERE nUserid = @OldUserID
	-- Letters Tables
	UPDATE tAttendanceLetterComputation SET nSupervisorrID = @NewUserID WHERE nSupervisorrID = @OldUserID
	UPDATE tAttendanceLetters SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tAttendanceLetters SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tAttendanceTransactions SET e_id = @NewUserID WHERE e_id = @OldUserID
	UPDATE tHLAttendanceLetterGeneration SET nSupervisorrID = @NewUserID WHERE nSupervisorrID = @OldUserID
	UPDATE tHLJobCertificationRequest SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tHLTardinessLetterGeneration SET nSupervisorrID = @NewUserID WHERE nSupervisorrID = @OldUserID
	UPDATE tHLTransDailyDetail SET e_id = @NewUserID WHERE e_id = @OldUserID
	UPDATE tHLTransDailyDetail SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tTardinessDetails SET e_id = @NewUserID WHERE e_id = @OldUserID
	UPDATE tTardinessLetter SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tTardinessLetter SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tTardinessLetterComputation SET nSupervisorrID = @NewUserID WHERE nSupervisorrID = @OldUserID
	UPDATE tTardinessLetters SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tTardinessLetters SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID
	UPDATE tTardinessTransactions SET e_id = @NewUserID WHERE e_id = @OldUserID
	UPDATE tUserAttendanceRules SET nUserID = @NewUserID WHERE nuserid = @OldUserID
	UPDATE tWarningLetter SET nUserID = @NewUserID WHERE nUserID = @OldUserID
	UPDATE tWarningLetter SET nSupervisorID = @NewUserID WHERE nSupervisorID = @OldUserID



	/****** Object:  Index [PK_tuser]    Script Date: 09/02/2011 11:46:29 ******/
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tuser]') AND name = N'PK_tuser')
	ALTER TABLE [dbo].[tuser] DROP CONSTRAINT [PK_tuser]

	UPDATE tuser SET id = @NewUserID WHERE id = @OldUserID

	/****** Object:  Index [PK_tuser]    Script Date: 09/02/2011 11:46:29 ******/
	IF  NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tuser]') AND name = N'PK_tuser')
	ALTER TABLE [dbo].[tuser] ADD  CONSTRAINT [PK_tuser] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO
