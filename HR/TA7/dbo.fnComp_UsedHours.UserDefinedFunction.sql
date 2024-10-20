USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_UsedHours]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnComp_UsedHours](@UserID int, @AccrualType varchar(50),@PeriodStartDate datetime, @PeriodEndDate datetime )
RETURNS decimal(18,5)
AS
BEGIN
	DECLARE @fltUsedHours decimal(18,5);

	SELECT	@fltUsedHours = isnull(sum( pp.HoursWorked),0)
	FROM	tPunchPair pp 
			inner JOIN tTransDef td on pp.sType = td.Name
	where	sAccrualImportName = @AccrualType 
			and pp.e_id = @UserID 
			and pp.DTPunchDate between @PeriodStartDate and @PeriodEndDate
	group by pp.e_id, td.sAccrualImportName

	RETURN isnull(@fltUsedHours,0);
END;
GO
