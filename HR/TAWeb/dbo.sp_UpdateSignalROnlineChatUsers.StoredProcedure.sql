USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSignalROnlineChatUsers]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UpdateSignalROnlineChatUsers] 
	-- Add the parameters for the stored procedure here
	@UserName varchar(500),
	@UserId varchar(500),
	@ConnectionId varchar(500),
	@UserInformationName varchar(500),
	@ActiveChatConversationId int,
	@CreatedBy int,
	@ClientId int,
	@CompanyId int
AS
BEGIN
	DECLARE @RowCount int = 0
	BEGIN TRY
		IF EXISTS(SELECT * FROM [ChatUsers] WHERE UserInformationName=@UserInformationName)
			UPDATE [dbo].[ChatUsers]
						SET  [UserID] = @UserId,[ConnectionID] = @ConnectionId,[ActiveChatConversationId] = @ActiveChatConversationId,[ModifiedBy] = 1,[ModifiedDate] = GetDate()
						WHERE UserInformationName=@UserInformationName
		ELSE
			INSERT INTO [dbo].[ChatUsers]([UserName],[UserID],[ConnectionID],[UserInformationName],[ActiveChatConversationId],[CreatedBy],[CreatedDate],[DataEntryStatus],ClientId,CompanyId)
			VALUES(@UserName,@UserId,@ConnectionId,@UserInformationName,@ActiveChatConversationId,1,GetDate(),1,@ClientId,@CompanyId)
	END TRY
	BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 
		   SET @RowCount = 0
	END CATCH
	RETURN @RowCount
END
GO
