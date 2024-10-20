USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_UserRole_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Abid H
-- Create date: 06/16/2015
-- Description:	Returns user roles
-- =============================================
/* 
	Revisions:

*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_UserRole_List]
(
	@ClientID bigint
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		ur.ClientID,
		ur.Id, 
		UserRoleName,
		AdminHQSystem,
		UserRolePermissions_IDS,
		count(e.UserRoles_ID) as usersCount
	from UserRoles ur 
		LEFT OUTER JOIN Employee e ON ur.ClientID = e.ClientID AND ur.Id = e.UserRoles_ID
	where ur.ClientID = @ClientID
	group by ur.ClientID, ur.Id, UserRoleName, AdminHQSystem, UserRolePermissions_IDS
)
GO
