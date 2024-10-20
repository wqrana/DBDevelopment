USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserInformationByWorkflowLevelGroupId]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUserInformationByWorkflowLevelGroupId] 
	@WorkflowLevelId int =0 ,
	@ClientId int=0
	
AS
BEGIN
		 
	Select distinct userInfo.*, UCI.LoginEmail,UCI.NotificationEmail
	From vw_UserInformation userInfo
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join UserEmployeeGroup UEG on  userInfo.UserInformationId=UEG.UserInformationId
	Inner Join EmployeeGroup EG on  EG.EmployeeGroupId=UEG.EmployeeGroupId
	Inner Join WorkflowLevelGroup WFG on  WFG.EmployeeGroupId= EG.EmployeeGroupId
	Where WFG.WorkflowLevelId = @WorkflowLevelId And userInfo.ClientId = @ClientId And UEG.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
END
GO
