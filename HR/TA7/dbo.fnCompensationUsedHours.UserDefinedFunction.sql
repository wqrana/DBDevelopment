USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationUsedHours]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCompensationUsedHours](@dtPeriodStartDate datetime, @dtPeriodEndDate datetime, @nUserID int, @sAccrualType varchar(50))
RETURNS float
AS
BEGIN
	DECLARE @fltUsedHours float;

	SELECT	@fltUsedHours = sum( pp.HoursWorked)
	FROM	tPunchPair pp 
			inner JOIN tTransDef td on pp.sType = td.Name
	where	sAccrualImportName = @sAccrualType 
			and pp.e_id = @nUserID 
			and pp.DTPunchDate between @dtPeriodStartDate and @dtPeriodEndDate
	group by pp.e_id, td.sAccrualImportName

	IF(@fltUsedHours IS NULL)
		SET @fltUsedHours = 0;
    
	RETURN @fltUsedHours;
END;
GO
