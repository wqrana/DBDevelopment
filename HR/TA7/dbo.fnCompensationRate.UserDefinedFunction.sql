USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationRate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCompensationRate](@nUserID int, @sAccrualType varchar(50) )
RETURNS float
AS
BEGIN
	DECLARE @fltAccruedHours float;

	SELECT	@fltAccruedHours = dblHourlyRate 
	FROM	tUserExtended 
	WHERE	nUserID = @nUserID;

	IF @fltAccruedHours is null
		SET @fltAccruedHours = 0;

	RETURN @fltAccruedHours ;
END;
GO
