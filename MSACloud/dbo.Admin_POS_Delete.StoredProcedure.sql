USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_POS_Delete]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/5/2014
-- Description:	Checks to see if the POS can be deleted, if it can it deletes it.  If not, then it returns a message as to why.
-- =============================================
-- Revisions:
--	2/27/2014 - Change to do a soft delete instead of a hard delete with Overrides.
-- 11/8/2017  - Message text is added in case of success
-- =============================================
CREATE PROCEDURE [dbo].[Admin_POS_Delete]
	@ClientID bigint,
	@POSID int,
	@OverrideOrders bit = 0,
	@OverrideCashResults bit = 0
AS
BEGIN
	DECLARE 
		@CanDelete bit, 
		@OrderCount int,
		@CashresultsCount int,
		@POSName nvarchar(20)

		SELECT @POSName=Name from POS where ClientID=@ClientID and ID=@POSID
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @CanDelete = 0
	SET @OrderCount = 0
	SET @CashresultsCount = 0

	BEGIN TRAN
	BEGIN TRY
		-- Check for valid Ids
		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID (%d) provided', 11, 1, @ClientID)

		IF (@POSID <= 0)
			RAISERROR('Invalid POS ID (%d) provided', 11, 1, @POSID)

		-- Check if can delete.
		-- Check Orders
		IF (@OverrideOrders = 1) BEGIN
			SELECT @OrderCount = COUNT(*) FROM Orders WHERE ClientID = @ClientID AND POS_Id = @POSID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to see if there are associated orders for POS (%s) for Client (%d).', 11, 2, @POSName, @ClientID)
		END

		-- Check CashResults
		IF (@OverrideCashResults = 1) BEGIN
			SELECT @CashresultsCount = COUNT(*) FROM CashResults WHERE ClientID = @ClientID AND POS_Id = @POSID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to see if there are associated cash results for POS (%s) for Client (%d).', 11, 2, @POSName, @ClientID)
		END

		-- Existing Records
		SELECT @CanDelete = CASE WHEN (@OrderCount + @CashresultsCount) <> 0 THEN 0 ELSE 1 END

		IF (@CanDelete = 0) BEGIN
			DECLARE @msg varchar(max)

			SET @msg = 'POS <b>' + @POSName + '</b> is associated to '

			IF (@OrderCount <> 0) 
				SET @msg = @msg + CAST(@OrderCount as varchar) + ' orders.'
			ELSE IF (@CashresultsCount <> 0)
				SET @msg = @msg + CAST(@CashresultsCount as varchar) + ' cash results.'
			ELSE
				SET @msg = @msg + ' unknown records.'

			RAISERROR(@msg, 11, 2)
		END

		-- Delete POS
		--DELETE FROM POS WHERE ClientID = @ClientID AND Id = @POSID
		UPDATE POS SET isDeleted = 1 WHERE ClientID = @ClientID AND Id = @POSID
		IF (@@ERROR <> 0) RAISERROR('Failed to Delete POS (%d).', 11, 3, @POSID)

			COMMIT TRAN

		SELECT @POSID as POS_Id,@POSName as POSName, 0 as Result, 'The POS record has been deleted succussfully.' as ErrorMessage
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN

		SELECT 0 as POS_Id,@POSName as POSNAME, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
