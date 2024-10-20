USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationStartOfDayBalance]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnCompensationStartOfDayBalance](@dtEffectiveDate datetime, @nUserID int, @sType varchar(50))
RETURNS float
AS
BEGIN	
	DECLARE @fltUsedHours float;
	
	SELECT	@fltUsedHours = (
				[dbo].[fnCompensationEndOfDayBalance] (@dtEffectiveDate, @nUserID, @sType)
				+ [dbo].[fnCompensationUsedHours](@dtEffectiveDate,@dtEffectiveDate, @nUserID,@sType ) 
			)

	IF(@fltUsedHours IS NULL)
		SET @fltUsedHours = 0;

	return @fltUsedHours; 
END;
GO
