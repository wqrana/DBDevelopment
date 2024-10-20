USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserTimesheetPayrollHistory]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserTimesheetPayrollHistory]
-- WITH ENCRYPTION
AS
SELECT        dbo.tblReportWeek.e_id, dbo.tblReportWeek.e_idno, dbo.tblReportWeek.e_name, dbo.tblReportWeek.nPayRuleID, dbo.tblReportWeek.sPayRuleName, dbo.tblReportWeek.nPayWeekNum, 
                         dbo.tblReportWeek.DTStartDate, dbo.tblReportWeek.DTEndDate, dbo.tblReportWeek.dblREGULAR, dbo.tblReportWeek.dblONEHALF, dbo.tblReportWeek.dblDOUBLE, dbo.tblReportWeek.sHoursSummary, 
                         dbo.tblReportWeek.sWeekID, dbo.tblReportWeek.nDept, dbo.tblReportWeek.sDeptName, dbo.tblReportWeek.nCompID, dbo.tblReportWeek.sCompanyName, dbo.tblReportWeek.nEmployeeType, 
                         dbo.tblReportWeek.sEmployeeTypeName, dbo.tblReportWeek.nJobTitleID, dbo.tblReportWeek.sJobTitleName, dbo.tblReportWeek.nScheduleID, dbo.tblReportWeek.sScheduleName, 
                         dbo.tblReportWeek.nPayPeriod, dbo.tblReportWeek.nReviewStatus, dbo.tblReportWeek.nReviewSupervisorID, dbo.tblReportWeek.sSupervisorName, dbo.tblReportWeek.nWeekID, dbo.tblReportWeek.dblMEAL, 
                         dbo.tblReportWeek.dblOTHERS, dbo.tblReportWeek.nLocked, dbo.tblCompanyPayrollRules.strPayrollCompany, dbo.tblCompanyPayrollRules.intPayrollRule, dbo.tblCompanyPayrollRules.intPaymentSchedule, 
                         dbo.tblUserCompanyPayroll.intPayrollUserStatus, dbo.tblUserCompanyPayroll.intPayMethodType, dbo.tblUserStatus.strStatusName, dbo.tblPayMethodType.strPayMethodType, dbo.tblReportWeek.strBatchID, 
                         dbo.tblReportWeek.boolDeleted
FROM            dbo.tblReportWeek INNER JOIN
                         dbo.tblCompanyPayrollRules ON dbo.tblReportWeek.nPayRuleID = dbo.tblCompanyPayrollRules.intPayrollRule INNER JOIN
                         dbo.tblPayMethodType INNER JOIN
                         dbo.tblUserCompanyPayroll ON dbo.tblPayMethodType.intPayMethodType = dbo.tblUserCompanyPayroll.intPayMethodType INNER JOIN
                         dbo.tblUserStatus ON dbo.tblUserCompanyPayroll.intPayrollUserStatus = dbo.tblUserStatus.intStatus ON dbo.tblReportWeek.e_id = dbo.tblUserCompanyPayroll.intUserID




GO
