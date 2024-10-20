USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_RolePermission_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 16-Jan-2016
-- Description:	This procedure Create/Update Role and its permissions in the AccessRights
-- Fixation of 243 work item in Axosoft
-- =============================================
CREATE PROCEDURE [dbo].[Admin_RolePermission_Save]
@ClientID bigint,
@SecurityGroupID INT,
@SecurityGroupName Varchar(32),
@AccessRights AccessRightsType READONLY,
@ResultCode int = 0 OUTPUT,
@ErrorMsg Varchar(4000) = '' OUTPUT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			IF (@SecurityGroupID = -1)
			BEGIN
				INSERT INTO [SecurityGroup] ([ClientID], [GroupName], [LastUpdatedUTC], [UpdatedBySync],
				[Local_ID], [CloudIDSync]) 
				VALUES(@ClientID, @SecurityGroupName, GETUTCDATE(), 0, NULL, 0)

				SET @SecurityGroupID = Scope_Identity();

			END
			ELSE
			BEGIN
			-- The Security ID comes from registration database UserRole table. Therefore, we need to
			-- find the securityGroupId using role name.
				SELECT @SecurityGroupID = ID FROM [SecurityGroup]
				WHERE ClientID = @ClientID AND GroupName = @SecurityGroupName

				UPDATE [SecurityGroup] SET [GroupName] = @SecurityGroupName
				WHERE ClientID = @ClientID AND ID = @SecurityGroupID
			END

			MERGE AccessRights AS T
			USING @AccessRights AS S
			ON (T.ObjectID = S.ObjectID AND T.SecurityGroup_Id = @SecurityGroupID AND T.ClientID = @ClientID)
			WHEN MATCHED THEN
			UPDATE SET T.canView = S.CanView, T.canInsert = S.CanInsert,
			T.canEdit = S.CanEdit, T.canDelete = S.CanDelete
			WHEN NOT MATCHED THEN
			INSERT ([ClientID], [ObjectID], [SecurityGroup_Id], [canInsert], [canDelete],
			[canView], [canEdit], [LastUpdatedUTC], [UpdatedBySync], [Local_ID], [CloudIDSync])
			VALUES(@ClientID, S.ObjectID, @SecurityGroupID, S.CanInsert, S.CanDelete,
			S.CanView, S.CanEdit, GETUTCDATE(), 0, NULL, 0);

			SET @ResultCode = 1;
			SET @ErrorMsg = '';

		COMMIT
		END TRY
	BEGIN CATCH

		ROLLBACK TRAN
		SET @ResultCode = -1;
		SET @ErrorMsg = ERROR_MESSAGE();

		/*DECLARE @ErrorMessage2 NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT 
        @ErrorMessage2 = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage2, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );*/
	END CATCH
END
GO
