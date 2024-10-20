USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_UserRole_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Abid H 
-- Create date: 5/19/2015
-- Description:	Saves a User Role 
-- =============================================
/*
	Revisions
	- 03/14/2016 - NAH - Remove references to Index Generator
*/
-- =============================================

CREATE PROCEDURE [dbo].[Admin_UserRole_Save]

	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@ID int, 
	@UserRoleName varchar(50),
	@AdminHQSystem int,
	@UserRolePermissions_IDS varchar(300)

	AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @New bit

	BEGIN TRAN
	BEGIN TRY
	SET @New = CASE @ID WHEN -1 THEN 1 ELSE 0 END

		-- Insert statements for procedure here
		IF (@New = 1) 
		BEGIN
			-- Get an Index
			/*
				EXEC dbo.[Main_IndexGenerator_GetIndex] @ClientID, 16, 1,  @ID OUTPUT
				IF ((@@ERROR <> 0) AND (@ID <= 0))
					RAISERROR('Failed to Get User Role Index', 11, 2)
			*/
				-- Insert the User Role
				INSERT INTO UserRoles ([ClientID],[UserRoleName],[AdminHQSystem],[UserRolePermissions_IDS]) 
							VALUES (@ClientID, @UserRoleName, @AdminHQSystem, @UserRolePermissions_IDS)

				IF (@@ERROR <> 0) RAISERROR('Failed to insert new user role.', 11, 2)

				SELECT @ID = SCOPE_IDENTITY()
			END
		ELSE 
			BEGIN
				UPDATE [dbo].[UserRoles] SET 
						[UserRoleName] = @UserRoleName
						,[AdminHQSystem] = @AdminHQSystem
						,[UserRolePermissions_IDS] = @UserRolePermissions_IDS
				WHERE Id = @ID AND ClientID = @ClientID

				IF (@@ERROR <> 0) RAISERROR('Failed to update user role.', 11, 2)
			END

			COMMIT TRAN
			SELECT @ID as ID, 0 as Result, '' as ErrorMessage
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 0 as ID, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
