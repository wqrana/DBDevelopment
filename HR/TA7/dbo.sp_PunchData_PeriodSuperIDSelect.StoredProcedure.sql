USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[sp_PunchData_PeriodSuperIDSelect]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PunchData_PeriodSuperIDSelect]
	-- Add the parameters for the stored procedure here
	@SuperID as bigint = '',
	@UserID as bigint = '',
	@PayWeekNum as bigint = '',
	@CompanyID as bigint = '',
	@DeptID as bigint = '',
	@JobTitleID as bigint = '',
	@EmployeeTypeID as bigint = ''
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT     tReportWeek.sCompanyName, tReportWeek.sDeptName, tReportWeek.sEmployeeTypeName, tReportWeek.sJobTitleName, tReportWeek.e_id, 
                      tReportWeek.e_idno, tReportWeek.e_name, tPunchData.tpdID, tPunchData.DTPunchDate, tPunchData.DTPunchDateTime, tPunchData.g_id, 
                      tPunchData.e_group, tPunchData.e_user, tPunchData.e_mode, tPunchData.e_type, tPunchData.e_result, tPunchData.b_Processed, 
                      tPunchData.b_Modified, tPunchData.nAdminID, tPunchData.sModType, 
                      tuser.name AS AdminName
FROM         tPunchDate INNER JOIN
                      tReportWeek ON tPunchDate.nWeekID = tReportWeek.nWeekID INNER JOIN
                      tPunchData ON tPunchDate.e_id = tPunchData.e_id AND tPunchDate.DTPunchDate = tPunchData.DTPunchDate LEFT OUTER JOIN
                      tUserSupervisors ON tReportWeek.e_id = tUserSupervisors.nUserID LEFT OUTER JOIN
                      tuser ON tPunchData.nAdminID = tuser.id
WHERE     (tReportWeek.nPayWeekNum = @PayWeekNum OR
                      @PayWeekNum = '') AND (tUserSupervisors.nSupervisorID = @SuperID OR
                      @SuperID = '') AND (tReportWeek.nCompID = @CompanyID OR
                      @CompanyID = '') AND (tReportWeek.nDept = @DeptID OR
                      @DeptID = '') AND (tReportWeek.nEmployeeType = @EmployeeTypeID OR
                      @EmployeeTypeID = '') AND (tReportWeek.nJobTitleID = @JobTitleID OR
                      @JobTitleID = '') AND (tReportWeek.e_id = @UserID OR @UserID='')
END
GO
