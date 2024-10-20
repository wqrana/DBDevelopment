USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeePerformanceReviewInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeePerformanceReviewInfo]
AS
SELECT 
  ep.UserInformationId,
  ep.EmployeePerformanceId,  
  ep.ReviewDate,
  ep.SupervisorId,
  reviewer.ShortFullName as ReviewerName,
  ep.PerformanceDescriptionId,
  pd.PerformanceDescriptionName,
  ep.DocName,
  ep.PerformanceResultId,
  pr.PerformanceResultName,
  ep.ActionTakenId,
  acttk.ActionTakenName,
  ep.ExpiryDate,
  ep.ReviewSummary,
  ep.ReviewNote
 
FROM  EmployeePerformance ep
LEFT JOIN UserInformation reviewer ON  reviewer.UserInformationId = ep.UserInformationId
LEFT JOIN PerformanceDescription pd ON pd.PerformanceDescriptionId = ep.PerformanceDescriptionId
LEFT JOIN PerformanceResult pr		ON pr.PerformanceResultId = ep.PerformanceResultId
LEFT JOIN ActionTaken acttk ON acttk.ActionTakenId = ep.ActionTakenId 
WHERE ep.DataEntryStatus = 1
GO
