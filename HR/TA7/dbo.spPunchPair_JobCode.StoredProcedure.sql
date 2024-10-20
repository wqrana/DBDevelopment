USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPunchPair_JobCode]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPunchPair_JobCode]
	-- Add the parameters for the stored procedure here
	@CompanyID as int, 
	@DeptID as int, 
	@SubDeptID as int, 
	@EmployeeTypeID as int,
	@JobCodeID as int,
	@CustomerID as int,
	@ProjectID as int,
	@WeekID as int,
	@UserID as int,
	@StartDate as datetime,
	@EndDate as datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT     viewUser_Reports.id, viewUser_Reports.name, viewUser_Reports.idno, viewUser_Reports.sCompanyName, viewUser_Reports.sDeptName, 
                      viewUser_Reports.sJobTitleName, viewUser_Reports.sEmployeeTypeName, viewUser_Reports.sPayrollRuleName, tPunchPair.DTPunchDate, 
                      tPunchPair.DTimeIn, tPunchPair.DTimeOut, tPunchPair.HoursWorked, tPunchPair.sType, tPunchPair.pCode, tPunchPair.bTrans, tPunchPair.sTCode, 
                      tPunchPair.sTDesc, tPunchPair.sTimeIn, tPunchPair.sTimeOut, tPunchPair.nWeekID, tJobCode.nJobCodeID, tJobCode.sJobCodeName, tProject.nProjectID, 
                      tProject.sProjectName, tCustomers.nCustomerID, tCustomers.sCustomerName, viewUser_Reports.nDeptID, viewUser_Reports.nJobTitleID, 
                      viewUser_Reports.nEmployeeType, viewUser_Reports.nCompanyID
FROM         tProject INNER JOIN
                      tJobCode ON tProject.nProjectID = tJobCode.nProjectID INNER JOIN
                      tCustomers ON tProject.nCustomerID = tCustomers.nCustomerID RIGHT OUTER JOIN
                      tPunchPair ON tJobCode.nJobCodeID = tPunchPair.nJobCodeID LEFT OUTER JOIN
                      viewUser_Reports ON tPunchPair.e_id = viewUser_Reports.id
where (viewUser_Reports.nCompanyID = @CompanyID OR @CompanyID = '') and (viewUser_Reports.nDeptID = @DeptID OR @DeptID = '')
	and (viewUser_Reports.nJobTitleID = @SubDeptID OR @SubDeptID = '') and (viewUser_Reports.nEmployeeType = @EmployeeTypeID OR @EmployeeTypeID = '')
	and (tJobCode.nJobCodeID = @JobCodeID OR @JobCodeID = '') and (tCustomers.nCustomerID = @CustomerID OR @CustomerID = '') 
	and (tProject.nProjectID = @ProjectID OR @ProjectID = '') and (tPunchPair.nWeekID = @WeekID OR @WeekID = '') 
	and (tPunchPair.DTPunchDate BETWEEN @StartDate and @EndDate OR @StartDate = '') 
END
GO
