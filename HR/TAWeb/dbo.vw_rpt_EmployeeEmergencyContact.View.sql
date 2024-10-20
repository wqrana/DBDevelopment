USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeEmergencyContact]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_rpt_EmployeeEmergencyContact]
AS
SELECT        
UserInformationId, 
EmergencyContactId, 
ec.RelationshipId,
r.RelationshipName, 
ContactPersonName, 
MainNumber, 
AlternateNumber
FROM EmergencyContact ec
LEFT JOIN Relationship r ON ec.RelationshipId = r.RelationshipId
WHERE ec.DataEntryStatus = 1
GO
