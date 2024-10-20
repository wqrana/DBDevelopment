USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeEducationInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeEducationInfo]
AS
SELECT 
  UserInformationId,
  dg.DegreeName,
  dg.DegreeId,
  empEdu.DateCompleted,
  empEdu.Title,
  empEdu.InstitutionName,
  empEdu.Note,
  empEdu.DocName
FROM EmployeeEducation empEdu
LEFT JOIN Degree dg ON  empEdu.DegreeId = dg.DegreeId
WHERE empEdu.DataEntryStatus = 1
GO
