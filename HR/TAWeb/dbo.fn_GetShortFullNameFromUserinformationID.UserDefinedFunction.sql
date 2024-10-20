USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetShortFullNameFromUserinformationID]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 2/14/2022
-- Description:	Finds the ShortFullName from the UserInformationID.  
-- =============================================
CREATE FUNCTION [dbo].[fn_GetShortFullNameFromUserinformationID]
(
	-- Add the parameters for the function here
	@UserInformationId int)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ShortFullName nvarchar(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT @ShortFullName =  ShortFullName from dbo.UserInformation where UserInformationId = @UserInformationId 
	
	-- Return the result of the function
	RETURN @ShortFullName

END
GO
