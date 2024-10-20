USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeCredentialInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeCredentialInfo]
AS
SELECT 
  UserInformationId,
  empCredential.CredentialId,
  empCredential.EmployeeCredentialId,
  Cred.CredentialName,
  empCredential.EmployeeCredentialName as CredentialExternalId,
  empCredential.EmployeeCredentialDescription,
  empCredential.IssueDate,
  empCredential.ExpirationDate,
  empCredential.Note,
  empCredential.IsRequired,
  empCredential.DocumentName
  
FROM EmployeeCredential empCredential
LEFT JOIN Credential Cred ON  Cred.CredentialId = empCredential.CredentialId
WHERE empCredential.DataEntryStatus = 1
GO
