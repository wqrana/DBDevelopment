USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewRes_SoftwareRestrictionGroup]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewRes_SoftwareRestrictionGroup]
-- WITH ENCRYPTION
AS
SELECT        dbo.tblSoftwareRestrictionsGroupMaster.intRestrictionsGroupID, dbo.tblSoftwareRestrictionsGroupMaster.strRestrictionsGroupName, dbo.tblSoftwareRestrictionsGroupMaster.boolDeleted, 
                         dbo.tblSoftwareRestrictionsGroupDetail.intRestrictionsID, dbo.tblSoftwareRestrictionsGroupDetail.boolView, dbo.tblSoftwareRestrictionsGroupDetail.boolEdit, dbo.tblSoftwareRestrictions.strRestrictionsName, 
                         dbo.tblSoftwareRestrictions.strRestrictionDescription, dbo.tblSoftwareRestrictions.boolPermitsView, dbo.tblSoftwareRestrictions.boolPermitsEdit, dbo.tblSoftwareRestrictions.intModuleID
FROM            dbo.tblSoftwareRestrictionsGroupDetail INNER JOIN
                         dbo.tblSoftwareRestrictionsGroupMaster ON dbo.tblSoftwareRestrictionsGroupDetail.intRestrictionsGroupID = dbo.tblSoftwareRestrictionsGroupMaster.intRestrictionsGroupID INNER JOIN
                         dbo.tblSoftwareRestrictions ON dbo.tblSoftwareRestrictionsGroupDetail.intRestrictionsID = dbo.tblSoftwareRestrictions.intRestrictionsID

GO
