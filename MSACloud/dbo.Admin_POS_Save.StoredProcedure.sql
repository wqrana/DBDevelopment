USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_POS_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/31/2014
-- Description:	Saves a POS
-- =============================================
/*
	Revisions
	- 12/23/2015 - muanwar - @POSID is by passed as id is identity in pos table
	- 03/14/2016 - NAH - Removed references to Index Generator
*/
-- =============================================
CREATE PROCEDURE [dbo].[Admin_POS_Save]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@POSID int,
	@School_Id int,
	@POS_Name varchar(15),
	@Credit_Card_Enabled bit,
	@Credit_Card_UserId varchar(20),
	@Credit_Card_Password varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE 
		@New bit

    -- Insert statements for procedure here
	BEGIN TRAN
	BEGIN TRY
		-- Check Client ID
		IF (@ClientID <= 0 OR @ClientID is null)
			RAISERROR('Invalid Client ID: %d', 11, 1, @ClientID)

		-- Is this New POS
		SET @New = CASE @POSID WHEN -1 THEN 1 ELSE 0 END

		IF (@New = 1) BEGIN
			-- Get a new Id
			/*
			EXEC dbo.Main_IndexGenerator_GetIndex @ClientID, 25, 1, @POSID OUTPUT
			IF (@@ERROR <> 0 OR @POSID = -1 OR @POSID = 0)
				RAISERROR('Failed to get an Id for the POS', 11, 2)
			*/
			-- Insert POS
			INSERT INTO POS (ClientID, School_Id, Name, ShortCutsNumber, ShortCutsBlob, isQuickSale, Quick1, Quick2, Quick3, isMealEqual, MealEqual1, MealEqual2, MealEqual3, EnableCCProcessing, VeriFoneUserId, VeriFonePassword)
				VALUES (@ClientID, @School_Id, @POS_Name, 1, NULL, 0, -1, -1, -1, 0, -1, -1, -1, @Credit_Card_Enabled, @Credit_Card_UserId, @Credit_Card_Password)

			IF (@@ERROR <> 0) RAISERROR('Failed to insert new pos.', 11, 3)

			SELECT @POSID = SCOPE_IDENTITY()
		END
		ELSE BEGIN
			-- Update POS
		-- if @Credit_Card_Password is empty then don't update password, Abid H
		if(@Credit_Card_Password='')
			UPDATE POS SET
				School_Id = @School_Id,
				Name = @POS_Name,
				EnableCCProcessing = @Credit_Card_Enabled,
				VerifoneUserId = @Credit_Card_UserId
			WHERE ClientID = @ClientID AND Id = @POSID
			ELSE
			UPDATE POS SET
				School_Id = @School_Id,
				Name = @POS_Name,
				EnableCCProcessing = @Credit_Card_Enabled,
				VerifoneUserId = @Credit_Card_UserId,
				VerifonePassword = @Credit_Card_Password
			WHERE ClientID = @ClientID AND Id = @POSID

			IF (@@ERROR <> 0) RAISERROR('Failed to update the POS (%d)', 11, 3, @POSID)
		END

		COMMIT TRAN

		SELECT @POSID as POS_Id, 0 as Result, '' as ErrorMessage
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 0 as POS_Id, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
