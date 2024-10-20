USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_SupervisedEmployees]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 6/15/2020
-- Description:	Returns the UserInformationId and EmployeeID of all employees supervised by @SupervisorUserID
-- =============================================
CREATE FUNCTION [dbo].[fn_SupervisedEmployees]
(
	-- Add the parameters for the function here
	@ClientID int,
	@SupervisorUserID int
)
RETURNS 
	@UserInformation TABLE
(
	 SupervisorUserID int
	,[UserInformationId] int not null
    ,[EmployeeId] [int] NULL
	,[IdNumber] [nvarchar](20) NULL
	,[SystemId] [nvarchar](20) NULL
	,[FirstName] [nvarchar](30) NULL
	,[MiddleInitial] [nvarchar](2) NULL
	,[FirstLastName] [varchar](30) NULL
	,[SecondLastName] [varchar](30) NULL
	,[ShortFullName] [nvarchar](50) NULL
    ,[ClientId] [int] NULL
    ,[EmploymentStatusId] [int] NULL
    ,[DefaultJobCodeId] [int] NULL
    ,[EthnicityId] [int] NULL
    ,[DisabilityId] [int] NULL
    ,[EmployeeNote] [int] NULL
    ,[GenderId] [int] NULL
    ,[BirthDate] [datetime] NULL
    ,[BirthPlace] [nvarchar](50) NULL
    ,[MaritalStatusId]  [int] NULL
    ,[SSNEncrypted] [nvarchar](512) NULL
    ,[PasswordHash] [varchar](512) NULL
    ,[EmployeeStatusId] [int] NULL
    ,[AspNetUserId] [nvarchar](128) NULL
	,[CreatedBy] [int] NULL
	,[CreatedDate] [datetime] NOT NULL
	,[DataEntryStatus] [int] NOT NULL
	,[ModifiedBy] [int] NULL
	,[ModifiedDate] [datetime] NULL
    ,[PictureFilePath] [nvarchar](512) NULL
    ,[ResumeFilePath] [nvarchar](512) NULL
    ,[EmployeeStatusDate] [datetime] NULL
    ,[CompanyID] int NOT NULL
    ,[DepartmentId]  [int] NULL
    ,[SubDepartmentId]  [int] NULL
    ,[EmployeeTypeID]  [int] NULL
    ,[PositionId]  [int] NULL
	,[LocationId]  [int] NULL
	,[EmploymentTypeId]  [int] NULL
    ,[SupervisorId]  [int] NULL
	,[Type] varchar(50) NULL
)
AS
BEGIN

	DECLARE @Temp TABLE (
	  SupervisorUserID int
	,[UserInformationId] int not null
    ,[EmployeeId] [int] NULL
	,[IdNumber] [nvarchar](20) NULL
	,[SystemId] [nvarchar](20) NULL
	,[FirstName] [nvarchar](30) NULL
	,[MiddleInitial] [nvarchar](2) NULL
	,[FirstLastName] [varchar](30) NULL
	,[SecondLastName] [varchar](30) NULL
	,[ShortFullName] [nvarchar](50) NULL
    ,[ClientId] [int] NULL
    ,[EmploymentStatusId] [int] NULL
    ,[DefaultJobCodeId] [int] NULL
    ,[EthnicityId] [int] NULL
    ,[DisabilityId] [int] NULL
    ,[EmployeeNote] [int] NULL
    ,[GenderId] [int] NULL
    ,[BirthDate] [datetime] NULL
    ,[BirthPlace] [nvarchar](50) NULL
    ,[MaritalStatusId]  [int] NULL
    ,[SSNEncrypted] [nvarchar](512) NULL
    ,[PasswordHash] [varchar](512) NULL
    ,[EmployeeStatusId] [int] NULL
    ,[AspNetUserId] [nvarchar](128) NULL
	,[CreatedBy] [int] NULL
	,[CreatedDate] [datetime] NOT NULL
	,[DataEntryStatus] [int] NOT NULL
	,[ModifiedBy] [int] NULL
	,[ModifiedDate] [datetime] NULL
    ,[PictureFilePath] [nvarchar](512) NULL
    ,[ResumeFilePath] [nvarchar](512) NULL
    ,[EmployeeStatusDate] [datetime] NULL
    ,[CompanyID] int NOT NULL
    ,[DepartmentId]  [int] NULL
    ,[SubDepartmentId]  [int] NULL
    ,[EmployeeTypeID]  [int] NULL
    ,[PositionId]  [int] NULL
	,[LocationId]  [int] NULL
	,[EmploymentTypeId]  [int] NULL
    ,[SupervisorId]  [int] NULL
	,[Type] varchar(50) NULL
)

	-- Add employees from Company, Department, Subdepartment and EmployeeType restrictions
	INSERT INTO @Temp
	SELECT 
	  @SupervisorUserID 
	  ,ui.[UserInformationId]
      ,[EmployeeId]
      ,[IdNumber]
      ,[SystemId]
      ,[FirstName]
      ,[MiddleInitial]
      ,[FirstLastName]
      ,[SecondLastName]
      ,[ShortFullName]
      ,ui.[ClientId]
      ,[EmploymentStatusId]
      ,[DefaultJobCodeId]
      ,[EthnicityId]
      ,[DisabilityId]
      ,[EmployeeNote]
      ,[GenderId]
      ,[BirthDate]
      ,[BirthPlace]
      ,[MaritalStatusId]
      ,[SSNEncrypted]
      ,[PasswordHash]
      ,[EmployeeStatusId]
      ,[AspNetUserId]
      ,ui.[CreatedBy]
      ,ui.[CreatedDate]
      ,ui.[DataEntryStatus]
      ,ui.[ModifiedBy]
      ,ui.[ModifiedDate]
      ,[PictureFilePath]
      ,[ResumeFilePath]
      ,[EmployeeStatusDate]
      ,ui.[CompanyID]
      ,ui.[DepartmentId]
      ,ui.[SubDepartmentId]
      ,ui.[EmployeeTypeID]
      ,ui.[PositionId]
	  ,ui.[LocationId]
	  ,ui.[EmploymentTypeId]
      ,ui.[SupervisorId]
	  ,''
	from [dbo].[vw_UserInformation] ui
	inner join SupervisorCompany sc on ui.CompanyId = sc.CompanyId and sc.UserInformationId=@SupervisorUserID
	left join Department dept on dept.DepartmentId = ui.DepartmentId
	left join SubDepartment subDept on subDept.SubDepartmentId = ui.DepartmentId
	left join EmployeeType etypr on etypr.EmployeeTypeId = ui.EmployeeTypeId
	where ((select count(*) from SupervisorDepartment sd where sd.UserInformationId=@SupervisorUserID)=0 Or ui.DepartmentId in (select sd.DepartmentId from SupervisorDepartment sd where sd.UserInformationId=@SupervisorUserID))
	  And ((select count(*) from SupervisorSubDepartment ssd where ssd.UserInformationId=@SupervisorUserID)=0 Or ui.SubDepartmentId in (select ssd.SubDepartmentId from SupervisorSubDepartment ssd where ssd.UserInformationId=@SupervisorUserID))
	  And ((select count(*) from SupervisorEmployeeType et where et.UserInformationId=@SupervisorUserID)=0 Or ui.EmployeeTypeId in (select et.EmployeeTypeId from SupervisorEmployeeType et where et.UserInformationId=@SupervisorUserID)) 
	
	--Add Employees assigned directly
	INSERT INTO @Temp
	SELECT 
	  @SupervisorUserID 
	  ,ui.[UserInformationId]
      ,[EmployeeId]
      ,[IdNumber]
      ,[SystemId]
      ,[FirstName]
      ,[MiddleInitial]
      ,[FirstLastName]
      ,[SecondLastName]
      ,[ShortFullName]
      ,ui.[ClientId]
      ,[EmploymentStatusId]
      ,[DefaultJobCodeId]
    
      ,[EthnicityId]
      ,[DisabilityId]
      ,[EmployeeNote]
      ,[GenderId]
      ,[BirthDate]
      ,[BirthPlace]
      ,[MaritalStatusId]
      ,[SSNEncrypted]
      ,[PasswordHash]
      ,[EmployeeStatusId]
      ,[AspNetUserId]
      ,ui.[CreatedBy]
      ,ui.[CreatedDate]
      ,ui.[DataEntryStatus]
      ,ui.[ModifiedBy]
      ,ui.[ModifiedDate]
      ,[PictureFilePath]
      ,[ResumeFilePath]
      ,[EmployeeStatusDate]
      ,ui.[CompanyID]
      ,ui.[DepartmentId]
      ,ui.[SubDepartmentId]
      ,ui.[EmployeeTypeID]
      ,ui.[PositionId]
	  ,ui.[LocationId]
	  ,ui.[EmploymentTypeId]
      ,ui.[SupervisorId]
	  ,'DirectlySupervised'
	from [dbo].[vw_UserInformation] ui inner join EmployeeSupervisor es on es.EmployeeUserId = ui.UserInformationId
	where SupervisorUserId = @SupervisorUserID
	---For Superuser
	INSERT INTO @Temp
	SELECT 
	  @SupervisorUserID 
	  ,ui.[UserInformationId]
      ,[EmployeeId]
      ,[IdNumber]
      ,[SystemId]
      ,[FirstName]
      ,[MiddleInitial]
      ,[FirstLastName]
      ,[SecondLastName]
      ,[ShortFullName]
      ,ui.[ClientId]
      ,[EmploymentStatusId]
      ,[DefaultJobCodeId]
     
      ,[EthnicityId]
      ,[DisabilityId]
      ,[EmployeeNote]
      ,[GenderId]
      ,[BirthDate]
      ,[BirthPlace]
      ,[MaritalStatusId]
      ,[SSNEncrypted]
      ,[PasswordHash]
      ,[EmployeeStatusId]
      ,[AspNetUserId]
      ,ui.[CreatedBy]
      ,ui.[CreatedDate]
      ,ui.[DataEntryStatus]
      ,ui.[ModifiedBy]
      ,ui.[ModifiedDate]
      ,[PictureFilePath]
      ,[ResumeFilePath]
      ,[EmployeeStatusDate]
      ,ui.[CompanyID]
      ,ui.[DepartmentId]
      ,ui.[SubDepartmentId]
      ,ui.[EmployeeTypeID]
      ,ui.[PositionId]
	  ,ui.[LocationId]
	  ,ui.[EmploymentTypeId]
      ,ui.[SupervisorId]
	  ,'SuperUser'
	from [dbo].[vw_UserInformation] ui 
	where @SupervisorUserID IN (select UserInformationId from UserInformationRole uir inner join Role r ON uir.RoleID = r.RoleId where r.RoleTypeId = 1)
	and ClientId = @ClientID
	
	insert into @UserInformation
	select distinct  * from @Temp
	
	RETURN 
END
GO
