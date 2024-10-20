USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetEmployeeIdFromUserID]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 8/19/2021
-- Description:	Finds the EmployeeID from the UserInformationID.  
-- =============================================
CREATE FUNCTION [dbo].[fn_GetEmployeeIdFromUserID]
(
	-- Add the parameters for the function here
	@UserInformationId int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Employeeid int

	-- Add the T-SQL statements to compute the return value here
	SELECT @Employeeid =  EmployeeId from dbo.UserInformation where UserInformationId = @UserInformationId
	
	-- Return the result of the function
	RETURN @Employeeid

END
GO
