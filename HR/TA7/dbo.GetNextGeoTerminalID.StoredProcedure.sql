USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[GetNextGeoTerminalID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNextGeoTerminalID] 
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ID INT
	DECLARE @MaxID INT
	DECLARE @MissingCarTypeIDs TABLE ( [ID] INT )

	SELECT @MaxID = intGeoTerminalID +1 FROM tblGeoTerminals

	SET @ID = 1
	WHILE @ID <= @MaxID
	BEGIN
		IF NOT EXISTS (SELECT 'X' FROM tblGeoTerminals
					   WHERE intGeoTerminalID = @ID)
			INSERT INTO @MissingCarTypeIDs ( [ID] )
			VALUES ( @ID )

		SET @ID = @ID + 1
	END
	IF @MAXID is null
		SELECT 1
	ELSE
		SELECT MIN([ID]) as NextID FROM @MissingCarTypeIDs
END
GO
