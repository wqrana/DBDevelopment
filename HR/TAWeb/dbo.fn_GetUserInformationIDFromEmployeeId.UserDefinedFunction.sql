USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetUserInformationIDFromEmployeeId]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 8/19/2021
-- Description:	Finds the UserInformationID from the EmployeeID and ClientID.  
-- =============================================
CREATE FUNCTION [dbo].[fn_GetUserInformationIDFromEmployeeId]
(
	-- Add the parameters for the function here
	@EmployeeID int,
	@ClientID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @UserID int

	-- Add the T-SQL statements to compute the return value here
	SELECT @UserID =  UserInformationId from dbo.UserInformation where EmployeeId = @EmployeeID and ClientID = @ClientID
	
	-- Return the result of the function
	RETURN @UserID

END
GO
