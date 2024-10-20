USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[sp_TransactionDetail_Licenses]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TransactionDetail_Licenses]
	-- Add the parameters for the stored procedure here
	@AccrualTrans as nvarchar(30)='',
	@SuperID as int = '',
	@TransID as int = '',
	@PayWeekNum as int = '',
	@StartDate as datetime = '',
	@EndDate as datetime= '',
	@CompanyID as int = '',
	@DeptID as int = '',
	@JobTitleID as int = '',
	@EmployeeTypeID as int = '',
	@UserID as int = ''
 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT DISTINCT 
                      tReportWeek.e_id, tReportWeek.e_idno, tReportWeek.e_name, tPunchDateDetail.DTPunchDate, tPunchDateDetail.sType, tPunchDateDetail.dblHours, 
                      tPunchDateDetail.sNote, tReportWeek.sCompanyName AS CompanyName, tReportWeek.sDeptName AS DeptName, 
                      tReportWeek.sJobTitleName AS JobTitleName, tReportWeek.sEmployeeTypeName AS EmployeeTypeName, tTransDef.nIsAbsent, 
                      tTransDef.nAttendaceCategory, tTransDef.nCountsForVacationAccrual, tTransDef.nCountsForSickAccrual, tTransDef.nAccrualType, 
                      tTransDef.sAccrualType, tTransDef.sAccrualImportName, tTransDef.sParentCode, tTransDef.nParentCode, tTransDef.sAttendanceCategory, 
                      tTransDef.pCode, tTransDef.ID AS TransID, tTransDef.sTDesc, tPunchDateDetail.nWeekID
FROM         tPunchDateDetail INNER JOIN
                      tTransDef ON tPunchDateDetail.sType = tTransDef.Name INNER JOIN
                      tReportWeek ON tPunchDateDetail.nWeekID = tReportWeek.nWeekID LEFT OUTER JOIN
                      tUserSupervisors ON tPunchDateDetail.e_id = tUserSupervisors.nUserID
WHERE     (tPunchDateDetail.DTPunchDate BETWEEN @StartDate AND @EndDate OR
                      @StartDate = '' AND @EndDate = '') AND (tTransDef.ID = @TransID OR
                      @TransID = '') AND (tUserSupervisors.nSupervisorID = @SuperID OR
                      @SuperID = '') AND (tTransDef.sAccrualImportName = @AccrualTrans OR
                      @AccrualTrans = '') AND (tTransDef.nAccrualType > 0) AND (tReportWeek.nPayWeekNum = @PayWeekNum OR
                      @PayWeekNum = '') AND (tReportWeek.e_id = @UserID OR
                      @UserID = '')
END
GO
