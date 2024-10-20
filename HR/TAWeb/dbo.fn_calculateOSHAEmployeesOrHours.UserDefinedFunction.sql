USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calculateOSHAEmployeesOrHours]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Waqar>
-- Create date: <2021-05-03>
-- Description:	<Calculate OSHA Total Employees or Total hours worked>
-- =============================================
Create FUNCTION [dbo].[fn_calculateOSHAEmployeesOrHours]
(
	-- Add the parameters for the function here
	@companyId int, 
	@reportYear int,
	@locationId int,
	@calcType nvarchar -- (E) Employee count (H) Total hours worked
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	If(@calcType='E')
	Begin

	return -1;
	End
	else
	    if(@calcType='H')
		Begin

		return -2;
		End

	
	Return 0;

END


GO
