USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[sp_SavePOS]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--12/13/2015-Munawar @NextID is bypassed as id is identity in pos table

CREATE procedure [dbo].[sp_SavePOS]
( 
	@ClientID bigint,
	@Id int = 0,
	@School_Id int,
	@Name varchar(15),
	@ShortCutsNumber int,
	@ShortCutsBlob image,
	@isQuickSale bit = 0,
	@Quick1 int = 0,
	@Quick2 int = 0,
	@Quick3 int = 0
)
AS 
BEGIN
	DECLARE @NextID int

	BEGIN TRY
	BEGIN TRAN
		IF EXISTS (select * from POS where ClientID = @ClientID and Id = @Id) BEGIN
			 update POS set 
				 Name= @Name,
				 School_Id = @School_Id,
				 ShortCutsNumber = @ShortCutsNumber,
				 ShortCutsBlob=@ShortCutsBlob,
				 isQuickSale=@isQuickSale,
				 Quick1 = @Quick1,
				 Quick2 = @Quick2,
				 Quick3 = @Quick3
			 where ClientID = @ClientID
				and Id = @Id
			IF (@@ERROR <> 0) RAISERROR('Failed to Update POS', 11, 1)

			SET @NextID = @id
		END
		ELSE BEGIN
			--if (@id = -1) BEGIN
			--	EXEC Main_IndexGenerator_GetIndex @ClientID, 25, 1, @NextID output, 0
			--	IF (@@ERROR <> 0) RAISERROR('Failed to Get Id for the POS', 11, 2)
			--END
			--ELSE BEGIN
			--	SET @NextID = @id
			--END
			--IF (@id <> -1) RAISERROR('ID %d does not exist', 11, 2, @id)
			
			INSERT INTO POS 
					(ClientID, Name, School_Id, ShortCutsNumber, ShortCutsBlob, isQuickSale, Quick1, Quick2, Quick3) 
				values 
					(@ClientID, @Name, @School_Id, @ShortCutsNumber, @ShortCutsBlob, @isQuickSale, @Quick1, @Quick2, @Quick3)
			IF (@@ERROR <> 0) RAISERROR('Failed to Create a new POS', 11, 3)

			SELECT @NextID = SCOPE_IDENTITY()
		END

		COMMIT TRAN
		SELECT @NextID as POS_Id, '' as ErrorMessage
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT -1 as POS_Id, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
