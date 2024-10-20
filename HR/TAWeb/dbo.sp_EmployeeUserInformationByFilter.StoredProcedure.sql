USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_EmployeeUserInformationByFilter]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_EmployeeUserInformationByFilter] 

	-- Add the parameters for the stored procedure here

	@superviserId as int,
	@clientId as int,
	@EmployeeStatusId as int=1
	,@CompanyId as int
	
AS
BEGIN


		 
	Select distinct case when userInfo.EmployeeStatusId=1 then 'bg-inverse-success' when userInfo.EmployeeStatusId=2 then 'bg-inverse-warning' else 'bg-inverse-danger' end EmpStatusBgClass, userinfo.id, userInfo.EmployeeId,
	userInfo.EmployeeStatusName,
	userInfo.FirstName,
	userInfo.FirstLastName + ' ' + userInfo.SecondLastName AS LastName,
	userinfo.CompanyID,
	cmp.CompanyName,
	cmp.Old_Id as OldCompanyId,
	dept.DepartmentName,
	subDept.SubDepartmentName,
	ps.PositionName,
	empType.EmployeeTypeName,
	empStatus.EmployeeStatusName,
	r.RoleName as UserRole,
 uci.LoginEmail
	,STRING_AGG(EmployeeGroupName, ', ') AS EmployeeGroups 

	From vw_UserInformation userInfo
	Left Join Company cmp On userInfo.CompanyID = cmp.CompanyId
	Left Join Department dept On userInfo.DepartmentId = dept.DepartmentId
	Left Join SubDepartment subDept On userInfo.SubDepartmentId = subDept.SubDepartmentId
	Left Join Position ps On userInfo.PositionId = ps.PositionId
	Left Join EmployeeType empType on userInfo.EmployeeTypeID = empType.EmployeeTypeId
	Left Join EmployeeStatus empStatus On userInfo.EmployeeStatusId = empStatus.EmployeeStatusId
	left join UserContactInformation uci on userInfo.UserInformationId= uci.UserInformationId and uci.DataEntryStatus=1
	left join UserInformationRole uir on userInfo.UserInformationId= uir.UserInformationId
	left join [Role]  r on uir.RoleId=r.RoleId
	left join UserEmployeeGroup ueg on ueg.UserInformationId=userInfo.UserInformationId
	left join EmployeeGroup eg on eg.EmployeeGroupId=ueg.EmployeeGroupId

 	WHERE userInfo.UserInformationId IN(Select distinct UserInformationId from dbo.fn_SupervisedEmployees(@clientID,@superviserId)) and (userInfo.EmployeeStatusId = @EmployeeStatusId or @EmployeeStatusId =0) and (cmp.CompanyId = @CompanyId or @CompanyId =0)
	
	
	AND userinfo.clientid =  @clientId
	AND userinfo.dataentrystatus = 1
	group by cmp.CompanyName,
	cmp.Old_Id ,
	dept.DepartmentName,
	subDept.SubDepartmentName,
	ps.PositionName,
	empType.EmployeeTypeName,
	empStatus.EmployeeStatusName
	,r.RoleName,uci.LoginEmail,
	userInfo.EmployeeId,
	userInfo.EmployeeStatusName,
	userInfo.FirstName,
	userInfo.SecondLastName,
	userInfo.FirstLastName,
	 userinfo.id,
	 userInfo.EmployeeStatusId,
	 userinfo.CompanyID order by EmployeeId 
	
END
GO
