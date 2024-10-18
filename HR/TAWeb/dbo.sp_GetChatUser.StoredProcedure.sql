USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetChatUser]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[sp_GetChatUser] 
	@UserInformationName nvarchar(250)
AS
BEGIN
	SELECT * FROM [ChatUsers] WHERE UserInformationName=@UserInformationName;
END
GO
