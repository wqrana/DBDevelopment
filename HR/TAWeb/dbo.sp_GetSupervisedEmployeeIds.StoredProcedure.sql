USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSupervisedEmployeeIds]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSupervisedEmployeeIds] 
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
	IF @EmployeeId is null Or @EmployeeId=0
		BEGIN
			SELECT @SelectedEmployeeIds = ISNULL(@SelectedEmployeeIds +',','') + Cast(EmployeeId as varchar) FROM fn_SupervisedEmployees(@ClientId,@SupervisorUserId)
			WHERE (DepartmentId = ISNULL(@DepartmentId,DepartmentId) And SubDepartmentId = ISNULL(@SubDepartmentId,SubDepartmentId) And EmployeeTypeId = ISNULL(@EmployeeTypeId,EmployeeTypeId)) 
				 Or [Type]='DirectlySupervised'
		END
	ELSE
		BEGIN
			SELECT @SelectedEmployeeIds = ISNULL(@SelectedEmployeeIds +',','') + Cast(EmployeeId as varchar) FROM fn_SupervisedEmployees(@ClientId,@SupervisorUserId)
			WHERE EmployeeId = @EmployeeId
		END
	SELECT @SelectedEmployeeIds
	  
END
GO
