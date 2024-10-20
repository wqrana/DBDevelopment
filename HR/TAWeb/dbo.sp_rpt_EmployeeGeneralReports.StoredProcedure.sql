USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_rpt_EmployeeGeneralReports]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <2020-09-01>
-- Description:	<Fetch the Employee General Reports data>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rpt_EmployeeGeneralReports] 
	-- Add the parameters for the stored procedure here
	@employeeIds nvarchar(max)='',
	@locationIds nvarchar(max)='',
	@deportmentIds nvarchar(max)='',
	@subDeportmentIds nvarchar(max)='',
	@employeeTypeIds nvarchar(max)='',
	@employmentTypeIds nvarchar(max)='',
	@employmentStatusIds nvarchar(max)='',
	@positionIds nvarchar(max)='',
	@statusIds nvarchar(max)='',
	@superviserId int,
	@clientId int,
	@companyId int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @selectedEmployeeTbl As Table(Id Bigint)
	Declare @selectedLocationTbl As Table(Id Bigint)
	Declare @selectedDepartmentTbl As Table(Id Bigint)
	Declare @selectedSubDepartmentTbl As Table(Id Bigint)
	Declare @selectedEmployeeTypeTbl As Table(Id Bigint)
	Declare @selectedEmploymentTypeTbl As Table(Id Bigint)
	Declare @selectedEmploymentStatusTbl As Table(Id Bigint)
	Declare @selectedPositionTbl As Table(Id Bigint)
	Declare @selectedStatusTbl As Table(Id Bigint)
	---Employee List
	Insert Into @selectedEmployeeTbl
	Select Id 
	From dbo.fn_splitIntIds(@employeeIds,',')
	--Location List
	Insert Into @selectedLocationTbl
	Select Id 
	From dbo.fn_splitIntIds(@locationIds,',')
	--Department List
	Insert Into @selectedDepartmentTbl
	Select Id 
	From dbo.fn_splitIntIds(@deportmentIds,',')
	-- Sub-Department List
	Insert Into @selectedSubDepartmentTbl
	Select Id 
	From dbo.fn_splitIntIds(@subDeportmentIds,',')
	--Employee Type List
	Insert Into @selectedEmployeeTypeTbl
	Select Id 
	From dbo.fn_splitIntIds(@employeeTypeIds,',')
	--Employment Type List
	Insert Into @selectedEmploymentTypeTbl
	Select Id 
	From dbo.fn_splitIntIds(@employmentTypeIds,',')
	--Employment Status
	Insert Into @selectedEmploymentStatusTbl
	Select Id 
	From dbo.fn_splitIntIds(@employmentStatusIds,',')
	--Position List
	Insert Into @selectedPositionTbl
	Select Id 
	From dbo.fn_splitIntIds(@positionIds,',')
	--Employee Status List
	Insert Into @selectedStatusTbl
	Select Id 
	From dbo.fn_splitIntIds(@statusIds,',')

	SELECT distinct empgrm.*
	FROM vw_rpt_EmployeeGeneralRptMain empgrm
	
	WHERE empgrm.UserInformationId IN(Select distinct UserInformationId from dbo.fn_SupervisedEmployees(@clientId,@superviserId)) 
	AND empgrm.CompanyID = @companyId
	AND  empgrm.DataEntryStatus = 1
	--based on selected employees
	AND  (empgrm.EmployeeId in (Select * From @selectedEmployeeTbl)
	        OR empgrm.EmployeeId = IIF(@employeeIds='', empgrm.EmployeeId,0))
	--based on selected locations
	AND  (empgrm.LocationId in (Select * From @selectedLocationTbl)
	        OR ISNULL(empgrm.LocationId,0) = IIF(@locationIds='', ISNULL(empgrm.LocationId,0),-1))
	--based on selected Departments
	AND  (empgrm.DepartmentId in (Select * From @selectedDepartmentTbl)
	        OR ISNULL(empgrm.DepartmentId,0) = IIF(@deportmentIds='', ISNULL(empgrm.DepartmentId,0),-1))
	--based on selected Sub-Departments
	AND  (empgrm.SubDepartmentId in (Select * From @selectedSubDepartmentTbl)
	        OR ISNULL(empgrm.SubDepartmentId,0) = IIF(@subDeportmentIds='', ISNULL(empgrm.SubDepartmentId,0),-1))
	--based on selected employee types
	AND  (empgrm.EmployeeTypeID in (Select * From @selectedEmployeeTypeTbl)
	        OR ISNULL(empgrm.EmployeeTypeID,0) = IIF(@employeeTypeIds='', ISNULL(empgrm.EmployeeTypeID,0),-1))
	--based on selected employment types
	AND  (empgrm.EmploymentTypeId in (Select * From @selectedEmploymentTypeTbl)
	        OR ISNULL(empgrm.EmploymentTypeId,0) = IIF(@employmentTypeIds='', ISNULL(empgrm.EmploymentTypeId,0),-1))
	--based on employment status
	AND  (empgrm.EmploymentStatusId in (Select * From @selectedEmploymentStatusTbl)
	        OR ISNULL(empgrm.EmploymentStatusId,0) = IIF(@employmentStatusIds='', ISNULL(empgrm.EmploymentStatusId,0),-1))
	--based on selected positions
	AND  (empgrm.PositionId in (Select * From @selectedPositionTbl)
	        OR ISNULL(empgrm.PositionId,0) = IIF(@positionIds='', ISNULL(empgrm.PositionId,0),-1))
	--based on selected Employee Status(s)
	AND  (empgrm.EmployeeStatusId in (Select * From @selectedStatusTbl)
	        OR empgrm.EmployeeStatusId = IIF(@statusIds='', empgrm.EmployeeStatusId,0))

END

GO
