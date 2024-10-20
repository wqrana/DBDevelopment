USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_CategoryType_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/27/2014
-- Description:	Save the Category Type
-- =============================================
-- Revisions
-- NAH - 2015-03-14 - Remove references to Index Generator and return correct value
-- =============================================
CREATE PROCEDURE [dbo].[Admin_CategoryType_Save]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@CategoryTypeID int,
	@CategoryTypeName varchar(15),
	@CanBeFree bit,
	@CanBeReduced bit,
	@Deleted bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRAN
	BEGIN TRY
		IF (@ClientID <= 0) RAISERROR('Invalid ClientID (%d) provided.', 11, 1, @ClientID)

		IF ((@CategoryTypeID < -1) OR (@CategoryTypeID = 0))
			RAISERROR('Invalid Categoty Type ID (%d) provided', 11, 1, @CategoryTypeID)

		IF (@CategoryTypeID = -1) BEGIN
			-- Get an Index
			/* Cloud DB does not use Index Generator *
			EXEC dbo.[Main_IndexGenerator_GetIndex] @ClientID, 22, 1, @CategoryTypeID OUTPUT
			IF ((@@ERROR <> 0) AND (@CategoryTypeID <= 0))
				RAISERROR('Failed to Get Category Type Index', 11, 2)
			*/
		
		--Munawar @CategoryTypeID is by pass as id colomn is set to identity-23-12-2015
			-- Insert the CategoryType
			INSERT INTO CategoryTypes ([ClientID], [Name], [canFree], [canReduce], [isDeleted], [isMealPlan], [isMealEquiv]) 
					VALUES (@ClientID, @CategoryTypeName, @CanBeFree, @CanBeReduced, @Deleted, 0, 0)

			IF (@@ERROR <> 0) RAISERROR('Failed to insert new CategoryType.', 11, 3)

			SELECT @CategoryTypeID = SCOPE_IDENTITY()
		END
		ELSE BEGIN
			UPDATE CategoryTypes SET
			   [Name] = @CategoryTypeName,
			   [canFree] = @CanBeFree,
			   [canReduce] = @CanBeReduced,
			   [isDeleted] = @Deleted
			WHERE 
				ClientID = @ClientID and
				Id = @CategoryTypeID
			
			IF (@@ERROR <> 0) RAISERROR('Failed to update the Category Type (%d)', 11, 3, @CategoryTypeID)
		END
		

		COMMIT TRAN
		SELECT @CategoryTypeID as CategoryType_Id, 0 as Result, '' as ErrorMessage
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 0 as CategoryType_Id, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
