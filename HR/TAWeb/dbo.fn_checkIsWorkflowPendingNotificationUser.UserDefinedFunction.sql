USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_checkIsWorkflowPendingNotificationUser]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Waqar>
-- Create date: <2024-01-24>
-- Description:	<Check for Closing notification user>
-- =============================================
CREATE FUNCTION [dbo].[fn_checkIsWorkflowPendingNotificationUser]
(
	-- Add the parameters for the function here
	@UserInformationId int=0,
	@UserLoginId int=0, 
	@WorkflowLevelTypeId int=0,
	@WorkflowLevelId int=0,
	@WorkflowGroupId int =0,	
	@ClientId int=0
)
RETURNS int
AS
BEGIN
-- Declare the return variable here
Declare @returnCount int =0
-- local variables
Declare @employeeCount int = 0
Declare @supervisorCount int = 0
Declare @employeeGroupCount int=0

-- Is in Supervisor List
	Select @supervisorCount=count(distinct UCI.UserInformationId)
	From  UserInformation userInfo
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join EmployeeSupervisor ES on ES.SupervisorUserId = userInfo.UserInformationId
	Where ES.EmployeeUserId = @UserInformationId And userInfo.ClientId = @ClientId And ES.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
	--And UCI.UserInformationId!= @UserInformationId
	And UCI.UserInformationId= @UserLoginId
-- Is in User Groups
	Select @employeeGroupCount=count(distinct UCI.UserInformationId)
	From UserInformation userInfo
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join UserEmployeeGroup UEG on  userInfo.UserInformationId=UEG.UserInformationId
	Inner Join EmployeeGroup EG on  EG.EmployeeGroupId=UEG.EmployeeGroupId
	Inner Join WorkflowLevelGroup WFG on  WFG.EmployeeGroupId= EG.EmployeeGroupId
	Where WFG.WorkflowLevelId = @WorkflowLevelId And userInfo.ClientId = @ClientId And UEG.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
	--And UCI.UserInformationId!=@UserInformationId
	And UCI.UserInformationId = @UserLoginId
	if @WorkFlowLevelTypeId=1
	begin
	 -- logic
		set @returnCount=@supervisorCount;
	end
	if @WorkflowGroupId>0
	begin
		set @returnCount=@returnCount+@employeeGroupCount
	end
	
	return @returnCount
END


GO
