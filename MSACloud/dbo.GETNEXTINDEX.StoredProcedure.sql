USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GETNEXTINDEX]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GETNEXTINDEX] 
	@ClientID bigint,
	@FOBJECTID int, 
	@IDXNEEDED int, 
	@NEXTID int OUTPUT, 
	@LOCALDB bit = 0
AS 
DECLARE @FVAL int,
		@RETVALUE int,
		@NEW bit
BEGIN
	BEGIN TRAN 
	BEGIN TRY
		SET @RETVALUE = 0
		SET @NEW = 0
		SELECT @FVAL = NextValue FROM IndexGenerator WITH (UPDLOCK) WHERE ClientID = @ClientID and ObjectID = @FOBJECTID 
		IF (@@ERROR <> 0)
			RAISERROR('Failed to Get Next Index',11,1)
		
		IF (@FVAL IS NULL) BEGIN
			SET @FVAL = 1
			SET @NEW = 1
		END

		IF (@LOCALDB = 1) BEGIN
			SET @IDXNEEDED = @IDXNEEDED * (-1)
			IF (@NEW = 1)
				SET @FVAL = -2
		END

		IF (@NEW = 1)
			INSERT INTO IndexGenerator (ClientID, NextValue, ObjectId) VALUES (@ClientID, (@FVAL + @IDXNEEDED), @FOBJECTID)
		ELSE
			UPDATE IndexGenerator SET NextValue = (@FVAL + @IDXNEEDED) WHERE ClientID = @ClientID and ObjectID = @FOBJECTID
		IF (@@ERROR <> 0)
			RAISERROR('Failed to Update Index Generator',11,2)

		COMMIT TRAN
		SET @NEXTID = @FVAL
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @NEXTID = 0
	END CATCH
END
GO
