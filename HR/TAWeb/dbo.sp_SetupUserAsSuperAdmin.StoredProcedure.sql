USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_SetupUserAsSuperAdmin]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Salman
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SetupUserAsSuperAdmin]
	-- Add the parameters for the stored procedure here
	@UserInformationId int ,
	@ClientId int ,
	@CompanyId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	IF NOT EXISTS (SELECT * FROM [Role] WHERE RoleTypeId=1)
		BEGIN
			INSERT INTO [dbo].[Role] ([RoleName],[Description],[RoleTypeId],[CompanyId],[ClientId],[CreatedBy],[CreatedDate],[DataEntryStatus],[ModifiedBy],[ModifiedDate])
				  VALUES ('Super Admin' ,'',1,@CompanyId,@ClientId,1,GetDate(),1,NULL,NULL);
		END

		Declare @RoleId int;
		SELECT @RoleId=RoleId FROM [Role] WHERE RoleTypeId=1;
		select @RoleId;
		INSERT INTO [UserInformationRole]([RoleID],[UserInformationId],[CompanyId],[ClientId],[CreatedBy],[CreatedDate],[DataEntryStatus])
		VALUES (@RoleId,@UserInformationId,@CompanyId,@ClientId,1,GETDATE(),1);

END
GO
