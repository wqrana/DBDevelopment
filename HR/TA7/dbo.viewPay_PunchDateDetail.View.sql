USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_PunchDateDetail]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_PunchDateDetail] AS SELECT        dbo.tPunchDateDetail.DTPunchDate, dbo.tPunchDateDetail.dblHours, dbo.tPunchDateDetail.sType,	   [dbo].[fnPay_UserTransaction_DefaultMoneyAmount](tPunchDateDetail.e_id,stype,dblhours) as MoneyAmount,  dbo.tPunchDateDetail.sExportCode, dbo.tPunchDateDetail.nHRProcessedCode, dbo.tPunchDateDetail.sNote,                           dbo.tPunchDateDetail.nCompensationStatus, dbo.tPunchDateDetail.nAccrualStatus, dbo.tPunchDateDetail.dblHoursOriginal, dbo.tPunchDateDetail.nCompensationStatusOriginal,                           dbo.tPunchDateDetail.nAccrualStatusOriginal, dbo.tPunchDateDetail.nAttendanceLetterCode, dbo.tPunchDateDetail.nTardinessLetterCode, dbo.tReportWeek.e_id, dbo.tReportWeek.e_idno,                           dbo.tReportWeek.e_name, dbo.tReportWeek.nPayRuleID, dbo.tReportWeek.sPayRuleName, dbo.tReportWeek.nPayWeekNum, dbo.tReportWeek.DTStartDate, dbo.tReportWeek.DTEndDate,                           dbo.tReportWeek.dblREGULAR, dbo.tReportWeek.dblONEHALF, dbo.tReportWeek.dblDOUBLE, dbo.tReportWeek.sHoursSummary, dbo.tReportWeek.sWeekID, dbo.tReportWeek.nDept,                           dbo.tReportWeek.sDeptName, dbo.tReportWeek.nCompID, dbo.tReportWeek.sCompanyName, dbo.tReportWeek.nEmployeeType, dbo.tReportWeek.sEmployeeTypeName, dbo.tReportWeek.nJobTitleID,                           dbo.tReportWeek.sJobTitleName, dbo.tReportWeek.nScheduleID, dbo.tReportWeek.sScheduleName, dbo.tReportWeek.nPayPeriod, dbo.tReportWeek.nReviewStatus, dbo.tReportWeek.nReviewSupervisorID,                           dbo.tReportWeek.sSupervisorName, dbo.tReportWeek.nWeekID, dbo.tReportWeek.dblMEAL, dbo.tReportWeek.dblOTHERS, dbo.tReportWeek.nLocked FROM            dbo.tPunchDateDetail INNER JOIN                          dbo.tReportWeek ON dbo.tPunchDateDetail.nWeekID = dbo.tReportWeek.nWeekID   



GO
