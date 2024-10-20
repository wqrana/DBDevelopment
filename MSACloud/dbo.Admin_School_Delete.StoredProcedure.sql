USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_School_Delete]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/24/2014
-- Description:	Checks to see if the School can be deleted, if it can it deletes it.  If not, then it returns a message as to why.
-- =============================================
CREATE PROCEDURE [dbo].[Admin_School_Delete]
	@ClientID bigint,
	@SchoolID int,
	@OverridePrimaryAssignment bit = 0,
	@OverridePOSAssignment bit = 0,
	@OverrideVendingMachineAssignment bit = 0,
	@OverrideExpressGroupAssignment bit = 0
AS
BEGIN
	DECLARE
		@CanDelete bit,
		@PrimaryAssignmentCount int,
		@POSCount int,
		@VendingMachineCount int,
		@ExpressGroupCount int

	SET @CanDelete = 1
	SET @PrimaryAssignmentCount = 0
	SET @POSCount = 0
	SET @VendingMachineCount = 0
	SET @ExpressGroupCount = 0

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY
		-- Check for valid Ids
		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID (%d) provided', 11, 1, @ClientID)

		IF (@SchoolID <= 0)
			RAISERROR('Invalid School ID (%d) provided', 11, 1, @SchoolID)

		-- Check if can delete.
		-- Check Primary Assignments
		IF (@OverridePrimaryAssignment = 0) BEGIN
			SELECT @PrimaryAssignmentCount = COUNT(*) FROM Customer_School WHERE ClientID = @ClientID AND School_Id = @SchoolID AND isPrimary = 1
			IF (@@ERROR <> 0)
				RAISERROR('Failed to see if there are customers assigned to School (%d) for Client (%d).', 11, 2, @SchoolID, @ClientID)
		END

		-- Check POSs in this School
		IF (@OverridePOSAssignment = 0) BEGIN
			SELECT @POSCount = COUNT(*) FROM POS WHERE ClientID = @ClientID AND School_Id = @SchoolID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to see if there are POSs assigned to School (%d) for Client (%d).', 11, 2, @SchoolID, @ClientID)
		END

		-- Check Vending Machines in this school
		IF (@OverrideVendingMachineAssignment = 0) BEGIN
			SELECT @VendingMachineCount = COUNT(*) FROM VendingMachines WHERE ClientID = @ClientID AND School_Id = @SchoolID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to see if there are Vending Machines assigned to School (%d) for Client (%d).', 11, 2, @SchoolID, @ClientID)
		END

		-- Check for Express Lunch Group Setup
		IF (@OverrideExpressGroupAssignment = 0) BEGIN
			SELECT @ExpressGroupCount = COUNT(*) FROM XpressGroup WHERE ClientID = @ClientID AND SchoolID = @SchoolID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to see if there are Express Groups setup for School (%d) for Client (%d).', 11, 2, @SchoolID, @ClientID)
		END

		SELECT @CanDelete = CASE WHEN (@PrimaryAssignmentCount + @POSCount + @VendingMachineCount + @ExpressGroupCount) <> 0 THEN 0 ELSE 1 END

		-- Check Counts.
		IF (@CanDelete = 0) BEGIN
			DECLARE @msg varchar(max)
			SET @msg = 'School ' + CAST(@SchoolID as varchar) + ' is associated with '

			IF (@PrimaryAssignmentCount <> 0)
				SET @msg = @msg + CAST(@PrimaryAssignmentCount as varchar) + ' Primary School Assignment record(s).'
			ELSE IF (@POSCount <> 0)
				SET @msg = @msg + CAST(@POSCount as varchar) + ' POS record(s).'
			ELSE IF (@ExpressGroupCount <> 0)
				SET @msg = @msg + CAST(@ExpressGroupCount as varchar) + ' Express Lunch Group record(s).'
			ELSE
				SET @msg = @msg + ' unknown record(s).'
			
			RAISERROR(@msg, 11, 3)
		END

		-- Mark School Deleted and Delete non-needed Assignments
		
		-- Delete Homerooms for this School
		--DELETE FROM Homerooms WHERE ClientID = @ClientID AND School_Id = @SchoolID
		--IF (@@ERROR <> 0) RAISERROR('Failed to delete homerooms for School (%d) for Client (%d).', 11, 3, @SchoolID, @ClientID)
		
		-- Delete School_Tax Assignments
		--DELETE FROM School_Tax WHERE ClientID = @ClientID AND School_Id = @SchoolID
		--IF (@@ERROR <> 0) RAISERROR('Failed to delete tax assignments for School (%d) for Client (%d).', 11, 3, @SchoolID, @ClientID)
		
		-- Mark as Deleted - School
		UPDATE Schools SET isDeleted = 1 WHERE ClientID = @ClientID AND Id = @SchoolID
		IF (@@ERROR <> 0) RAISERROR('Failed to mark School (%d) as deleted for Client (%d).', 11, 3, @SchoolID, @ClientID)
				
		COMMIT TRAN

		SELECT @SchoolID as School_Id, 0 as Result, '' as ErrorMessage
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN

		SELECT 0 as School_Id, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
