USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[sp_TransactionDetail_PeriodSuperIDSelect]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TransactionDetail_PeriodSuperIDSelect]
	-- Add the parameters for the stored procedure here
	@SuperID as bigint = '',
	@TransID as bigint = '',
	@PayWeekNum as bigint = '',
	@CompanyID as bigint = '',
	@DeptID as bigint = '',
	@JobTitleID as bigint = '',
	@EmployeeTypeID as bigint = '',
	@AttendanceRevision as bigint = '',
	@TardinessRevision as bigint = ''
 AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT     tPunchDate.e_id, tPunchDate.e_idno, tPunchDate.e_name, tPunchDateDetail.DTPunchDate, tPunchDateDetail.sType, tPunchDateDetail.dblHours, 
                      tPunchDateDetail.sNote, tTransDef.nIsAbsent, tTransDef.nAttendaceCategory, tTransDef.nCountsForVacationAccrual, tTransDef.nCountsForSickAccrual, 
                      tTransDef.nAccrualType, tTransDef.sAccrualType, tTransDef.sAccrualImportName, tTransDef.sParentCode, tTransDef.nParentCode, 
                      tTransDef.sAttendanceCategory, tTransDef.pCode, tTransDef.ID AS TransID, tTransDef.sTDesc, tPunchDateDetail.nWeekID, 
                      tReportWeek.sCompanyName, tReportWeek.sDeptName, tReportWeek.sEmployeeTypeName, tReportWeek.sJobTitleName
FROM         tPunchDateDetail INNER JOIN
                      tPunchDate ON tPunchDateDetail.e_id = tPunchDate.e_id AND tPunchDateDetail.DTPunchDate = tPunchDate.DTPunchDate INNER JOIN
                      tTransDef ON tPunchDateDetail.sType = tTransDef.Name INNER JOIN
                      tReportWeek ON tPunchDate.nWeekID = tReportWeek.nWeekID INNER JOIN
                      tUserSupervisors ON tReportWeek.e_id = tUserSupervisors.nUserID
WHERE     (tTransDef.ID = @TransID OR
                      @TransID = '') AND (tReportWeek.nPayWeekNum = @PayWeekNum or @PayWeekNum='') AND (tUserSupervisors.nSupervisorID = @SuperID) AND 
                      (tReportWeek.nCompID = @CompanyID or @CompanyID='') AND (tReportWeek.nDept = @DeptID or @DeptID='') AND (tReportWeek.nEmployeeType = @EmployeeTypeID or @EmployeeTypeID='') AND 
                      (tReportWeek.nJobTitleID = @JobTitleID or @JobTitleID='') AND (tTransDef.nAttendanceRevision = @AttendanceRevision OR
                      @AttendanceRevision = '') AND (tTransDef.nTardinessRevision = @TardinessRevision OR
                      @TardinessRevision = '')
END
GO
