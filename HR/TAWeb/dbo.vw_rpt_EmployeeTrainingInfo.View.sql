USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeTrainingInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_rpt_EmployeeTrainingInfo]
AS
SELECT 
  UserInformationId,
  tr.TrainingId,
  tr.TrainingName,
  empTraining.TrainingDate,
  empTraining.Type as TrainingType,
  empTraining.ExpiryDate,
  empTraining.Note,
  empTraining.DocName,
  empTraining.TrainingTypeId,
  trType.TrainingTypeName
FROM EmployeeTraining empTraining
LEFT JOIN Training tr ON  empTraining.TrainingId = tr.TrainingId
LEFT JOIN TrainingType trType ON empTraining.TrainingTypeId = trType.TrainingTypeId
WHERE empTraining.DataEntryStatus = 1
GO
