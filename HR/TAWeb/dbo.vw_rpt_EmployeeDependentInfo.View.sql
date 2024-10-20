USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeDependentInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeDependentInfo]
AS
SELECT 
  ed.UserInformationId,
  ed.EmployeeDependentId,
  ed.FirstName,
  ed.LastName,
  ed.SSN as EdSSN,
  ed.BirthDate,
  ds.StatusName,
  gd.GenderName,
  rel.RelationshipName,
  ed.DocName,
  ed.ExpiryDate,
  ed.IsFullTimeStudent,
  ed.IsDentalInsurance,
  ed.IsHealthInsurance,
  ed.IsTaxPurposes,
  ed.SchoolAttending 
FROM  EmployeeDependent ed
LEFT JOIN DependentStatus ds ON ds.DependentStatusId = ed.DependentStatusId
LEFT JOIN Gender gd ON gd.GenderId = ed.GenderId
LEFT JOIN Relationship rel ON rel.RelationshipId = ed.RelationshipId
WHERE ed.DataEntryStatus = 1
GO
