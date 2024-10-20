USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_SelectPayrollschedulesUsers]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spPay_SelectPayrollschedulesUsers]
	-- Add the parameters for the stored procedure here
	@PAYWEEKNUM int,
	@SCHEDULEID int,
	@PAYROLLUSERSTATUS int
-- WITH ENCRYPTION
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        dbo.tReportWeek.e_id as intUserID, dbo.tReportWeek.e_idno, dbo.tReportWeek.e_name as strUserName, dbo.tReportWeek.nPayRuleID, dbo.tReportWeek.sPayRuleName, dbo.tReportWeek.nPayWeekNum, 
                         dbo.tReportWeek.DTStartDate, dbo.tReportWeek.DTEndDate, dbo.tReportWeek.dblREGULAR, dbo.tReportWeek.dblONEHALF, dbo.tReportWeek.dblDOUBLE, dbo.tReportWeek.sHoursSummary, 
                         dbo.tReportWeek.sWeekID, dbo.tReportWeek.nDept, dbo.tReportWeek.sDeptName, dbo.tReportWeek.nCompID, dbo.tReportWeek.sCompanyName, dbo.tReportWeek.nEmployeeType, 
                         dbo.tReportWeek.sEmployeeTypeName, dbo.tReportWeek.nJobTitleID, dbo.tReportWeek.sJobTitleName, dbo.tReportWeek.nScheduleID, dbo.tReportWeek.sScheduleName, 
                         dbo.tReportWeek.nPayPeriod, dbo.tReportWeek.nReviewStatus, dbo.tReportWeek.nReviewSupervisorID, dbo.tReportWeek.sSupervisorName, dbo.tReportWeek.nWeekID, dbo.tReportWeek.dblMEAL, 
                         dbo.tReportWeek.dblOTHERS, dbo.tReportWeek.nLocked, dbo.tblCompanyPayrollRules.strPayrollCompany, dbo.tblCompanyPayrollRules.intPayrollRule, dbo.tblCompanyPayrollRules.intPaymentSchedule, 
                         dbo.tblUserCompanyPayroll.intPayrollUserStatus, dbo.tblUserCompanyPayroll.intPayMethodType, dbo.tblUserStatus.strStatusName, dbo.tblPayMethodType.strPayMethodType
	FROM            dbo.tReportWeek INNER JOIN
                         dbo.tblCompanyPayrollRules ON dbo.tReportWeek.nPayRuleID = dbo.tblCompanyPayrollRules.intPayrollRule INNER JOIN
                         dbo.tblPayMethodType INNER JOIN
                         dbo.tblUserCompanyPayroll ON dbo.tblPayMethodType.intPayMethodType = dbo.tblUserCompanyPayroll.intPayMethodType INNER JOIN
                         dbo.tblUserStatus ON dbo.tblUserCompanyPayroll.intPayrollUserStatus = dbo.tblUserStatus.intStatus ON dbo.tReportWeek.e_id = dbo.tblUserCompanyPayroll.intUserID
	WHERE nPayWeekNum = @PAYWEEKNUM AND intPayrollUserStatus = @PAYROLLUSERSTATUS AND intPaymentSchedule = @SCHEDULEID
END


GO
