USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_SickInFamilyUsedHours]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnComp_SickInFamilyUsedHours](@UserID int, @TransType varchar(50),@PeriodStartDate datetime, @PeriodEndDate datetime )
RETURNS decimal(18,5)
AS
BEGIN
	DECLARE @sifUsedHours decimal(18,5);

	SELECT	@sifUsedHours = isnull(sum( pp.HoursWorked),0)
	FROM	tPunchPair pp 
			inner JOIN tTransDef td on pp.sType = td.Name
	where	td.Name = @TransType 
			and pp.e_id = @UserID 
			and pp.DTPunchDate between @PeriodStartDate and @PeriodEndDate
	

	RETURN isnull(@sifUsedHours,0);
END;

GO
