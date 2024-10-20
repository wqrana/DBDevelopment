USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_UserInformation]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UserInformation] 
	-- Add the parameters for the stored procedure here
	@employeeId int =0 ,
	@employeeName nvarchar(250) = '',
	@positionId int = 0,
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
		 
	Select distinct userInfo.*,
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
	AND userInfo.EmployeeId = IIF(@employeeId = 0,userInfo.EmployeeId,@employeeId)
	AND userInfo.ShortFullName like '%'+ @employeeName + '%'
	AND IsNull(userInfo.PositionId,0)	= IIF(@positionId = 0,IsNull(userInfo.PositionId,0),@positionId)
	AND userInfo.EmployeeStatusId		= IIF(@employeeStatusId = 0,userInfo.employeeStatusId,@employeeStatusId)
	AND userinfo.clientid =  @clientId
	AND userinfo.companyid = @companyId
	AND userinfo.dataentrystatus = 1
	
	Union All
	
	Select distinct userInfo.*,
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
	WHERE @superviserId = @employeeUserId
	AND  userInfo.UserInformationId IN(@employeeUserId)
	AND userInfo.EmployeeId = IIF(@employeeId = 0,userInfo.EmployeeId,@employeeId)
	AND userInfo.ShortFullName like '%'+ @employeeName + '%'
	AND IsNull(userInfo.PositionId,0)	= IIF(@positionId = 0,IsNull(userInfo.PositionId,0),@positionId)
	AND userInfo.EmployeeStatusId		= IIF(@employeeStatusId = 0,userInfo.employeeStatusId,@employeeStatusId)
	AND userinfo.clientid =  @clientId
	AND userinfo.companyid = @companyId
	AND userinfo.dataentrystatus = 1
END
GO
