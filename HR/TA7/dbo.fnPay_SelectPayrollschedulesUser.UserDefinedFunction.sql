USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_SelectPayrollschedulesUser]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/3/2016
-- Description:	Select the users from the timesheets that apply to a particular payroll

CREATE FUNCTION [dbo].[fnPay_SelectPayrollschedulesUser]
(	
	@PAYWEEKNUM int,
	@SCHEDULEID int,
	@PAYROLLUSERSTATUS int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
SELECT        tReportWeek.e_id AS intUserID, tReportWeek.e_idno, tReportWeek.e_name AS strUserName, tReportWeek.nPayRuleID, tReportWeek.sPayRuleName, tReportWeek.nPayWeekNum, tReportWeek.DTStartDate, 
                         tReportWeek.DTEndDate, tReportWeek.dblREGULAR, tReportWeek.dblONEHALF, tReportWeek.dblDOUBLE, tReportWeek.sHoursSummary, tReportWeek.sWeekID, tReportWeek.nDept, tReportWeek.sDeptName, 
                         tReportWeek.nCompID, tReportWeek.sCompanyName, tReportWeek.nEmployeeType, tReportWeek.sEmployeeTypeName, tReportWeek.nJobTitleID, tReportWeek.sJobTitleName, tReportWeek.nScheduleID, 
                         tReportWeek.sScheduleName, tReportWeek.nPayPeriod, tReportWeek.nReviewStatus, tReportWeek.nReviewSupervisorID, tReportWeek.sSupervisorName, tReportWeek.nWeekID, tReportWeek.dblMEAL, 
                         tReportWeek.dblOTHERS, tReportWeek.nLocked, tblCompanyPayrollRules.strPayrollCompany, tblCompanyPayrollRules.intPayrollRule, tblCompanyPayrollRules.intPaymentSchedule, 
                         tblUserCompanyPayroll.intPayrollUserStatus, tblUserCompanyPayroll.intPayMethodType, tblUserStatus.strStatusName, tblPayMethodType.strPayMethodType
FROM            tblCompanyPayrollRules INNER JOIN
                         tReportWeek ON tblCompanyPayrollRules.intPayrollRule = tReportWeek.nPayRuleID INNER JOIN
                         tblPayMethodType INNER JOIN
                         tblUserCompanyPayroll ON tblPayMethodType.intPayMethodType = tblUserCompanyPayroll.intPayMethodType INNER JOIN
                         tblUserStatus ON tblUserCompanyPayroll.intPayrollUserStatus = tblUserStatus.intStatus ON tReportWeek.e_id = tblUserCompanyPayroll.intUserID
WHERE nPayWeekNum = @PAYWEEKNUM AND intPayrollUserStatus = @PAYROLLUSERSTATUS AND intPaymentSchedule = @SCHEDULEID 


)




GO
