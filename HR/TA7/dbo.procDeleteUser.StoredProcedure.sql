USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[procDeleteUser]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procDeleteUser]
(
@UserID as int)
AS
BEGIN
	DELETE FROM tAuditInfo WHERE nUserIDAffected = @UserID
	DELETE FROM tblGeoTerminalUsers WHERE intUserID = @UserID
	DELETE FROM tBultosWeekEntry WHERE nUserID = @UserID
	DELETE FROM tSchedModDailyDetail WHERE nUserID = @UserID
	DELETE FROM tSchedModPeriodSumm WHERE nUserID = @UserID
	DELETE FROM tScheduleSched WHERE nUserID = @UserID
	DELETE FROM tUserAccrual WHERE nUserID = @UserID
	DELETE FROM tuserCF WHERE id = @UserID
	DELETE FROM tUserCompanyRestriction WHERE nuserid = @UserID
	DELETE FROM tUserExtended WHERE nUserID = @UserID
	DELETE FROM tUserInternetAccess WHERE nuserid = @UserID
	DELETE FROM tUserSchedules WHERE nUserID = @UserID
	DELETE FROM tUserSupervisors WHERE nUserID = @UserID
	DELETE FROM tUserSupervisors WHERE nSupervisorID = @UserID
	-- Punches Data
	DELETE FROM tEnter WHERE e_id = @UserID
	DELETE FROM tPunchData WHERE e_id = @UserID
	DELETE FROM tPunchDate WHERE e_id = @UserID
	DELETE FROM tPunchDateDetail WHERE e_id = @UserID
	DELETE FROM tPunchDateDetailPayCycle WHERE e_id = @UserID
	DELETE FROM tPunchDatePayCycle WHERE e_id = @UserID
	DELETE FROM tPunchPair WHERE e_id = @UserID
	DELETE FROM tPunchWeek WHERE e_id = @UserID
	DELETE FROM tReportWeek WHERE e_id = @UserID
	DELETE FROM tReportWeekPayCycle WHERE e_id = @UserID
	-- Compensation Tables
	DELETE FROM tAccrualsComputationLog WHERE intUserID = @UserID
	DELETE FROM tAccrualsComputationLog_Prev WHERE intUserID = @UserID
	DELETE FROM tCompensationComputationLog WHERE intUserID = @UserID
	DELETE FROM tUserCompensation WHERE nUserID = @UserID
	DELETE FROM tUserCompensationAdjust WHERE nUserID = @UserID
	DELETE FROM tUserCompensationMonthly WHERE nUserid = @UserID
	-- Letters Tables
	DELETE FROM tAttendanceLetters WHERE nUserID = @UserID
	DELETE FROM tAttendanceTransactions WHERE e_id = @UserID
	DELETE FROM tHLJobCertificationRequest WHERE nUserID = @UserID
	DELETE FROM tHLTransDailyDetail WHERE e_id = @UserID
	DELETE FROM tTardinessDetails WHERE e_id = @UserID
	DELETE FROM tTardinessLetter WHERE nUserID = @UserID
	DELETE FROM tTardinessLetters WHERE nUserID = @UserID
	DELETE FROM tTardinessTransactions WHERE e_id = @UserID
	DELETE FROM tUserAttendanceRules WHERE nuserid = @UserID
	DELETE FROM tWarningLetter WHERE nUserID = @UserID
	-- tUser
	DELETE FROM tUser WHERE id = @UserId
END
GO
