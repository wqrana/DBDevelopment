USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[sp_AccruableLicenses]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AccruableLicenses]
@UserID as bigint = '',
@StatusID as bigint = '',
@DeptID as bigint = '',
@JobTitleID as bigint = '',
@EmployeeTypeID as bigint = '',
@CompanyID as bigint = '',
@LicenseCode as nvarchar(30) = '',
@SuperID as bigint = ''
AS
BEGIN
	SET NOCOUNT ON;
SELECT DISTINCT 
                      viewUser.id, viewUser.name, viewUser.idno, viewUser.nStatus, viewUser.sNotes, viewUser.sCompanyName, viewUser.sDeptName, 
                      viewUser.sJobTitleName, viewUser.sEmployeeTypeName, viewUser.sPayrollRuleName, viewUser.sScheduleName, viewUser.nDeptID, 
                      viewUser.nJobTitleID, viewUser.nGroupID, viewUser.nEmployeeType, viewUser.nCompanyID, viewUser.nPayrollRuleID, viewUser.nScheduleID, 
                      viewUser.dCompanySeniorityDate, tUserAccrual.sLicenseCode, tUserAccrual.dblAccruedHours, tUserAccrual.dImportDate, tUserAccrual.dModifiedDate, 
                      tPayrollRule.dblSchedDailyRegHours, tPayrollRule.dblSchedWeeklyRegHours
FROM         tUserAccrual INNER JOIN
                      viewUser ON tUserAccrual.nUserID = viewUser.id LEFT OUTER JOIN
                      tPayrollRule ON viewUser.nPayrollRuleID = tPayrollRule.ID LEFT OUTER JOIN
                      tUserSupervisors ON viewUser.id = tUserSupervisors.nUserID
WHERE     (viewUser.id = @UserID OR
                      @UserID = '') AND (viewUser.nStatus = @StatusID OR
                      @StatusID = '') AND (viewUser.nDeptID = @DeptID OR
                      @DeptID = '') AND (viewUser.nJobTitleID = @JobTitleID OR
                      @JobTitleID = '') AND (viewUser.nEmployeeType = @EmployeeTypeID OR
                      @EmployeeTypeID = '') AND (viewUser.nCompanyID = @CompanyID OR
                      @CompanyID = '') AND (tUserAccrual.sLicenseCode = @LicenseCode OR
                      @LicenseCode = '') AND (tUserSupervisors.nSupervisorID = @SuperID OR
                      @SuperID = '')
	/* SET NOCOUNT ON */
	RETURN
end
GO
