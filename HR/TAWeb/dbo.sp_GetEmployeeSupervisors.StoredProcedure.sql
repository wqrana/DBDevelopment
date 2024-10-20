USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetEmployeeSupervisors]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetEmployeeSupervisors] 
	@UserInformationId int =0 ,
	@ClientId int=0
	
AS
BEGIN
		 
	Select distinct userInfo.*, UCI.LoginEmail,UCI.NotificationEmail
	From vw_UserInformation userInfo
	Inner Join UserContactInformation UCI on  userInfo.UserInformationId=UCI.UserInformationId
	Inner Join EmployeeSupervisor ES on ES.SupervisorUserId = userInfo.UserInformationId
	Where ES.EmployeeUserId = @UserInformationId And userInfo.ClientId = @ClientId And ES.ClientId = @ClientId 
	And UCI.ClientId = @ClientId
END
GO
