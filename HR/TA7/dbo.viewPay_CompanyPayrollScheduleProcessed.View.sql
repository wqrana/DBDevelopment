USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_CompanyPayrollScheduleProcessed]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[viewPay_CompanyPayrollScheduleProcessed]    Script Date: 6/26/2017 3:10:56 PM ******/
CREATE VIEW [dbo].[viewPay_CompanyPayrollScheduleProcessed]
AS
SELECT DISTINCT 
                         TOP (100) PERCENT cpr.strPayrollCompany AS strCompanyName, cps.strPayrollSchedule, rw.nPayWeekNum, CAST(rw.DTStartDate AS date) AS DTStartDate, CAST(rw.DTEndDate AS date) AS DTEndDate, 
                         csp.intPayWeekNumber, csp.strBatchID, ub.strBatchDescription, ub.intBatchStatus, ub.dtPayDate, ub.intCreatedByID, ub.strCreateByName, ub.dtBatchCreated, ub.strStatusDescription, cps.intPayrollScheduleID, 
                         ub.strBatchTypeName, ub.intBatchType, ub.ClosedByUserID, ub.ClosedDateTime
FROM            dbo.tReportWeek AS rw INNER JOIN
                         dbo.tblCompanyPayrollRules AS cpr ON rw.nPayRuleID = cpr.intPayrollRule INNER JOIN
                         dbo.tPayrollRule AS pr ON rw.nPayRuleID = pr.ID AND rw.nCompID = pr.nCompanyID LEFT OUTER JOIN
                         dbo.viewPay_UserBatchStatus AS ub ON rw.nPayWeekNum = ub.intPayWeekNum AND rw.e_id = ub.intUserID LEFT OUTER JOIN
                         dbo.tblCompanyPayrollSchedules AS cps ON cpr.intPaymentSchedule = cps.intPayrollScheduleID AND cpr.strPayrollCompany = cps.strCompanyName LEFT OUTER JOIN
                         dbo.tblCompanySchedulesProcessed AS csp ON cpr.strPayrollCompany = csp.strCompanyName AND rw.nPayWeekNum = csp.intPayWeekNumber AND cpr.intPaymentSchedule = csp.intPayrollScheduleID
GO
