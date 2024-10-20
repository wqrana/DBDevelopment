USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnComp_CheckTimeOffValidation]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnComp_CheckTimeOffValidation](@UserID int,  @TimeOffFromDate datetime)
RETURNS  bit
AS
BEGIN
DECLARE @Ret as bit = 1

	--Checks the Regular Payrolls of the employee. If a payroll exists, then it checks if it is closed (-1) or open
	--If the date is not in a closed payroll, then the date is valid (1)
	select @Ret = IIF(intBatchStatus = -1,0,1)  from viewPay_UserBatchStatus 
	where intUserID = @UserID and @TimeOffFromDate between dtStartDatePeriod AND dtEndDatePeriod
	AND intBatchType = 0

	--Note: There should be cancellation period value return at some point if the request is not processed.
	--		Even if a payroll is not run with the date, there is a practical limit that should be obeserved.

	Return ISNULL(@Ret,1)
END;
GO
