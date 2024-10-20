USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_UserInformationByFilter]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UserInformationByFilter] 
	-- Add the parameters for the stored procedure here
	@employeeId int =0 ,
	@employeeName nvarchar(250) = '',
	@departmentId int = 0,
	@subDepartmentId int = 0,
	@positionId int = 0,
	@employmentTypeId int=0,
	@employeeTypeId int=0,
	@employeeStatusId int = 0,
	@superviserId int,
	@clientId int,
	@companyId int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @employeeUserId int=0
	Select @employeeUserId = UserInformationId
	From UserInformation
	Where EmployeeId= @employeeId
		 
	Select distinct userInfo.FirstLastName + ' ' + userInfo.SecondLastName AS LastName, case when userInfo.EmployeeStatusId=1 then 'bg-inverse-success' when userInfo.EmployeeStatusId=2 then 'bg-inverse-warning' else 'bg-inverse-danger' end EmpStatusBgClass , userInfo.*,
	cmp.CompanyName,
	cmp.Old_Id as OldCompanyId,
	dept.DepartmentName,
	subDept.SubDepartmentName,
	ps.PositionName,
	empType.EmployeeTypeName,
	empStatus.EmployeeStatusName

	From vw_UserInformation userInfo
	Left Join Company cmp On userInfo.CompanyID = cmp.CompanyId
	Left Join Department dept On userInfo.DepartmentId = dept.DepartmentId
	Left Join SubDepartment subDept On userInfo.SubDepartmentId = subDept.SubDepartmentId
	Left Join Position ps On userInfo.PositionId = ps.PositionId
	Left Join EmployeeType empType on userInfo.EmployeeTypeID = empType.EmployeeTypeId
	Left Join EmployeeStatus empStatus On userInfo.EmployeeStatusId = empStatus.EmployeeStatusId
	WHERE userInfo.UserInformationId IN(Select distinct UserInformationId from dbo.fn_SupervisedEmployees(@clientId,@superviserId))
	--AND userInfo.EmployeeId = IIF(@employeeId = 0,userInfo.EmployeeId,@employeeId)
	  and (userInfo.EmployeeId = @employeeId or @employeeId =0) 
	AND userInfo.ShortFullName like '%'+ @employeeName + '%'
	--AND IsNull(userInfo.DepartmentId,0)	= IIF(@departmentId = 0,IsNull(userInfo.DepartmentId,0),@departmentId)
	and (userInfo.DepartmentId = @departmentId or @departmentId =0) 
	--AND IsNull(userInfo.SubDepartmentId,0)	= IIF(@subDepartmentId = 0,IsNull(userInfo.SubDepartmentId,0),@subDepartmentId)
    and (userInfo.SubDepartmentId = @subDepartmentId or @subDepartmentId =0) 
	--AND IsNull(userInfo.PositionId,0)	= IIF(@positionId = 0,IsNull(userInfo.PositionId,0),@positionId)
	and (userInfo.PositionId = @positionId or @positionId =0) 
	--AND IsNull(userInfo.EmploymentTypeId,0)	= IIF(@employmentTypeId = 0,IsNull(userInfo.EmploymentTypeId,0),@employmentTypeId)
	  and (userInfo.EmploymentTypeId = @employmentTypeId or @employmentTypeId =0) 
	--AND IsNull(userInfo.EmployeeTypeID,0)	= IIF(@employeeTypeId = 0,IsNull(userInfo.EmployeeTypeID,0),@employeeTypeId)
	 and (userInfo.EmployeeTypeID = @employeeTypeId or @employeeTypeId =0) 
	--AND userInfo.EmployeeStatusId		= IIF(@employeeStatusId = 0,userInfo.employeeStatusId,@employeeStatusId)
	  and (userInfo.EmployeeStatusId = @employeeStatusId or @employeeStatusId =0) 
	AND userinfo.clientid =  @clientId
	AND userinfo.companyid = @companyId
	AND userinfo.dataentrystatus = 1
	
	--Union All
	
	--Select distinct userInfo.*,
	--cmp.CompanyName,
	--cmp.Old_Id as OldCompanyId,
	--dept.DepartmentName,
	--subDept.SubDepartmentName,
	--ps.PositionName,
	--empType.EmployeeTypeName,
	--empStatus.EmployeeStatusName

	--From vw_UserInformation userInfo
	--Left Join Company cmp On userInfo.CompanyID = cmp.CompanyId
	--Left Join Department dept On userInfo.DepartmentId = dept.DepartmentId
	--Left Join SubDepartment subDept On userInfo.SubDepartmentId = subDept.SubDepartmentId
	--Left Join Position ps On userInfo.PositionId = ps.PositionId
	--Left Join EmployeeType empType on userInfo.EmployeeTypeID = empType.EmployeeTypeId
	--Left Join EmployeeStatus empStatus On userInfo.EmployeeStatusId = empStatus.EmployeeStatusId
	--WHERE @superviserId = @employeeUserId
	--AND  userInfo.UserInformationId IN(@employeeUserId)
	--AND userInfo.EmployeeId = IIF(@employeeId = 0,userInfo.EmployeeId,@employeeId)
	--AND userInfo.ShortFullName like '%'+ @employeeName + '%'
	--AND IsNull(userInfo.DepartmentId,0)	= IIF(@departmentId = 0,IsNull(userInfo.DepartmentId,0),@departmentId)
	--AND IsNull(userInfo.SubDepartmentId,0)	= IIF(@subDepartmentId = 0,IsNull(userInfo.SubDepartmentId,0),@subDepartmentId)
	--AND IsNull(userInfo.PositionId,0)	= IIF(@positionId = 0,IsNull(userInfo.PositionId,0),@positionId)
	--AND IsNull(userInfo.EmploymentTypeId,0)	= IIF(@employmentTypeId = 0,IsNull(userInfo.EmploymentTypeId,0),@employmentTypeId)
	--AND IsNull(userInfo.EmployeeTypeID,0)	= IIF(@employeeTypeId = 0,IsNull(userInfo.EmployeeTypeID,0),@employeeTypeId)
	--AND userInfo.EmployeeStatusId		= IIF(@employeeStatusId = 0,userInfo.employeeStatusId,@employeeStatusId)
	--AND userinfo.clientid =  @clientId
	--AND userinfo.companyid = @companyId
	--AND userinfo.dataentrystatus = 1
END
GO
