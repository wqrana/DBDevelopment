USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserInformation]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserInformation]
-- WITH ENCRYPTION
AS
SELECT        dbo.tUserExtended.nUserID AS intUserID, dbo.tUserExtended.sEmployeeID AS strIDNumber, dbo.tUserExtended.sSSN AS strSSN, dbo.tUserExtended.sEmployeeName AS strNameOnCheck, 
                         dbo.tUserExtended.sHomeAddressLine1 AS strAddress1, dbo.tUserExtended.sHomeAddressLine2 AS strAddress2, dbo.tUserExtended.sHomeCity AS strCity, dbo.tUserExtended.sHomeState AS strState, 
                         dbo.tUserExtended.sHomeZipCode AS strZipCode, dbo.tUserExtended.sHomePhoneHum AS strPhone, dbo.tUserExtended.dBirthDate AS strBirthDate, dbo.tUserExtended.dOriginalHiredDate AS strHiredDate, 
                         dbo.tUserExtended.dTerminationDate AS strTerminationDate, dbo.tUserExtended.sRegTempCode AS strRegTemp, dbo.tUserExtended.sFullPartTimeCode AS strFullPartTime, 
                         dbo.viewUser_Reports.sCompanyName, dbo.viewUser_Reports.sDeptName, dbo.viewUser_Reports.sJobTitleName, dbo.viewUser_Reports.sEmployeeTypeName, dbo.viewUser_Reports.sPayrollRuleName, 
                         dbo.viewUser_Reports.sScheduleName, dbo.viewUser_Reports.nDeptID, dbo.viewUser_Reports.nJobTitleID, dbo.viewUser_Reports.nGroupID, dbo.viewUser_Reports.nEmployeeType, 
                         dbo.viewUser_Reports.nCompanyID, dbo.viewUser_Reports.nPayrollRuleID, dbo.viewUser_Reports.nScheduleID, dbo.viewUser_Reports.email AS strEmail
FROM            dbo.tUserExtended INNER JOIN
                         dbo.viewUser_Reports ON dbo.tUserExtended.nUserID = dbo.viewUser_Reports.id

GO
