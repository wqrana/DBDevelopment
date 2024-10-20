USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationAccruedHours]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCompensationAccruedHours](@dtStartDate datetime, @dtEndDate datetime, @nUserID int, @sAccrualType varchar(50))
RETURNS float
AS
BEGIN
	DECLARE @fltAccruedHours float;

	SELECT	@fltAccruedHours = (
				[dbo].[fnCompensationStartOfDayBalance](@dtEndDate, @nUserID, @sAccrualType) 
				- [dbo].[fnCompensationStartOfDayBalance] (@dtStartDate, @nUserID, @sAccrualType) 
				+ [dbo].[fnCompensationUsedHours](@dtStartDate , @dtEndDate, @nUserID, @sAccrualType)
			)

	IF(@fltAccruedHours IS NULL)
		SET @fltAccruedHours = 0;

    RETURN @fltAccruedHours ;
END;
GO
