USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewUser_Reports]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
   CREATE VIEW [dbo].[viewUser_Reports] 
   AS 
   SELECT     TOP (100) PERCENT dbo.tuser.id, dbo.tuser.name, dbo.tuser.idno, dbo.tuser.nStatus, dbo.tuser.sNotes, 
				dbo.tCompany.Name AS sCompanyName, dbo.tDept.Name AS sDeptName, dbo.tJobTitle.Name AS sJobTitleName, 
				dbo.tEmployeeType.Name AS sEmployeeTypeName, dbo.tPayrollRule.Name AS sPayrollRuleName, dbo.tSchedule.Name AS sScheduleName, 
				dbo.tuser.nDeptID, dbo.tuser.nJobTitleID, dbo.tuser.nGroupID,  dbo.tuser.nEmployeeType, dbo.tuser.nCompanyID, 
				dbo.tuser.nPayrollRuleID, dbo.tuser.nScheduleID, dbo.tUserExtended.dCompanySeniorityDate, 
				dbo.tUserExtended.sSSN, dbo.tUserExtended.sHomeAddressLine1, dbo.tUserExtended.sHomeAddressLine2, dbo.tUserExtended.sHomeCity,                        
				dbo.tUserExtended.sHomeState, dbo.tUserExtended.sHomeZipCode, dbo.tUserExtended.sHomePhoneHum, dbo.tUserExtended.sSex,                        
				dbo.tUserExtended.sMaritalStatus, dbo.tUserExtended.dBirthDate, dbo.tUserExtended.dOriginalHiredDate, dbo.tUserExtended.dblHourlyRate,                        
				dbo.tUserExtended.sRegTempCode, dbo.tUserExtended.sFullPartTimeCode, dbo.tUserExtended.dblBaseCompensationRate,                        
				dbo.tUserExtended.sJobTitle AS email , tuser.intPositionID,tblPosition.strPositionName, tUserExtended.dTerminationDate
				, tuser.FirstName, tuser.MiddleInitial, tuser.FirstLastName, tuser.SecondLastName
				FROM  
				dbo.tuser LEFT OUTER JOIN  dbo.tUserExtended ON dbo.tuser.id = dbo.tUserExtended.nUserID 
				LEFT OUTER JOIN  dbo.tEmployeeType ON dbo.tuser.nEmployeeType = dbo.tEmployeeType.ID 
				LEFT OUTER JOIN  dbo.tSchedule ON dbo.tuser.nScheduleID = dbo.tSchedule.ID 
				LEFT OUTER JOIN  dbo.tPayrollRule ON dbo.tuser.nPayrollRuleID = dbo.tPayrollRule.ID 
				LEFT OUTER JOIN  dbo.tJobTitle ON dbo.tuser.nJobTitleID = dbo.tJobTitle.ID 
				LEFT OUTER JOIN dbo.tDept ON dbo.tuser.nDeptID = dbo.tDept.ID 
				LEFT OUTER JOIN dbo.tCompany ON dbo.tuser.nCompanyID = dbo.tCompany.ID 
				LEFT OUTER JOIN dbo.tblPosition ON dbo.tuser.intPositionID = dbo.tblPosition.intPositionID
				ORDER BY dbo.tuser.name   

GO
