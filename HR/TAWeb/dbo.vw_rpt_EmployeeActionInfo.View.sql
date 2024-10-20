USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeActionInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_rpt_EmployeeActionInfo]
AS
SELECT 
UserInformationId,
empAction.EmployeeActionId,
empAction.ActionTypeId,
act.ActionTypeName,
empAction.ActionName,
empAction.ActionDescription,
empAction.ActionNotes,
empAction.ActionDate,
empAction.ActionExpiryDate

FROM EmployeeAction empAction
LEFT JOIN ActionType act ON  act.ActionTypeId = empAction.ActionTypeId
WHERE empAction.DataEntryStatus = 1
GO
