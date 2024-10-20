USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_UserRole_Delete]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 20-Jan-2017
-- Description:	This procedure deletes a SecurityGroup along with its permissions from AccessRights table.
-- We pass SecurityGroup name to this sp to delete because the Security Groups or UserRoles are loaded from
-- Registration database into the screen.
-- =============================================
CREATE PROCEDURE [dbo].[Admin_UserRole_Delete] 
	@ClientID BIGINT, 
	@SecurityGroupName VARCHAR(32),
	@ResultCode int = 0 OUTPUT,
	@ErrorMessage varchar(4000) OUTPUT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @SecurityGroupId INT = -1;
			SELECT @SecurityGroupId = ID FROM [SecurityGroup]
			WHERE ClientID = @ClientID AND GroupName = @SecurityGroupName
	
			DELETE FROM [SecurityGroup] WHERE ClientID = @ClientID AND ID = @SecurityGroupId;
			DELETE FROM AccessRights WHERE ClientID = @ClientID AND SecurityGroup_Id = @SecurityGroupId;
			COMMIT TRAN
			SET @ResultCode = 1
			SET @ErrorMessage = ''
		END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @ResultCode = -1;
		SET @ErrorMessage = ERROR_MESSAGE();
	END CATCH
END
GO
