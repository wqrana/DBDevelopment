USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_Delete]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 3/24/2014
-- Description:	Checks to see if the User can be deleted, if it can it deletes it.  If not, then it returns a message as to why.
-- =============================================
-- Revisions:
-- 4/4/2014: Fix Update Statement From Schools to Employee
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Users_Delete]
	@ClientID bigint,
	@EmployeeID int OUTPUT,
	@ResultCode int OUTPUT,
	@ErrorMessage varchar(4000) OUTPUT
AS
BEGIN
	DECLARE
		@CanDelete bit

	SET @CanDelete = 1

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY
		-- Check for valid Ids
		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID (%d) provided', 11, 1, @ClientID)

		IF (@EmployeeID <= 0)
			RAISERROR('Invalid Employee ID (%d) provided', 11, 1, @EmployeeID)

		-- Mark as Deleted - Employee
		UPDATE Employee SET isDeleted = 1 WHERE ClientID = @ClientID AND Customer_Id = @EmployeeID
		IF (@@ERROR <> 0) RAISERROR('Failed to mark Employee (%d) as deleted for Client (%d).', 11, 3, @EmployeeID, @ClientID)
				
		COMMIT TRAN
		SET @ResultCode = 0
		SET @ErrorMessage = ''
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @ResultCode = ERROR_STATE()
		SET @ErrorMessage = ERROR_MESSAGE()
	END CATCH
END
GO
