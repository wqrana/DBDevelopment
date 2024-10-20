USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnRes_tblUserSoftwareRestrictions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	For Rsturns the software rstrictions assigned to the user
-- =============================================

CREATE FUNCTION [dbo].[fnRes_tblUserSoftwareRestrictions]
(	
	-- Add the parameters for the function here
	@USERID int
)
RETURNS 
@tblUserSoftwareRestrictions TABLE 
(
	intUserID int,
 intRestrictionsGroupID int,
  strRestrictionsGroupName nvarchar(50), 
  boolDeleted bit, 
  intRestrictionsID int, 
  strRestrictionsName nvarchar(50),  
  strRestrictionDescription nvarchar(100), 
  boolView bit, 
  boolEdit bit	,
  boolPermitsView bit, 
  boolPermitsEdit bit, 
  intModuleID int 
) 
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @intRestrictionsGroupID int
	SELECT @intRestrictionsGroupID  = intRestrictionsGroupID FROM tblUserSoftwareRestrictionsGroup
	
	if @intRestrictionsGroupID is null SET @intRestrictionsGroupID = 0 
	
	--Select group restritions and return for user
	INSERT INTO @tblUserSoftwareRestrictions
	SELECT intUserID, intRestrictionsGroupID, strRestrictionsGroupName, boolDeleted, intRestrictionsID, strRestrictionsName, strRestrictionDescription, boolView, boolEdit , boolPermitsView, boolPermitsEdit, intModuleID 
	FROM viewRes_UserSoftwareRestrictions where intUserID = @USERID
	RETURN
END
GO
