USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSS_GetHoursInDay]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 7/7/2021
-- Description:	Returns the expected work hours for the specified search date
-- =============================================
CREATE FUNCTION [dbo].[fnSS_GetHoursInDay]
(
	@UserID int,
	@SearchDate date
)
RETURNS decimal(18,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @decHoursInDay decimal(18,2)
	
	--Return the schedule hours from the Payroll Rule
	Select @decHoursInDay  =  pr.dblSchedDailyRegHours 
	From tPayrollRule pr inner join tuser u on pr.id = u.nPayrollRuleID
	Where u.id = @UserID
	-- Return the result of the function
	
	RETURN @decHoursInDay

END
GO
