USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Neil Heverly
-- Create date: 3/20/2014
-- Description:	Saves User
-- =============================================
-- Revisions:

 -- Added UserRolesID Abid H
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Users_Save]
	-- Add the parameters for the stored procedure here
	@ClientID bigint, 

	-- Required information
	@EmployeeID int OUTPUT,  -- Value should always be set before saving
	@LoginName varchar(15),
	@Password varchar(15),
	@SecurityGroupID int,
	@UserRolesID int,
	

	-- Results
	@ResultCode int = 0 OUTPUT,
	@ErrorMessage varchar(4000) = '' OUTPUT

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
		@EmployeeExists bit

	BEGIN TRAN
	BEGIN TRY
		-- Check Values
		IF ((@ClientID <= 0) OR (@EmployeeID <= 0))
			RAISERROR('Invalid Client ID (%d) or Employee ID (%d) provided', 11, 1, @ClientID, @EmployeeID)
		
		IF (@SecurityGroupID <= 0 AND @SecurityGroupID != -2)
			RAISERROR('Invalid Security Group ID (%d) provided', 11, 1, @SecurityGroupID)

		SELECT @EmployeeExists = COUNT(*) FROM Employee WHERE ClientID = @ClientID AND Customer_Id = @EmployeeID AND isDeleted = 0
		IF (@@ERROR <> 0) RAISERROR('Failed to see if employee ID %d already exists for Client ID %d', 11, 2, @EmployeeID, @ClientID)

		-- Insert statements for procedure here
		IF (@EmployeeExists = 1) BEGIN
			-- Update Employee
			UPDATE Employee SET
				[LoginName] = @LoginName
				  ,[Password] = @Password
				  ,[SecurityGroup_Id] = @SecurityGroupID
				  ,[isDeleted] = 0
				  ,[UserRoles_ID] = @UserRolesID
			WHERE ClientID = @ClientID AND Customer_Id = @EmployeeID AND isDeleted = 0
			SET @ResultCode = 1
		END
		ELSE BEGIN
			-- Insert the Employee
			INSERT INTO Employee ([ClientID],[Customer_Id],[SecurityGroup_Id],[LoginName],[Password], [UserRoles_ID])
				VALUES (@ClientID, @EmployeeID, @SecurityGroupID, @LoginName, @Password, @UserRolesID)
				SET @ResultCode = 0
		END
		IF (@@ERROR <> 0)
			RAISERROR('Failed to Save the User', 11, 3)

		COMMIT TRAN
		
		SET @ErrorMessage = ''
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @ResultCode = ERROR_STATE()
		SET @ErrorMessage = ERROR_MESSAGE()
	END CATCH
END
GO
