USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationEndOfDayBalance]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCompensationEndOfDayBalance](@dtEffectiveDate datetime, @nUserID int, @sType varchar(50))
RETURNS float
AS
BEGIN
	DECLARE @fltCompBeginningBal float;
	
	SELECT	TOP(1) @fltCompBeginningBal = dblAccruedHours
	FROM	tUserCompensationMonthly 
	WHERE	dEffectiveDate <= @dtEffectiveDate  
			AND sAccrualType = @sType
			AND nUserID = @nUserID
	ORDER BY dEffectiveDate DESC

	IF(@fltCompBeginningBal IS NULL)
		SET @fltCompBeginningBal = 0;
    
	RETURN @fltCompBeginningBal;
END;
GO
