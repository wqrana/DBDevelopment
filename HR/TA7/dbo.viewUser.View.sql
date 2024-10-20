USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewUser]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewUser]
AS
SELECT     TOP 100 PERCENT dbo.tuser.id, dbo.tuser.name, dbo.tuser.idno, dbo.tuser.nStatus, dbo.tuser.sNotes, dbo.tCompany.Name AS sCompanyName, 
                      dbo.tDept.Name AS sDeptName, dbo.tJobTitle.Name AS sJobTitleName, dbo.tEmployeeType.Name AS sEmployeeTypeName, 
                      dbo.tPayrollRule.Name AS sPayrollRuleName, dbo.tSchedule.Name AS sScheduleName, dbo.tuser.nDeptID, dbo.tuser.nJobTitleID, dbo.tuser.nGroupID, 
                      dbo.tuser.nEmployeeType, dbo.tuser.nCompanyID, dbo.tuser.nPayrollRuleID, dbo.tuser.nScheduleID, 
                      dbo.tUserExtended.dCompanySeniorityDate
FROM         dbo.tuser INNER JOIN
                      dbo.tUserExtended ON dbo.tuser.id = dbo.tUserExtended.nUserID LEFT OUTER JOIN
                      dbo.tEmployeeType ON dbo.tuser.nEmployeeType = dbo.tEmployeeType.ID LEFT OUTER JOIN
                      dbo.tSchedule ON dbo.tuser.nScheduleID = dbo.tSchedule.ID LEFT OUTER JOIN
                      dbo.tPayrollRule ON dbo.tuser.nPayrollRuleID = dbo.tPayrollRule.ID LEFT OUTER JOIN
                      dbo.tJobTitle ON dbo.tuser.nJobTitleID = dbo.tJobTitle.ID LEFT OUTER JOIN
                      dbo.tDept ON dbo.tuser.nDeptID = dbo.tDept.ID LEFT OUTER JOIN
                      dbo.tCompany ON dbo.tuser.nCompanyID = dbo.tCompany.ID
ORDER BY dbo.tuser.name
GO
