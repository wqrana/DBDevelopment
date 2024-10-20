USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSupervisedEmployees]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[sp_GetSupervisedEmployees] 
	-- Add the parameters for the stored procedure here
	@ClientId int,
	@SupervisorUserId int,
	@EmployeeId int=null,
	@DepartmentId int=null,
	@SubDepartmentId int=null,
	@EmployeeTypeId int=null,
	@CompanyId int=null
	
AS
BEGIN

DECLARE @SelectedEmployeeIds AS VARCHAR(8000)
SELECT * FROM fn_SupervisedEmployees(@ClientId,@SupervisorUserId)
Where DepartmentId = ISNULL(@DepartmentId,DepartmentId) And SubDepartmentId = ISNULL(@SubDepartmentId,SubDepartmentId) And EmployeeTypeId = ISNULL(@EmployeeTypeId,EmployeeTypeId) 

	  
END
GO
