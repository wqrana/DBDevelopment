USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeCustomFieldInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_rpt_EmployeeCustomFieldInfo]
AS
SELECT 
  UserInformationId,
  empCustomField.CustomFieldId,
  empCustomField.EmployeeCustomFieldId,
  CustFd.CustomFieldTypeId,
  CustFdType.CustomFieldTypeName,
  CustFd.CustomFieldName,
  CustFd.CustomFieldDescription,
  CustFd.IsExpirable,
  empCustomField.CustomFieldValue,
  empCustomField.CustomFieldNote,
  empCustomField.ExpirationDate,
  empCustomField.IssuanceDate,
  empCustomField.ReturnDate
  
FROM EmployeeCustomField empCustomField
LEFT JOIN CustomField CustFd ON  CustFd.CustomFieldId = empCustomField.CustomFieldId
LEFT JOIN CustomFieldType CustFdType ON CustFd.CustomFieldTypeId = CustFdType.CustomFieldTypeId
WHERE empCustomField.DataEntryStatus = 1
GO
