USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_ReportWeek_PunchPair]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

   CREATE VIEW [dbo].[viewPay_ReportWeek_PunchPair] AS SELECT        tReportWeek.e_id, tReportWeek.e_idno, tReportWeek.e_name, tReportWeek.nPayRuleID, tReportWeek.sPayRuleName, tReportWeek.nPayWeekNum, tReportWeek.DTStartDate, tReportWeek.DTEndDate,                           tReportWeek.dblREGULAR, tReportWeek.dblONEHALF, tReportWeek.dblDOUBLE, tReportWeek.sHoursSummary, tReportWeek.sWeekID, tReportWeek.nDept, tReportWeek.sDeptName, tReportWeek.nCompID,                           tReportWeek.sCompanyName, tReportWeek.nEmployeeType, tReportWeek.sEmployeeTypeName, tReportWeek.nJobTitleID, tReportWeek.sJobTitleName, tReportWeek.nScheduleID,                           tReportWeek.sScheduleName, tReportWeek.nPayPeriod, tReportWeek.nReviewStatus, tReportWeek.nReviewSupervisorID, tReportWeek.sSupervisorName, tReportWeek.nWeekID, tReportWeek.dblMEAL,                           tReportWeek.dblOTHERS, tReportWeek.nLocked, tPunchPair.DTPunchDate, tPunchPair.DTimeIn, tPunchPair.DTimeOut, tPunchPair.HoursWorked, tPunchPair.sType, tPunchPair.pCode, tPunchPair.bTrans,                           tPunchPair.sTCode, tPunchPair.sTDesc, tPunchPair.sTimeIn, tPunchPair.sTimeOut, tPunchPair.nJobCodeID, dbo.fnPay_UserTransaction_DefaultMoneyAmount(  tReportWeek.e_id,tPunchPair.sType,tPunchPair.HoursWorked) as MoneyAmount FROM            tReportWeek LEFT OUTER JOIN                          tPunchPair ON tReportWeek.nWeekID = tPunchPair.nWeekID     



GO
