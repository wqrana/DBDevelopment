USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewRes_UserSoftwareRestrictions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE VIEW [dbo].[viewRes_UserSoftwareRestrictions]
	-- WITH ENCRYPTION
	AS
SELECT UserGroup.[intUserID]
      ,UserGroup.[intRestrictionsGroupID]
      ,Masterdetail.[intRestrictionsID]
      ,isnull(userdetail.[boolView],0) as boolView
      ,isnull(userdetail.[boolEdit],0) as boolEdit
      ,sr.[strRestrictionsName]
      ,sr.[strRestrictionDescription]
      ,sr.[boolPermitsView]
      ,sr.[boolPermitsEdit]
      ,sr.[intModuleID]
      ,GroupMaster.[strRestrictionsGroupName]
      ,GroupMaster.[boolDeleted]
	   from tblUserSoftwareRestrictionsGroup UserGroup inner join tblSoftwareRestrictionsGroupMaster GroupMaster ON UserGroup.intRestrictionsGroupID = GroupMaster.intRestrictionsGroupID
		inner join tblSoftwareRestrictionsGroupDetail Masterdetail on UserGroup.intRestrictionsGroupID = Masterdetail.intRestrictionsGroupID 
		left outer join tblUserSoftwareRestrictionsDetail userdetail on UserGroup.intUserID = userdetail.intUserID and Masterdetail.intRestrictionsID = userdetail.intRestrictionsID
		inner join tblSoftwareRestrictions sr on Masterdetail.intRestrictionsID = sr.intRestrictionsID
GO
