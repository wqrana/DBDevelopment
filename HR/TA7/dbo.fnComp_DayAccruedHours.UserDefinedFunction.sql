USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_DayAccruedHours]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Gets the hours accrued for en employee between startdate and enddate
CREATE FUNCTION [dbo].[fnComp_DayAccruedHours](@UserID int, @AccrualType varchar(50), @StartDate datetime, @EndDate datetime)
RETURNS decimal(18,5)
AS
BEGIN
	DECLARE @fltAccruedHours decimal(18,5);

	SELECT @fltAccruedHours  = isnull(sum(dblAccruedHours),0) from tUserCompensationAccruals 
	where nUserID = @UserID and dEffectiveDate between @StartDate AND @EndDate
	AND sAccrualType = @AccrualType

    RETURN isnull(@fltAccruedHours,0) ;

END;
GO
