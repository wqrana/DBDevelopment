USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[sp_TransactionDetail_SuperIDSelect]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TransactionDetail_SuperIDSelect]
	-- Add the parameters for the stored procedure here
	@SuperID as int = '',
	@TransID as int = '',
	@StartDate as datetime = '',
	@EndDate as datetime= '',
	@CompanyID as int = '',
	@DeptID as int = '',
	@JobTitleID as int = '',
	@EmployeeTypeID as int = '',
	@AttendanceRevision as bigint = '',
	@TardinessRevision as bigint = ''

 AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT     tPunchDate.e_id, tPunchDate.e_idno, tPunchDate.e_name, tPunchDateDetail.DTPunchDate, tPunchDateDetail.sType, tPunchDateDetail.dblHours, 
                      tPunchDateDetail.sNote, tCompany.Name AS CompanyName, tDept.Name AS DeptName, tJobTitle.Name AS JobTitleName, 
                      tEmployeeType.Name AS EmployeeTypeName, tTransDef.nIsAbsent, tTransDef.nAttendaceCategory, tTransDef.nCountsForVacationAccrual, 
                      tTransDef.nCountsForSickAccrual, tTransDef.nAccrualType, tTransDef.sAccrualType, tTransDef.sAccrualImportName, tTransDef.sParentCode, 
                      tTransDef.nParentCode, tTransDef.sAttendanceCategory, tTransDef.pCode, tTransDef.ID AS TransID, tTransDef.sTDesc, 
                      tPunchDateDetail.nWeekID
FROM         tPunchDateDetail INNER JOIN
                      tPunchDate ON tPunchDateDetail.e_id = tPunchDate.e_id AND tPunchDateDetail.DTPunchDate = tPunchDate.DTPunchDate INNER JOIN
                      tTransDef ON tPunchDateDetail.sType = tTransDef.Name INNER JOIN
                      tUserSupervisors ON tPunchDate.e_id = tUserSupervisors.nUserID LEFT OUTER JOIN
                      tEmployeeType ON tPunchDate.nEmployeeTypeID = tEmployeeType.ID LEFT OUTER JOIN
                      tJobTitle ON tPunchDate.nJobTitleID = tJobTitle.ID LEFT OUTER JOIN
                      tCompany ON tPunchDate.nCompanyID = tCompany.ID LEFT OUTER JOIN
                      tDept ON tPunchDate.nDeptID = tDept.ID
WHERE     (tCompany.ID = @CompanyID OR
                      @CompanyID = '') AND (tDept.ID = @DeptID OR
                      @DeptID = '') AND (tJobTitle.ID = @JobTitleID OR
                      @JobTitleID = '') AND (tEmployeeType.ID = @EmployeeTypeID OR
                      @EmployeeTypeID = '') AND (tPunchDateDetail.DTPunchDate BETWEEN @StartDate AND @EndDate OR
                      @StartDate = '' AND @EndDate = '') AND (tTransDef.ID = @TransID OR
                      @TransID = '') AND (tUserSupervisors.nSupervisorID = @SuperID)AND (tTransDef.nAttendanceRevision = @AttendanceRevision OR
                      @AttendanceRevision = '') AND (tTransDef.nTardinessRevision = @TardinessRevision OR
                      @TardinessRevision = '')
END
GO
